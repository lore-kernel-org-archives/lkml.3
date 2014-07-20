Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaGTBH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 21:07:29 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56084 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaGTBH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 21:07:28 -0400
Date: Sun, 20 Jul 2014 03:07:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 07/10] nohz: Enforce timekeeping on CPU 0
Message-ID: <20140720010440.GA2062@lerouge>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-8-git-send-email-fweisbec@gmail.com>
 <alpine.LFD.2.11.1407191318320.3647@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1407191318320.3647@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 01:31:25PM -0400, Nicolas Pitre wrote:
> On Sat, 19 Jul 2014, Frederic Weisbecker wrote:
> 
> > The timekeeper gets initialized to the value of the CPU where the
> > first clockevent device is setup. This works well because the timekeeper
> > can be any online CPU in most configs.
> > 
> > Full dynticks has its own requirement though and needs the timekeeper
> > to always be 0. And this requirement seem to accomodate pretty well with
> > the above described boot timekeeper setting because the first clockevent
> > device happens to be initialized, most of the time, on the boot CPU
> > (which should be CPU 0).
> 
> This might have been discussed before... but this isn't ARM big.LITTLE 
> friendly at all.
> 
> Could we accommodate for any arbitrary CPU instead of making CPU 0 
> "special" other than its role as the boot CPU please?  It doesn't have 
> to be completely dynamic, but CPU 0 might be a really bad choice for 
> ongoing periodic duties in some configurations.  For example, we might 
> highly prefer to do this on CPU 4 for power efficiency reasons once it 
> is online and keep CPU 0 in a deep C-state as much as possible.

I can certainly arrange for setting user defined timekeeper on boot
time. Just one constraint: since the timekeeper is fixed, we can't
offline it. That's usually fine with CPU 0 but on other CPUs, rejecting
a CPU offlining blocks the suspend process.

I imagine I can handover the timekeeping to another CPU in this case
and accept the offlining. But there are chances that the only online
CPUs remaining are full dynticks and it's not tempting to give them
a timekeeping duty.
