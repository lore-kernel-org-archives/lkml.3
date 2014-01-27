Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaA0S7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:59:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754231AbaA0S7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:59:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        jkosina@suse.cz, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 06/11] kexec: A new system call, kexec_file_load, for in kernel kexec
Date: Mon, 27 Jan 2014 13:57:46 -0500
Message-Id: <1390849071-21989-7-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the in kernel kexec functionality. It implements a
new system call kexec_file_load. I think parameter list of this system
call will change as I have not done the kernel image signature handling
yet. I have been told that I might have to pass the detached signature
and size as part of system call.

Previously segment list was prepared in user space. Now user space just
passes kernel fd, initrd fd and command line and kernel will create a
segment list internally.

This patch contains generic part of the code. Actual segment preparation
and loading is done by arch and image specific loader. Which comes in
next patch.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 arch/x86/kernel/machine_kexec_64.c |  50 ++++
 arch/x86/syscalls/syscall_64.tbl   |   1 +
 include/linux/kexec.h              |  55 +++++
 include/linux/syscalls.h           |   3 +
 include/uapi/linux/kexec.h         |   4 +
 kernel/kexec.c                     | 495 ++++++++++++++++++++++++++++++++++++-
 kernel/sys_ni.c                    |   1 +
 7 files changed, 605 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index 4eabc16..c91d72a 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -22,6 +22,13 @@
 #include <asm/mmu_context.h>
 #include <asm/debugreg.h>
 
+/* arch dependent functionality related to kexec file based syscall */
+static struct kexec_file_type kexec_file_type[]={
+	{"", NULL, NULL, NULL},
+};
+
+static int nr_file_types = sizeof(kexec_file_type)/sizeof(kexec_file_type[0]);
+
 static void free_transition_pgtable(struct kimage *image)
 {
 	free_page((unsigned long)image->arch.pud);
@@ -281,3 +288,46 @@ void arch_crash_save_vmcoreinfo(void)
 #endif
 }
 
+/* arch dependent functionality related to kexec file based syscall */
+
+int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
+					unsigned long buf_len)
+{
+	int i, ret = -ENOEXEC;
+
+	for (i = 0; i < nr_file_types; i++) {
+		if (!kexec_file_type[i].probe)
+			continue;
+
+		ret = kexec_file_type[i].probe(buf, buf_len);
+		if (!ret) {
+			image->file_handler_idx = i;
+			return ret;
+		}
+	}
+
+	return ret;
+}
+
+void *arch_kexec_kernel_image_load(struct kimage *image, char *kernel,
+			unsigned long kernel_len, char *initrd,
+			unsigned long initrd_len, char *cmdline,
+			unsigned long cmdline_len)
+{
+	int idx = image->file_handler_idx;
+
+	if (idx < 0)
+		return ERR_PTR(-ENOEXEC);
+
+	return kexec_file_type[idx].load(image, kernel, kernel_len, initrd,
+					initrd_len, cmdline, cmdline_len);
+}
+
+int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	int idx = image->file_handler_idx;
+
+	if (kexec_file_type[idx].cleanup)
+		return kexec_file_type[idx].cleanup(image);
+	return 0;
+}
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index a12bddc..3eec4d4 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -322,6 +322,7 @@
 313	common	finit_module		sys_finit_module
 314	common	sched_setattr		sys_sched_setattr
 315	common	sched_getattr		sys_sched_getattr
+316	common	kexec_file_load		sys_kexec_file_load
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d8188b3..51b56cd 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -121,13 +121,58 @@ struct kimage {
 #define KEXEC_TYPE_DEFAULT 0
 #define KEXEC_TYPE_CRASH   1
 	unsigned int preserve_context : 1;
+	/* If set, we are using file mode kexec syscall */
+	unsigned int file_mode : 1;
 
 #ifdef ARCH_HAS_KIMAGE_ARCH
 	struct kimage_arch arch;
 #endif
+
+	/* Additional Fields for file based kexec syscall */
+	void *kernel_buf;
+	unsigned long kernel_buf_len;
+
+	void *initrd_buf;
+	unsigned long initrd_buf_len;
+
+	char *cmdline_buf;
+	unsigned long cmdline_buf_len;
+
+	/* index of file handler in array */
+	int file_handler_idx;
+
+	/* Image loader handling the kernel can store a pointer here */
+	void * image_loader_data;
 };
 
+/*
+ * Keeps a track of buffer parameters as provided by caller for requesting
+ * memory placement of buffer.
+ */
+struct kexec_buf {
+	struct kimage *image;
+	char *buffer;
+	unsigned long bufsz;
+	unsigned long memsz;
+	unsigned long buf_align;
+	unsigned long buf_min;
+	unsigned long buf_max;
+	int top_down;		/* allocate from top of memory hole */
+};
 
+typedef int (kexec_probe_t)(const char *kernel_buf, unsigned long kernel_size);
+typedef void *(kexec_load_t)(struct kimage *image, char *kernel_buf,
+				unsigned long kernel_len, char *initrd,
+				unsigned long initrd_len, char *cmdline,
+				unsigned long cmdline_len);
+typedef int (kexec_cleanup_t)(struct kimage *image);
+
+struct kexec_file_type {
+	const char *name;
+	kexec_probe_t *probe;
+	kexec_load_t *load;
+	kexec_cleanup_t *cleanup;
+};
 
 /* kexec interface functions */
 extern void machine_kexec(struct kimage *image);
@@ -138,6 +183,11 @@ extern asmlinkage long sys_kexec_load(unsigned long entry,
 					struct kexec_segment __user *segments,
 					unsigned long flags);
 extern int kernel_kexec(void);
+extern int kexec_add_buffer(struct kimage *image, char *buffer,
+			unsigned long bufsz, unsigned long memsz,
+			unsigned long buf_align, unsigned long buf_min,
+			unsigned long buf_max, int buf_end,
+			unsigned long *load_addr);
 #ifdef CONFIG_COMPAT
 extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,
@@ -146,6 +196,8 @@ extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 #endif
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
+extern void kimage_set_start_addr(struct kimage *image, unsigned long start);
+
 extern void crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
@@ -194,6 +246,9 @@ extern int kexec_load_disabled;
 #define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT)
 #endif
 
+/* Listof defined/legal kexec file flags */
+#define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH)
+
 #define VMCOREINFO_BYTES           (4096)
 #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
 #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40ed9e9..db55884 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -307,6 +307,9 @@ asmlinkage long sys_restart_syscall(void);
 asmlinkage long sys_kexec_load(unsigned long entry, unsigned long nr_segments,
 				struct kexec_segment __user *segments,
 				unsigned long flags);
+asmlinkage long sys_kexec_file_load(int kernel_fd, int initrd_fd,
+				const char __user * cmdline_ptr,
+				unsigned long cmdline_len, unsigned long flags);
 
 asmlinkage long sys_exit(int error_code);
 asmlinkage long sys_exit_group(int error_code);
diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
index d6629d4..5fddb1b 100644
--- a/include/uapi/linux/kexec.h
+++ b/include/uapi/linux/kexec.h
@@ -13,6 +13,10 @@
 #define KEXEC_PRESERVE_CONTEXT	0x00000002
 #define KEXEC_ARCH_MASK		0xffff0000
 
+/* Kexec file load interface flags */
+#define KEXEC_FILE_UNLOAD	0x00000001
+#define KEXEC_FILE_ON_CRASH	0x00000002
+
 /* These values match the ELF architecture values.
  * Unless there is a good reason that should continue to be the case.
  */
diff --git a/kernel/kexec.c b/kernel/kexec.c
index c0944b2..b28578a 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -123,6 +123,11 @@ static struct page *kimage_alloc_page(struct kimage *image,
 				       gfp_t gfp_mask,
 				       unsigned long dest);
 
+void kimage_set_start_addr(struct kimage *image, unsigned long start)
+{
+	image->start = start;
+}
+
 static int copy_user_segment_list(struct kimage *image,
 				unsigned long nr_segments,
 				struct kexec_segment __user *segments)
@@ -259,6 +264,219 @@ static struct kimage *do_kimage_alloc_init(void)
 
 static void kimage_free_page_list(struct list_head *list);
 
+static int copy_file_from_fd(int fd, void **buf, unsigned long *buf_len)
+{
+	struct fd f = fdget(fd);
+	int ret = 0;
+	struct kstat stat;
+	loff_t pos;
+	ssize_t bytes = 0;
+
+	if (!f.file)
+		return -EBADF;
+
+	ret = vfs_getattr(&f.file->f_path, &stat);
+	if (ret)
+		goto out;
+
+	if (stat.size > INT_MAX) {
+		ret = -EFBIG;
+		goto out;
+	}
+
+	/* Don't hand 0 to vmalloc, it whines. */
+	if (stat.size == 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	*buf = vmalloc(stat.size);
+        if (!*buf) {
+                ret = -ENOMEM;
+                goto out;
+        }
+
+	pos = 0;
+	while (pos < stat.size) {
+		bytes = kernel_read(f.file, pos, (char *)(*buf) + pos,
+                                    stat.size - pos);
+                if (bytes < 0) {
+                        vfree(*buf);
+                        ret = bytes;
+                        goto out;
+                }
+
+                if (bytes == 0)
+                        break;
+                pos += bytes;
+        }
+
+        *buf_len = pos;
+
+out:
+	fdput(f);
+	return ret;
+}
+
+/* Architectures can provide this probe function */
+int __attribute__ ((weak))
+arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
+				unsigned long buf_len)
+{
+	return -ENOEXEC;
+}
+
+void * __attribute__ ((weak))
+arch_kexec_kernel_image_load(struct kimage *image, char *kernel,
+		unsigned long kernel_len, char *initrd,
+		unsigned long initrd_len, char *cmdline,
+		unsigned long cmdline_len)
+{
+	return ERR_PTR(-ENOEXEC);
+}
+
+void __attribute__ ((weak))
+arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	return;
+}
+
+/*
+ * Free up tempory buffers allocated which are not needed after image has
+ * been loaded.
+ *
+ * Free up memory used by kernel, initrd, and comand line. This is temporary
+ * memory allocation which is not needed any more after these buffers have
+ * been loaded into separate segments and have been copied elsewhere
+ */
+static void kimage_file_post_load_cleanup(struct kimage *image)
+{
+	vfree(image->kernel_buf);
+	image->kernel_buf = NULL;
+
+	vfree(image->initrd_buf);
+	image->initrd_buf = NULL;
+
+	vfree(image->cmdline_buf);
+	image->cmdline_buf = NULL;
+
+	/* See if architcture has anything to cleanup post load */
+	arch_kimage_file_post_load_cleanup(image);
+}
+
+/*
+ * In file mode list of segments is prepared by kernel. Copy relevant
+ * data from user space, do error checking, prepare segment list
+ */
+static int kimage_file_prepare_segments(struct kimage *image, int kernel_fd,
+		int initrd_fd, const char __user *cmdline_ptr,
+		unsigned long cmdline_len)
+{
+	int ret = 0;
+	void *ldata;
+
+	ret = copy_file_from_fd(kernel_fd, &image->kernel_buf,
+					&image->kernel_buf_len);
+	if (ret)
+		goto out;
+
+	/* Call arch image probe handlers */
+	ret = arch_kexec_kernel_image_probe(image, image->kernel_buf,
+						image->kernel_buf_len);
+
+	if (ret)
+		goto out;
+
+	ret = copy_file_from_fd(initrd_fd, &image->initrd_buf,
+					&image->initrd_buf_len);
+	if (ret)
+		goto out;
+
+	image->cmdline_buf = vzalloc(cmdline_len);
+	if (!image->cmdline_buf)
+		goto out;
+
+	ret = copy_from_user(image->cmdline_buf, cmdline_ptr, cmdline_len);
+	if (ret) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	image->cmdline_buf_len = cmdline_len;
+
+	/* command line should be a string with last byte null */
+	if (image->cmdline_buf[cmdline_len - 1] != '\0') {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* Call arch image load handlers */
+	ldata = arch_kexec_kernel_image_load(image,
+			image->kernel_buf, image->kernel_buf_len,
+			image->initrd_buf, image->initrd_buf_len,
+			image->cmdline_buf, image->cmdline_buf_len);
+
+	if (IS_ERR(ldata)) {
+		ret = PTR_ERR(ldata);
+		goto out;
+	}
+
+	image->image_loader_data = ldata;
+out:
+	return ret;
+}
+
+static int kimage_file_normal_alloc(struct kimage **rimage, int kernel_fd,
+		int initrd_fd, const char __user *cmdline_ptr,
+		unsigned long cmdline_len)
+{
+	int result;
+	struct kimage *image;
+
+	/* Allocate and initialize a controlling structure */
+	image = do_kimage_alloc_init();
+	if (!image)
+		return -ENOMEM;
+
+	image->file_mode = 1;
+	image->file_handler_idx = -1;
+
+	result = kimage_file_prepare_segments(image, kernel_fd, initrd_fd,
+			cmdline_ptr, cmdline_len);
+	if (result)
+		goto out_free_image;
+
+	result = sanity_check_segment_list(image);
+	if (result)
+		goto out_free_post_load_bufs;
+
+	result = -ENOMEM;
+	image->control_code_page = kimage_alloc_control_pages(image,
+					   get_order(KEXEC_CONTROL_PAGE_SIZE));
+	if (!image->control_code_page) {
+		printk(KERN_ERR "Could not allocate control_code_buffer\n");
+		goto out_free_post_load_bufs;
+	}
+
+	image->swap_page = kimage_alloc_control_pages(image, 0);
+	if (!image->swap_page) {
+		printk(KERN_ERR "Could not allocate swap buffer\n");
+		goto out_free_control_pages;
+	}
+
+	*rimage = image;
+	return 0;
+
+out_free_control_pages:
+	kimage_free_page_list(&image->control_pages);
+out_free_post_load_bufs:
+	kimage_file_post_load_cleanup(image);
+	kfree(image->image_loader_data);
+out_free_image:
+	kfree(image);
+	return result;
+}
+
 static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 				unsigned long nr_segments,
 				struct kexec_segment __user *segments)
@@ -682,6 +900,16 @@ static void kimage_free(struct kimage *image)
 
 	/* Free the kexec control pages... */
 	kimage_free_page_list(&image->control_pages);
+
+	kfree(image->image_loader_data);
+
+	/*
+	 * Free up any temporary buffers allocated. This might hit if
+	 * error occurred much later after buffer allocation.
+	 */
+	if (image->file_mode)
+		kimage_file_post_load_cleanup(image);
+
 	kfree(image);
 }
 
@@ -811,10 +1039,14 @@ static int kimage_load_normal_segment(struct kimage *image,
 	unsigned long maddr;
 	size_t ubytes, mbytes;
 	int result;
-	unsigned char __user *buf;
+	unsigned char __user *buf = NULL;
+	unsigned char *kbuf = NULL;
 
 	result = 0;
-	buf = segment->buf;
+	if (image->file_mode)
+		kbuf = segment->kbuf;
+	else
+		buf = segment->buf;
 	ubytes = segment->bufsz;
 	mbytes = segment->memsz;
 	maddr = segment->mem;
@@ -846,7 +1078,11 @@ static int kimage_load_normal_segment(struct kimage *image,
 				PAGE_SIZE - (maddr & ~PAGE_MASK));
 		uchunk = min(ubytes, mchunk);
 
-		result = copy_from_user(ptr, buf, uchunk);
+		/* For file based kexec, source pages are in kernel memory */
+		if (image->file_mode)
+			memcpy(ptr, kbuf, uchunk);
+		else
+			result = copy_from_user(ptr, buf, uchunk);
 		kunmap(page);
 		if (result) {
 			result = -EFAULT;
@@ -854,7 +1090,10 @@ static int kimage_load_normal_segment(struct kimage *image,
 		}
 		ubytes -= uchunk;
 		maddr  += mchunk;
-		buf    += mchunk;
+		if (image->file_mode)
+			kbuf += mchunk;
+		else
+			buf += mchunk;
 		mbytes -= mchunk;
 	}
 out:
@@ -1097,6 +1336,72 @@ asmlinkage long compat_sys_kexec_load(unsigned long entry,
 }
 #endif
 
+SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd, const char __user *, cmdline_ptr, unsigned long, cmdline_len, unsigned long, flags)
+{
+	int ret = 0, i;
+	struct kimage **dest_image, *image;
+
+	/* We only trust the superuser with rebooting the system. */
+	if (!capable(CAP_SYS_BOOT))
+		return -EPERM;
+
+	pr_debug("kexec_file_load: kernel_fd=%d initrd_fd=%d cmdline=0x%p"
+			" cmdline_len=%lu flags=0x%lx\n", kernel_fd, initrd_fd,
+			cmdline_ptr, cmdline_len, flags);
+
+	/* Make sure we have a legal set of flags */
+	if (flags != (flags & KEXEC_FILE_FLAGS))
+		return -EINVAL;
+
+	image = NULL;
+
+	if (!mutex_trylock(&kexec_mutex))
+		return -EBUSY;
+
+	dest_image = &kexec_image;
+	if (flags & KEXEC_FILE_ON_CRASH)
+		dest_image = &kexec_crash_image;
+
+	if (flags & KEXEC_FILE_UNLOAD)
+		goto exchange;
+
+	ret = kimage_file_normal_alloc(&image, kernel_fd, initrd_fd,
+				cmdline_ptr, cmdline_len);
+	if (ret)
+		goto out;
+
+	ret = machine_kexec_prepare(image);
+	if (ret)
+		goto out;
+
+	for (i = 0; i < image->nr_segments; i++) {
+		struct kexec_segment *ksegment;
+
+		ksegment = &image->segment[i];
+		pr_debug("Loading segment %d: buf=0x%p bufsz=0x%zx mem=0x%lx"
+			" memsz=0x%zx\n", i, ksegment->buf, ksegment->bufsz,
+			ksegment->mem, ksegment->memsz);
+		ret = kimage_load_segment(image, &image->segment[i]);
+		if (ret)
+			goto out;
+		pr_debug("Done loading segment %d\n", i);
+	}
+
+	kimage_terminate(image);
+
+	/*
+	 * Free up any temporary buffers allocated which are not needed
+	 * after image has been loaded
+	 */
+	kimage_file_post_load_cleanup(image);
+exchange:
+	image = xchg(dest_image, image);
+out:
+	mutex_unlock(&kexec_mutex);
+	kimage_free(image);
+	return ret;
+}
+
 void crash_kexec(struct pt_regs *regs)
 {
 	/* Take the kexec_mutex here to prevent sys_kexec_load
@@ -1651,6 +1956,188 @@ static int __init crash_save_vmcoreinfo_init(void)
 
 module_init(crash_save_vmcoreinfo_init)
 
+static int __kexec_add_segment(struct kimage *image, char *buf,
+		unsigned long bufsz, unsigned long mem, unsigned long memsz)
+{
+	struct kexec_segment *ksegment;
+
+	ksegment = &image->segment[image->nr_segments];
+	ksegment->kbuf = buf;
+	ksegment->bufsz = bufsz;
+	ksegment->mem = mem;
+	ksegment->memsz = memsz;
+	image->nr_segments++;
+
+	return 0;
+}
+
+static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
+					struct kexec_buf *kbuf)
+{
+	struct kimage *image = kbuf->image;
+	unsigned long temp_start, temp_end;
+
+	temp_end = min(end, kbuf->buf_max);
+	temp_start = temp_end - kbuf->memsz;
+
+	do {
+		/* align down start */
+		temp_start = temp_start & (~ (kbuf->buf_align - 1));
+
+		if (temp_start < start || temp_start < kbuf->buf_min)
+			return 0;
+
+		temp_end = temp_start + kbuf->memsz - 1;
+
+		/*
+		 * Make sure this does not conflict with any of existing
+		 * segments
+		 */
+		if (kimage_is_destination_range(image, temp_start, temp_end)) {
+			temp_start = temp_start - PAGE_SIZE;
+			continue;
+		}
+
+		/* We found a suitable memory range */
+		break;
+	} while(1);
+
+	/* If we are here, we found a suitable memory range */
+	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
+				kbuf->memsz);
+
+	/* Stop navigating through remaining System RAM ranges */
+	return 1;
+}
+
+static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
+					struct kexec_buf *kbuf)
+{
+	struct kimage *image = kbuf->image;
+	unsigned long temp_start, temp_end;
+
+	temp_start = max(start, kbuf->buf_min);
+
+	do {
+		temp_start = ALIGN(temp_start, kbuf->buf_align);
+		temp_end = temp_start + kbuf->memsz - 1;
+
+		if (temp_end > end || temp_end > kbuf->buf_max)
+			return 0;
+		/*
+		 * Make sure this does not conflict with any of existing
+		 * segments
+		 */
+		if (kimage_is_destination_range(image, temp_start, temp_end)) {
+			temp_start = temp_start + PAGE_SIZE;
+			continue;
+		}
+
+		/* We found a suitable memory range */
+		break;
+	} while(1);
+
+	/* If we are here, we found a suitable memory range */
+	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
+				kbuf->memsz);
+
+	/* Stop navigating through remaining System RAM ranges */
+	return 1;
+}
+
+static int walk_ram_range_callback(u64 start, u64 end, void *arg)
+{
+	struct kexec_buf *kbuf = (struct kexec_buf *)arg;
+	unsigned long sz = end - start + 1;
+
+	/* Returning 0 will take to next memory range */
+	if (sz < kbuf->memsz)
+		return 0;
+
+	if (end < kbuf->buf_min || start > kbuf->buf_max)
+		return 0;
+
+	/*
+	 * Allocate memory top down with-in ram range. Otherwise bottom up
+	 * allocation.
+	 */
+	if (kbuf->top_down)
+		return locate_mem_hole_top_down(start, end, kbuf);
+	else
+		return locate_mem_hole_bottom_up(start, end, kbuf);
+}
+
+/*
+ * Helper functions for placing a buffer in a kexec segment. This assumes
+ * that kexec_mutex is held.
+ */
+int kexec_add_buffer(struct kimage *image, char *buffer,
+		unsigned long bufsz, unsigned long memsz,
+		unsigned long buf_align, unsigned long buf_min,
+		unsigned long buf_max, int top_down, unsigned long *load_addr)
+{
+
+	unsigned long nr_segments = image->nr_segments, new_nr_segments;
+	struct kexec_segment *ksegment;
+	struct kexec_buf *kbuf;
+
+	/* Currently adding segment this way is allowed only in file mode */
+	if (!image->file_mode)
+		return -EINVAL;
+
+	if (nr_segments >= KEXEC_SEGMENT_MAX)
+		return -EINVAL;
+
+	/*
+	 * Make sure we are not trying to add buffer after allocating
+	 * control pages. All segments need to be placed first before
+	 * any control pages are allocated. As control page allocation
+	 * logic goes through list of segments to make sure there are
+	 * no destination overlaps.
+	 */
+	WARN_ONCE(!list_empty(&image->control_pages), "Adding kexec buffer"
+			" after allocating control pages\n");
+
+	kbuf = kzalloc(sizeof(struct kexec_buf), GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	kbuf->image = image;
+	kbuf->buffer = buffer;
+	kbuf->bufsz = bufsz;
+	/* Align memsz to next page boundary */
+	kbuf->memsz = ALIGN(memsz, PAGE_SIZE);
+
+	/* Align to atleast page size boundary */
+	kbuf->buf_align = max(buf_align, PAGE_SIZE);
+	kbuf->buf_min = buf_min;
+	kbuf->buf_max = buf_max;
+	kbuf->top_down = top_down;
+
+	/* Walk the RAM ranges and allocate a suitable range for the buffer */
+	walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
+
+	kbuf->image = NULL;
+	kfree(kbuf);
+
+	/*
+	 * If range could be found successfully, it would have incremented
+	 * the nr_segments value.
+	 */
+	new_nr_segments = image->nr_segments;
+
+	/* A suitable memory range could not be found for buffer */
+	if (new_nr_segments == nr_segments)
+		return -EADDRNOTAVAIL;
+
+	/* Found a suitable memory range */
+
+	ksegment = &image->segment[new_nr_segments - 1];
+	*load_addr = ksegment->mem;
+	return 0;
+}
+
+
 /*
  * Move into place and start executing a preloaded standalone
  * executable.  If nothing was preloaded return an error.
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 7078052..7e1e13d 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -25,6 +25,7 @@ cond_syscall(sys_swapon);
 cond_syscall(sys_swapoff);
 cond_syscall(sys_kexec_load);
 cond_syscall(compat_sys_kexec_load);
+cond_syscall(sys_kexec_file_load);
 cond_syscall(sys_init_module);
 cond_syscall(sys_finit_module);
 cond_syscall(sys_delete_module);
-- 
1.8.4.2

