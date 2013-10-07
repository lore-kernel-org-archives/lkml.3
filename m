Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3JGXyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 19:54:14 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:59154 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3JGXyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 19:54:13 -0400
Message-ID: <1381190047.12191.32.camel@edumazet-glaptop.roam.corp.google.com>
Subject: Re: [PATCH 4/4] [RFC] ipv6: Fix for possible ipv6 seqlock deadlock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Mon, 07 Oct 2013 16:54:07 -0700
In-Reply-To: <1381186321-4906-5-git-send-email-john.stultz@linaro.org>
References: <1381186321-4906-1-git-send-email-john.stultz@linaro.org>
	 <1381186321-4906-5-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-07 at 15:52 -0700, John Stultz wrote:
> While enabling lockdep on seqlocks, I ran across the warning below
> caused by the ipv6 stats being updated in both irq and non-irq context.

You mean a lockdep warning on a seqcount in this context, right ?

> 
> This patch changes from IP6_INC_STATS_BH to IP6_INC_STATS (suggested
> by Eric Dumazet) to resolve this problem.
...
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: James Morris <jmorris@namei.org>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Patrick McHardy <kaber@trash.net>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  net/ipv6/ip6_output.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 3a692d5..7e63c1e 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -909,7 +909,7 @@ static int ip6_dst_lookup_tail(struct sock *sk,
>  
>  out_err_release:
>  	if (err == -ENETUNREACH)
> -		IP6_INC_STATS_BH(net, NULL, IPSTATS_MIB_OUTNOROUTES);
> +		IP6_INC_STATS(net, NULL, IPSTATS_MIB_OUTNOROUTES);
>  	dst_release(*dst);
>  	*dst = NULL;
>  	return err;

This one is certainly a bug fix, David please consider adding it to your
net tree

Bug added in commit ca46f9c834913f ("[IPv6] SNMP: Increment OutNoRoutes
when connecting to unreachable network")

Acked-by: Eric Dumazet <edumazet@google.com>



