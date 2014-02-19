Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaBSL54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:57:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaBSL5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:57:55 -0500
Date: Wed, 19 Feb 2014 12:57:47 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: paulus@samba.org, Ingo Molnar <mingo@redhat.com>, acme@ghostprotocols.net,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sched: tip/master show panic while booting/rebooting
Message-ID: <20140219115747.GJ15586@twins.programming.kicks-ass.net>
References: <5302EBA3.10909@linux.vnet.ibm.com>
 <20140218112230.GA27965@twins.programming.kicks-ass.net>
 <5304210B.9060604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5304210B.9060604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 11:12:11AM +0800, Michael wang wrote:
> On 02/18/2014 07:22 PM, Peter Zijlstra wrote:
> > On Tue, Feb 18, 2014 at 01:12:03PM +0800, Michael wang wrote:
> >> Hi, Folks
> >>
> >> Got below panic while testing tip/master on x86 box, it randomly
> >> occur while booting or rebooting, any ideas?
> > 
> > The obvious pick would be the relocation of the idle_balance call, but
> > I'm not sure how that'll end up stalling.
> 
> I've review the code again, seems like it was caused by the same issue
> we discussed (RT/DL enqueued issue), I found that idle_balance() will
> return 1 in such cases:
> 
>         /*
>          * While browsing the domains, we released the rq lock.
>          * A task could have be enqueued in the meantime
>          */
>         if (this_rq->nr_running && !pulled_task)
>                 return 1;
> 
> And if no more fair task to be pulled, we will do balance again and
> again in pick_next_task_fair() until panic in NMI...
> 
> The solution we discussed could solve the problem I suppose, it was
> already in progress, correct?
> 
> Please let me know if there are any thing I could help with ;-)

Great, thanks!

Right, I'm waiting for Ingo to appear and commit some patches into tip.
