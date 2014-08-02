Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbaHBJ2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 05:28:12 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33388 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752967AbaHBJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 05:28:08 -0400
Date: Sat, 2 Aug 2014 10:27:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Brian Norris <computersforpeace@gmail.com>
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
Subject: Re: [PATCH v8 01/11] ARM: brcmstb: add infrastructure for
	ARM-based Broadcom STB SoCs
Message-ID: <20140802092756.GZ30282@n2100.arm.linux.org.uk>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com> <1405976886-27807-2-git-send-email-computersforpeace@gmail.com> <CAL_Jsq+Nbk7m9KXhG+Chdpvurp75RrvhFR2oE_LGxV444GSe9Q@mail.gmail.com> <20140731022320.GM3711@ld-irv-0074> <20140731084315.GJ30282@n2100.arm.linux.org.uk> <20140731220642.GQ3711@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731220642.GQ3711@ld-irv-0074>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 03:06:42PM -0700, Brian Norris wrote:
> Hi Russell,
> 
> Yes, I noticed this. What I meant is that smp_ops.cpu_die() and
> smp_ops.cpu_kill() are not synchronized.
...
> We're not relying on the L1 cache, though. Don't sync_cache_{r,w}()
> ensure all reads/writes reach at least the L2?

What exactly are you trying to achieve here?

> How does that ensure that the CPU is down by the time the work is
> scheduled? It seems like this would just defer the work long enough that
> it *most likely* has quiesced, but I don't see how this gives us a
> better guarantee. Or maybe I'm missing something. (If so, please do
> enlighten!)

Note that I said a delayed work queue.  The dying CPU runs a predictable
sequence once cpu_die() has been entered - interrupts at the GIC have
been programmed to be routed to other CPUs, interrupts at the CPU are
masked, so the CPU isn't going to be doing anything else except executing
that code path.  So, it's going to be a predictable number of CPU cycles.

That allows you to arrange a delayed workqueue (or a timer) to fire
after a period of time that you can guarantee that the dying CPU has
reached that wfi().

Another point which raises itself in your patch is this:

+       /* Settle-time from Broadcom-internal DVT reference code */
+       udelay(7);

7us looks very precise, but udelay() may not be that precise.  What is
the actual specification?  Does it say "you must wait at least 7us"?

udelay() _may_ return early, especially if it is using the CPU delay
loop to perform the delay - I've explained why this happens previously,
and why it isn't a bug.

If you're using a timer-based delay for udelay() (which you should be
using if you support cpufreq) then the delay should be more accurate,
but it's still good practise to give a little leeway on the figure.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
