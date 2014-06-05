Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaFELRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:17:04 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36028 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaFELRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:17:00 -0400
Date: Thu, 5 Jun 2014 13:15:35 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140605111535.GB16642@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 09:06:56AM -0400, Vivek Goyal wrote:
> Previous patch provided the interface definition and this patch prvides
> implementation of new syscall.
> 
> Previously segment list was prepared in user space. Now user space just
> passes kernel fd, initrd fd and command line and kernel will create a
> segment list internally.
> 
> This patch contains generic part of the code. Actual segment preparation
> and loading is done by arch and image specific loader. Which comes in
> next patch.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  arch/x86/kernel/machine_kexec_64.c |  54 +++++
>  include/linux/kexec.h              |  53 ++++
>  include/uapi/linux/kexec.h         |   4 +
>  kernel/kexec.c                     | 483 ++++++++++++++++++++++++++++++++++++-
>  4 files changed, 589 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> index 679cef0..d9c5cf0 100644
> --- a/arch/x86/kernel/machine_kexec_64.c
> +++ b/arch/x86/kernel/machine_kexec_64.c
> @@ -22,6 +22,13 @@
>  #include <asm/mmu_context.h>
>  #include <asm/debugreg.h>
>  
> +/* arch dependent functionality related to kexec file based syscall */

  ... arch-dependent ...			... file-based ...

> +static struct kexec_file_type kexec_file_type[] = {

You could call this kexec_file_types and use ARRAY_SIZE and drop this
nr_file_types; mangled diff ontop:

Index: b/arch/x86/kernel/machine_kexec_64.c
===================================================================
--- a/arch/x86/kernel/machine_kexec_64.c        2014-06-04 17:32:31.520372283 +0200
+++ b/arch/x86/kernel/machine_kexec_64.c        2014-06-04 17:30:59.214376321 +0200
@@ -23,12 +23,10 @@
 #include <asm/debugreg.h>
 
 /* arch dependent functionality related to kexec file based syscall */
-static struct kexec_file_type kexec_file_type[] = {
+static struct kexec_file_type kexec_file_types[] = {
        {"", NULL, NULL, NULL},
 };
 
-static int nr_file_types = sizeof(kexec_file_type)/sizeof(kexec_file_type[0]);
-
 static void free_transition_pgtable(struct kimage *image)
 {
        free_page((unsigned long)image->arch.pud);
@@ -297,7 +295,7 @@ int arch_kexec_kernel_image_probe(struct
 {
        int i, ret = -ENOEXEC;
 
-       for (i = 0; i < nr_file_types; i++) {
+       for (i = 0; i < ARRAY_SIZE(kexec_file_types); i++) {
                if (!kexec_file_type[i].probe)
                        continue;
 

> +	{"", NULL, NULL, NULL},
> +};
> +
> +static int nr_file_types = sizeof(kexec_file_type)/sizeof(kexec_file_type[0]);
> +

Superfluous newline.

>  static void free_transition_pgtable(struct kimage *image)
>  {
>  	free_page((unsigned long)image->arch.pud);
> @@ -283,3 +290,50 @@ void arch_crash_save_vmcoreinfo(void)
>  			      (unsigned long)&_text - __START_KERNEL);
>  }
>  
> +/* arch dependent functionality related to kexec file based syscall */
> +
> +int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
> +					unsigned long buf_len)

Arg alignment: it is customary to put function args on new line at the
next right position after the opening brace. Ditto for the rest of the
locations where this is the case.

> +{
> +	int i, ret = -ENOEXEC;
> +
> +	for (i = 0; i < nr_file_types; i++) {
> +		if (!kexec_file_type[i].probe)
> +			continue;
> +
> +		ret = kexec_file_type[i].probe(buf, buf_len);
> +		if (!ret) {
> +			image->file_handler_idx = i;
> +			return ret;
> +		}
> +	}
> +
> +	return ret;
> +}
> +
> +void *arch_kexec_kernel_image_load(struct kimage *image, char *kernel,
> +			unsigned long kernel_len, char *initrd,
> +			unsigned long initrd_len, char *cmdline,
> +			unsigned long cmdline_len)

Those are a *lot* of arguments. Maybe a helper struct encompassing them
all to pass around?

> +{
> +	int idx = image->file_handler_idx;
> +
> +	if (idx < 0)
> +		return ERR_PTR(-ENOEXEC);
> +
> +	return kexec_file_type[idx].load(image, kernel, kernel_len, initrd,
> +					initrd_len, cmdline, cmdline_len);
> +}
> +
> +int arch_kimage_file_post_load_cleanup(struct kimage *image)
> +{
> +	int idx = image->file_handler_idx;
> +
> +	/* This can be called up even before image handler has been set */
> +	if (idx < 0)
> +		return 0;

Btw, these games with the index seem not optimal to me. Why not simply
have image->fops or so which is a pointer to struct kexec_file_type
after having it renamed to kexec_file_ops and then assign the correct
one to image->fops in arch_kexec_kernel_image_probe() and then simply
call the proper handler:

	if (!image->fops)
		return;

	return image->fops->cleanup(image);

and above

	return image->fops->load(...)

and so on.

In any case, this looks cleaner to me.

> +
> +	if (kexec_file_type[idx].cleanup)
> +		return kexec_file_type[idx].cleanup(image);
> +	return 0;
> +}
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index d0285cc..3790519 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -121,13 +121,58 @@ struct kimage {
>  #define KEXEC_TYPE_DEFAULT 0
>  #define KEXEC_TYPE_CRASH   1
>  	unsigned int preserve_context : 1;
> +	/* If set, we are using file mode kexec syscall */
> +	unsigned int file_mode:1;
>  
>  #ifdef ARCH_HAS_KIMAGE_ARCH
>  	struct kimage_arch arch;
>  #endif
> +
> +	/* Additional Fields for file based kexec syscall */

Why capitalized?

> +	void *kernel_buf;
> +	unsigned long kernel_buf_len;
> +
> +	void *initrd_buf;
> +	unsigned long initrd_buf_len;
> +
> +	char *cmdline_buf;
> +	unsigned long cmdline_buf_len;
> +
> +	/* index of file handler in array */
> +	int file_handler_idx;
> +
> +	/* Image loader handling the kernel can store a pointer here */
> +	void *image_loader_data;
>  };
>  
> +/*
> + * Keeps a track of buffer parameters as provided by caller for requesting

"Keeps track"

> + * memory placement of buffer.
> + */
> +struct kexec_buf {
> +	struct kimage *image;
> +	char *buffer;
> +	unsigned long bufsz;
> +	unsigned long memsz;
> +	unsigned long buf_align;
> +	unsigned long buf_min;
> +	unsigned long buf_max;
> +	bool top_down;		/* allocate from top of memory hole */
> +};
>  
> +typedef int (kexec_probe_t)(const char *kernel_buf, unsigned long kernel_size);
> +typedef void *(kexec_load_t)(struct kimage *image, char *kernel_buf,
> +				unsigned long kernel_len, char *initrd,
> +				unsigned long initrd_len, char *cmdline,
> +				unsigned long cmdline_len);
> +typedef int (kexec_cleanup_t)(struct kimage *image);
> +
> +struct kexec_file_type {
> +	const char *name;
> +	kexec_probe_t *probe;
> +	kexec_load_t *load;
> +	kexec_cleanup_t *cleanup;
> +};
>  
>  /* kexec interface functions */
>  extern void machine_kexec(struct kimage *image);
> @@ -138,6 +183,11 @@ extern asmlinkage long sys_kexec_load(unsigned long entry,
>  					struct kexec_segment __user *segments,
>  					unsigned long flags);
>  extern int kernel_kexec(void);
> +extern int kexec_add_buffer(struct kimage *image, char *buffer,
> +			unsigned long bufsz, unsigned long memsz,
> +			unsigned long buf_align, unsigned long buf_min,
> +			unsigned long buf_max, bool top_down,
> +			unsigned long *load_addr);
>  extern struct page *kimage_alloc_control_pages(struct kimage *image,
>  						unsigned int order);
>  extern void crash_kexec(struct pt_regs *);
> @@ -188,6 +238,9 @@ extern int kexec_load_disabled;
>  #define KEXEC_FLAGS    (KEXEC_ON_CRASH | KEXEC_PRESERVE_CONTEXT)
>  #endif
>  
> +/* Listof defined/legal kexec file flags */

"List of ..."

> +#define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH)
> +
>  #define VMCOREINFO_BYTES           (4096)
>  #define VMCOREINFO_NOTE_NAME       "VMCOREINFO"
>  #define VMCOREINFO_NOTE_NAME_BYTES ALIGN(sizeof(VMCOREINFO_NOTE_NAME), 4)
> diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
> index d6629d4..5fddb1b 100644
> --- a/include/uapi/linux/kexec.h
> +++ b/include/uapi/linux/kexec.h
> @@ -13,6 +13,10 @@
>  #define KEXEC_PRESERVE_CONTEXT	0x00000002
>  #define KEXEC_ARCH_MASK		0xffff0000
>  
> +/* Kexec file load interface flags */
> +#define KEXEC_FILE_UNLOAD	0x00000001
> +#define KEXEC_FILE_ON_CRASH	0x00000002

Do we have those documented somewhere and what do they mean?

> +
>  /* These values match the ELF architecture values.
>   * Unless there is a good reason that should continue to be the case.
>   */
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index a3044e6..1ad4d60 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -260,6 +260,221 @@ static struct kimage *do_kimage_alloc_init(void)
>  
>  static void kimage_free_page_list(struct list_head *list);
>  
> +static int copy_file_from_fd(int fd, void **buf, unsigned long *buf_len)
> +{
> +	struct fd f = fdget(fd);
> +	int ret = 0;
> +	struct kstat stat;
> +	loff_t pos;
> +	ssize_t bytes = 0;
> +
> +	if (!f.file)
> +		return -EBADF;
> +
> +	ret = vfs_getattr(&f.file->f_path, &stat);
> +	if (ret)
> +		goto out;
> +
> +	if (stat.size > INT_MAX) {
> +		ret = -EFBIG;
> +		goto out;
> +	}
> +
> +	/* Don't hand 0 to vmalloc, it whines. */
> +	if (stat.size == 0) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	*buf = vmalloc(stat.size);
> +	if (!*buf) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	pos = 0;
> +	while (pos < stat.size) {
> +		bytes = kernel_read(f.file, pos, (char *)(*buf) + pos,
> +					stat.size - pos);
> +		if (bytes < 0) {
> +			vfree(*buf);
> +			ret = bytes;
> +			goto out;
> +		}
> +
> +		if (bytes == 0)
> +			break;
> +		pos += bytes;
> +	}
> +
> +	*buf_len = pos;
> +out:
> +	fdput(f);
> +	return ret;
> +}
> +
> +/* Architectures can provide this probe function */
> +int __attribute__ ((weak))

We have __weak for that.

> +arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
> +				unsigned long buf_len)
> +{
> +	return -ENOEXEC;
> +}
> +
> +void *__attribute__ ((weak))

ditto.

> +arch_kexec_kernel_image_load(struct kimage *image, char *kernel,
> +		unsigned long kernel_len, char *initrd,
> +		unsigned long initrd_len, char *cmdline,
> +		unsigned long cmdline_len)
> +{
> +	return ERR_PTR(-ENOEXEC);
> +}
> +
> +void __attribute__ ((weak))

ditto.

> +arch_kimage_file_post_load_cleanup(struct kimage *image)
> +{
> +	return;
> +}
> +
> +/*
> + * Free up tempory buffers allocated which are not needed after image has
> + * been loaded.
> + *
> + * Free up memory used by kernel, initrd, and comand line. This is temporary
> + * memory allocation which is not needed any more after these buffers have
> + * been loaded into separate segments and have been copied elsewhere
> + */

Why do we need that comment? It is obvious what's going on.

> +static void kimage_file_post_load_cleanup(struct kimage *image)
> +{
> +	vfree(image->kernel_buf);
> +	image->kernel_buf = NULL;
> +
> +	vfree(image->initrd_buf);
> +	image->initrd_buf = NULL;
> +
> +	vfree(image->cmdline_buf);
> +	image->cmdline_buf = NULL;
> +
> +	/* See if architcture has anything to cleanup post load */

s/architcture/architecture/

> +	arch_kimage_file_post_load_cleanup(image);
> +}
> +
> +/*
> + * In file mode list of segments is prepared by kernel. Copy relevant
> + * data from user space, do error checking, prepare segment list
> + */
> +static int kimage_file_prepare_segments(struct kimage *image, int kernel_fd,
> +		int initrd_fd, const char __user *cmdline_ptr,
> +		unsigned long cmdline_len)

arg alignment

> +{
> +	int ret = 0;
> +	void *ldata;
> +
> +	ret = copy_file_from_fd(kernel_fd, &image->kernel_buf,
> +					&image->kernel_buf_len);
> +	if (ret)
> +		return ret;
> +
> +	/* Call arch image probe handlers */
> +	ret = arch_kexec_kernel_image_probe(image, image->kernel_buf,
> +						image->kernel_buf_len);
> +
> +	if (ret)
> +		goto out;
> +
> +	ret = copy_file_from_fd(initrd_fd, &image->initrd_buf,
> +					&image->initrd_buf_len);
> +	if (ret)
> +		goto out;
> +
> +	image->cmdline_buf = vzalloc(cmdline_len);
> +	if (!image->cmdline_buf)

		ret = -ENOMEM;

> +		goto out;
> +
> +	ret = copy_from_user(image->cmdline_buf, cmdline_ptr, cmdline_len);
> +	if (ret) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	image->cmdline_buf_len = cmdline_len;
> +
> +	/* command line should be a string with last byte null */
> +	if (image->cmdline_buf[cmdline_len - 1] != '\0') {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	/* Call arch image load handlers */
> +	ldata = arch_kexec_kernel_image_load(image,
> +			image->kernel_buf, image->kernel_buf_len,
> +			image->initrd_buf, image->initrd_buf_len,
> +			image->cmdline_buf, image->cmdline_buf_len);
> +
> +	if (IS_ERR(ldata)) {
> +		ret = PTR_ERR(ldata);
> +		goto out;
> +	}
> +
> +	image->image_loader_data = ldata;
> +out:
> +	/* In case of error, free up all allocated memory in this function */
> +	if (ret)
> +		kimage_file_post_load_cleanup(image);
> +	return ret;
> +}
> +
> +static int kimage_file_normal_alloc(struct kimage **rimage, int kernel_fd,
> +		int initrd_fd, const char __user *cmdline_ptr,
> +		unsigned long cmdline_len)

arg alignment

> +{
> +	int result;
> +	struct kimage *image;
> +
> +	/* Allocate and initialize a controlling structure */

No need for that comment IMO.

> +	image = do_kimage_alloc_init();
> +	if (!image)
> +		return -ENOMEM;
> +
> +	image->file_mode = 1;
> +	image->file_handler_idx = -1;
> +
> +	result = kimage_file_prepare_segments(image, kernel_fd, initrd_fd,
> +			cmdline_ptr, cmdline_len);

arg alignment... yeah, you know what I mean, I'm not going to point
those out further anymore.

> +	if (result)
> +		goto out_free_image;
> +
> +	result = sanity_check_segment_list(image);
> +	if (result)
> +		goto out_free_post_load_bufs;
> +
> +	result = -ENOMEM;
> +	image->control_code_page = kimage_alloc_control_pages(image,
> +					   get_order(KEXEC_CONTROL_PAGE_SIZE));
> +	if (!image->control_code_page) {
> +		pr_err("Could not allocate control_code_buffer\n");

Might wanna define pr_fmt when using the pr_* things fo the first time
in this file.

> +		goto out_free_post_load_bufs;
> +	}
> +
> +	image->swap_page = kimage_alloc_control_pages(image, 0);
> +	if (!image->swap_page) {
> +		pr_err(KERN_ERR "Could not allocate swap buffer\n");
> +		goto out_free_control_pages;
> +	}
> +
> +	*rimage = image;
> +	return 0;
> +
> +out_free_control_pages:
> +	kimage_free_page_list(&image->control_pages);
> +out_free_post_load_bufs:
> +	kimage_file_post_load_cleanup(image);
> +	kfree(image->image_loader_data);
> +out_free_image:
> +	kfree(image);
> +	return result;
> +}
> +
>  static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
>  				unsigned long nr_segments,
>  				struct kexec_segment __user *segments)
> @@ -683,6 +898,16 @@ static void kimage_free(struct kimage *image)
>  
>  	/* Free the kexec control pages... */
>  	kimage_free_page_list(&image->control_pages);
> +
> +	kfree(image->image_loader_data);
> +
> +	/*
> +	 * Free up any temporary buffers allocated. This might hit if
> +	 * error occurred much later after buffer allocation.
> +	 */
> +	if (image->file_mode)
> +		kimage_file_post_load_cleanup(image);
> +
>  	kfree(image);
>  }
>  
> @@ -812,10 +1037,14 @@ static int kimage_load_normal_segment(struct kimage *image,
>  	unsigned long maddr;
>  	size_t ubytes, mbytes;
>  	int result;
> -	unsigned char __user *buf;
> +	unsigned char __user *buf = NULL;
> +	unsigned char *kbuf = NULL;
>  
>  	result = 0;
> -	buf = segment->buf;
> +	if (image->file_mode)
> +		kbuf = segment->kbuf;
> +	else
> +		buf = segment->buf;
>  	ubytes = segment->bufsz;
>  	mbytes = segment->memsz;
>  	maddr = segment->mem;
> @@ -847,7 +1076,11 @@ static int kimage_load_normal_segment(struct kimage *image,
>  				PAGE_SIZE - (maddr & ~PAGE_MASK));
>  		uchunk = min(ubytes, mchunk);
>  
> -		result = copy_from_user(ptr, buf, uchunk);
> +		/* For file based kexec, source pages are in kernel memory */
> +		if (image->file_mode)
> +			memcpy(ptr, kbuf, uchunk);
> +		else
> +			result = copy_from_user(ptr, buf, uchunk);
>  		kunmap(page);
>  		if (result) {
>  			result = -EFAULT;
> @@ -855,7 +1088,10 @@ static int kimage_load_normal_segment(struct kimage *image,
>  		}
>  		ubytes -= uchunk;
>  		maddr  += mchunk;
> -		buf    += mchunk;
> +		if (image->file_mode)
> +			kbuf += mchunk;
> +		else
> +			buf += mchunk;
>  		mbytes -= mchunk;
>  	}
>  out:
> @@ -1102,7 +1338,64 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
>  		const char __user *, cmdline_ptr, unsigned long,
>  		cmdline_len, unsigned long, flags)
>  {
> -	return -ENOSYS;
> +	int ret = 0, i;
> +	struct kimage **dest_image, *image;
> +
> +	/* We only trust the superuser with rebooting the system. */
> +	if (!capable(CAP_SYS_BOOT))
> +		return -EPERM;
> +
> +	/* Make sure we have a legal set of flags */
> +	if (flags != (flags & KEXEC_FILE_FLAGS))
> +		return -EINVAL;

This test looks strange: according to it, kexec_file_load has to always
be called with both KEXEC_FILE_UNLOAD and KEXEC_FILE_ON_CRASH set. Don't
you want to check against an allowed mask or so like KEXEC_FLAGS is
handled in kexec_load?

> +
> +	image = NULL;
> +
> +	if (!mutex_trylock(&kexec_mutex))
> +		return -EBUSY;
> +
> +	dest_image = &kexec_image;
> +	if (flags & KEXEC_FILE_ON_CRASH)
> +		dest_image = &kexec_crash_image;
> +
> +	if (flags & KEXEC_FILE_UNLOAD)
> +		goto exchange;
> +
> +	ret = kimage_file_normal_alloc(&image, kernel_fd, initrd_fd,
> +				cmdline_ptr, cmdline_len);
> +	if (ret)
> +		goto out;
> +
> +	ret = machine_kexec_prepare(image);
> +	if (ret)
> +		goto out;
> +
> +	for (i = 0; i < image->nr_segments; i++) {
> +		struct kexec_segment *ksegment;
> +
> +		ksegment = &image->segment[i];
> +		pr_debug("Loading segment %d: buf=0x%p bufsz=0x%zx mem=0x%lx memsz=0x%zx\n",
> +			 i, ksegment->buf, ksegment->bufsz, ksegment->mem,
> +			 ksegment->memsz);
> +
> +		ret = kimage_load_segment(image, &image->segment[i]);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	kimage_terminate(image);
> +
> +	/*
> +	 * Free up any temporary buffers allocated which are not needed
> +	 * after image has been loaded
> +	 */
> +	kimage_file_post_load_cleanup(image);
> +exchange:
> +	image = xchg(dest_image, image);
> +out:
> +	mutex_unlock(&kexec_mutex);
> +	kimage_free(image);
> +	return ret;
>  }
>  
>  void crash_kexec(struct pt_regs *regs)
> @@ -1659,6 +1952,186 @@ static int __init crash_save_vmcoreinfo_init(void)
>  
>  subsys_initcall(crash_save_vmcoreinfo_init);
>  
> +static int __kexec_add_segment(struct kimage *image, char *buf,
> +		unsigned long bufsz, unsigned long mem, unsigned long memsz)
> +{
> +	struct kexec_segment *ksegment;
> +
> +	ksegment = &image->segment[image->nr_segments];
> +	ksegment->kbuf = buf;
> +	ksegment->bufsz = bufsz;
> +	ksegment->mem = mem;
> +	ksegment->memsz = memsz;
> +	image->nr_segments++;
> +
> +	return 0;
> +}
> +
> +static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
> +					struct kexec_buf *kbuf)
> +{
> +	struct kimage *image = kbuf->image;
> +	unsigned long temp_start, temp_end;
> +
> +	temp_end = min(end, kbuf->buf_max);
> +	temp_start = temp_end - kbuf->memsz;
> +
> +	do {
> +		/* align down start */
> +		temp_start = temp_start & (~(kbuf->buf_align - 1));
> +
> +		if (temp_start < start || temp_start < kbuf->buf_min)
> +			return 0;
> +
> +		temp_end = temp_start + kbuf->memsz - 1;
> +
> +		/*
> +		 * Make sure this does not conflict with any of existing
> +		 * segments
> +		 */
> +		if (kimage_is_destination_range(image, temp_start, temp_end)) {
> +			temp_start = temp_start - PAGE_SIZE;
> +			continue;
> +		}
> +
> +		/* We found a suitable memory range */
> +		break;
> +	} while (1);
> +
> +	/* If we are here, we found a suitable memory range */
> +	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
> +				kbuf->memsz);
> +
> +	/* Stop navigating through remaining System RAM ranges */
> +	return 1;
> +}
> +
> +static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
> +					struct kexec_buf *kbuf)
> +{
> +	struct kimage *image = kbuf->image;
> +	unsigned long temp_start, temp_end;
> +
> +	temp_start = max(start, kbuf->buf_min);
> +
> +	do {
> +		temp_start = ALIGN(temp_start, kbuf->buf_align);
> +		temp_end = temp_start + kbuf->memsz - 1;
> +
> +		if (temp_end > end || temp_end > kbuf->buf_max)
> +			return 0;
> +		/*
> +		 * Make sure this does not conflict with any of existing
> +		 * segments
> +		 */
> +		if (kimage_is_destination_range(image, temp_start, temp_end)) {
> +			temp_start = temp_start + PAGE_SIZE;
> +			continue;
> +		}
> +
> +		/* We found a suitable memory range */
> +		break;
> +	} while (1);
> +
> +	/* If we are here, we found a suitable memory range */
> +	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
> +				kbuf->memsz);
> +
> +	/* Stop navigating through remaining System RAM ranges */
> +	return 1;
> +}
> +
> +static int walk_ram_range_callback(u64 start, u64 end, void *arg)
> +{
> +	struct kexec_buf *kbuf = (struct kexec_buf *)arg;
> +	unsigned long sz = end - start + 1;
> +
> +	/* Returning 0 will take to next memory range */
> +	if (sz < kbuf->memsz)
> +		return 0;
> +
> +	if (end < kbuf->buf_min || start > kbuf->buf_max)
> +		return 0;
> +
> +	/*
> +	 * Allocate memory top down with-in ram range. Otherwise bottom up
> +	 * allocation.
> +	 */
> +	if (kbuf->top_down)
> +		return locate_mem_hole_top_down(start, end, kbuf);
> +	else
> +		return locate_mem_hole_bottom_up(start, end, kbuf);
> +}
> +
> +/*
> + * Helper functions for placing a buffer in a kexec segment. This assumes

s/functions/function/

> + * that kexec_mutex is held.
> + */
> +int kexec_add_buffer(struct kimage *image, char *buffer,
> +		unsigned long bufsz, unsigned long memsz,
> +		unsigned long buf_align, unsigned long buf_min,
> +		unsigned long buf_max, bool top_down, unsigned long *load_addr)
> +{
> +
> +	unsigned long nr_segments = image->nr_segments, new_nr_segments;
> +	struct kexec_segment *ksegment;
> +	struct kexec_buf buf, *kbuf;
> +
> +	/* Currently adding segment this way is allowed only in file mode */
> +	if (!image->file_mode)
> +		return -EINVAL;
> +
> +	if (nr_segments >= KEXEC_SEGMENT_MAX)
> +		return -EINVAL;
> +
> +	/*
> +	 * Make sure we are not trying to add buffer after allocating
> +	 * control pages. All segments need to be placed first before
> +	 * any control pages are allocated. As control page allocation
> +	 * logic goes through list of segments to make sure there are
> +	 * no destination overlaps.
> +	 */
> +	if (!list_empty(&image->control_pages)) {
> +		WARN_ON(1);
> +		return -EINVAL;
> +	}
> +
> +	memset(&buf, 0, sizeof(struct kexec_buf));
> +	kbuf = &buf;
> +	kbuf->image = image;
> +	kbuf->buffer = buffer;
> +	kbuf->bufsz = bufsz;
> +
> +	/* Align memsz to next page boundary */

No need for that comment...

> +	kbuf->memsz = ALIGN(memsz, PAGE_SIZE);
> +
> +	/* Align to atleast page size boundary */

ditto.

> +	kbuf->buf_align = max(buf_align, PAGE_SIZE);
> +	kbuf->buf_min = buf_min;
> +	kbuf->buf_max = buf_max;
> +	kbuf->top_down = top_down;
> +
> +	/* Walk the RAM ranges and allocate a suitable range for the buffer */
> +	walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
> +
> +	/*
> +	 * If range could be found successfully, it would have incremented
> +	 * the nr_segments value.
> +	 */
> +	new_nr_segments = image->nr_segments;
> +
> +	/* A suitable memory range could not be found for buffer */
> +	if (new_nr_segments == nr_segments)
> +		return -EADDRNOTAVAIL;

Right, why don't you check walk_system_ram_res's retval? If it is != 0,
i.e. walk_ram_range_callback gives a 1 on "success", you can drop this
way of checking whether finding a new range succeeded.

> +
> +	/* Found a suitable memory range */
> +

superfluous newline.

> +	ksegment = &image->segment[new_nr_segments - 1];
> +	*load_addr = ksegment->mem;
> +	return 0;
> +}
> +
> +
>  /*
>   * Move into place and start executing a preloaded standalone
>   * executable.  If nothing was preloaded return an error.
> -- 
> 1.9.0
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
