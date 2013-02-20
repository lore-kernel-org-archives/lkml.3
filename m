Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876Ab3BTPoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:44:30 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:62770 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832Ab3BTPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:44:26 -0500
MIME-Version: 1.0
In-Reply-To: <87k3qa7333.fsf@linaro.org>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<87k3qa7333.fsf@linaro.org>
Date: Wed, 20 Feb 2013 16:44:24 +0100
Message-ID: <CAFTL4hzH7avJLAvjBf3Px44s-BRRezTekrdQR4vSUhyFTYXwHA@mail.gmail.com>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/15 Kevin Hilman <khilman@linaro.org>:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
>
>> Ingo,
>>
>> Please pull the new full dynticks cputime accounting code that
>> can be found at:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>>       tags/full-dynticks-cputime-for-mingo
>>
>> My last concern is the dependency on CONFIG_64BIT. We rely on cputime_t
>> being u64 for reasonable nanosec granularity implementation. And therefore
>> we need a single instruction fetch to read kernel cpustat for atomicity
>> requirement against concurrent incrementation, which only 64 bit archs
>> can provide.
>
> Actually, moderately recent 32-bit ARMs can do atomic 64-bit load/stores
> too.

Does gcc automatically handle 64 bit store/loads in one way or does
that require specific CPU instructions?

>
> Also, is it just kernel_cpustat increments that need protection? or do
> the various reads of the task_struct's cputime fields also need
> protection (hmm, thinking twice, maybe those are already sufficiently
> protected by the vtime_seqlock?)

At least the task stats are protected with vtime_seqlock (hopefully I
haven't missed some). But per cpu or global stats are not.

>
>> It's probably no big deal to solve this issue. What we need is simply some
>> atomic accessors.
>
> What about using the atomic64_* accessors?  Those would just use the
> native loads/stores on arches that have them, otherwise
> CONFIG_GENERIC_ATOMIC64 provides some fallbacks.

Yeah may be we can try this.

>
> To give it a try, below is a quick patch to convert kernel_cpustat to
> atomic64.  I only got as far as compile testing and basic boot testing
> on a 32-bit ARM platform, but let me know if this is the right
> direction.

Ok, I'll comment on your second version.

>
>> There is just no emergency though as this new option depends on the context
>> tracking subsystem that only x86-64 (and soon ppc64) implements yet. And
>> this set is complex enough already. I think we can deal with that later.
>
> I've started working on the ARM version of the context_tracker, so
> "later" is coming quickly and I will do what I can to help this along.

Ok. Thanks.
