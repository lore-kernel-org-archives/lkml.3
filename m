Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbaCDGPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 01:15:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16611 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbaCDGPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 01:15:09 -0500
X-IronPort-AV: E=Sophos;i="4.97,583,1389715200"; 
   d="scan'208";a="9641577"
Message-ID: <53156621.60900@cn.fujitsu.com>
Date: Tue, 04 Mar 2014 13:35:29 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, bcrl@kvack.org
CC: viro@zeniv.linux.org.uk, jmoyer@redhat.com, kosaki.motohiro@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, guz.fnst@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Update PATCH 2/2] aio, mem-hotplug: Add memory barrier to aio
 ring page migration.
References: <1393497616-16428-1-git-send-email-tangchen@cn.fujitsu.com> <1393497616-16428-3-git-send-email-tangchen@cn.fujitsu.com> <530F2A2D.50307@jp.fujitsu.com> <530F3327.8020205@jp.fujitsu.com>
In-Reply-To: <530F3327.8020205@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/04 13:31:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/04 13:31:37,
	Serialize complete at 2014/03/04 13:31:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 	thu, 27 Feb 2014 21:44:23 +0900, Yasuaki Ishimatsu wrote:
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
> So add a wmb and rmb to synchronize them.
> 
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> ---
>  fs/aio.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 50c089c..8d9b82b 100644
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
> @@ -1074,6 +1082,12 @@ static long aio_read_events_ring(struct kioctx *ctx,
>  		page = ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE];
>  		pos %= AIO_EVENTS_PER_PAGE;
> 
> +		/*
> +		 * Ensure that the page's data was copied from old one by
> +		 * aio_migratepage().
> +		 */
> +		smp_rmb();
> +

smp_read_barrier_depends() is better.

"One could place an A smp_rmb() primitive between the pointer fetch and
 dereference. However, this imposes unneeded overhead on systems (such as
 i386, IA64, PPC, and SPARC) that respect data dependencies on the read side.
 A smp_read_barrier_depends() primitive has been added to the Linux 2.6 kernel
 to eliminate overhead on these systems."
		-- From Chapter 7.1 of <Memory Barriers: a Hardware View for Software Hackers>
		   Written by Paul E. McKenney

Thanks
Miao

>  		ev = kmap(page);
>  		copy_ret = copy_to_user(event + ret, ev + pos,
>  					sizeof(*ev) * avail);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

