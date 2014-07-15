Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaGOOpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:45:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37018 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaGOOp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:45:29 -0400
Message-ID: <1405435525.5744.29.camel@marge.simpson.net>
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Jul 2014 16:45:25 +0200
In-Reply-To: <alpine.DEB.2.10.1407151452370.24854@nanos>
References: <1405110784.2970.655.camel@schen9-DESK>
	 <20140714101611.GS9918@twins.programming.kicks-ass.net>
	 <1405354214.2970.663.camel@schen9-DESK>
	 <20140714161432.GC9918@twins.programming.kicks-ass.net>
	 <1405357534.2970.701.camel@schen9-DESK>
	 <20140714181738.GI9918@twins.programming.kicks-ass.net>
	 <1405364908.2970.729.camel@schen9-DESK>
	 <20140714191504.GO9918@twins.programming.kicks-ass.net>
	 <1405367450.2970.750.camel@schen9-DESK>
	 <20140715095045.GV9918@twins.programming.kicks-ass.net>
	 <20140715120728.GR3588@twins.programming.kicks-ass.net>
	 <alpine.DEB.2.10.1407151452370.24854@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 14:59 +0200, Thomas Gleixner wrote:
> On Tue, 15 Jul 2014, Peter Zijlstra wrote:
> 
> > On Tue, Jul 15, 2014 at 11:50:45AM +0200, Peter Zijlstra wrote:
> > > So you already have an idle notifier (which is x86 only, we should fix
> > > that I suppose), and you then double check there really isn't anything
> > > else running.
> > 
> > Note that we've already done a large part of the expense of going idle
> > by the time we call that idle notifier -- in specific, we've
> > reprogrammed the clock to stop the tick.
> > 
> > Its really wasteful to then generate work again, which means we have to
> > again reprogram the clock etc.
> 
> Doing anything which is not related to idle itself in the idle
> notifier is just plain wrong.
> 
> If that stuff wants to utilize idle slots, we really need to come up
> with a generic and general solution. Otherwise we'll grow those warts
> all over the architecture space, with slightly different ways of
> wreckaging the world an some more.
> 
> This whole attidute of people thinking that they need their own
> specialized scheduling around the real scheduler is a PITA. All this
> stuff is just damanging any sensible approach of power saving, load
> balancing, etc.

Not to mention that we're already too rotund...

pipe-test scheduling cross core, ie ~0 work, ~pure full fastpath. All
kernels with same (obese) distro config, with drivers reduced to what my
boxen need. Squint a little, there is some jitter. These kernels are
all adjusted to eliminate various regressions that would otherwise skew
results up to and including _very_ badly.  See "virgin", the numbers are
much more useful without that particular skew methinks :) 

3.0.101-default        3.753363 usecs/loop -- avg 3.770737 530.4 KHz   1.000
3.1.10-default         3.723843 usecs/loop -- avg 3.716058 538.2 KHz   1.014
3.2.51-default         3.728060 usecs/loop -- avg 3.710372 539.0 KHz   1.016
3.3.8-default          3.906174 usecs/loop -- avg 3.900399 512.8 KHz    .966
3.4.97-default         3.864158 usecs/loop -- avg 3.865281 517.4 KHz    .975
3.5.7-default          3.967481 usecs/loop -- avg 3.962757 504.7 KHz    .951
3.6.11-default         3.851186 usecs/loop -- avg 3.845321 520.1 KHz    .980
3.7.10-default         3.777869 usecs/loop -- avg 3.776913 529.5 KHz    .998
3.8.13-default         4.049927 usecs/loop -- avg 4.041905 494.8 KHz    .932
3.9.11-default         3.973046 usecs/loop -- avg 3.974208 503.2 KHz    .948
3.10.27-default        4.189598 usecs/loop -- avg 4.189298 477.4 KHz    .900
3.11.10-default        4.293870 usecs/loop -- avg 4.297979 465.3 KHz    .877
3.12.24-default        4.321570 usecs/loop -- avg 4.321961 462.8 KHz    .872
3.13.11-default        4.137845 usecs/loop -- avg 4.134863 483.7 KHz    .911
3.14.10-default        4.145348 usecs/loop -- avg 4.139987 483.1 KHz    .910     1.000
3.15.4-default         4.355594 usecs/loop -- avg 4.351961 459.6 KHz    .866      .951    1.000
3.16.0-default         4.537279 usecs/loop -- avg 4.543532 440.2 KHz    .829      .911     .957
3.16.0-virgin          6.377331 usecs/loop -- avg 6.352794 314.8 KHz   0.sob

my local config, group sched, namespaces etc disabled
3.0.101-smp            3.692377 usecs/loop -- avg 3.690774 541.9 KHz   1.000
3.1.10-smp             3.573832 usecs/loop -- avg 3.563269 561.3 KHz   1.035
3.2.51-smp             3.632690 usecs/loop -- avg 3.628220 551.2 KHz   1.017
3.3.8-smp              3.801838 usecs/loop -- avg 3.803441 525.8 KHz    .970
3.4.97-smp             3.836087 usecs/loop -- avg 3.843501 520.4 KHz    .960
3.5.7-smp              3.646927 usecs/loop -- avg 3.646288 548.5 KHz   1.012
3.6.11-smp             3.674402 usecs/loop -- avg 3.680929 543.3 KHz   1.002
3.7.10-smp             3.644274 usecs/loop -- avg 3.644566 548.8 KHz   1.012
3.8.13-smp             3.678164 usecs/loop -- avg 3.675524 544.1 KHz   1.004
3.9.11-smp             3.834943 usecs/loop -- avg 3.845852 520.0 KHz    .959
3.10.27-smp            3.651881 usecs/loop -- avg 3.634515 550.3 KHz   1.015
3.11.10-smp            3.716159 usecs/loop -- avg 3.720603 537.5 KHz    .991
3.12.24-smp            3.862634 usecs/loop -- avg 3.872252 516.5 KHz    .953
3.13.11-smp            3.803254 usecs/loop -- avg 3.802553 526.0 KHz    .970
3.14.10-smp            4.010009 usecs/loop -- avg 4.009019 498.9 KHz    .920
3.15.4-smp             3.882398 usecs/loop -- avg 3.884095 514.9 KHz    .950
3.16.0-master          4.061003 usecs/loop -- avg 4.058244 492.8 KHz    .909

echo 0 > sched_wakeup_granularity_ns, taskset -c 3 pipe-test 1 (shortest path)
3.0.101-default        3.352267 usecs/loop -- avg 3.352434 596.6 KHz   1.000
3.16.0-default         3.596559 usecs/loop -- avg 3.594023 556.5 KHz    .932

3.0.101-smp            3.089251 usecs/loop -- avg 3.089556 647.3 KHz   1.000
3.16.0-master          3.254721 usecs/loop -- avg 3.251534 615.1 KHz    .950

sched+idle is becoming more of a not-so-fastpath.  Pure sched is not as
bad, but still, we're getting fat.

netperf TCP_RR         trans/sec (unbound)
3.0.101-default        91360.56     1.000
3.16.0-default         72523.30      .793

3.0.101-smp            92166.23     1.000
3.16.0-master          81235.30      .881

echo 0 > sched_wakeup_granularity_ns, bound to cpu3
3.0.101-smp            94289.95     1.000
3.16.0-master          81219.02      .861

Leanest meanest kernel ever to run on this box (2.6.22 + cfs-2.6.25 etc)
did that bound TCP_RR at ~114k IIRC.  My userspace became too new to
boot that kernel without a squabble, but I think I recall correctly.

-Mike

