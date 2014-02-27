Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbaB0AXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 19:23:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:28942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaB0AX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 19:23:29 -0500
X-IronPort-AV: E=Sophos;i="4.97,551,1389715200"; 
   d="scan'208";a="9611799"
Message-ID: <530E8628.3060105@cn.fujitsu.com>
Date: Thu, 27 Feb 2014 08:26:16 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, bcrl@kvack.org, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com
CC: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] aio, memory-hotplug: Fix confliction when migrating
 and accessing ring pages.
References: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 08:21:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/02/27 08:21:04,
	Serialize complete at 2014/02/27 08:21:04
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

On 02/26/2014 04:38 PM, Tang Chen wrote:
> AIO ring page migration has been implemented by the following patch:
>
>          https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/aio.c?id=36bc08cc01709b4a9bb563b35aa530241ddc63e3

Forgot to mention that the above patch was merged when Linux 3.12 was 
released.
So I think this problem exists in 3.12 stable tree.

If the following solution is acceptable, we need to merge it to 3.12 
stable tree, too.

Please reply ASAP.

Thanks.

>
> In this patch, ctx->completion_lock is used to prevent other processes
> from accessing the ring page being migrated.
>
> But in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring(),
> when writing to the ring page, they didn't take ctx->completion_lock.
>
> As a result, for example, we have the following problem:
>
>              thread 1                      |              thread 2
>                                            |
> aio_migratepage()                         |
>   |->  take ctx->completion_lock            |
>   |->  migrate_page_copy(new, old)          |
>   |   *NOW*, ctx->ring_pages[idx] == old   |
>                                            |
>                                            |    *NOW*, ctx->ring_pages[idx] == old
>                                            |    aio_read_events_ring()
>                                            |     |->  ring = kmap_atomic(ctx->ring_pages[0])
>                                            |     |->  ring->head = head;          *HERE, write to the old ring page*
>                                            |     |->  kunmap_atomic(ring);
>                                            |
>   |->  ctx->ring_pages[idx] = new           |
>   |   *BUT NOW*, the content of            |
>   |    ring_pages[idx] is old.             |
>   |->  release ctx->completion_lock         |
>
> As above, the new ring page will not be updated.
>
> The solution is taking ctx->completion_lock in thread 2, which means,
> in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring() when
> writing to ring pages.
>
>
> Reported-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> ---
>   fs/aio.c | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 062a5f6..50c089c 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -366,6 +366,7 @@ static int aio_setup_ring(struct kioctx *ctx)
>   	int nr_pages;
>   	int i;
>   	struct file *file;
> +	unsigned long flags;
>
>   	/* Compensate for the ring buffer's head/tail overlap entry */
>   	nr_events += 2;	/* 1 is required, 2 for good luck */
> @@ -437,6 +438,14 @@ static int aio_setup_ring(struct kioctx *ctx)
>   	ctx->user_id = ctx->mmap_base;
>   	ctx->nr_events = nr_events; /* trusted copy */
>
> +	/*
> +	 * The aio ring pages are user space pages, so they can be migrated.
> +	 * When writing to an aio ring page, we should ensure the page is not
> +	 * being migrated. Aio page migration procedure is protected by
> +	 * ctx->completion_lock, so we add this lock here.
> +	 */
> +	spin_lock_irqsave(&ctx->completion_lock, flags);
> +
>   	ring = kmap_atomic(ctx->ring_pages[0]);
>   	ring->nr = nr_events;	/* user copy */
>   	ring->id = ~0U;
> @@ -448,6 +457,8 @@ static int aio_setup_ring(struct kioctx *ctx)
>   	kunmap_atomic(ring);
>   	flush_dcache_page(ctx->ring_pages[0]);
>
> +	spin_unlock_irqrestore(&ctx->completion_lock, flags);
> +
>   	return 0;
>   }
>
> @@ -542,6 +553,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
>   	unsigned i, new_nr;
>   	struct kioctx_table *table, *old;
>   	struct aio_ring *ring;
> +	unsigned long flags;
>
>   	spin_lock(&mm->ioctx_lock);
>   	rcu_read_lock();
> @@ -556,9 +568,19 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
>   					rcu_read_unlock();
>   					spin_unlock(&mm->ioctx_lock);
>
> +					/*
> +					 * Accessing ring pages must be done
> +					 * holding ctx->completion_lock to
> +					 * prevent aio ring page migration
> +					 * procedure from migrating ring pages.
> +					 */
> +					spin_lock_irqsave(&ctx->completion_lock,
> +							  flags);
>   					ring = kmap_atomic(ctx->ring_pages[0]);
>   					ring->id = ctx->id;
>   					kunmap_atomic(ring);
> +					spin_unlock_irqrestore(
> +						&ctx->completion_lock, flags);
>   					return 0;
>   				}
>
> @@ -1021,6 +1043,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
>   	unsigned head, tail, pos;
>   	long ret = 0;
>   	int copy_ret;
> +	unsigned long flags;
>
>   	mutex_lock(&ctx->ring_lock);
>
> @@ -1066,11 +1089,21 @@ static long aio_read_events_ring(struct kioctx *ctx,
>   		head %= ctx->nr_events;
>   	}
>
> +	/*
> +	 * The aio ring pages are user space pages, so they can be migrated.
> +	 * When writing to an aio ring page, we should ensure the page is not
> +	 * being migrated. Aio page migration procedure is protected by
> +	 * ctx->completion_lock, so we add this lock here.
> +	 */
> +	spin_lock_irqsave(&ctx->completion_lock, flags);
> +
>   	ring = kmap_atomic(ctx->ring_pages[0]);
>   	ring->head = head;
>   	kunmap_atomic(ring);
>   	flush_dcache_page(ctx->ring_pages[0]);
>
> +	spin_unlock_irqrestore(&ctx->completion_lock, flags);
> +
>   	pr_debug("%li  h%u t%u\n", ret, head, tail);
>
>   	put_reqs_available(ctx, ret);
