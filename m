Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab3I0FrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 01:47:19 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39529 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3I0FrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 01:47:16 -0400
Date: Fri, 27 Sep 2013 07:47:12 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] [RFC] ipv6: Fix for possible ipv6 seqlock deadlock
Message-ID: <20130927054712.GB6597@gmail.com>
References: <1380220464-28840-1-git-send-email-john.stultz@linaro.org>
 <1380220464-28840-5-git-send-email-john.stultz@linaro.org>
 <1380223848.3165.207.camel@edumazet-glaptop>
 <52448F0F.9050408@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52448F0F.9050408@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> On 09/26/2013 12:30 PM, Eric Dumazet wrote:
> > On Thu, 2013-09-26 at 11:34 -0700, John Stultz wrote:
> >> While enabling lockdep on seqlocks, I ran accross the warning below
> >> caused by the ipv6 stats being updated in both irq and non-irq context.
> >>
> >> This is a novice attempt to correct the issue, and with this patch
> >> the warning goes away. Any better solutions would be appreciated!
> > ...
> >
> >>  
> >>  out_err_release:
> >> -	if (err == -ENETUNREACH)
> >> +	if (err == -ENETUNREACH) {
> >> +		unsigned long flags;
> >> +		/* some of the stats are locked in irq context */
> >> +		local_irq_save(flags);
> >>  		IP6_INC_STATS_BH(net, NULL, IPSTATS_MIB_OUTNOROUTES);
> >> +		local_irq_restore(flags);
> >> +	}
> >>  	dst_release(*dst);
> >>  	*dst = NULL;
> >>  	return err;
> > You better change IP6_INC_STATS_BH() to IP6_INC_STATS()
> >
> > On x86 for example, no extra code will be generated (no need to disable
> > hard or soft irqs)
> 
> Ah, thanks! Verified it resolves the warning as well, so I've changed my
> patch to use your suggestion.

Btw., is this a deadlock that could occur upstream? If yes then adding a 
Cc: <stable@kernel.org> tag might be warranted.

Thanks,

	Ingo
