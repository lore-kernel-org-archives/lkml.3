Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaB0O5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:57:34 -0500
Received: from kanga.kvack.org ([205.233.56.17]:54522 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbaB0O5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:57:32 -0500
Date: Thu, 27 Feb 2014 09:57:30 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio ring page migration.
Message-ID: <20140227145730.GA639@kvack.org>
References: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com> <1393497616-16428-3-git-send-email-tangchen@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393497616-16428-3-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 06:40:16PM +0800, Tang Chen wrote:
> When doing aio ring page migration, we migrated the page, and update
> ctx->ring_pages[]. Like the following:
> 
> aio_migratepage()
>  |-> migrate_page_copy(new, old)
>  |   ......				/* Need barrier here */
>  |-> ctx->ring_pages[idx] = new
> 
> Actually, we need a memory barrier between these two operations.
> Otherwise, if ctx->ring_pages[] is updated before memory copy due to
> the compiler optimization, other processes may have an opportunity
> to access to the not fully initialized new ring page.
> 
> So add a wmb to synchronize them.

The smp_wmb() is not needed after you added the taking of ctx->completion_lock 
lock since all accesses to ring_pages is then protected by the spinlock.  
Why are you adding this then?  Or have you missed adding the lock somewhere?  
Also, if you've changed the patch, it is customary to add a "v2" somewhere in 
the patch title so that I have some idea what version of the patch should be 
applied.

		-ben

> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> ---
>  fs/aio.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 50c089c..f0ed838 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -327,6 +327,14 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
>  		pgoff_t idx;
>  		spin_lock_irqsave(&ctx->completion_lock, flags);
>  		migrate_page_copy(new, old);
> +
> +		/*
> +		 * Ensure memory copy is finished before updating
> +		 * ctx->ring_pages[]. Otherwise other processes may access to
> +		 * new ring pages which are not fully initialized.
> +		 */
> +		smp_wmb();
> +
>  		idx = old->index;
>  		if (idx < (pgoff_t)ctx->nr_pages) {
>  			/* And only do the move if things haven't changed */
> -- 
> 1.8.3.1

-- 
"Thought is the essence of where you are now."
