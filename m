Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934733Ab3BTK3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:29:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55001 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934648Ab3BTK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:29:34 -0500
Message-ID: <1361356160.10155.22.camel@laptop>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>, Pawel Moll <pawel.moll@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Date: Wed, 20 Feb 2013 11:29:20 +0100
In-Reply-To: <5123C3AF.8060100@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org> <alpine.LFD.2.02.1302182132230.22263@ionos>
	 <5123C3AF.8060100@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-19 at 10:25 -0800, John Stultz wrote:
> So describe how the perf time domain is different then
> CLOCK_MONOTONIC_RAW.

The primary difference is that the trace/sched/perf time domain is not
strictly monotonic, it is only locally monotonic -- that is two time
stamps taken on the same cpu are guaranteed to be monotonic.

Furthermore, to make it useful, there's an actual bound on the inter-cpu
drift (implemented by limiting the drift to CLOCK_MONOTONIC).

Additionally -- to increase use -- we also added a monotonic sync point
when cpu A queries time of cpu B.

> My concern here is that we're basically creating a kernel interface
> that 
> exports implementation-defined semantics (again: whatever perf does 
> right now). And I think folks want to do this, because adding
> CLOCK_PERF 
> is easier then trying to:
> 
> 1) Get a lock-free method for accessing CLOCK_MONOTONIC_RAW
> 
> 2) Having perf interpolate its timestamps to CLOCK_MONOTONIC, or 
> CLOCKMONOTONIC_RAW when it exports the data

Mostly cheaper, not easier. Given unstable TSC, MONOTONIC will have to
fall back to another clock source (hpet, acpi_pm and other assorted
crap).

In order to avoid this, we'd had to relax the requirements. Using
anything other than TSC is simply not an option.

