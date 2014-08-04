Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaHDLuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:50:05 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55293 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaHDLuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:50:02 -0400
Message-ID: <53DF7361.7000103@gmail.com>
Date: Mon, 04 Aug 2014 14:49:53 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: jgross@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5] Save command pool address of Scsi_Host
References: <1407151802-27198-1-git-send-email-jgross@suse.com>
In-Reply-To: <1407151802-27198-1-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 02:30 PM, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
> private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
> scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.
> 
> This will result in an access error when the host is removed.
> 
> Avoid the problem by saving the address of a new allocated command pool where
> it is expected.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  drivers/scsi/scsi.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 88d46fe..b0cef5b 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -380,6 +380,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
>  		pool->slab_flags |= SLAB_CACHE_DMA;
>  		pool->gfp_mask = __GFP_DMA;
>  	}
> +
> +	if (hostt->cmd_size)
> +		hostt->cmd_pool = pool;
> +
>  	return pool;
>  }
>  
> @@ -424,8 +428,10 @@ out:
>  out_free_slab:
>  	kmem_cache_destroy(pool->cmd_slab);
>  out_free_pool:
> -	if (hostt->cmd_size)
> +	if (hostt->cmd_size) {
>  		scsi_free_host_cmd_pool(pool);

I disagree I liked the V4 version better. It is much nicer on the review
that we NULL the same one we pass in with no need for context that's outside
of this scope

Just my $0.017
Boaz

> +		hostt->cmd_pool = NULL;
> +	}
>  	goto out;
>  }
>  
> @@ -447,8 +453,10 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
>  	if (!--pool->users) {
>  		kmem_cache_destroy(pool->cmd_slab);
>  		kmem_cache_destroy(pool->sense_slab);
> -		if (hostt->cmd_size)
> +		if (hostt->cmd_size) {
>  			scsi_free_host_cmd_pool(pool);
> +			hostt->cmd_pool = NULL;
> +		}
>  	}
>  	mutex_unlock(&host_cmd_pool_mutex);
>  }
> 

