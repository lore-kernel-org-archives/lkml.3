Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab3DKROK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 13:14:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21104 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3DKROH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 13:14:07 -0400
MIME-Version: 1.0
Message-ID: <ecb7519b-669a-48e4-b217-a77ecb60afd4@default>
Date: Thu, 11 Apr 2013 10:13:42 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>
Subject: RE: [PATCH 02/10] staging: zcache: remove zcache_freeze
References: <<1365553560-32258-1-git-send-email-liwanp@linux.vnet.ibm.com>>
 <<1365553560-32258-3-git-send-email-liwanp@linux.vnet.ibm.com>>
In-Reply-To: <<1365553560-32258-3-git-send-email-liwanp@linux.vnet.ibm.com>>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6668.5000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Wanpeng Li [mailto:liwanp@linux.vnet.ibm.com]
> Subject: [PATCH 02/10] staging: zcache: remove zcache_freeze
> 
> The default value of zcache_freeze is false and it won't be modified by
> other codes. Remove zcache_freeze since no routine can disable zcache
> during system running.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

I'd prefer to leave this code in place as it may be very useful
if/when zcache becomes more tightly integrated into the MM subsystem
and the rest of the kernel.  And the subtleties for temporarily disabling
zcache (which is what zcache_freeze does) are non-obvious and
may cause data loss so if someone wants to add this functionality
back in later and don't have this piece of code, it may take
a lot of pain to get it working.

Usage example: All CPUs are fully saturated so it is questionable
whether spending CPU cycles for compression is wise.  Kernel
could disable zcache using zcache_freeze.  (Yes, a new entry point
would need to be added to enable/disable zcache_freeze.)

My two cents... others are welcome to override.

> ---
>  drivers/staging/zcache/zcache-main.c |   55 +++++++++++-----------------------
>  1 file changed, 18 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
> index e23d814..fe6801a 100644
> --- a/drivers/staging/zcache/zcache-main.c
> +++ b/drivers/staging/zcache/zcache-main.c
> @@ -1118,15 +1118,6 @@ free_and_out:
>  #endif /* CONFIG_ZCACHE_WRITEBACK */
> 
>  /*
> - * When zcache is disabled ("frozen"), pools can be created and destroyed,
> - * but all puts (and thus all other operations that require memory allocation)
> - * must fail.  If zcache is unfrozen, accepts puts, then frozen again,
> - * data consistency requires all puts while frozen to be converted into
> - * flushes.
> - */
> -static bool zcache_freeze;
> -
> -/*
>   * This zcache shrinker interface reduces the number of ephemeral pageframes
>   * used by zcache to approximately the same as the total number of LRU_FILE
>   * pageframes in use, and now also reduces the number of persistent pageframes
> @@ -1221,44 +1212,34 @@ int zcache_put_page(int cli_id, int pool_id, struct tmem_oid *oidp,
>  {
>  	struct tmem_pool *pool;
>  	struct tmem_handle th;
> -	int ret = -1;
> +	int ret = 0;
>  	void *pampd = NULL;
> 
>  	BUG_ON(!irqs_disabled());
>  	pool = zcache_get_pool_by_id(cli_id, pool_id);
>  	if (unlikely(pool == NULL))
>  		goto out;
> -	if (!zcache_freeze) {
> -		ret = 0;
> -		th.client_id = cli_id;
> -		th.pool_id = pool_id;
> -		th.oid = *oidp;
> -		th.index = index;
> -		pampd = zcache_pampd_create((char *)page, size, raw,
> -				ephemeral, &th);
> -		if (pampd == NULL) {
> -			ret = -ENOMEM;
> -			if (ephemeral)
> -				inc_zcache_failed_eph_puts();
> -			else
> -				inc_zcache_failed_pers_puts();
> -		} else {
> -			if (ramster_enabled)
> -				ramster_do_preload_flnode(pool);
> -			ret = tmem_put(pool, oidp, index, 0, pampd);
> -			if (ret < 0)
> -				BUG();
> -		}
> -		zcache_put_pool(pool);
> +
> +	th.client_id = cli_id;
> +	th.pool_id = pool_id;
> +	th.oid = *oidp;
> +	th.index = index;
> +	pampd = zcache_pampd_create((char *)page, size, raw,
> +			ephemeral, &th);
> +	if (pampd == NULL) {
> +		ret = -ENOMEM;
> +		if (ephemeral)
> +			inc_zcache_failed_eph_puts();
> +		else
> +			inc_zcache_failed_pers_puts();
>  	} else {
> -		inc_zcache_put_to_flush();
>  		if (ramster_enabled)
>  			ramster_do_preload_flnode(pool);
> -		if (atomic_read(&pool->obj_count) > 0)
> -			/* the put fails whether the flush succeeds or not */
> -			(void)tmem_flush_page(pool, oidp, index);
> -		zcache_put_pool(pool);
> +		ret = tmem_put(pool, oidp, index, 0, pampd);
> +		if (ret < 0)
> +			BUG();
>  	}
> +	zcache_put_pool(pool);
>  out:
>  	return ret;
>  }
> --
> 1.7.10.4
