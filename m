Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701AbaFEUSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 16:18:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbaFEUSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 16:18:21 -0400
Date: Thu, 5 Jun 2014 16:17:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org,
        greg@kroah.com, jkosina@suse.cz, dyoung@redhat.com,
        chaowang@redhat.com, bhe@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140605201732.GF14083@redhat.com>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140605111535.GB16642@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605111535.GB16642@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 01:15:35PM +0200, Borislav Petkov wrote:

[..]
> > --- a/arch/x86/kernel/machine_kexec_64.c
> > +++ b/arch/x86/kernel/machine_kexec_64.c
> > @@ -22,6 +22,13 @@
> >  #include <asm/mmu_context.h>
> >  #include <asm/debugreg.h>
> >  
> > +/* arch dependent functionality related to kexec file based syscall */
> 
>   ... arch-dependent ...			... file-based ...

Will change.

> 
> > +static struct kexec_file_type kexec_file_type[] = {
> 
> You could call this kexec_file_types and use ARRAY_SIZE and drop this
> nr_file_types; mangled diff ontop:

Sounds good. Will change.

[..]
> > +static int nr_file_types = sizeof(kexec_file_type)/sizeof(kexec_file_type[0]);
> > +
> 
> Superfluous newline.

Will remove.

> 
> >  static void free_transition_pgtable(struct kimage *image)
> >  {
> >  	free_page((unsigned long)image->arch.pud);
> > @@ -283,3 +290,50 @@ void arch_crash_save_vmcoreinfo(void)
> >  			      (unsigned long)&_text - __START_KERNEL);
> >  }
> >  
> > +/* arch dependent functionality related to kexec file based syscall */
> > +
> > +int arch_kexec_kernel_image_probe(struct kimage *image, void *buf,
> > +					unsigned long buf_len)
> 
> Arg alignment: it is customary to put function args on new line at the
> next right position after the opening brace. Ditto for the rest of the
> locations where this is the case.

Will do.

[..]
> > +void *arch_kexec_kernel_image_load(struct kimage *image, char *kernel,
> > +			unsigned long kernel_len, char *initrd,
> > +			unsigned long initrd_len, char *cmdline,
> > +			unsigned long cmdline_len)
> 
> Those are a *lot* of arguments. Maybe a helper struct encompassing them
> all to pass around?

I think everything is already available in "struct kimage *image". So I
don't have to pass all these separately. I think I will remove all these
extra parameters and expect arch function to retrieve all that from
"struct kimage *image".

I guess I was trying to make "struct kimage" mostly opaque to arch
functions.

> 
> > +{
> > +	int idx = image->file_handler_idx;
> > +
> > +	if (idx < 0)
> > +		return ERR_PTR(-ENOEXEC);
> > +
> > +	return kexec_file_type[idx].load(image, kernel, kernel_len, initrd,
> > +					initrd_len, cmdline, cmdline_len);
> > +}
> > +
> > +int arch_kimage_file_post_load_cleanup(struct kimage *image)
> > +{
> > +	int idx = image->file_handler_idx;
> > +
> > +	/* This can be called up even before image handler has been set */
> > +	if (idx < 0)
> > +		return 0;
> 
> Btw, these games with the index seem not optimal to me. Why not simply
> have image->fops or so which is a pointer to struct kexec_file_type
> after having it renamed to kexec_file_ops and then assign the correct
> one to image->fops in arch_kexec_kernel_image_probe() and then simply
> call the proper handler:
> 
> 	if (!image->fops)
> 		return;
> 
> 	return image->fops->cleanup(image);
> 
> and above
> 
> 	return image->fops->load(...)
> 
> and so on.
> 
> In any case, this looks cleaner to me.

Ok, I will clean it up.


[..]
> > +
> > +	/* Additional Fields for file based kexec syscall */
> 
> Why capitalized?

Just typo. Will fix it.

[..]
> > +/*
> > + * Keeps a track of buffer parameters as provided by caller for requesting
> 
> "Keeps track"

will fix.

[..]
> > +/* Listof defined/legal kexec file flags */
> 
> "List of ..."
> 

Will fix.

[..]
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
> Do we have those documented somewhere and what do they mean?

Nope. I will put couple of comments here to explain what these flags do.

[..]
> > +/* Architectures can provide this probe function */
> > +int __attribute__ ((weak))
> 
> We have __weak for that.

Will change everywhere.

[..]
> > +/*
> > + * Free up tempory buffers allocated which are not needed after image has
> > + * been loaded.
> > + *
> > + * Free up memory used by kernel, initrd, and comand line. This is temporary
> > + * memory allocation which is not needed any more after these buffers have
> > + * been loaded into separate segments and have been copied elsewhere
> > + */
> 
> Why do we need that comment? It is obvious what's going on.

It is obivious that we are freeing memory but what was not obivious to
me that I already copied contents of these buffers in a seaparate memory
region (segment), hence I am able to free it. So I would like to keep
comment there.

> 
> > +static void kimage_file_post_load_cleanup(struct kimage *image)
> > +{
> > +	vfree(image->kernel_buf);
> > +	image->kernel_buf = NULL;
> > +
> > +	vfree(image->initrd_buf);
> > +	image->initrd_buf = NULL;
> > +
> > +	vfree(image->cmdline_buf);
> > +	image->cmdline_buf = NULL;
> > +
> > +	/* See if architcture has anything to cleanup post load */
> 
> s/architcture/architecture/

Will fix it.

> 
> > +	arch_kimage_file_post_load_cleanup(image);
> > +}
> > +
> > +/*
> > + * In file mode list of segments is prepared by kernel. Copy relevant
> > + * data from user space, do error checking, prepare segment list
> > + */
> > +static int kimage_file_prepare_segments(struct kimage *image, int kernel_fd,
> > +		int initrd_fd, const char __user *cmdline_ptr,
> > +		unsigned long cmdline_len)
> 
> arg alignment

Sure, will change everywhere.


[..]
> > +	image->cmdline_buf = vzalloc(cmdline_len);
> > +	if (!image->cmdline_buf)
> 
> 		ret = -ENOMEM;

Good catch. This would have led to various sorts of issues. Will fix it.

> > +	int result;
> > +	struct kimage *image;
> > +
> > +	/* Allocate and initialize a controlling structure */
> 
> No need for that comment IMO.

Will drop.

> > +
> > +	result = -ENOMEM;
> > +	image->control_code_page = kimage_alloc_control_pages(image,
> > +					   get_order(KEXEC_CONTROL_PAGE_SIZE));
> > +	if (!image->control_code_page) {
> > +		pr_err("Could not allocate control_code_buffer\n");
> 
> Might wanna define pr_fmt when using the pr_* things fo the first time
> in this file.

Hmm....

I see that printk.h already provides a definition is pr_fmt is not
defined. So that means I shouldn't have to define pr_fmt() before I
use pr_*?

#ifndef pr_fmt
#define pr_fmt(fmt) fmt
#endif


> 
> > +		goto out_free_post_load_bufs;
> > +	}
> > +
> > +	image->swap_page = kimage_alloc_control_pages(image, 0);
> > +	if (!image->swap_page) {
> > +		pr_err(KERN_ERR "Could not allocate swap buffer\n");
> > +		goto out_free_control_pages;
> > +	}
> > +
> > +	*rimage = image;
> > +	return 0;
> > +
> > +out_free_control_pages:
> > +	kimage_free_page_list(&image->control_pages);
> > +out_free_post_load_bufs:
> > +	kimage_file_post_load_cleanup(image);
> > +	kfree(image->image_loader_data);
> > +out_free_image:
> > +	kfree(image);
> > +	return result;
> > +}
> > +
> >  static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
> >  				unsigned long nr_segments,
> >  				struct kexec_segment __user *segments)
> > @@ -683,6 +898,16 @@ static void kimage_free(struct kimage *image)
> >  
> >  	/* Free the kexec control pages... */
> >  	kimage_free_page_list(&image->control_pages);
> > +
> > +	kfree(image->image_loader_data);
> > +
> > +	/*
> > +	 * Free up any temporary buffers allocated. This might hit if
> > +	 * error occurred much later after buffer allocation.
> > +	 */
> > +	if (image->file_mode)
> > +		kimage_file_post_load_cleanup(image);
> > +
> >  	kfree(image);
> >  }
> >  
> > @@ -812,10 +1037,14 @@ static int kimage_load_normal_segment(struct kimage *image,
> >  	unsigned long maddr;
> >  	size_t ubytes, mbytes;
> >  	int result;
> > -	unsigned char __user *buf;
> > +	unsigned char __user *buf = NULL;
> > +	unsigned char *kbuf = NULL;
> >  
> >  	result = 0;
> > -	buf = segment->buf;
> > +	if (image->file_mode)
> > +		kbuf = segment->kbuf;
> > +	else
> > +		buf = segment->buf;
> >  	ubytes = segment->bufsz;
> >  	mbytes = segment->memsz;
> >  	maddr = segment->mem;
> > @@ -847,7 +1076,11 @@ static int kimage_load_normal_segment(struct kimage *image,
> >  				PAGE_SIZE - (maddr & ~PAGE_MASK));
> >  		uchunk = min(ubytes, mchunk);
> >  
> > -		result = copy_from_user(ptr, buf, uchunk);
> > +		/* For file based kexec, source pages are in kernel memory */
> > +		if (image->file_mode)
> > +			memcpy(ptr, kbuf, uchunk);
> > +		else
> > +			result = copy_from_user(ptr, buf, uchunk);
> >  		kunmap(page);
> >  		if (result) {
> >  			result = -EFAULT;
> > @@ -855,7 +1088,10 @@ static int kimage_load_normal_segment(struct kimage *image,
> >  		}
> >  		ubytes -= uchunk;
> >  		maddr  += mchunk;
> > -		buf    += mchunk;
> > +		if (image->file_mode)
> > +			kbuf += mchunk;
> > +		else
> > +			buf += mchunk;
> >  		mbytes -= mchunk;
> >  	}
> >  out:
> > @@ -1102,7 +1338,64 @@ SYSCALL_DEFINE5(kexec_file_load, int, kernel_fd, int, initrd_fd,
> >  		const char __user *, cmdline_ptr, unsigned long,
> >  		cmdline_len, unsigned long, flags)
> >  {
> > -	return -ENOSYS;
> > +	int ret = 0, i;
> > +	struct kimage **dest_image, *image;
> > +
> > +	/* We only trust the superuser with rebooting the system. */
> > +	if (!capable(CAP_SYS_BOOT))
> > +		return -EPERM;
> > +
> > +	/* Make sure we have a legal set of flags */
> > +	if (flags != (flags & KEXEC_FILE_FLAGS))
> > +		return -EINVAL;
> 
> This test looks strange: according to it, kexec_file_load has to always
> be called with both KEXEC_FILE_UNLOAD and KEXEC_FILE_ON_CRASH set.

I think this test says that "flags" has to be some combination of valid
flags and superset is in KEXEC_FILE_FLAGS.

So user can pass only KEXEC_FILE_ON_CRASH.
flags = 0x00000002
KEXEC_FILE_FLAGS = 0x0x00000003
flags & KEXEC_FILE_FLAGS = 0x00000002 = flags.

>Don't you want to check against an allowed mask or so like KEXEC_FLAGS is
> handled in kexec_load?

KEXEC_FILE_FLAGS is the set of allowed flags and I am passing flags
through it. 

Are you referring to the fact that kexec_load() also passes it
additionally through KEXEC_ARCH_MASK?

Actually I am not sure if we need KEXEC_ARCH_MASK in this new system
call. I see that old call reserved uppper 16bits of flags for passing
the arch info. And passed in arch needs to be either native arch or
default arch.

I guess it might have been done to ensure that user is not expecting to
boot an image which can't boot on the running arch. But this test could
have been entirely done in user space.

I have no idea what's the purpose of this test. And why would we need
it in new syscall. We are passing the new kernel file to system and
image loader can look arch info in header and decide whether this
image can be booted in currently running arch or not.

Eric, can you please shed some light on what's the purpose of passing
arch info in flags in kexec_load().
	

[..]
> > +/*
> > + * Helper functions for placing a buffer in a kexec segment. This assumes
> 
> s/functions/function/

Will fix.

[..]
> > +	/* Align memsz to next page boundary */
> 
> No need for that comment...

Ok, will drop.

> 
> > +	kbuf->memsz = ALIGN(memsz, PAGE_SIZE);
> > +
> > +	/* Align to atleast page size boundary */
> 
> ditto.

Will drop.

> 
> > +	kbuf->buf_align = max(buf_align, PAGE_SIZE);
> > +	kbuf->buf_min = buf_min;
> > +	kbuf->buf_max = buf_max;
> > +	kbuf->top_down = top_down;
> > +
> > +	/* Walk the RAM ranges and allocate a suitable range for the buffer */
> > +	walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
> > +
> > +	/*
> > +	 * If range could be found successfully, it would have incremented
> > +	 * the nr_segments value.
> > +	 */
> > +	new_nr_segments = image->nr_segments;
> > +
> > +	/* A suitable memory range could not be found for buffer */
> > +	if (new_nr_segments == nr_segments)
> > +		return -EADDRNOTAVAIL;
> 
> Right, why don't you check walk_system_ram_res's retval? If it is != 0,
> i.e. walk_ram_range_callback gives a 1 on "success", you can drop this
> way of checking whether finding a new range succeeded.

In last version when I had ELF header support, I was checking for return
code 1 at one place and you had not liked that.

Anyway, I am thinking that problem here is that walk_* variants use
return code of called function to decide whether to continue looping
or not. I think these are two independent activities.  Pass a boolean
to called function which should be set to false if callee wants to
stop the loop. 

That way, callee can pass both errors and success without having to
worry about loop. And callee can return 0 to represent success and
negative error code to represent error.

How about following patch. This just compiles and I have not tested it
yet. I think it should work.

---
 include/linux/ioport.h |    4 +--
 kernel/kexec.c         |   50 +++++++++++++++++++++----------------------------
 kernel/resource.c      |   14 +++++++------
 3 files changed, 32 insertions(+), 36 deletions(-)

Index: linux-2.6/kernel/resource.c
===================================================================
--- linux-2.6.orig/kernel/resource.c	2014-06-02 14:47:58.292304960 -0400
+++ linux-2.6/kernel/resource.c	2014-06-05 15:23:40.305446872 -0400
@@ -371,11 +371,12 @@ static int find_next_iomem_res(struct re
 }
 
 int walk_ram_res(char *name, unsigned long flags, u64 start, u64 end,
-		void *arg, int (*func)(u64, u64, void *))
+		void *arg, int (*func)(u64, u64, void *, bool *))
 {
 	struct resource res;
 	u64 orig_end;
 	int ret = -1;
+	bool stop = false;
 
 	res.start = start;
 	res.end = end;
@@ -383,8 +384,8 @@ int walk_ram_res(char *name, unsigned lo
 	orig_end = res.end;
 	while ((res.start < res.end) &&
 		(find_next_iomem_res(&res, name) >= 0)) {
-		ret = (*func)(res.start, res.end, arg);
-		if (ret)
+		ret = (*func)(res.start, res.end, arg, &stop);
+		if (stop == true)
 			break;
 		res.start = res.end + 1;
 		res.end = orig_end;
@@ -441,11 +442,12 @@ static int find_next_system_ram(struct r
  * with pfn can truncate ranges.
  */
 int walk_system_ram_res(u64 start, u64 end, void *arg,
-				int (*func)(u64, u64, void *))
+				int (*func)(u64, u64, void *, bool *))
 {
 	struct resource res;
 	u64 orig_end;
 	int ret = -1;
+	bool stop = false;
 
 	res.start = start;
 	res.end = end;
@@ -453,8 +455,8 @@ int walk_system_ram_res(u64 start, u64 e
 	orig_end = res.end;
 	while ((res.start < res.end) &&
 		(find_next_system_ram(&res, "System RAM") >= 0)) {
-		ret = (*func)(res.start, res.end, arg);
-		if (ret)
+		ret = (*func)(res.start, res.end, arg, &stop);
+		if (stop == true)
 			break;
 		res.start = res.end + 1;
 		res.end = orig_end;
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c	2014-06-05 14:58:26.976833241 -0400
+++ linux-2.6/kernel/kexec.c	2014-06-05 15:33:47.986727393 -0400
@@ -2063,7 +2063,7 @@ static int __kexec_add_segment(struct ki
 }
 
 static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
-					struct kexec_buf *kbuf)
+					struct kexec_buf *kbuf, bool *stop)
 {
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
@@ -2076,7 +2076,7 @@ static int locate_mem_hole_top_down(unsi
 		temp_start = temp_start & (~(kbuf->buf_align - 1));
 
 		if (temp_start < start || temp_start < kbuf->buf_min)
-			return 0;
+			return -EADDRNOTAVAIL;
 
 		temp_end = temp_start + kbuf->memsz - 1;
 
@@ -2098,11 +2098,12 @@ static int locate_mem_hole_top_down(unsi
 				kbuf->memsz);
 
 	/* Stop navigating through remaining System RAM ranges */
-	return 1;
+	*stop = true;
+	return 0;
 }
 
 static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
-					struct kexec_buf *kbuf)
+					struct kexec_buf *kbuf, bool *stop)
 {
 	struct kimage *image = kbuf->image;
 	unsigned long temp_start, temp_end;
@@ -2114,7 +2115,7 @@ static int locate_mem_hole_bottom_up(uns
 		temp_end = temp_start + kbuf->memsz - 1;
 
 		if (temp_end > end || temp_end > kbuf->buf_max)
-			return 0;
+			return -EADDRNOTAVAIL;
 		/*
 		 * Make sure this does not conflict with any of existing
 		 * segments
@@ -2133,29 +2134,29 @@ static int locate_mem_hole_bottom_up(uns
 				kbuf->memsz);
 
 	/* Stop navigating through remaining System RAM ranges */
-	return 1;
+	*stop = true;
+	return 0;
 }
 
-static int walk_ram_range_callback(u64 start, u64 end, void *arg)
+static int walk_ram_range_callback(u64 start, u64 end, void *arg, bool *stop)
 {
 	struct kexec_buf *kbuf = (struct kexec_buf *)arg;
 	unsigned long sz = end - start + 1;
 
-	/* Returning 0 will take to next memory range */
 	if (sz < kbuf->memsz)
-		return 0;
+		return -EADDRNOTAVAIL;
 
 	if (end < kbuf->buf_min || start > kbuf->buf_max)
-		return 0;
+		return -EADDRNOTAVAIL;
 
 	/*
 	 * Allocate memory top down with-in ram range. Otherwise bottom up
 	 * allocation.
 	 */
 	if (kbuf->top_down)
-		return locate_mem_hole_top_down(start, end, kbuf);
+		return locate_mem_hole_top_down(start, end, kbuf, stop);
 	else
-		return locate_mem_hole_bottom_up(start, end, kbuf);
+		return locate_mem_hole_bottom_up(start, end, kbuf, stop);
 }
 
 /*
@@ -2168,15 +2169,15 @@ int kexec_add_buffer(struct kimage *imag
 		unsigned long buf_max, bool top_down, unsigned long *load_addr)
 {
 
-	unsigned long nr_segments = image->nr_segments, new_nr_segments;
 	struct kexec_segment *ksegment;
 	struct kexec_buf buf, *kbuf;
+	int ret;
 
 	/* Currently adding segment this way is allowed only in file mode */
 	if (!image->file_mode)
 		return -EINVAL;
 
-	if (nr_segments >= KEXEC_SEGMENT_MAX)
+	if (image->nr_segments >= KEXEC_SEGMENT_MAX)
 		return -EINVAL;
 
 	/*
@@ -2208,25 +2209,18 @@ int kexec_add_buffer(struct kimage *imag
 
 	/* Walk the RAM ranges and allocate a suitable range for the buffer */
 	if (image->type == KEXEC_TYPE_CRASH)
-		walk_ram_res("Crash kernel", IORESOURCE_MEM | IORESOURCE_BUSY,
-				crashk_res.start, crashk_res.end, kbuf,
-				walk_ram_range_callback);
+		ret = walk_ram_res("Crash kernel",
+				   IORESOURCE_MEM | IORESOURCE_BUSY,
+				   crashk_res.start, crashk_res.end, kbuf,
+				   walk_ram_range_callback);
 	else
-		walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
+		ret = walk_system_ram_res(0, -1, kbuf, walk_ram_range_callback);
 
-	/*
-	 * If range could be found successfully, it would have incremented
-	 * the nr_segments value.
-	 */
-	new_nr_segments = image->nr_segments;
-
-	/* A suitable memory range could not be found for buffer */
-	if (new_nr_segments == nr_segments)
+	if (ret)
 		return -EADDRNOTAVAIL;
 
 	/* Found a suitable memory range */
-
-	ksegment = &image->segment[new_nr_segments - 1];
+	ksegment = &image->segment[image->nr_segments - 1];
 	*load_addr = ksegment->mem;
 	return 0;
 }
Index: linux-2.6/include/linux/ioport.h
===================================================================
--- linux-2.6.orig/include/linux/ioport.h	2014-06-05 15:21:08.064872797 -0400
+++ linux-2.6/include/linux/ioport.h	2014-06-05 15:23:56.713616633 -0400
@@ -239,10 +239,10 @@ walk_system_ram_range(unsigned long star
 		void *arg, int (*func)(unsigned long, unsigned long, void *));
 extern int
 walk_system_ram_res(u64 start, u64 end, void *arg,
-				int (*func)(u64, u64, void *));
+				int (*func)(u64, u64, void *, bool *));
 extern int
 walk_ram_res(char *name, unsigned long flags, u64 start, u64 end, void *arg,
-				int (*func)(u64, u64, void *));
+				int (*func)(u64, u64, void *, bool *));
 
 /* True if any part of r1 overlaps r2 */
 static inline bool resource_overlaps(struct resource *r1, struct resource *r2)

