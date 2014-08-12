Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaHLVAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:00:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbaHLVAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:00:50 -0400
Date: Tue, 12 Aug 2014 17:00:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, hpa@zytor.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] take the segment adding out of locate_mem_hole
 functions
Message-ID: <20140812210045.GG16961@redhat.com>
References: <1407821368-2358-1-git-send-email-bhe@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407821368-2358-1-git-send-email-bhe@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 01:29:27PM +0800, Baoquan He wrote:
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
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/kexec.h | 1 +
>  kernel/kexec.c        | 9 +++++----
>  2 files changed, 6 insertions(+), 4 deletions(-)
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
> index 0b49a0a..586444e 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -2054,8 +2054,7 @@ static int locate_mem_hole_top_down(unsigned long start, unsigned long end,
>  	} while (1);
>  
>  	/* If we are here, we found a suitable memory range */
> -	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start, > -			    kbuf->memsz);
> +	kbuf->mem = temp_start;
>  
>  	/* Success, stop navigating through remaining System RAM ranges */
>  	return 1;
> @@ -2089,8 +2088,7 @@ static int locate_mem_hole_bottom_up(unsigned long start, unsigned long end,
>  	} while (1);
>  
>  	/* If we are here, we found a suitable memory range */
> -	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, temp_start,
> -			    kbuf->memsz);
> +	kbuf->mem = temp_start;
>  
>  	/* Success, stop navigating through remaining System RAM ranges */
>  	return 1;
> @@ -2176,6 +2174,9 @@ int kexec_add_buffer(struct kimage *image, char *buffer, unsigned long bufsz,
>  		return -EADDRNOTAVAIL;
>  	}
>  
> +	__kexec_add_segment(image, kbuf->buffer, kbuf->bufsz, kbuf->mem,
> +			    kbuf->memsz);
> +

I think let us open code this function then. That way we have to
retreive ksegment pointer once and it is easy to read.

  	/* Found a suitable memory range */
	ksegment = &image->segment[image->nr_segments];
        ksegment->kbuf = kbuf->buffer;
        ksegment->bufsz = kbuf->bufsz;
        ksegment->mem = kbuf->mem;
        ksegment->memsz = kbuf->memsz;
        image->nr_segments++;
	*load_addr = ksegment->mem;

>  	/* Found a suitable memory range */
>  	ksegment = &image->segment[image->nr_segments - 1];
>  	*load_addr = ksegment->mem;

If possible, can you hold on to your cleanup patches for a bit. I want
to post some patches to introduce a config option for new syscall and
they will need to go in sooner. You can rebase your patches on top of
that.

Thanks
Vivek
