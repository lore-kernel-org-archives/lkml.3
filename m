Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaBXSAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:00:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693AbaBXSAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:00:30 -0500
Date: Mon, 24 Feb 2014 11:41:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz
Subject: Re: [PATCH 06/11] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20140224164131.GJ4631@redhat.com>
References: <1390849071-21989-1-git-send-email-vgoyal@redhat.com>
 <1390849071-21989-7-git-send-email-vgoyal@redhat.com>
 <20140221145910.GE11531@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221145910.GE11531@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 03:59:10PM +0100, Borislav Petkov wrote:

[..]
> You might want to run it through checkpatch - some of them are actually,
> to my surprise, legitimate :)

Thanks for having a look at the patches. I will run patches through
checkpatch before next posting.

[..]
> > +struct kexec_buf {
> > +	struct kimage *image;
> > +	char *buffer;
> > +	unsigned long bufsz;
> > +	unsigned long memsz;
> > +	unsigned long buf_align;
> > +	unsigned long buf_min;
> > +	unsigned long buf_max;
> > +	int top_down;		/* allocate from top of memory hole */
> 
> Looks like this wants to be a bool.

Will change.

> 
> ...
> 
> > diff --git a/include/uapi/linux/kexec.h b/include/uapi/linux/kexec.h
> > index d6629d4..5fddb1b 100644
> > --- a/include/uapi/linux/kexec.h
> > +++ b/include/uapi/linux/kexec.h
> > @@ -13,6 +13,10 @@
> >  #define KEXEC_PRESERVE_CONTEXT	0x00000002
> >  #define KEXEC_ARCH_MASK		0xffff0000
> >  
> > +/* Kexec file load interface flags */
> > +#define KEXEC_FILE_UNLOAD	0x00000001
> > +#define KEXEC_FILE_ON_CRASH	0x00000002
> 
> BIT()

What's that?

> 
> > +
> >  /* These values match the ELF architecture values.
> >   * Unless there is a good reason that should continue to be the case.
> >   */
> > diff --git a/kernel/kexec.c b/kernel/kexec.c
> > index c0944b2..b28578a 100644
> > --- a/kernel/kexec.c
> > +++ b/kernel/kexec.c
> > @@ -123,6 +123,11 @@ static struct page *kimage_alloc_page(struct kimage *image,
> >  				       gfp_t gfp_mask,
> >  				       unsigned long dest);
> >  
> > +void kimage_set_start_addr(struct kimage *image, unsigned long start)
> > +{
> > +	image->start = start;
> > +}
> 
> Why a separate function? It is used only once in the next patch.

Right now there is only one user. But once other image loader support
comes along or other arches support file based kexec, they can make
use of same function.

This is a pretty important modification as it decides what's the starting
point of next kernel image. I wanted to make it a function callable by
users who wanted to modify it instead of of letting them directly 
modify image->start.

[..]
> > +	/* Call arch image load handlers */
> > +	ldata = arch_kexec_kernel_image_load(image,
> > +			image->kernel_buf, image->kernel_buf_len,
> > +			image->initrd_buf, image->initrd_buf_len,
> > +			image->cmdline_buf, image->cmdline_buf_len);
> > +
> > +	if (IS_ERR(ldata)) {
> > +		ret = PTR_ERR(ldata);
> > +		goto out;
> > +	}
> > +
> > +	image->image_loader_data = ldata;
> > +out:
> > +	return ret;
> 
> You probably want to drop this "out:" label and simply return the error
> value directly in each error path above for simplicity.
> 

Ok, will do. I don't seem to be doing anything in "out" except return ret.
So will get rid of this label and return early in error path.

> > +static int kimage_file_normal_alloc(struct kimage **rimage, int kernel_fd,
> > +		int initrd_fd, const char __user *cmdline_ptr,
> > +		unsigned long cmdline_len)
> > +{
> > +	int result;
> > +	struct kimage *image;
> > +
> > +	/* Allocate and initialize a controlling structure */
> > +	image = do_kimage_alloc_init();
> > +	if (!image)
> > +		return -ENOMEM;
> > +
> > +	image->file_mode = 1;
> > +	image->file_handler_idx = -1;
> > +
> > +	result = kimage_file_prepare_segments(image, kernel_fd, initrd_fd,
> > +			cmdline_ptr, cmdline_len);
> > +	if (result)
> > +		goto out_free_image;
> > +
> > +	result = sanity_check_segment_list(image);
> > +	if (result)
> > +		goto out_free_post_load_bufs;
> 
> Dunno, it could probably be a larger restructuring effort but if you
> do load a segment and sanity-check it right after loading, instead of
> loading all of them first and then iterating over them, you could save
> yourself some work in the error case when a segment fails the check.
> 

Could be. I am trying to reuse exisitng code. In current code, user space
passes a list of segments and then kernel calls this function to make sure
all the segments passed in make sense.

Here also arch dependent part of kernel is preparing a list of segments
wanted and then generic code is reusing the existing function to make
sure segment list is sane. I like code reuse part of it.

Also, segment loading has not taken place yet. They are loaded later
in kimage_load_segment().

[..]
> > +	/* Walk the RAM ranges and allocate a suitable range for the buffer */
> > +	walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
> > +
> > +	kbuf->image = NULL;
> > +	kfree(kbuf);
> 
> This is freed after kzalloc'ing it a bit earlier, why not make it a
> stack variable for simplicity? struct kexec_buf doesn't seem that
> large...

Ya, I was not sure whether to make it stack variable or allocate
dynamically. It seems to be roughly 60bytes in size on 64bit. I guess
I will convert it into a stack variable.

Thanks
Vivek
