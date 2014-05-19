Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaESCoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:44:46 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:40285 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbaESCoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:44:44 -0400
Message-ID: <1400467481.5211.48.camel@marge.simpson.net>
Subject: Re: [PATCH] sched/rt: don't try to balance rt_runtime when it is
 futile
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 19 May 2014 04:44:41 +0200
In-Reply-To: <20140518155815.GK4570@linux.vnet.ibm.com>
References: <1400080115-12339-1-git-send-email-paul.gortmaker@windriver.com>
	 <20140514154459.GE4570@linux.vnet.ibm.com>
	 <1400123931.5175.38.camel@marge.simpson.net>
	 <1400386954.5140.36.camel@marge.simpson.net>
	 <20140518052039.GF4570@linux.vnet.ibm.com>
	 <1400402201.5166.13.camel@marge.simpson.net>
	 <20140518155815.GK4570@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-18 at 08:58 -0700, Paul E. McKenney wrote: 
> On Sun, May 18, 2014 at 10:36:41AM +0200, Mike Galbraith wrote:
> > On Sat, 2014-05-17 at 22:20 -0700, Paul E. McKenney wrote:
> > 
> > > If you are saying that turning on nohz_full doesn't help unless you
> > > also ensure that there is only one runnable task per CPU, I completely
> > > agree.  If you are saying something else, you lost me.  ;-)
> > 
> > Yup, that's it more or less.  It's not only single task loads that could
> > benefit from better isolation, but if isolation improving measures are
> > tied to nohz_full, other sensitive loads will suffer if they try to use
> > isolation improvements.
> 
> So you are arguing for a separate Kconfig variable that does the isolation?
> So that NO_HZ_FULL selects this new variable, and (for example) RCU
> uses this new variable to decide when to pin the grace-period kthreads
> onto the housekeeping CPU?

I'm thinking more about runtime, but yes.

The tick mode really wants to be selectable per set (in my boxen you can
switch between nohz off/idle, but not yet nohz_full, that might get real
interesting).  You saw in my numbers that ticked is far better for the
threaded rt load, but what if the total load has both sensitive rt and
compute components to worry about?  The rt component wants relief from
the jitter that flipping the tick inflicts, but also wants as little
disturbance as possible, so RCU offload and whatever other measures that
are or become available are perhaps interesting to it as well.  The
numbers showed that here and now the two modes can work together in the
same box, I can have my rt set ticking away, and other cores doing
tickless compute, but enabling that via common config (distros don't
want to ship many kernel flavors) has a cost to rt performance.

Ideally, bean counting would be switchable too, giving all components
the environment they like best.

-Mike

