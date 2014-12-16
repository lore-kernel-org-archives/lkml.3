Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaLPJHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:07:25 -0500
Received: from down.free-electrons.com ([37.187.137.238]:33766 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750885AbaLPJHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:07:19 -0500
Date: Tue, 16 Dec 2014 10:07:15 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Mike Turquette <mturquette@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] ARM: at91: fix irq_pm_install_action WARNING
Message-ID: <20141216100715.57baeb65@bbrezillon>
In-Reply-To: <3542278.8lcJeXLMFm@vostro.rjw.lan>
References: <1418660152-17185-1-git-send-email-boris.brezillon@free-electrons.com>
	<2662748.NJbkr6jW7r@vostro.rjw.lan>
	<3542278.8lcJeXLMFm@vostro.rjw.lan>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Mon, 15 Dec 2014 23:48:14 +0100
"Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:

> On Monday, December 15, 2014 11:20:17 PM Rafael J. Wysocki wrote:
> > On Monday, December 15, 2014 05:15:47 PM Boris Brezillon wrote:
> > > Commit cab303be91dc47942bc25de33dc1140123540800 [1] introduced a WARN_ON
> > > test which triggers a WARNING backtrace on at91 platforms.
> > 
> > Pretty much as intended.

Yep. BTW did you have other platforms/drivers in mind when proposing
this patch, or were you just trying to identify the offending ones ?

> > 
> > > While this WARN_ON is absolutely necessary to warn users that they should
> > > not mix request with and without IRQF_NO_SUSPEND flags on shared IRQs,
> > > there is no easy way to solve this issue on at91 platforms.
> > > 
> > > The main reason is that the init timer is often using a shared irq line
> > > and thus request this irq with IRQF_NO_SUSPEND flag set, while other
> > > peripherals request the same irq line without this flag.
> > > 
> > > We could deal with that by identifying whether a given peripheral is
> > > connected to the init timer shared irq line and add the IRQF_NO_SUSPEND
> > > in this case, but this implies adding the logic in all peripheral drivers
> > > that could be connected to this shared irq.
> > > 
> > > This series takes the reverse approach: force IRQ users to specify that
> > > they take care of disabling peripheral interrupts and that IRQ core can
> > > safely leave the handler in a suspended state without having to bother
> > > about spurious interrupts.
> > > This is done by mean of a new IRQF_SUSPEND_NOACTION flag which tells the
> > > core to move the action handler to a suspended list, thus preventing its
> > > execution when we are in suspend mode.
> > > Of course, specifying the IRQF_SUSPEND_NOACTION flag implies taking care
> > > of masking/unmasking the peripheral interrupts in the suspend/resume
> > > implementation.
> > 
> > Well, I'm not sure how much value is in all that to be honest.  The only
> > thing it helps with is to make the WARN_ON go away in some cases, while
> > the drivers in question need to make sure that they disable their interrupts
> > properly anyway, so what exactly is the purpose of the new irqaction
> > shuffling?
> > 
> > It might just be simpler to add a flag to suppress the WARN_ON that would be
> > set by the user of IRQF_NO_SUSPEND that is broken enough to have to share the
> > interrupt with others ...
> 
> Or even set IRFQ_NO_SUSPEND for all of the users of this interrupt and add
> comments to them explaining why it is set.
> 
> 

Maybe I should have sent this series as a RFC, anyway, I'm not trying
to make existing code more complicated just for fun, and I'm open to
any suggestion.

Actually I thought about adding a new flag (let's call it
IRQF_DONT_COMPLAIN for now ;-)) to remove those warnings (or specifying
IRFQ_NO_SUSPEND in all peripherals sharing the IRQ with the init
timer), but after discussing the problem with Thomas I decided to go
for the approach described in my cover letter.

Thomas, correct me if I'm wrong, but your concern about the
IRQF_DONT_COMPLAIN approach was that it was leaving interrupt handlers
of suspended devices in an active state (meaning that they could be
called in "suspend" or "early resume" state), and such devices might
not properly handle interrupts while being in a suspended state (clocks
and regulators disabled).
In at91 specific case this should not be an issue thought.

We have the same problem when setting IRFQ_NO_SUSPEND on all peripherals
sharing the IRQ with the init timer.
Moreover, I'd like to keep the core automatically disabling the IRQ when
the PMC, RTC, watchdog or DBGU (UART) peripherals have their own
dedicated IRQ (which is the case on Atmel sama5 SoCs).
This implies testing for the SoC version in each of these drivers and
adapting the request_irq call accordingly.

Thomas, Rafael, if both of you think I should either introduce a new
flag or specify IRFQ_NO_SUSPEND in all shared IRQ users, then I can go
for one of this solution.

BTW, have you heard about other platforms/drivers impacted by this
WARN_ON addition, and if so how did they solve the problem ?

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
