Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab3BTKGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:06:47 -0500
Received: from www.linutronix.de ([62.245.132.108]:38267 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3BTKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:06:45 -0500
Date: Wed, 20 Feb 2013 11:06:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Stephane Eranian <eranian@google.com>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
In-Reply-To: <5123FAAE.3030706@linaro.org>
Message-ID: <alpine.LFD.2.02.1302201040180.22263@ionos>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet> <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com> <51118797.9080800@linaro.org>
 <alpine.LFD.2.02.1302182132230.22263@ionos> <5123C3AF.8060100@linaro.org> <alpine.LFD.2.02.1302192021370.22263@ionos> <alpine.LFD.2.02.1302192056330.22263@ionos> <5123E20E.60307@linaro.org> <alpine.LFD.2.02.1302192152240.22263@ionos>
 <5123FAAE.3030706@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, John Stultz wrote:
> On 02/19/2013 01:50 PM, Thomas Gleixner wrote:
> > 2) Doing #1 will allow to observe the described time going backwards
> >     scenario in kernel as well.
> > 
> >     The reason why we did not get complaints about that scenario at all
> >     (yet) is that the window and the probability to hit it are small
> >     enough. Nevertheless it's a real issue for virtualized systems.
> > 
> >     Now you came up with the great idea, that the timekeeping core is
> >     able to calculate what the approximate safe value is for the
> >     clocksource readout to be in a state where wreckage relative to the
> >     last update of the clocksource is not observable, not matter how
> >     long the scheduled out delay is and in which direction the NTP
> >     update is going.
> 
> So the other bit of caution here, is I realize my idea of "valid cycle ranges"
> has the potential for deadlock.
> 
> While it should be fine for use with vdso, we have to be careful if we use
> this in-kernel, because if we're in the update path, the valid interval check
> could trigger the ktime_get() in hrtimer_interrupt() to spin forever. So we
> need to be sure we don't use this method anywhere in the code paths that
> trigger the update_wall_time() code.

Hmm, right.
 
> So some additional thinking may be necessary here. Though it may be as simple
> as making sure we don't loop on the cpu that does the timekeeping update.

Either that or make sure to use ktime_get_nocheck() in those code pathes.

Thanks,

	tglx
