Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab3LLN2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:28:54 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:58613 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3LLN2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:28:50 -0500
Date: Thu, 12 Dec 2013 14:28:46 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131212132846.GA16750@gmail.com>
References: <20131211113839.GF21683@pd.tnic>
 <20131211115239.GA21999@twins.programming.kicks-ass.net>
 <1386764955.12005.60.camel@marge.simpson.net>
 <20131211124352.GB21999@twins.programming.kicks-ass.net>
 <20131211134048.GH21683@pd.tnic>
 <20131211145655.GB4510@gmail.com>
 <20131211164318.GA2480@laptop.programming.kicks-ass.net>
 <20131211175036.GC12431@gmail.com>
 <52A8F073.9040500@zytor.com>
 <20131212085143.GC21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131212085143.GC21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Dec 11, 2013 at 03:08:35PM -0800, H. Peter Anvin wrote:
> > On 12/11/2013 09:50 AM, Ingo Molnar wrote:
> > > 
> > > Well, availability could be a problem too, if some CPU (real or 
> > > virtual) implements MWAIT but not CLFLUSH.
> > > 
> > > In theory we could make mwait an alternatives variant and patch in the 
> > > right combination of instructions? The CLFLUSH goes to the same 
> > > address as on which the monitoring happens, so it could be considered 
> > > one meta-instruction.
> > > 
> > 
> > The first thing to do is probably to drop the use of thread_info as a
> > wakeup doorbell.  It seemed like a good idea at the time -- after all,
> > there is one for each thread -- but it is extremely likely to be dirty
> > in the cache, which is (presumably) what causes these kinds of bugs to
> > be maximally likely.  Even if we don't do the CLFLUSH it is likely that
> > the hardware has to do something expensive behind the scenes.
> > 
> > So I would like to propose that we switch to using a percpu variable
> > which is a single cache line of nothing at all.  It would only ever be
> > touched by MONITOR and for explicit wakeup.  Hopefully that will resolve
> > this problem without the need for the CLFLUSH.
> 
> The reason we use thread_info::flags is because we need to write
> TIF_NEED_RESCHED into it to wake up anyhow.
> 
> Using another cacheline would mean the wakeup path would need to write a
> second cross cpu cacheline -- that is badness too.
> 
> So no, I don't think we want to listen to another line.

Seconded ...

Thanks,

	Ingo
