Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab3BFWY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:24:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54354 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131Ab3BFWYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:24:23 -0500
Date: Wed, 6 Feb 2013 14:24:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 21/77] block: fix synchronization and limit check in
 blk_alloc_devt()
Message-Id: <20130206142422.b2f8eac6.akpm@linux-foundation.org>
In-Reply-To: <1360179649-22465-22-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
	<1360179649-22465-22-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Feb 2013 11:39:53 -0800
Tejun Heo <tj@kernel.org> wrote:

> idr allocation in blk_alloc_devt() wasn't synchronized against lookup
> and removal, and its limit check was off by one - 1 << MINORBITS is
> the number of minors allowed, not the maximum allowed minor.
> 
> Add locking and rename MAX_EXT_DEVT to NR_EXT_DEVT and fix limit
> checking.
> 
> ...
>
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -26,7 +26,7 @@ static DEFINE_MUTEX(block_class_lock);
>  struct kobject *block_depr;
>  
>  /* for extended dynamic devt allocation, currently only one major is used */
> -#define MAX_EXT_DEVT		(1 << MINORBITS)
> +#define NR_EXT_DEVT		(1 << MINORBITS)
>  
>  /* For extended devt allocation.  ext_devt_mutex prevents look up
>   * results from going away underneath its user.
> @@ -423,17 +423,18 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
>  	do {
>  		if (!idr_pre_get(&ext_devt_idr, GFP_KERNEL))
>  			return -ENOMEM;
> +		mutex_lock(&ext_devt_mutex);
>  		rc = idr_get_new(&ext_devt_idr, part, &idx);
> +		if (!rc && idx >= NR_EXT_DEVT) {
> +			idr_remove(&ext_devt_idr, idx);
> +			rc = -EBUSY;
> +		}
> +		mutex_unlock(&ext_devt_mutex);
>  	} while (rc == -EAGAIN);
>  
>  	if (rc)
>  		return rc;
>  
> -	if (idx > MAX_EXT_DEVT) {
> -		idr_remove(&ext_devt_idr, idx);
> -		return -EBUSY;
> -	}
> -
>  	*devt = MKDEV(BLOCK_EXT_MAJOR, blk_mangle_minor(idx));
>  	return 0;
>  }

This gets all tangled up with
http://ozlabs.org/~akpm/mmotm/broken-out/block-fix-ext_devt_idr-handling.patch,
which appears to solve the same issue.

What to do?

