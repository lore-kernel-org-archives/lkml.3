Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758782Ab3BSUPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:15:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:35127 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757787Ab3BSUPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:15:36 -0500
Date: Tue, 19 Feb 2013 21:15:29 +0100 (CET)
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
In-Reply-To: <alpine.LFD.2.02.1302192021370.22263@ionos>
Message-ID: <alpine.LFD.2.02.1302192056330.22263@ionos>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet> <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com> <51118797.9080800@linaro.org>
 <alpine.LFD.2.02.1302182132230.22263@ionos> <5123C3AF.8060100@linaro.org> <alpine.LFD.2.02.1302192021370.22263@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2013, Thomas Gleixner wrote:
> On Tue, 19 Feb 2013, John Stultz wrote:
> Would be interesting to compare and contrast that. Though you can't do
> that in the kernel as the write hold time of the timekeeper seq is way
> larger than the gtod->seq write hold time. I have a patch series in
> work which makes the timekeeper seq hold time almost as short as that
> of gtod->seq.

As a side note. There is a really interesting corner case
vs. virtualization.

  VCPU0						VCPU1

  update_wall_time()
    write_seqlock_irqsave(&tk->lock, flags);
    ....

Host schedules out VCPU0

Arbitrary delay

Host schedules in VCPU0
						__vdso_clock_gettime()#1
    update_vsyscall();
						__vdso_clock_gettime()#2

Depending on the length of the delay which kept VCPU0 away from
executing and depending on the direction of the ntp update of the
timekeeping variables __vdso_clock_gettime()#2 can observe time going
backwards.

You can reproduce that by pinning VCPU0 to physical core 0 and VCPU1
to physical core 1. Now remove all load from physical core 1 except
VCPU1 and put massive load on physical core 0 and make sure that the
NTP adjustment lowers the mult factor.

Fun, isn't it ?

     tglx


