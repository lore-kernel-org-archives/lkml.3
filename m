Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab3HMJxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:53:07 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:45262 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3HMJxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:53:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.713
From: Lars Poeschel <poeschel@lemonage.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] RFC: interrupt consistency check for OF GPIO IRQs
Date: Tue, 13 Aug 2013 11:52:52 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "Linux-OMAP" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>
References: <1375101368-17645-1-git-send-email-linus.walleij@linaro.org> <CACxGe6uNJNMdZ1HYGgCtLM2t2TWGCR6btjOHVmP=vDXXvvFfRg@mail.gmail.com> <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com>
In-Reply-To: <CACRpkdYjJL6FZwEbB7XLnb9QtjB=3LeE9Ny6KQ4PkM3zpdNqqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308131152.52648.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 31. Juli 2013, 01:44:53 schrieb Linus Walleij:
> On Tue, Jul 30, 2013 at 6:30 AM, Grant Likely <grant.likely@linaro.org> 
wrote:
> > On Mon, Jul 29, 2013 at 6:36 AM, Linus Walleij 
<linus.walleij@linaro.org> wrote:
> >> To solve this dilemma, perform an interrupt consistency check
> >> when adding a GPIO chip: if the chip is both gpio-controller and
> >> interrupt-controller, walk all children of the device tree,
> >> check if these in turn reference the interrupt-controller, and
> >> if they do, loop over the interrupts used by that child and
> >> perform gpio_reques() and gpio_direction_input() on these,
> >> making them unreachable from the GPIO side.
> > 
> > Ugh, that's pretty awful, and it doesn't actually solve the root
> > problem of the GPIO and IRQ subsystems not cooperating. It's also a
> > very DT-centric solution even though we're going to see the exact same
> > issue on ACPI machines.
> 
> The problem is that the patches for OMAP that I applied
> and now have had to revert solves it in an even uglier way,
> leading to breaking boards, as was noticed.
> 
> The approach in this patch has the potential to actually
> work without regressing a bunch of boards...

I fully agree. I spent many time understanding the problem and reading 
mails to see what happend so far. This is by far the best way to solve the 
problem that was proposed until now. I support that approach.
 
> Whether this is a problem in ACPI or not remains to be seen,
> but I'm not sure about that. Device trees allows for a GPIO line
> to be used as an interrupt source and GPIO line orthogonally,
> and that is the root of this problem. Does ACPI have the same
> problem, or does it impose natural restrictions on such use
> cases?

Is requesting GPIOs directly common in the ACPI world? Does ACPI allow to 
use GPIOs for interrupts?
And even if ACPI had the same problems than device tree, finding a common 
solution seems very difficult to me.
I also prefer Linus' way here. This can be fixes in gpiolib for the device 
tree path and this is ok.

> > We have to solve the problem in a better way than that.

Linus asked for real solutions more than once. Can anybody propose a better 
way ?

> >> This has the following undesired effects:
> >> 
> >> - The GPIOlib subsystem is not aware that the line is in use
> >> 
> >>   and willingly lets some other consumer perform gpio_request()
> >>   on it, leading to a complex resource conflict if it occurs.
> > 
> > If a gpio line is being both requested as a gpio and used as an
> > interrupt line, then either a) it's a bug, or b) the gpio line needs
> > to be used as input only so it is compatible with irq usage. b) should
> > be supportable.
> 
> Yes this is what I'm saying too I think...
> 
> The bug in (a) manifested itself in the OMAP patch with
> no real solution in sight.
> 
> >> - The GPIO debugfs file claims this GPIO line is "free".
> > 
> > Surely we can fix this. I still don't see a problem of having the
> > controller request the gpio when it is claimed as an irq if we can get
> > around the problem of another user performing a /valid/ request on the
> > same GPIO line. The solution may be to have a special form of request
> > or flag that allows it to be shared.
> 
> I don't see how sharing works here, or how another user,
> i.e. another one than the user wanting to recieve the IRQ,
> can validly request such a line? What would the usecase for
> that valid request be?

I also don't see the usecase for that. Sure, that can be done, but it is of 
no use. If it shows, that someone really needs this, it can be implemented 
later.

> Basically I believe these two things need to be exclusive in
> the DT world:
> 
> A: request_irq(a resource passed from "interrupts");
>      -> core implicitly performs gpio_request()
>          gpio_direction_input()
> 
> B: gpio_request(a resource passed from "gpios");
>      gpio_direction_input()
>      request_irq(gpio_to_irq())
> 
> Never both. And IIUC that was what happened in the
> OMAP case.

ACK.
 
> >> - The line direction of the interrupt GPIO line is not
> >> 
> >>   explicitly set as input, even though it is obvious that such
> >>   a line need to be set up in this way, often making the system
> >>   depend on boot-on defaults for this kind of settings.
> > 
> > Should also be solvable if the gpio request problem is solved.
> 
> Agreed...

To push the discussion a bit further, I took Linus patch and extended it so 
that it can be tested now on real world hardware. I tested it on my device 
tree enabled board and it works fine here. Refer to [1], [2] for version 2 
of the patch.
It completely scans the device tree for interrupt-controller users of the 
gpio_chip in question. It requests the needed gpios and sets them as input.
If the gpio_chip is removed, it also frees the gpio lines.
Folks please help testing!

Thanks,
Lars

[1] http://marc.info/?l=linux-kernel&m=137638745909335&w=2
[2] https://patchwork.kernel.org/patch/2843525/
