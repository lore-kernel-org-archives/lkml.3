Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaGUV5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 17:57:12 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:49899 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaGUV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 17:57:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140721215225.GD11555@pd.tnic>
References: <20140719130602.GA5101@pd.tnic> <53CD6B50.5010404@mit.edu>
 <20140721213534.GB11555@pd.tnic> <CALCETrW91Q=ivYRVFb0WKXgHQO7O+x_HHDy67e90TU6Bte_ecg@mail.gmail.com>
 <20140721215225.GD11555@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 21 Jul 2014 14:56:49 -0700
Message-ID: <CALCETrX1LbZAiPH4x2Uby_cUUj2wgN92wc+5wvf-B3_9XdObWQ@mail.gmail.com>
Subject: Re: [PATCH] x86, TSC: Add a software TSC offset
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 2:52 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jul 21, 2014 at 02:41:50PM -0700, Andy Lutomirski wrote:
>> How will this be compatible with the vdso?
>
> I've never thought about it yet. How compatible would you want it to be
> and what do you expect from it?

I expect that users of __vdso_clock_gettime (e.g. glibc) will get the
correct time :)  They use vread_tsc, and they can't use
preempt_disable, because they're in userspace.  They also can't
directly access per-cpu variables.

Turning off vdso tsc support on these machines would be an option.

>
> Remember, this is only attempting to be a hardware workaround for a
> smallish number of systems out there. Most of current machines should
> have stable and synched TSCs.

I actually own one of these systems.  It's a Sandy Bridge Core-i7
Extreme or something like that.

>
>> Also, IIRC, rdtscp does not need rdtsc_barrier(), whereas rdtsc does.
>> Getting this wrong will be a significant slowdown.
>
> This is too cryptic for me - get_cycles doesn't barrier around the TSC
> now either. Again, we will most likely end up not using RDTSCP anyway.

I wonder if that's a bug in get_cycles.

The basic issue is that rdtsc is not ordered with respect to nearby
loads, so it's fairly easy to see it behaving non-monotonically across
CPUs.  rdtscp is ordered, but it's a little slower.

--Andy
