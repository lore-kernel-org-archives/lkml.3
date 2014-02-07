Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaBGCDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 21:03:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:58016 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbaBGCDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 21:03:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1391712162.10160.8.camel@edumazet-glaptop2.roam.corp.google.com>
Date: Thu, 06 Feb 2014 18:03:23 -0800
In-Reply-To: <1391712162.10160.8.camel@edumazet-glaptop2.roam.corp.google.com>
	(Eric Dumazet's message of "Thu, 06 Feb 2014 10:42:42 -0800")
Message-ID: <87txcbisr8.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18ZueedNYj50w53sPFdreiXZ5ZWIOJqP7w=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4996]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Eric Dumazet <eric.dumazet@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] net: use __GFP_NORETRY for high order allocations
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> From: Eric Dumazet <edumazet@google.com>
>
> sock_alloc_send_pskb() & sk_page_frag_refill()
> have a loop trying high order allocations to prepare
> skb with low number of fragments as this increases performance.
>
> Problem is that under memory pressure/fragmentation, this can
> trigger OOM while the intent was only to try the high order
> allocations, then fallback to order-0 allocations.
>
> We had various reports from unexpected regressions.
>
> According to David, setting __GFP_NORETRY should be fine,
> as the asynchronous compaction is still enabled, and this
> will prevent OOM from kicking as in :
>
> CFSClientEventm invoked oom-killer: gfp_mask=0x42d0, order=3, oom_adj=0,
> oom_score_adj=0, oom_score_badness=2 (enabled),memcg_scoring=disabled
> CFSClientEventm 
>
> Call Trace:
>  [<ffffffff8043766c>] dump_header+0xe1/0x23e
>  [<ffffffff80437a02>] oom_kill_process+0x6a/0x323
>  [<ffffffff80438443>] out_of_memory+0x4b3/0x50d
>  [<ffffffff8043a4a6>] __alloc_pages_may_oom+0xa2/0xc7
>  [<ffffffff80236f42>] __alloc_pages_nodemask+0x1002/0x17f0
>  [<ffffffff8024bd23>] alloc_pages_current+0x103/0x2b0
>  [<ffffffff8028567f>] sk_page_frag_refill+0x8f/0x160
>  [<ffffffff80295fa0>] tcp_sendmsg+0x560/0xee0
>  [<ffffffff802a5037>] inet_sendmsg+0x67/0x100
>  [<ffffffff80283c9c>] __sock_sendmsg_nosec+0x6c/0x90
>  [<ffffffff80283e85>] sock_sendmsg+0xc5/0xf0
>  [<ffffffff802847b6>] __sys_sendmsg+0x136/0x430
>  [<ffffffff80284ec8>] sys_sendmsg+0x88/0x110
>  [<ffffffff80711472>] system_call_fastpath+0x16/0x1b
> Out of Memory: Kill process 2856 (bash) score 9999 or sacrifice child
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Acked-by: David Rientjes <rientjes@google.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I have seen similiar order 3 allocation failures as well and reached the
same conclusion that __GFP_NORETRY was the solution.

Eric
> ---
>  net/core/sock.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 0c127dcdf6a8..5b6a9431b017 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1775,7 +1775,9 @@ struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
>  			while (order) {
>  				if (npages >= 1 << order) {
>  					page = alloc_pages(sk->sk_allocation |
> -							   __GFP_COMP | __GFP_NOWARN,
> +							   __GFP_COMP |
> +							   __GFP_NOWARN |
> +							   __GFP_NORETRY,
>  							   order);
>  					if (page)
>  						goto fill_page;
> @@ -1845,7 +1847,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t prio)
>  		gfp_t gfp = prio;
>  
>  		if (order)
> -			gfp |= __GFP_COMP | __GFP_NOWARN;
> +			gfp |= __GFP_COMP | __GFP_NOWARN | __GFP_NORETRY;
>  		pfrag->page = alloc_pages(gfp, order);
>  		if (likely(pfrag->page)) {
>  			pfrag->offset = 0;
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
