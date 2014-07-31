Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaGaWGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:06:48 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:49385 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGaWGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:06:47 -0400
Date: Thu, 31 Jul 2014 15:06:42 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Herring <robherring2@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Matt Porter <mporter@linaro.org>, Marc Carino <marc.ceeeee@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 01/11] ARM: brcmstb: add infrastructure for ARM-based
 Broadcom STB SoCs
Message-ID: <20140731220642.GQ3711@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
 <1405976886-27807-2-git-send-email-computersforpeace@gmail.com>
 <CAL_Jsq+Nbk7m9KXhG+Chdpvurp75RrvhFR2oE_LGxV444GSe9Q@mail.gmail.com>
 <20140731022320.GM3711@ld-irv-0074>
 <20140731084315.GJ30282@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731084315.GJ30282@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Thu, Jul 31, 2014 at 09:43:15AM +0100, Russell King wrote:
> On Wed, Jul 30, 2014 at 07:23:20PM -0700, Brian Norris wrote:
> > I appreciate your comments, but where were many of these 5 months ago on
> > the first 7 revisions? :)
> > 
> > On a practical note: v9 is already queued for 3.17. Should I send
> > patches for the 3.17 cycle (or later) to fixup some of these issues? Or
> > would you recommend pulling the patches out of Matt Porter's tree now,
> > and reintroducing for 3.18? (I would be much happier with the first.)
> > 
> > I do note that we at least need to fix allmodconfig ASAP; I'll reply to
> > Russell on that one.
> > 
> > On Wed, Jul 30, 2014 at 12:09:48PM -0500, Rob Herring wrote:
> > > On Mon, Jul 21, 2014 at 4:07 PM, Brian Norris <computersforpeace@gmail.com> wrote:
> > > > +
> > > > +       per_cpu_sw_state_wr(cpu, 1);
> > > 
> > > The kernel already tracks the state.
> > 
> > Yes, but it doesn't synchronize cpu_die() and cpu_kill(). But I see you
> > objected below.
> 
> Err.
> 
> static DECLARE_COMPLETION(cpu_died);

Yes, I noticed this. What I meant is that smp_ops.cpu_die() and
smp_ops.cpu_kill() are not synchronized.

> /*
>  * called on the thread which is asking for a CPU to be shutdown -
>  * waits until shutdown has completed, or it is timed out.
>  */
> void __cpu_die(unsigned int cpu)
> {
>         if (!wait_for_completion_timeout(&cpu_died, msecs_to_jiffies(5000))) {
>                 pr_err("CPU%u: cpu didn't die\n", cpu);
>                 return;
>         }
>         printk(KERN_NOTICE "CPU%u: shutdown\n", cpu);
> ...
>         if (!platform_cpu_kill(cpu))
>                 printk("CPU%u: unable to kill\n", cpu);
> }
> 
> void __ref cpu_die(void)
> {
> ...
>         /*
>          * Tell __cpu_die() that this CPU is now safe to dispose of.  Once
>          * this returns, power and/or clocks can be removed at any point
>          * from this CPU and its cache by platform_cpu_kill().
>          */
>         complete(&cpu_died);
> 
> There _is_ synchronisation between these two.  Your cpu_kill() function
> will not be called until we have flushed all data from the dying CPU's
> cache.  That's the best we can do, because if we cause the dying CPU to
> exit the coherency domain, any kind of locking or completion will no
> longer work (neither will your state tracking solution because the L1
> caches will no longer snoop.)

We're not relying on the L1 cache, though. Don't sync_cache_{r,w}()
ensure all reads/writes reach at least the L2?

Besides, we modeled this after the MCPM code (e.g., __mcpm_cpu_down()).
Are both implementations incorrect?

> > Hmm, I'm pretty sure the synchronization is required for our B15 core.
> > If we yank the power before the core has properly quiesced, the whole
> > CPU complex will lock up. (Similar story for the power-up while loop you
> > complained about above.)
> 
> If you need to ensure that the power isn't turned off too soon, how about
> using a delayed work queue to do the power-off of the CPU (remembering to
> cancel the delayed work queue when powering the CPU back up.)

How does that ensure that the CPU is down by the time the work is
scheduled? It seems like this would just defer the work long enough that
it *most likely* has quiesced, but I don't see how this gives us a
better guarantee. Or maybe I'm missing something. (If so, please do
enlighten!)

Brian
