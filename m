Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348AbaKDSJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 13:09:24 -0500
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:43255 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752250AbaKDSJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:09:20 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] staging: comedi: prepare support for per-file read and write subdevices
Date: Tue,  4 Nov 2014 18:09:00 +0000
Message-Id: <1415124541-13648-2-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415124541-13648-1-git-send-email-abbotti@mev.co.uk>
References: <1415124541-13648-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comedi devices may have several subdevices that support "read" and/or
"write" asynchronous commands that use the "read" or "write" file
operations for data transfer.  The low-level Comedi drivers may nominate
a default "read" subdevice and/or a default "write" subdevice, but it
may have other subdevices that support asynchronous commands.

The Comedi core provides a somewhat clunky mechanism to provide access
to the asynchronous command support of the non-default subdevices.  When
a low-level device is "attached" to a core Comedi device, it dynamically
allocates a minor device number for each of the subdevices that support
asynchrounous commands and associates them with files created in SysFS
named "comediX_subdY", where "X" is the minor device number of the main
comedi device, and "Y" is the subdevice number.  An application can open
these subdevice-specific files and they behave like the regular
"comediX" files except that the "read" and/or "write" subdevice may be
different to the default chosen by the low-level driver.

This patch adds a layer of indirection between the file object and the
comedi device object to allow the current "read" and/or "write"
subdevice to be altered after opening the Comedi device, on a per-file
object basis.  The advantage is that an application only needs to open
the main Comedi device file and can then choose which subdevice it wants
to "read" or "write".  The main Comedi device file can be opened more
than once, and each file object can choose the "read" and "write"
subdevices independently.

The new `struct comedi_file` is created on "open" and freed on
"release".  It includes pointers to the main Comedi device structure,
and to the current "read" and "write" subdevice structures (which may be
NULL).  It also has information to keep track of when a low-level device
has been attached or detached since the previous time the file object
was used.  In that case, the current "read" and "write" subdevices in
the `struct comedi_file` will be changed to the new defaults (or set to
NULL).  (The change to new defaults is done by `comedi_file_reset()`.
The checking for attach/detach is done by `comedi_file_check()` which
will call `comedi_file_reset()` if there have been any attach/detach
operations since the previous call.)

A subsequent patch will add the ioctls to change the current "read" and
"write" subdevices.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/comedi_fops.c | 127 ++++++++++++++++++++++++++++-------
 1 file changed, 102 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 65894fd..79b852c 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -43,6 +43,22 @@
 
 #include "comedi_internal.h"
 
+/**
+ * struct comedi_file - per-file private data for comedi device
+ * @dev: comedi_device struct
+ * @read_subdev: current "read" subdevice
+ * @write_subdev: current "write" subdevice
+ * @last_detach_count: last known detach count
+ * @last_attached: last known attached/detached state
+ */
+struct comedi_file {
+	struct comedi_device *dev;
+	struct comedi_subdevice *read_subdev;
+	struct comedi_subdevice *write_subdev;
+	unsigned int last_detach_count;
+	bool last_attached:1;
+};
+
 #define COMEDI_NUM_MINORS 0x100
 #define COMEDI_NUM_SUBDEVICE_MINORS	\
 	(COMEDI_NUM_MINORS - COMEDI_NUM_BOARD_MINORS)
@@ -239,6 +255,54 @@ comedi_write_subdevice(const struct comedi_device *dev, unsigned int minor)
 	return dev->write_subdev;
 }
 
+static void comedi_file_reset(struct file *file)
+{
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
+	struct comedi_subdevice *s, *read_s, *write_s;
+	unsigned int minor = iminor(file_inode(file));
+
+	read_s = dev->read_subdev;
+	write_s = dev->write_subdev;
+	if (minor >= COMEDI_NUM_BOARD_MINORS) {
+		s = comedi_subdevice_from_minor(dev, minor);
+		if (s == NULL || s->subdev_flags & SDF_CMD_READ)
+			read_s = s;
+		if (s == NULL || s->subdev_flags & SDF_CMD_WRITE)
+			write_s = s;
+	}
+	cfp->last_attached = dev->attached;
+	cfp->last_detach_count = dev->detach_count;
+	ACCESS_ONCE(cfp->read_subdev) = read_s;
+	ACCESS_ONCE(cfp->write_subdev) = write_s;
+}
+
+static void comedi_file_check(struct file *file)
+{
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
+
+	if (cfp->last_attached != dev->attached ||
+	    cfp->last_detach_count != dev->detach_count)
+		comedi_file_reset(file);
+}
+
+static struct comedi_subdevice *comedi_file_read_subdevice(struct file *file)
+{
+	struct comedi_file *cfp = file->private_data;
+
+	comedi_file_check(file);
+	return ACCESS_ONCE(cfp->read_subdev);
+}
+
+static struct comedi_subdevice *comedi_file_write_subdevice(struct file *file)
+{
+	struct comedi_file *cfp = file->private_data;
+
+	comedi_file_check(file);
+	return ACCESS_ONCE(cfp->write_subdev);
+}
+
 static int resize_async_buffer(struct comedi_device *dev,
 			       struct comedi_subdevice *s, unsigned new_size)
 {
@@ -776,7 +840,6 @@ static int do_devinfo_ioctl(struct comedi_device *dev,
 			    struct comedi_devinfo __user *arg,
 			    struct file *file)
 {
-	const unsigned minor = iminor(file_inode(file));
 	struct comedi_subdevice *s;
 	struct comedi_devinfo devinfo;
 
@@ -788,13 +851,13 @@ static int do_devinfo_ioctl(struct comedi_device *dev,
 	strlcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
 	strlcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
 
-	s = comedi_read_subdevice(dev, minor);
+	s = comedi_file_read_subdevice(file);
 	if (s)
 		devinfo.read_subdevice = s->index;
 	else
 		devinfo.read_subdevice = -1;
 
-	s = comedi_write_subdevice(dev, minor);
+	s = comedi_file_write_subdevice(file);
 	if (s)
 		devinfo.write_subdevice = s->index;
 	else
@@ -1787,8 +1850,9 @@ static int do_poll_ioctl(struct comedi_device *dev, unsigned long arg,
 static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
 				  unsigned long arg)
 {
-	const unsigned minor = iminor(file_inode(file));
-	struct comedi_device *dev = file->private_data;
+	unsigned minor = iminor(file_inode(file));
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
 	int rc;
 
 	mutex_lock(&dev->mutex);
@@ -1910,8 +1974,8 @@ static struct vm_operations_struct comedi_vm_ops = {
 
 static int comedi_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	const unsigned minor = iminor(file_inode(file));
-	struct comedi_device *dev = file->private_data;
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
 	struct comedi_subdevice *s;
 	struct comedi_async *async;
 	struct comedi_buf_map *bm = NULL;
@@ -1937,9 +2001,9 @@ static int comedi_mmap(struct file *file, struct vm_area_struct *vma)
 	}
 
 	if (vma->vm_flags & VM_WRITE)
-		s = comedi_write_subdevice(dev, minor);
+		s = comedi_file_write_subdevice(file);
 	else
-		s = comedi_read_subdevice(dev, minor);
+		s = comedi_file_read_subdevice(file);
 	if (!s) {
 		retval = -EINVAL;
 		goto done;
@@ -2002,8 +2066,8 @@ done:
 static unsigned int comedi_poll(struct file *file, poll_table *wait)
 {
 	unsigned int mask = 0;
-	const unsigned minor = iminor(file_inode(file));
-	struct comedi_device *dev = file->private_data;
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
 	struct comedi_subdevice *s;
 
 	mutex_lock(&dev->mutex);
@@ -2013,7 +2077,7 @@ static unsigned int comedi_poll(struct file *file, poll_table *wait)
 		goto done;
 	}
 
-	s = comedi_read_subdevice(dev, minor);
+	s = comedi_file_read_subdevice(file);
 	if (s && s->async) {
 		poll_wait(file, &s->async->wait_head, wait);
 		if (!s->busy || !comedi_is_subdevice_running(s) ||
@@ -2022,7 +2086,7 @@ static unsigned int comedi_poll(struct file *file, poll_table *wait)
 			mask |= POLLIN | POLLRDNORM;
 	}
 
-	s = comedi_write_subdevice(dev, minor);
+	s = comedi_file_write_subdevice(file);
 	if (s && s->async) {
 		unsigned int bps = comedi_bytes_per_sample(s);
 
@@ -2046,8 +2110,8 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 	struct comedi_async *async;
 	int n, m, count = 0, retval = 0;
 	DECLARE_WAITQUEUE(wait, current);
-	const unsigned minor = iminor(file_inode(file));
-	struct comedi_device *dev = file->private_data;
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
 	bool on_wait_queue = false;
 	bool attach_locked;
 	unsigned int old_detach_count;
@@ -2063,7 +2127,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 		goto out;
 	}
 
-	s = comedi_write_subdevice(dev, minor);
+	s = comedi_file_write_subdevice(file);
 	if (!s || !s->async) {
 		retval = -EIO;
 		goto out;
@@ -2115,7 +2179,7 @@ static ssize_t comedi_write(struct file *file, const char __user *buf,
 				 * meantime!), but check the subdevice pointer
 				 * as well just in case.
 				 */
-				new_s = comedi_write_subdevice(dev, minor);
+				new_s = comedi_file_write_subdevice(file);
 				if (dev->attached &&
 				    old_detach_count == dev->detach_count &&
 				    s == new_s && new_s->async == async)
@@ -2190,8 +2254,8 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 	struct comedi_async *async;
 	int n, m, count = 0, retval = 0;
 	DECLARE_WAITQUEUE(wait, current);
-	const unsigned minor = iminor(file_inode(file));
-	struct comedi_device *dev = file->private_data;
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
 	unsigned int old_detach_count;
 	bool become_nonbusy = false;
 	bool attach_locked;
@@ -2207,7 +2271,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 		goto out;
 	}
 
-	s = comedi_read_subdevice(dev, minor);
+	s = comedi_file_read_subdevice(file);
 	if (!s || !s->async) {
 		retval = -EIO;
 		goto out;
@@ -2304,7 +2368,7 @@ static ssize_t comedi_read(struct file *file, char __user *buf, size_t nbytes,
 		 * meantime!), but check the subdevice pointer as well just in
 		 * case.
 		 */
-		new_s = comedi_read_subdevice(dev, minor);
+		new_s = comedi_file_read_subdevice(file);
 		if (dev->attached && old_detach_count == dev->detach_count &&
 		    s == new_s && new_s->async == async) {
 			if (become_nonbusy || comedi_buf_n_bytes_ready(s) == 0)
@@ -2322,6 +2386,7 @@ out:
 static int comedi_open(struct inode *inode, struct file *file)
 {
 	const unsigned minor = iminor(inode);
+	struct comedi_file *cfp;
 	struct comedi_device *dev = comedi_dev_get_from_minor(minor);
 	int rc;
 
@@ -2330,6 +2395,12 @@ static int comedi_open(struct inode *inode, struct file *file)
 		return -ENODEV;
 	}
 
+	cfp = kzalloc(sizeof(*cfp), GFP_KERNEL);
+	if (!cfp)
+		return -ENOMEM;
+
+	cfp->dev = dev;
+
 	mutex_lock(&dev->mutex);
 	if (!dev->attached && !capable(CAP_NET_ADMIN)) {
 		dev_dbg(dev->class_dev, "not attached and not CAP_NET_ADMIN\n");
@@ -2351,26 +2422,31 @@ static int comedi_open(struct inode *inode, struct file *file)
 	}
 
 	dev->use_count++;
-	file->private_data = dev;
+	file->private_data = cfp;
+	comedi_file_reset(file);
 	rc = 0;
 
 out:
 	mutex_unlock(&dev->mutex);
-	if (rc)
+	if (rc) {
 		comedi_dev_put(dev);
+		kfree(cfp);
+	}
 	return rc;
 }
 
 static int comedi_fasync(int fd, struct file *file, int on)
 {
-	struct comedi_device *dev = file->private_data;
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
 
 	return fasync_helper(fd, file, on, &dev->async_queue);
 }
 
 static int comedi_close(struct inode *inode, struct file *file)
 {
-	struct comedi_device *dev = file->private_data;
+	struct comedi_file *cfp = file->private_data;
+	struct comedi_device *dev = cfp->dev;
 	struct comedi_subdevice *s = NULL;
 	int i;
 
@@ -2396,6 +2472,7 @@ static int comedi_close(struct inode *inode, struct file *file)
 
 	mutex_unlock(&dev->mutex);
 	comedi_dev_put(dev);
+	kfree(cfp);
 
 	return 0;
 }
-- 
2.1.1

