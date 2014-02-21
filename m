Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaBUO7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 09:59:18 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36380 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaBUO7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 09:59:16 -0500
Date: Fri, 21 Feb 2014 15:59:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 06/11] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20140221145910.GE11531@pd.tnic>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-7-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1390849071-21989-7-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 01:57:46PM -0500, Vivek Goyal wrote:
> This patch implements the in kernel kexec functionality. It implements a
> new system call kexec_file_load. I think parameter list of this system
> call will change as I have not done the kernel image signature handling
> yet. I have been told that I might have to pass the detached signature
> and size as part of system call.
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

You might want to run it through checkpatch - some of them are actually,
to my surprise, legitimate :)

Just some minor nitpicks below...

> ---
>  arch/x86/kernel/machine_kexec_64.c |  50 ++++
>  arch/x86/syscalls/syscall_64.tbl   |   1 +
>  include/linux/kexec.h              |  55 +++++
>  include/linux/syscalls.h           |   3 +
>  include/uapi/linux/kexec.h         |   4 +
>  kernel/kexec.c                     | 495 ++++++++++++++++++++++++++++++++++++-
>  kernel/sys_ni.c                    |   1 +
>  7 files changed, 605 insertions(+), 4 deletions(-)

...

> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index d8188b3..51b56cd 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -121,13 +121,58 @@ struct kimage {
>  #define KEXEC_TYPE_DEFAULT 0
>  #define KEXEC_TYPE_CRASH   1
>  	unsigned int preserve_context : 1;
> +	/* If set, we are using file mode kexec syscall */
> +	unsigned int file_mode : 1;
>  
>  #ifdef ARCH_HAS_KIMAGE_ARCH
>  	struct kimage_arch arch;
>  #endif
> +
> +	/* Additional Fields for file based kexec syscall */
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
> +	void * image_loader_data;
>  };
>  
> +/*
> + * Keeps a track of buffer parameters as provided by caller for requesting
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
> +	int top_down;		/* allocate from top of memory hole */

Looks like this wants to be a bool.

...

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

BIT()

> +
>  /* These values match the ELF architecture values.
>   * Unless there is a good reason that should continue to be the case.
>   */
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index c0944b2..b28578a 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -123,6 +123,11 @@ static struct page *kimage_alloc_page(struct kimage *image,
>  				       gfp_t gfp_mask,
>  				       unsigned long dest);
>  
> +void kimage_set_start_addr(struct kimage *image, unsigned long start)
> +{
> +	image->start = start;
> +}

Why a separate function? It is used only once in the next patch.

...

> +static int kimage_file_prepare_segments(struct kimage *image, int kernel_fd,
> +		int initrd_fd, const char __user *cmdline_ptr,
> +		unsigned long cmdline_len)
> +{
> +	int ret = 0;
> +	void *ldata;
> +
> +	ret = copy_file_from_fd(kernel_fd, &image->kernel_buf,
> +					&image->kernel_buf_len);
> +	if (ret)
> +		goto out;
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
> +	return ret;

You probably want to drop this "out:" label and simply return the error
value directly in each error path above for simplicity.

> +static int kimage_file_normal_alloc(struct kimage **rimage, int kernel_fd,
> +		int initrd_fd, const char __user *cmdline_ptr,
> +		unsigned long cmdline_len)
> +{
> +	int result;
> +	struct kimage *image;
> +
> +	/* Allocate and initialize a controlling structure */
> +	image = do_kimage_alloc_init();
> +	if (!image)
> +		return -ENOMEM;
> +
> +	image->file_mode = 1;
> +	image->file_handler_idx = -1;
> +
> +	result = kimage_file_prepare_segments(image, kernel_fd, initrd_fd,
> +			cmdline_ptr, cmdline_len);
> +	if (result)
> +		goto out_free_image;
> +
> +	result = sanity_check_segment_list(image);
> +	if (result)
> +		goto out_free_post_load_bufs;

Dunno, it could probably be a larger restructuring effort but if you
do load a segment and sanity-check it right after loading, instead of
loading all of them first and then iterating over them, you could save
yourself some work in the error case when a segment fails the check.

...

> +int kexec_add_buffer(struct kimage *image, char *buffer,
> +		unsigned long bufsz, unsigned long memsz,
> +		unsigned long buf_align, unsigned long buf_min,
> +		unsigned long buf_max, int top_down, unsigned long *load_addr)
> +{
> +
> +	unsigned long nr_segments = image->nr_segments, new_nr_segments;
> +	struct kexec_segment *ksegment;
> +	struct kexec_buf *kbuf;
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
> +	WARN_ONCE(!list_empty(&image->control_pages), "Adding kexec buffer"
> +			" after allocating control pages\n");
> +
> +	kbuf = kzalloc(sizeof(struct kexec_buf), GFP_KERNEL);
> +	if (!kbuf)
> +		return -ENOMEM;
> +
> +	kbuf->image = image;
> +	kbuf->buffer = buffer;
> +	kbuf->bufsz = bufsz;
> +	/* Align memsz to next page boundary */
> +	kbuf->memsz = ALIGN(memsz, PAGE_SIZE);
> +
> +	/* Align to atleast page size boundary */
> +	kbuf->buf_align = max(buf_align, PAGE_SIZE);
> +	kbuf->buf_min = buf_min;
> +	kbuf->buf_max = buf_max;
> +	kbuf->top_down = top_down;
> +
> +	/* Walk the RAM ranges and allocate a suitable range for the buffer */
> +	walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
> +
> +	kbuf->image = NULL;
> +	kfree(kbuf);

This is freed after kzalloc'ing it a bit earlier, why not make it a
stack variable for simplicity? struct kexec_buf doesn't seem that
large...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
