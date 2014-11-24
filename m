Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaKXXwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:52:34 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:45125 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbaKXXwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:52:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141124235058.GZ5050@linux.vnet.ibm.com>
References: <20141122234157.GB5050@linux.vnet.ibm.com> <CALCETrVzeK=VWnAhpkPhxj9C012ETgArEPmLMFfhKJ7k1pHsXA@mail.gmail.com>
 <20141124205441.GW5050@linux.vnet.ibm.com> <CALCETrXBofV3oxDwK4MiSvFQcX3yxX_sL_KY63EZ8DgS8LnJSg@mail.gmail.com>
 <20141124213501.GX5050@linux.vnet.ibm.com> <20141124223407.GB8512@linux.vnet.ibm.com>
 <CALCETrUA+z5z6bnOw63-EUiFD4WQtBXm1TE2DSRj3uG+d_k-bQ@mail.gmail.com>
 <20141124225754.GY5050@linux.vnet.ibm.com> <20141124233101.GA2819@linux.vnet.ibm.com>
 <CALCETrV37kqC658AzBHZ5z_vH2b_1T821q5EfbMcS9Ecpj8EEw@mail.gmail.com> <20141124235058.GZ5050@linux.vnet.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 24 Nov 2014 15:52:10 -0800
Message-ID: <CALCETrUFwyBYFWZi4JC1-HftmUumLr+bB1kh8EW6LViN+G+j+g@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] x86, traps: Track entry into and exit from IST context
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Josh Triplett <josh@joshtriplett.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 3:50 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Nov 24, 2014 at 03:35:55PM -0800, Andy Lutomirski wrote:
>> On Mon, Nov 24, 2014 at 3:31 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Mon, Nov 24, 2014 at 02:57:54PM -0800, Paul E. McKenney wrote:
>> >> On Mon, Nov 24, 2014 at 02:36:18PM -0800, Andy Lutomirski wrote:
>> >> > On Mon, Nov 24, 2014 at 2:34 PM, Paul E. McKenney
>> >> > <paulmck@linux.vnet.ibm.com> wrote:
>> >> > > On Mon, Nov 24, 2014 at 01:35:01PM -0800, Paul E. McKenney wrote:
>> >>
>> >> [ . . . ]
>> >>
>> >> > > And the following Promela model claims that your approach works.
>> >> > > Should I trust it?  ;-)
>> >> > >
>> >> >
>> >> > I think so.
>> >> >
>> >> > Want to write a patch?  If so, whose tree should it go in?  I can add
>> >> > it to my IST series, but that seems a bit odd.
>> >>
>> >> Working on it.  ;-)
>> >
>> > And here is a sneak preview of the patch.  Thoughts?
>> >
>> >                                                         Thanx, Paul
>> >
>> > ------------------------------------------------------------------------
>> >
>> > rcu: Make rcu_nmi_enter() handle nesting
>> >
>> > Andy Lutomirski is introducing ISTs into x86, which from RCU's
>> > viewpoint are NMIs.  Because ISTs and NMIs can nest, rcu_nmi_enter() and
>> > rcu_nmi_exit() must now correctly handle nesting.
>>
>> You must not be a frequent reader of entry_64.S and the Intel SDM :)
>> IOW, IST is just a stack switching mechanism, and these interrupts
>> have been around forever -- they're just buggy right now.
>>
>> How about:
>>
>> x86 has multiple types of NMI-like interrupts: real NMIs, machine
>> checks, and, for some values of NMI-like, debugging and breakpoint
>> interrupts.  These interrupts can nest inside each other.  Andy
>> Lutomirski is adding RCU support to these interrupts, so
>> rcu_nmi_enter() and rcu_nmi_exit() must now correctly handle nesting.
>>
>> Other than that, I like it.
>
> And here is the updated version.  Left to my normal workflow, this would
> go into 3.20.  Please let me know if you need it earlier, but in that
> case, I will need you to test it fairly soon.  (I don't have any way
> to test nested NMI-like things.)

Dunno.  Tony and Borislav -- when do you want the IST stack switching stuff?

--Andy

>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
> rcu: Make rcu_nmi_enter() handle nesting
>
> The x86 architecture has multiple types of NMI-like interrupts: real
> NMIs, machine checks, and, for some values of NMI-like, debugging
> and breakpoint interrupts.  These interrupts can nest inside each
> other.  Andy Lutomirski is adding RCU support to these interrupts,
> so rcu_nmi_enter() and rcu_nmi_exit() must now correctly handle nesting.
>
> This commit therefore introduces nesting, using a clever NMI-coordination
> algorithm suggested by Andy.  The trick is to atomically increment
> ->dynticks (if needed) before manipulating ->dynticks_nmi_nesting on entry
> (and, accordingly, after on exit).  In addition, ->dynticks_nmi_nesting
> is incremented by one if ->dynticks was incremented and by two otherwise.
> This means that when rcu_nmi_exit() sees ->dynticks_nmi_nesting equal
> to one, it knows that ->dynticks must be atomically incremented.
>
> This NMI-coordination algorithms has been validated by the following
> Promela model, for whatever that might be worth:
>
> /*
>  * Promela model for Andy Lutomirski's suggested change to rcu_nmi_enter()
>  * that allows nesting.
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation; either version 2 of the License, or
>  * (at your option) any later version.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License for more details.
>  *
>  * You should have received a copy of the GNU General Public License
>  * along with this program; if not, you can access it online at
>  * http://www.gnu.org/licenses/gpl-2.0.html.
>  *
>  * Copyright IBM Corporation, 2014
>  *
>  * Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>  */
>
> byte dynticks_nesting = 0;
> byte dynticks_nmi_nesting = 0;
> byte dynticks = 0;
>
> /*
>  * Promela verision of rcu_nmi_enter().
>  */
> inline rcu_nmi_enter()
> {
>         byte incby;
>
>         incby = 2;
>         assert(dynticks_nmi_nesting >= 0);
>         if
>         :: (dynticks & 1) == 0 ->
>                 atomic {
>                         dynticks = dynticks + 1;
>                 }
>                 assert((dynticks & 1) == 1);
>                 incby = 1;
>         :: else ->
>                 skip;
>         fi;
>         dynticks_nmi_nesting = dynticks_nmi_nesting + incby;
>         assert(dynticks_nmi_nesting >= 1);
> }
>
> /*
>  * Promela verision of rcu_nmi_exit().
>  */
> inline rcu_nmi_exit()
> {
>         assert(dynticks_nmi_nesting > 0);
>         assert((dynticks & 1) != 0);
>         if
>         :: dynticks_nmi_nesting != 1 ->
>                 dynticks_nmi_nesting = dynticks_nmi_nesting - 2;
>         :: else ->
>                 dynticks_nmi_nesting = 0;
>                 atomic {
>                         dynticks = dynticks + 1;
>                 }
>                 assert((dynticks & 1) == 0);
>         fi;
> }
>
> /*
>  * Base-level NMI runs non-atomically.  Crudely emulates process-level
>  * dynticks-idle entry/exit.
>  */
> proctype base_NMI()
> {
>         byte busy;
>
>         busy = 0;
>         do
>         ::      if
>                 :: 1 -> atomic {
>                                 dynticks = dynticks + 1;
>                         }
>                         busy = 0;
>                 :: 1 -> skip;
>                 fi;
>                 rcu_nmi_enter();
>                 assert((dynticks & 1) == 1);
>                 rcu_nmi_exit();
>                 if
>                 :: busy -> skip;
>                 :: !busy ->
>                         atomic {
>                                 dynticks = dynticks + 1;
>                         }
>                         busy = 1;
>                 fi;
>         od;
> }
>
> /*
>  * Nested NMI runs atomically to emulate interrupting base_level().
>  */
> proctype nested_NMI()
> {
>         do
>         ::      atomic {
>                         rcu_nmi_enter();
>                         assert((dynticks & 1) == 1);
>                         rcu_nmi_exit();
>                 }
>         od;
> }
>
> init {
>         run base_NMI();
>         run nested_NMI();
> }
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index 8749f43f3f05..fc0236992655 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -759,39 +759,71 @@ void rcu_irq_enter(void)
>  /**
>   * rcu_nmi_enter - inform RCU of entry to NMI context
>   *
> - * If the CPU was idle with dynamic ticks active, and there is no
> - * irq handler running, this updates rdtp->dynticks_nmi to let the
> - * RCU grace-period handling know that the CPU is active.
> + * If the CPU was idle from RCU's viewpoint, update rdtp->dynticks and
> + * rdtp->dynticks_nmi_nesting to let the RCU grace-period handling know
> + * that the CPU is active.  This implementation permits nested NMIs, as
> + * long as the nesting level does not overflow an int.  (You will probably
> + * run out of stack space first.)
>   */
>  void rcu_nmi_enter(void)
>  {
>         struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
> +       int incby = 2;
>
> -       if (rdtp->dynticks_nmi_nesting == 0 &&
> -           (atomic_read(&rdtp->dynticks) & 0x1))
> -               return;
> -       rdtp->dynticks_nmi_nesting++;
> -       smp_mb__before_atomic();  /* Force delay from prior write. */
> -       atomic_inc(&rdtp->dynticks);
> -       /* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
> -       smp_mb__after_atomic();  /* See above. */
> -       WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
> +       /* Complain about underflow. */
> +       WARN_ON_ONCE(rdtp->dynticks_nmi_nesting < 0);
> +
> +       /*
> +        * If idle from RCU viewpoint, atomically increment ->dynticks
> +        * to mark non-idle and increment ->dynticks_nmi_nesting by one.
> +        * Otherwise, increment ->dynticks_nmi_nesting by two.  This means
> +        * if ->dynticks_nmi_nesting is equal to one, we are guaranteed
> +        * to be in the outermost NMI handler that interrupted an RCU-idle
> +        * period (observation due to Andy Lutomirski).
> +        */
> +       if (!(atomic_read(&rdtp->dynticks) & 0x1)) {
> +               smp_mb__before_atomic();  /* Force delay from prior write. */
> +               atomic_inc(&rdtp->dynticks);
> +               /* atomic_inc() before later RCU read-side crit sects */
> +               smp_mb__after_atomic();  /* See above. */
> +               WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
> +               incby = 1;
> +       }
> +       rdtp->dynticks_nmi_nesting += incby;
> +       barrier();
>  }
>
>  /**
>   * rcu_nmi_exit - inform RCU of exit from NMI context
>   *
> - * If the CPU was idle with dynamic ticks active, and there is no
> - * irq handler running, this updates rdtp->dynticks_nmi to let the
> - * RCU grace-period handling know that the CPU is no longer active.
> + * If we are returning from the outermost NMI handler that interrupted an
> + * RCU-idle period, update rdtp->dynticks and rdtp->dynticks_nmi_nesting
> + * to let the RCU grace-period handling know that the CPU is back to
> + * being RCU-idle.
>   */
>  void rcu_nmi_exit(void)
>  {
>         struct rcu_dynticks *rdtp = this_cpu_ptr(&rcu_dynticks);
>
> -       if (rdtp->dynticks_nmi_nesting == 0 ||
> -           --rdtp->dynticks_nmi_nesting != 0)
> +       /*
> +        * Check for ->dynticks_nmi_nesting underflow and bad ->dynticks.
> +        * (We are exiting an NMI handler, so RCU better be paying attention
> +        * to us!)
> +        */
> +       WARN_ON_ONCE(rdtp->dynticks_nmi_nesting <= 0);
> +       WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1));
> +
> +       /*
> +        * If the nesting level is not 1, the CPU wasn't RCU-idle, so
> +        * leave it in non-RCU-idle state.
> +        */
> +       if (rdtp->dynticks_nmi_nesting != 1) {
> +               rdtp->dynticks_nmi_nesting -= 2;
>                 return;
> +       }
> +
> +       /* This NMI interrupted an RCU-idle CPU, restore RCU-idleness. */
> +       rdtp->dynticks_nmi_nesting = 0;
>         /* CPUs seeing atomic_inc() must see prior RCU read-side crit sects */
>         smp_mb__before_atomic();  /* See above. */
>         atomic_inc(&rdtp->dynticks);
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
