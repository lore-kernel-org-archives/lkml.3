Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaB0KDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:03:32 -0500
Received: from kanga.kvack.org ([205.233.56.17]:53673 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbaB0KD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:03:28 -0500
Date: Thu, 27 Feb 2014 05:03:27 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] aio, memory-hotplug: Fix confliction when migrating and accessing ring pages.
Message-ID: <20140227100327.GA26444@kvack.org>
References: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com> <530E8628.3060105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530E8628.3060105@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:26:16AM +0800, Tang Chen wrote:
> Forgot to mention that the above patch was merged when Linux 3.12 was 
> released.
> So I think this problem exists in 3.12 stable tree.
> 
> If the following solution is acceptable, we need to merge it to 3.12 
> stable tree, too.
> 
> Please reply ASAP.

I'm travelling right now and won't be testing this patch until I get back 
home in about a week, so, for now, I'll apply the patch to my aio-next tree 
so that it gets some exposure to the various trinty runs and other tools 
people run against the -next tree.  I'll then push it out to Linus once I've 
run my own sanity tests next week.  Regards,

		-ben

> Thanks.
> 
> >
> >In this patch, ctx->completion_lock is used to prevent other processes
> >from accessing the ring page being migrated.
> >
> >But in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring(),
> >when writing to the ring page, they didn't take ctx->completion_lock.
> >
> >As a result, for example, we have the following problem:
> >
> >             thread 1                      |              thread 2
> >                                           |
> >aio_migratepage()                         |
> >  |->  take ctx->completion_lock            |
> >  |->  migrate_page_copy(new, old)          |
> >  |   *NOW*, ctx->ring_pages[idx] == old   |
> >                                           |
> >                                           |    *NOW*, 
> >                                           ctx->ring_pages[idx] == old
> >                                           |    aio_read_events_ring()
> >                                           |     |->  ring = 
> >                                           kmap_atomic(ctx->ring_pages[0])
> >                                           |     |->  ring->head = head;   
> >                                           *HERE, write to the old ring 
> >                                           page*
> >                                           |     |->  kunmap_atomic(ring);
> >                                           |
> >  |->  ctx->ring_pages[idx] = new           |
> >  |   *BUT NOW*, the content of            |
> >  |    ring_pages[idx] is old.             |
> >  |->  release ctx->completion_lock         |
> >
> >As above, the new ring page will not be updated.
> >
> >The solution is taking ctx->completion_lock in thread 2, which means,
> >in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring() when
> >writing to ring pages.
> >
> >
> >Reported-by: Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>
> >Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
> >---
> >  fs/aio.c | 33 +++++++++++++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >
> >diff --git a/fs/aio.c b/fs/aio.c
> >index 062a5f6..50c089c 100644
> >--- a/fs/aio.c
> >+++ b/fs/aio.c
> >@@ -366,6 +366,7 @@ static int aio_setup_ring(struct kioctx *ctx)
> >  	int nr_pages;
> >  	int i;
> >  	struct file *file;
> >+	unsigned long flags;
> >
> >  	/* Compensate for the ring buffer's head/tail overlap entry */
> >  	nr_events += 2;	/* 1 is required, 2 for good luck */
> >@@ -437,6 +438,14 @@ static int aio_setup_ring(struct kioctx *ctx)
> >  	ctx->user_id = ctx->mmap_base;
> >  	ctx->nr_events = nr_events; /* trusted copy */
> >
> >+	/*
> >+	 * The aio ring pages are user space pages, so they can be migrated.
> >+	 * When writing to an aio ring page, we should ensure the page is not
> >+	 * being migrated. Aio page migration procedure is protected by
> >+	 * ctx->completion_lock, so we add this lock here.
> >+	 */
> >+	spin_lock_irqsave(&ctx->completion_lock, flags);
> >+
> >  	ring = kmap_atomic(ctx->ring_pages[0]);
> >  	ring->nr = nr_events;	/* user copy */
> >  	ring->id = ~0U;
> >@@ -448,6 +457,8 @@ static int aio_setup_ring(struct kioctx *ctx)
> >  	kunmap_atomic(ring);
> >  	flush_dcache_page(ctx->ring_pages[0]);
> >
> >+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
> >+
> >  	return 0;
> >  }
> >
> >@@ -542,6 +553,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct 
> >mm_struct *mm)
> >  	unsigned i, new_nr;
> >  	struct kioctx_table *table, *old;
> >  	struct aio_ring *ring;
> >+	unsigned long flags;
> >
> >  	spin_lock(&mm->ioctx_lock);
> >  	rcu_read_lock();
> >@@ -556,9 +568,19 @@ static int ioctx_add_table(struct kioctx *ctx, struct 
> >mm_struct *mm)
> >  					rcu_read_unlock();
> >  					spin_unlock(&mm->ioctx_lock);
> >
> >+					/*
> >+					 * Accessing ring pages must be done
> >+					 * holding ctx->completion_lock to
> >+					 * prevent aio ring page migration
> >+					 * procedure from migrating ring 
> >pages.
> >+					 */
> >+				 spin_lock_irqsave(&ctx->completion_lock,
> >+							  flags);
> >  					ring = 
> >  					kmap_atomic(ctx->ring_pages[0]);
> >  					ring->id = ctx->id;
> >  					kunmap_atomic(ring);
> >+					spin_unlock_irqrestore(
> >+						&ctx->completion_lock, 
> >flags);
> >  					return 0;
> >  				}
> >
> >@@ -1021,6 +1043,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
> >  	unsigned head, tail, pos;
> >  	long ret = 0;
> >  	int copy_ret;
> >+	unsigned long flags;
> >
> >  	mutex_lock(&ctx->ring_lock);
> >
> >@@ -1066,11 +1089,21 @@ static long aio_read_events_ring(struct kioctx 
> >*ctx,
> >  		head %= ctx->nr_events;
> >  	}
> >
> >+	/*
> >+	 * The aio ring pages are user space pages, so they can be migrated.
> >+	 * When writing to an aio ring page, we should ensure the page is not
> >+	 * being migrated. Aio page migration procedure is protected by
> >+	 * ctx->completion_lock, so we add this lock here.
> >+	 */
> >+	spin_lock_irqsave(&ctx->completion_lock, flags);
> >+
> >  	ring = kmap_atomic(ctx->ring_pages[0]);
> >  	ring->head = head;
> >  	kunmap_atomic(ring);
> >  	flush_dcache_page(ctx->ring_pages[0]);
> >
> >+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
> >+
> >  	pr_debug("%li  h%u t%u\n", ret, head, tail);
> >
> >  	put_reqs_available(ctx, ret);

-- 
"Thought is the essence of where you are now."
