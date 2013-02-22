Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab3BWKBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 05:01:05 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:54838 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3BWKAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 05:00:53 -0500
Date: Fri, 22 Feb 2013 15:12:15 -0800
From: Simon Horman <horms@verge.net.au>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kexec: avoid freeing NULL pointer in function
 kimage_crash_alloc
Message-ID: <20130222231214.GH4737@verge.net.au>
References: <5126F92A.2030007@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5126F92A.2030007@cn.fujitsu.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 12:50:50PM +0800, Zhang Yanfei wrote:
> Though there is no error if we free a NULL pointer, I think we could
> avoid this behaviour. Change the code a little in kimage_crash_alloc()
> could avoid this kind of unnecessary free.
> 
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>


Reviewed-by: Simon Horman <horms@verge.net.au>

> ---
>  kernel/kexec.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 5e4bd78..4e96fa7 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -310,7 +310,7 @@ static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
>  		mend = mstart + image->segment[i].memsz - 1;
>  		/* Ensure we are within the crash kernel limits */
>  		if ((mstart < crashk_res.start) || (mend > crashk_res.end))
> -			goto out;
> +			goto out_free;
>  	}
>  
>  	/*
> @@ -323,16 +323,15 @@ static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
>  					   get_order(KEXEC_CONTROL_PAGE_SIZE));
>  	if (!image->control_code_page) {
>  		printk(KERN_ERR "Could not allocate control_code_buffer\n");
> -		goto out;
> +		goto out_free;
>  	}
>  
> -	result = 0;
> -out:
> -	if (result == 0)
> -		*rimage = image;
> -	else
> -		kfree(image);
> +	*rimage = image;
> +	return 0;
>  
> +out_free:
> +	kfree(image);
> +out:
>  	return result;
>  }
>  
> -- 
> 1.7.1
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
