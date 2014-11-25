Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991AbaKYSCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:02:08 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:40544 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaKYSCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:02:05 -0500
Date: Tue, 25 Nov 2014 10:01:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jiri Kosina <jkosina@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: (bisected) Lock up on sh73a0/kzm9g on cpuidle initialization
Message-ID: <20141125180159.GI5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAMuHMdXaaa2t6+sH2egGacVxkAPeTUkAgwdYsOnMnEPnuLdB5Q@mail.gmail.com>
 <545BE1DE.6060900@linaro.org>
 <CAMuHMdXQr65g4He0D0ZRN923OJ2A7WNgwbiTru_1dGWnvbvCJA@mail.gmail.com>
 <CAMuHMdUjYMC8i2F9n6fWdPBOQVSohKA3ZxJJyq8h808Z9tEypw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUjYMC8i2F9n6fWdPBOQVSohKA3ZxJJyq8h808Z9tEypw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112518-0009-0000-0000-0000069A82E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 06:49:16PM +0100, Geert Uytterhoeven wrote:
> On Fri, Nov 7, 2014 at 8:59 AM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Thu, Nov 6, 2014 at 10:02 PM, Daniel Lezcano
> > <daniel.lezcano@linaro.org> wrote:
> >> On 11/06/2014 09:38 PM, Geert Uytterhoeven wrote:
> >>> When CONFIG_CPU_IDLE=y, the kernel locks up during cpuidle initialization
> >>> on Renesas sh73a0/kzm9g-reference, which has a dual-core Cortex-A9.
> >>>
> >>> Last message is:
> >>>
> >>>      DMA: preallocated 256 KiB pool for atomic coherent allocations
> >>>
> >>> After this it's supposed to print:
> >>>
> >>>      cpuidle: using governor ladder
> >>>      cpuidle: using governor menu
> >>>
> >>> I've bisected this to commit 442bf3aaf55a91ebfec71da46a4ee10a3c905bcc
> >>> ("sched: Let the scheduler see CPU idle states").
> >>>
> >>> Reverting that commit, and commit 83a0a96a5f26d974580fd7251043ff70c8f1823d
> >>> ("sched/fair: Leverage the idle state info when choosing the "idlest"
> >>> cpu") which
> >>> depends on it, fixes the problem.
> >>>
> >>> I saw the discussion "lockdep splat in CPU hotplug", so I enabled lockdep
> >>> debugging, but didn't see a lockdep splat.
> >>
> >> Did you try the fix attached ?
> >>
> >> https://lkml.org/lkml/2014/10/22/722
> >
> > Thanks, I didn't try that.
> >
> > However, this patch seems to be in v3.18-rc3, so I'm already using it.
> > Hence it doesn't fix the problem for me.
> >
> > On another board, with a dual Cortex-A15, the problem doesn't show up.
> 
> This problem (regression introduced in v3.18-rc1) is still present in v3.18-rc6.
> 
> I did some more investigations, and it's hanging in the call to
> synchronize_rcu() in cpuidle_uninstall_idle_handler(), which was added in
> commit 442bf3aaf55a91ebfec71da46a4ee10a3c905bcc.
> More specificailly, it's blocked on the wait_for_completion(&rcu.completion)
> in kernel/rcu/update.c:void wait_rcu_gp(call_rcu_func_t crf).

You didn't disable RCU CPU stall warnings, did you?  If you did, please
re-enable them, as the stall warning messages will likely help to debug
this.  The soft-lockup checks can also be quite valuable.

If you haven't run with CONFIG_PROVE_RCU=y, please try that.  For example,
if you have CONFIG_PREEMPT=y and you do synchronize_rcu() from within
an RCU read-side critical section (don't do that, it will hang!!!),
then you will get a lockdep splat.

Does any sort of system activity (keyboard, network, etc.) unstick the
system?

If you have tried all those things without good effect, could you please
send along your .config and an alt-sysrq-t dump of all tasks' stacks?

							Thanx, Paul

> Anyone with a clue?
> 
> Thanks again!
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

