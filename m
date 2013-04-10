Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205Ab3DJQBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:01:07 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:62322 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab3DJQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:01:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130408111919.GB1225@gmail.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
	<20130408111919.GB1225@gmail.com>
Date: Wed, 10 Apr 2013 18:01:02 +0200
Message-ID: <CAFTL4hxDGfEWPz0+zsHLmdaPDSg4n0iFHpeN=w=5eFGX9sRZ2w@mail.gmail.com>
Subject: Re: [RFC GIT PULL] nohz: Kconfig layout improvements
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/8 Ingo Molnar <mingo@kernel.org>:
> I pulled it into tip:timers/nohz and will push it out if it passes testing because
> I like the improvements - but there's still a few things missing I think.
>
> Firstly, I performed this "how are users exposed to this new feature" test:
>
>    git checkout v3.9-rc6
>    make defconfig
>    git checkout tip/master
>    make oldconfig
>
> the x86 (64-bit) defconfig has NO_HZ enabled. When I did the 'make oldconfig', I
> was given:
>
>   *
>   * Timers subsystem
>   *
>   Timer tick handling
>   > 1. Periodic timer ticks (constant rate, no dynticks) (PERIODIC_HZ) (NEW)
>     2. Idle dynticks system (tickless idle) (NO_HZ_IDLE) (NEW)
>   choice[1-2]:
>
> [ Firstly, while at it: that should be 'Timer subsystem' or 'Timers'. ]

Isn't "Timers" too general? I really don't mind changing that though.

>
> More importantly, the new Kconfig behavior is still not quite right for two
> reasons:
>
> 1)
>
> the default is not set to NO_HZ_IDLE. The oldconfig .config had
> CONFIG_NO_HZ set - this should be grandfathered over into the new config's
> default choice. That can probably be done by still keeping CONFIG_NO_HZ as
> a migration helper entry.

Ah I did keep it for backward compatibility. We default to
CONFIG_NO_HZ_IDLE if CONFIG_NO_HZ is set. This is just not working
because CONFIG_NO_HZ isn't visible. It's an arbirtrary Kconfig
limitation. I'll just make it visible by adding it a title text and
this will work.

> 2)
>
> there's still no extended idle tick option offered - due to it not meeting
> the CONFIG_VIRT_CPU_ACCOUNTING_GEN dependency.
>
> Even if I read the Kconfig rules and figure out the dependency, I have to
> perform _two_ steps to get extended ticks:
>
> I had to manually find CONFIG_VIRT_CPU_ACCOUNTING_GEN in the .config and
> delete it, so that I'm given the choice on the next 'make oldconfig'.
>
> Then NO_HZ_EXTENDED was set to disabled in the .config silently, because
> NO_HZ_IDLE was already set. So I had to delete that and re-configure it
> again.

Agreed. I mentioned that in the pull request. It's again due to an
arbitrary Kconfig limitation. The following:

    config X
        select Y

doesn't work if Y is part of a Kconfig "choice".
I have a patch that fixes in Kconfig, will submit it to Michal and fix
the nohz passive dependency once we get that sorted.


>
> Highly inconvenient.
>
> -----------------------
>
> Once the dependencies are right I like it how then we get offered the 3 variants:
>
>  *
>  * Timers subsystem
>  *
>  Timer tick handling
>  > 1. Periodic timer ticks (constant rate, no dynticks) (PERIODIC_HZ) (NEW)
>    2. Idle dynticks system (tickless idle) (NO_HZ_IDLE) (NEW)
>    3. Full dynticks system (tickless single task) (NO_HZ_EXTENDED) (NEW)
>
> and I think that is how it should always look like, for standard .config's, pretty
> much regardless of how other things are configured - as long as the architecture
> supports extended dynticks.
>
> So I'd suggest the following changes to fix the remaining usability problems:
>
>  - .config compatibility fix: the default selection should pick up existing
>    CONFIG_NO_HZ settings, for a kernel release cycle, so that people whole just go
>    through 'make oldconfig' and rely on the defaults don't lose CONFIG_NO_HZ_IDLE.
>
>    This can probably be done by adding a CONFIG_NO_HZ Kconfig entry, and
>    documenting it as a migration helper. This can then be removed in v3.11. The
>    multiple choices entry can then use CONFIG_NO_HZ to set its default offering to
>    CONFIG_NO_HZ_IDLE or CONFIG_PERIODIC_HZ?

Ok I just need to make that Kconfig symbol visible. I guess we can
indeed remove it in the future.

>
>  - CONFIG_VIRT_CPU_ACCOUNTING_GEN should be selected as well. (Maybe even the RCU
>    model.)

So, will deal with that in the Kconfig side :)

>
>  - Nit: the 'depends on SMP' part looks a bit weird. Is that a quirk?

It's a dependency inherited from CONFIG_RCU_USER_QS. But it's also
necessary because we need a timekeeping CPU. I'll add a comment on
that.

>
>  - Plus a minor help text nit: I'd not call it 'tickless single task' - but
>    'tickless'. When there are multiple tasks on a CPU then it's natural that
>    there's a scheduler tick arbitrating between them - this can be mentioned in
>    the help text, but otherwise should not distract from the 'full dynticks'
>    notion.
>
>    It's not even always about a single task: when there's multiple SCHED_FIFO
>    tasks running, then the scheduler tick is expected to be off, even if there are
>    2 or more SCHED_FIFO tasks on that runqueue, right?

Yeah agreed.

>
>  - Could we rename NO_HZ_EXTENDED to NO_HZ_FULL? :-) I think it's important to
>    stress that in this mode the kernel does whatever it can to keep the tick off:
>
>
>      CONFIG_HZ_PERIODIC          # (no dynticks,      periodic ticks)
>      CONFIG_NO_HZ_IDLE           # (partial dynticks, tick is off in idle only)
>      CONFIG_NO_HZ_FULL           # (full dynticks,    tick is off whenever possible)
>
>    while 'extended' is too vague, it really does not tell us anything about how
>    it's meant to be 'extended'.

Sounds good :)  I too prefer the "_FULL" based naming.

>
>    ( And I'd also suggest renaming CONFIG_PERIODIC_HZ -> CONFIG_HZ_PERIODIC, to be
>      consistent with the NO_HZ_IDLE, NO_HZ_FULL Polish notation naming pattern. )

Ok.

>
> I'm so nitpicky because the Kconfig logic of major kernel features has the
> potential to cause quite a bit of user and tester confusion, so we have to try to
> do our utmost best to structure it in the most logical and approachable fashion.

Agreed, I'm looking at these issues, thanks!
