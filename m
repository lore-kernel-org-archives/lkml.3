Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbbAPSur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 13:50:47 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54535 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbbAPSuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 13:50:14 -0500
From: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org,
        Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Subject: [PATCH 4/4] uio: Implement hotunplug support, using libunload
Date: Fri, 16 Jan 2015 10:49:39 -0800
Message-Id: <1421434179-3650-5-git-send-email-mandeep.sandhu@cyaninc.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
References: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change it is possible to remove a module that implements
a uio device, or to remove the underlying hardware device of a uio
device withot crashing the kernel, or causing user space more problems
than just an I/O error.

The implicit module parameter that was passed by uio_register_device
to __uio_register_device has been removed as it is now safe to call
uio_unregister_device while uio file handles are open.

In uio all file methods (except release) now must perform their work
inside of the unload_lock. This guarantees that uio_unregister_device
won't return until all currently running uio methods complete, and
it allows uio to return -EIO after the underlying device has been
unregistered.

The fops->release method must perform the bulk of it's work under the
unload_release_lock. With release more needs to be done than to
more than wait for the method to finish executing, the release also
needs to handle the info->releae being called early on files that
are not closed when unregister is running. Taking the unload_release
lock fails if and only if the info->release method has already been
called at the time fops->release runs.

Instead of holding a module reference, the uio files have been modified
to instead hold an extra reference to struct uio_device, ensuring
that the uio file_operations functions will not access freed memory
even after the uio device has been unregistered.

The bulk of the changes are simply modifying the code flow of the
uio functions to run under the appropriate unload lock.

uio_open is modestly special in that it needs to run under the
uio_unload lock (to keep the uio device from unloading), but not have
it's file structure on the uio unload list until it is certain
that the open will succeed (ensuring that release will not be called
on a file that we failed to open). uio_open also carefully grabs
the reference to the uio_device under the idr_mutex to guarnatee
the the uio_device reference held by the idr data structure
is valid while we are incrementing the uio_device reference count.

uio_device_unregister does a fair bit more than what it used to. All
of the extra work is essentially handling the early shutdown of file
handles when a device is unregistered while files are still open.

Tested-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Signed-off-by: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
---
 drivers/uio/uio.c          | 258 +++++++++++++++++++++++++++++++++------------
 include/linux/uio_driver.h |  11 +-
 2 files changed, 194 insertions(+), 75 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 4b57c6b..50548fb 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -23,7 +23,9 @@
 #include <linux/string.h>
 #include <linux/kobject.h>
 #include <linux/cdev.h>
+#include <linux/file.h>
 #include <linux/uio_driver.h>
+#include <linux/unload.h>
 
 #define UIO_MAX_DEVICES		(1U << MINORBITS)
 
@@ -415,60 +417,73 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
 }
 
 struct uio_listener {
-	struct uio_device *dev;
+	struct unload_file ufile;
 	s32 event_count;
 };
 
+#define listener_idev(LISTENER) \
+	container_of((LISTENER)->ufile.unload, struct uio_device, unload)
+
 static int uio_open(struct inode *inode, struct file *filep)
 {
 	struct uio_device *idev;
-	struct uio_listener *listener;
+	struct uio_listener *listener = NULL;
 	int ret = 0;
 
 	mutex_lock(&minor_lock);
 	idev = idr_find(&uio_idr, iminor(inode));
+	if (idev)
+		get_device(&idev->device);
 	mutex_unlock(&minor_lock);
-	if (!idev) {
-		ret = -ENODEV;
-		goto out;
-	}
 
-	if (!try_module_get(idev->owner)) {
-		ret = -ENODEV;
-		goto out;
-	}
+	ret = -ENODEV;
+	if (!idev)
+		goto err_out;
 
 	listener = kmalloc(sizeof(*listener), GFP_KERNEL);
-	if (!listener) {
-		ret = -ENOMEM;
-		goto err_alloc_listener;
-	}
+	ret = -ENOMEM;
+	if (!listener)
+		goto err_out;
 
-	listener->dev = idev;
+	unload_file_init(&listener->ufile, filep, &idev->unload);
 	listener->event_count = atomic_read(&idev->event);
 	filep->private_data = listener;
 
-	if (idev->info->open) {
+	/*
+	 * Take the users lock before opening the file to ensure the
+	 * file is not unregistered while it is being opened.
+	 */
+	ret = -EIO;
+	if (!unload_trylock(&idev->unload))
+		goto err_out;
+
+	ret = 0;
+	if (idev->info->open)
 		ret = idev->info->open(idev->info, inode);
-		if (ret)
-			goto err_infoopen;
-	}
-	return 0;
 
-err_infoopen:
-	kfree(listener);
+	/*
+	 * Add to the listener list only if the open succeeds.
+	 * This ensures that uio_unregister_device won't call
+	 * release unless open has succeeded.
+	 */
+	if (ret == 0)
+		unload_file_attach(&listener->ufile, &idev->unload);
 
-err_alloc_listener:
-	module_put(idev->owner);
+	unload_unlock(&idev->unload);
 
-out:
+err_out:
+	if (ret) {
+		if (idev)
+			put_device(&idev->device);
+		kfree(listener);
+	}
 	return ret;
 }
 
 static int uio_fasync(int fd, struct file *filep, int on)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
 
 	return fasync_helper(fd, filep, on, &idev->async_queue);
 }
@@ -477,44 +492,61 @@ static int uio_release(struct inode *inode, struct file *filep)
 {
 	int ret = 0;
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
 
-	if (idev->info->release)
-		ret = idev->info->release(idev->info, inode);
+	if (unload_release_trylock(&listener->ufile)) {
+		if (idev->info->release)
+			ret = idev->info->release(idev->info, inode);
 
-	module_put(idev->owner);
+		unload_release_unlock(&listener->ufile);
+	}
 	kfree(listener);
+	put_device(&idev->device);
 	return ret;
 }
 
 static unsigned int uio_poll(struct file *filep, poll_table *wait)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
+	unsigned int ret;
+
+	if (!unload_trylock(&idev->unload))
+		return POLLERR;
 
+	ret = POLLERR;
 	if (!idev->info->irq)
-		return -EIO;
+		goto out;
 
 	poll_wait(filep, &idev->wait, wait);
+	ret = 0;
 	if (listener->event_count != atomic_read(&idev->event))
-		return POLLIN | POLLRDNORM;
-	return 0;
+		ret = POLLIN | POLLRDNORM;
+
+out:
+	unload_unlock(&idev->unload);
+	return ret;
 }
 
 static ssize_t uio_read(struct file *filep, char __user *buf,
 			size_t count, loff_t *ppos)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
 	DECLARE_WAITQUEUE(wait, current);
 	ssize_t retval;
 	s32 event_count;
 
-	if (!idev->info->irq)
+	if (!unload_trylock(&idev->unload))
 		return -EIO;
 
+	retval = -EIO;
+	if (!idev->info->irq)
+		goto out;
+
+	retval = -EINVAL;
 	if (count != sizeof(s32))
-		return -EINVAL;
+		goto out;
 
 	add_wait_queue(&idev->wait, &wait);
 
@@ -541,12 +573,21 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 			retval = -ERESTARTSYS;
 			break;
 		}
+		unload_unlock(&idev->unload);
+
 		schedule();
+
+		if (!unload_trylock(&idev->unload)) {
+			retval = -EIO;
+			break;
+		}
 	} while (1);
 
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&idev->wait, &wait);
 
+out:
+	unload_unlock(&idev->unload);
 	return retval;
 }
 
@@ -554,24 +595,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
 			size_t count, loff_t *ppos)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
 	ssize_t retval;
 	s32 irq_on;
 
-	if (!idev->info->irq)
+	if (!unload_trylock(&idev->unload))
 		return -EIO;
 
+	retval = -EIO;
+	if (!idev->info->irq)
+		goto out;
+
+	retval = -EINVAL;
 	if (count != sizeof(s32))
-		return -EINVAL;
+		goto out;
 
+	retval = -ENOSYS;
 	if (!idev->info->irqcontrol)
-		return -ENOSYS;
+		goto out;
 
+	retval = -EFAULT;
 	if (copy_from_user(&irq_on, buf, count))
-		return -EFAULT;
+		goto out;
 
 	retval = idev->info->irqcontrol(idev->info, irq_on);
 
+out:
+	unload_unlock(&idev->unload);
 	return retval ? retval : sizeof(s32);
 }
 
@@ -587,17 +637,23 @@ static int uio_find_mem_index(struct vm_area_struct *vma)
 	return -1;
 }
 
-static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int uio_logical_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
 	struct page *page;
 	unsigned long offset;
 	void *addr;
+	int ret;
+	int mi;
 
-	int mi = uio_find_mem_index(vma);
-	if (mi < 0)
+	if (!unload_trylock(&idev->unload))
 		return VM_FAULT_SIGBUS;
 
+	ret = VM_FAULT_SIGBUS;
+	mi = uio_find_mem_index(vma);
+	if (mi < 0)
+		goto out;
+
 	/*
 	 * We need to subtract mi because userspace uses offset = N*PAGE_SIZE
 	 * to use mem[N].
@@ -611,26 +667,38 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 		page = vmalloc_to_page(addr);
 	get_page(page);
 	vmf->page = page;
-	return 0;
+	ret = 0;
+out:
+	unload_unlock(&idev->unload);
+	return ret;
 }
 
 static const struct vm_operations_struct uio_logical_vm_ops = {
-	.fault = uio_vma_fault,
+	.fault = uio_logical_fault,
 };
 
-static int uio_mmap_logical(struct vm_area_struct *vma)
+static int uio_physical_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
-	vma->vm_ops = &uio_logical_vm_ops;
-	return 0;
+	/* The pages should always be mapped, so we should never get
+	 * here unless the device has been hotunplugged
+	 */
+	return VM_FAULT_SIGBUS;
 }
 
 static const struct vm_operations_struct uio_physical_vm_ops = {
+	.fault = uio_physical_fault,
 #ifdef CONFIG_HAVE_IOREMAP_PROT
 	.access = generic_access_phys,
 #endif
 };
 
+static int uio_mmap_logical(struct vm_area_struct *vma)
+{
+	vma->vm_flags |= VM_DONTEXPAND | VM_DONTDUMP;
+	vma->vm_ops = &uio_logical_vm_ops;
+	return 0;
+}
+
 static int uio_mmap_physical(struct vm_area_struct *vma)
 {
 	struct uio_device *idev = vma->vm_private_data;
@@ -647,6 +715,7 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 
 	vma->vm_ops = &uio_physical_vm_ops;
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_ops = &uio_physical_vm_ops;
 
 	/*
 	 * We cannot use the vm_iomap_memory() helper here,
@@ -667,34 +736,48 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
 	int mi;
 	unsigned long requested_pages, actual_pages;
 
+	int ret;
+
+	if (!unload_trylock(&idev->unload))
+		return -EIO;
+
+	ret = -EINVAL;
 	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+		goto out;
 
 	vma->vm_private_data = idev;
 
+	ret = -EINVAL;
 	mi = uio_find_mem_index(vma);
 	if (mi < 0)
-		return -EINVAL;
+		goto out;
 
 	requested_pages = vma_pages(vma);
 	actual_pages = ((idev->info->mem[mi].addr & ~PAGE_MASK)
 			+ idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	ret = -EINVAL;
 	if (requested_pages > actual_pages)
-		return -EINVAL;
+		goto out;
 
 	switch (idev->info->mem[mi].memtype) {
-		case UIO_MEM_PHYS:
-			return uio_mmap_physical(vma);
-		case UIO_MEM_LOGICAL:
-		case UIO_MEM_VIRTUAL:
-			return uio_mmap_logical(vma);
-		default:
-			return -EINVAL;
+	case UIO_MEM_PHYS:
+		ret = uio_mmap_physical(vma);
+		break;
+	case UIO_MEM_LOGICAL:
+	case UIO_MEM_VIRTUAL:
+		ret = uio_mmap_logical(vma);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
 	}
+out:
+	unload_unlock(&idev->unload);
+	return ret;
 }
 
 static const struct file_operations uio_fops = {
@@ -793,9 +876,7 @@ static void uio_device_release(struct device *dev)
  *
  * returns zero on success or a negative error code.
  */
-int __uio_register_device(struct module *owner,
-			  struct device *parent,
-			  struct uio_info *info)
+int uio_register_device(struct device *parent, struct uio_info *info)
 {
 	struct uio_device *idev;
 	int ret = 0;
@@ -810,10 +891,10 @@ int __uio_register_device(struct module *owner,
 		return -ENOMEM;
 	}
 
-	idev->owner = owner;
 	idev->info = info;
 	init_waitqueue_head(&idev->wait);
 	atomic_set(&idev->event, 0);
+	unload_init(&idev->unload);
 
 	ret = uio_get_minor(idev);
 	if (ret)
@@ -856,7 +937,7 @@ err_device_create:
 	uio_free_minor(idev);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__uio_register_device);
+EXPORT_SYMBOL_GPL(uio_register_device);
 
 /**
  * uio_unregister_device - unregister a industrial IO device
@@ -866,16 +947,59 @@ EXPORT_SYMBOL_GPL(__uio_register_device);
 void uio_unregister_device(struct uio_info *info)
 {
 	struct uio_device *idev;
+	struct unload_file *ufile;
+	struct hlist_node *n;
 
 	if (!info || !info->uio_dev)
 		return;
 
 	idev = info->uio_dev;
 
+	/*
+	 * Stop accepting new callers into the uio functions, and wait
+	 * until all existing callers into the uio functions are done.
+	 */
+	unload_barrier(&idev->unload);
+
+	/* Notify listeners that the uio devices has gone. */
+	wake_up_interruptible_all(&idev->wait);
+	kill_fasync(&idev->async_queue, SIGIO, POLL_ERR);
+
+	/*
+	 * unload_barrier froze the idev->unload.ufiles list and grabbed
+	 * a reference to every file on that list.  Now cleanup those files
+	 * and drop the extra reference.
+	 */
+	hlist_for_each_entry_safe(ufile, n, &idev->unload.ufiles, list) {
+		struct file *file = ufile->file;
+		struct inode *inode = file->f_path.dentry->d_inode;
+
+		/* Cause all mappings to trigger a SIGBUS */
+		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+		/* Remove the file from the fasync list because any
+		 * future attempts to add/remove this file from this
+		 * list will return -EIO.
+		 */
+		fasync_helper(-1, file, 0, &idev->async_queue);
+
+		/* Now that userspace is totally blocked off run the
+		 * release code to clean up, the uio devices data
+		 * structures.
+		 */
+		if (info->release)
+			info->release(info, inode);
+
+		/* Forget about this file */
+		unload_file_detach(ufile);
+		fput(file);
+	}
+
 	uio_free_minor(idev);
 
 	uio_dev_del_attributes(idev);
 
+	idev->info = NULL;
 	device_unregister(&idev->device);
 
 	return;
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 3d906e0..81674ef 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -17,6 +17,7 @@
 #include <linux/device.h>
 #include <linux/fs.h>
 #include <linux/interrupt.h>
+#include <linux/unload.h>
 
 struct module;
 struct uio_map;
@@ -65,7 +66,6 @@ struct uio_port {
 #define MAX_UIO_PORT_REGIONS	5
 
 struct uio_device {
-        struct module           *owner;
 	struct device           device;
         int                     minor;
         atomic_t                event;
@@ -74,6 +74,7 @@ struct uio_device {
         struct uio_info         *info;
         struct kobject          *map_dir;
         struct kobject          *portio_dir;
+	struct unload           unload;
 };
 
 /**
@@ -107,13 +108,7 @@ struct uio_info {
 };
 
 extern int __must_check
-	__uio_register_device(struct module *owner,
-			      struct device *parent,
-			      struct uio_info *info);
-
-/* use a define to avoid include chaining to get THIS_MODULE */
-#define uio_register_device(parent, info) \
-	__uio_register_device(THIS_MODULE, parent, info)
+	uio_register_device(struct device *parent, struct uio_info *info);
 
 extern void uio_unregister_device(struct uio_info *info);
 extern void uio_event_notify(struct uio_info *info);
-- 
1.9.1

