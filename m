Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaIJPUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:20:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaIJPUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:20:44 -0400
Date: Wed, 10 Sep 2014 11:20:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, ebiederm@xmission.com,
        tglx@linutronix.de, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v2 1/3] take the segment adding out of locate_mem_hole
 functions
Message-ID: <20140910152025.GC7898@redhat.com>
References: <1410262580-1561-1-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410262580-1561-1-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 07:36:18PM +0800, Baoquan He wrote:
> In locate_mem_hole functions, a memory hole is located and added as
> kexec_segment. But from the name of locate_mem_hole, it should only
> take responsibility of searching a available memory hole to contain
> data of a specified size.
> 
> So in this patch add a new field 'mem' into kexec_buf, then take that
> kexec segment adding code out of locate_mem_hole_top_down and
> locate_mem_hole_bottom_up. This make clear of the functionality of
> locate_mem_hole just like it declars to do. And by this
> locate_mem_hole_callback chould be used later if anyone want to locate
> a memory hole for other use.
> 
> Meanwhile Vivek suggested opening code function __kexec_add_segment(),
> that way we have to retreive ksegment pointer once and it is easy to
> read. So just do it in this patch and remove __kexec_add_segment()
> since no one use it anymore.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>

Bao,

These 3 patches look good to me. I am assuming you have tested these
to make sure nothing is broken.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> ---
>  include/linux/kexec.h |  1 +
>  kernel/kexec.c        | 29 ++++++++---------------------
>  2 files changed, 9 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> index 4b2a0e1..9d957b7 100644
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -178,6 +178,7 @@ struct kexec_buf {
>  	struct kimage *image;
>  	char *buffer;
>  	unsigned long bufsz;
> +	unsigned long mem;
>  	unsigned long memsz;
>  	unsigned long buf_align;
>  	unsigned long buf_min;
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 2bee072..63bc3cd 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -2016,22 +2016,6 @@ static int __init crash_save_vmcoreinfo_init(void)
>  subsys_initcall(crash_save_vmcoreinfo_init);
>  
>  #ifdef CONFIG_KEXEC_FILE
> -static int __kexec_add_segment(struct kimage *image, char *buf,
> -			       unsigned long bufsz, unsigned long mem,
> -			       unsigned long memsz)
> -{
> -	struct kexec_segment *ksegment;
> -
> -	ksegment = &image->segment[image->nr_segments];
> -	ksegment->kbuf = buf;
> -	ksegment->bufsz = bufsz;
> -	ksegment->mem = mem;
> -	ksegment->memsz = memsz;
> -	image->nr_segments++;
> -
> -	return 0;
> -}
> -
>  static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  				    struct kexec_buf *kbuf)
>  {
> @@ -2064,8 +2048,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  	} while (1);
>  
>  	/* If we are here, we found a suitable memory range */
> -	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
> -			    kbuf->memsz);
> +	kbuf->mem = temp_start;
>  
>  	/* Success, stop navigating through remaining System RAM ranges */
>  	return 1;
> @@ -2099,8 +2082,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
>  	} while (1);
>  
>  	/* If we are here, we found a suitable memory range */
> -	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
> -			    kbuf->memsz);
> +	kbuf->mem = temp_start;
>  
>  	/* Success, stop navigating through remaining System RAM ranges */
>  	return 1;
> @@ -2187,7 +2169,12 @@ int kexec_add_buffer(struct kimage *image, char *buffer, unsigned long bufsz,
>  	}
>  
>  	/* Found a suitable memory range */
> -	ksegment = &image->segment[image->nr_segments - 1];
> +	ksegment = &image->segment[image->nr_segments];
> +	ksegment->kbuf = kbuf->buffer;
> +	ksegment->bufsz = kbuf->bufsz;
> +	ksegment->mem = kbuf->mem;
> +	ksegment->memsz = kbuf->memsz;
> +	image->nr_segments++;
>  	*load_addr = ksegment->mem;
>  	return 0;
>  }
> -- 
> 1.8.5.3
