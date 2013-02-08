Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946678Ab3BHPvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:51:33 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45725 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946654Ab3BHPvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:51:31 -0500
MIME-Version: 1.0
In-Reply-To: <20130207190754.GB25223@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
	<1360205415.2621.60.camel@gandalf.local.home>
	<20130207111025.GD8945@gmail.com>
	<CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
	<20130207190754.GB25223@gmail.com>
Date: Fri, 8 Feb 2013 16:51:29 +0100
Message-ID: <CAFTL4hwKzcNEr8G1h1SErhwxAuQKR3rEX3cxxCyxf_LFHudL0Q@mail.gmail.com>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/7 Ingo Molnar <mingo@kernel.org>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> 2013/2/7 Ingo Molnar <mingo@kernel.org>:
>> >
>> > * Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> >> I'll reply to this as I come up with comments.
>> >>
>> >> First thing is, don't call it NO_HZ_FULL. A better name would
>> >> be NO_HZ_CPU. I would like to reserve NO_HZ_FULL when we
>> >> totally remove jiffies :-)
>> >
>> > I don't think we want yet another config option named in a
>> > weird way.
>> >
>> > What we want instead is to just split NO_HZ up into its
>> > conceptual parts:
>> >
>> >    CONFIG_NO_HZ_IDLE
>>
>> Renaming CONFIG_NO_HZ to CONFIG_NO_HZ_IDLE is something I
>> considered. I was just worried about this option being present
>> in many defconfig.
>
> I don't think renaming it is an option - it's present not just
> in defconfigs, but in various distro configs, etc.
>
> But we can add new config variables and use the existing
> CONFIG_NO_HZ value to set their default values.

Sure.

>> Note on my tree I stop the tick on both rings. I believe that
>> restarting the tick on kernel entry isn't something we should
>> seriously consider. It would be a costly operation that may
>> make things worse. And in fact there is no big difference.
>> Just kernelspace has more opportunities to be disturbed (RCU
>> IPIs, async timer/work scheduled by the kernel, etc...) and
>> get its tick restarted sometimes.
>
> Ok.
>
> Could we just simplify things and make this an unconditional
> option of NO_HZ? Any reason why we'd want to make this
> configurable, other than debugging?
>
> I'm worried about the proliferation of not easily separable
> config options. We already have way too many timer and scheduler
> options to begin with.

Like Steve said, this is for overhead reasons. The syscall uses the
slow path so that's ok. But we add a callback to every exception, irq
entry/exit, scheduler sched switch, signal handling, user and kernel
preemption point. This all could be lowered using static keys but even
that doesn't make me feel comfortable with this idea.

Moreover, for now this is going to be used only on extreme usecases
such as real time and HPC. If we really have to merge this into an
all-in-one nohz kconfig, I suggest we wait for the feature to mature a
bit and prove that it can be useful further those specialized
workloads, and also that we can ensure it's off-case overhead is not
significant.
