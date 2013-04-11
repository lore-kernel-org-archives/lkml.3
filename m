Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab3DKJ6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:58:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59489 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080Ab3DKJ6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:58:36 -0400
Date: Thu, 11 Apr 2013 11:58:31 +0200
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@sr71.net>
Cc: hpa@linux.intel.com, linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/5] make /dev/kmem return error for highmem
Message-ID: <20130411095831.GB15924@pd.tnic>
References: <20130410233249.7FFCB63B@viggo.jf.intel.com>
 <20130410233252.81839D50@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130410233252.81839D50@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just nitpicks:

On Wed, Apr 10, 2013 at 04:32:52PM -0700, Dave Hansen wrote:
> 
> I was auding the /dev/mem code for more questionable uses of

	auditing

> __pa(), and ran across this.
> 
> My assumption is that if you use /dev/kmem, you expect to be
> able to read the kernel virtual mappings.  However, those
> mappings _stop_ as soon as we hit high memory.  The
> pfn_valid() check in here is good for memory holes, but since
> highmem pages are still valid, it does no good for those.
> 
> Also, since we are now checking that __pa() is being done on
> valid virtual addresses, this might have tripped the new
> check.  Even with the new check, this code would have been
> broken with the NUMA remapping code had we not ripped it
> out:
> 
> 	https://patchwork.kernel.org/patch/2075911/

This is an upstream commit so you probably might want to state the
commit id here instead of some website which may or may not exist in the
future.

> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> ---
> 
>  linux.git-davehans/drivers/char/mem.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff -puN drivers/char/mem.c~make-kmem-return-error-for-highmem drivers/char/mem.c
> --- linux.git/drivers/char/mem.c~make-kmem-return-error-for-highmem	2013-04-10 16:23:45.151087081 -0700
> +++ linux.git-davehans/drivers/char/mem.c	2013-04-10 16:23:45.154087084 -0700
> @@ -336,10 +336,19 @@ static int mmap_mem(struct file *file, s
>  #ifdef CONFIG_DEVKMEM
>  static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
>  {
> +	unsigned long kernel_vaddr;
>  	unsigned long pfn;
>  
> +	kernel_vaddr = (u64)vma->vm_pgoff << PAGE_SHIFT;
> +	/*
> +	 * pfn_valid() (below) does not trip for highmem addresses.  This
> +	 * essentially means that we will be mapping gibberish in for them
> +	 * instead of what the _kernel_ has mapped at the requested address.
> +	 */
> +	if (kernel_vaddr >= high_memory)
> +		return -EIO;

drivers/char/mem.c: In function ‘mmap_kmem’:
drivers/char/mem.c:348:19: warning: comparison between pointer and integer [enabled by default]

>  	/* Turn a kernel-virtual address into a physical page frame */
> -	pfn = __pa((u64)vma->vm_pgoff << PAGE_SHIFT) >> PAGE_SHIFT;
> +	pfn = __pa(kernel_vaddr) >> PAGE_SHIFT;
>  
>  	/*
>  	 * RED-PEN: on some architectures there is more mapped memory than
> _
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
