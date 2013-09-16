Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902Ab3IPQEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:04:08 -0400
Received: from smtp1-1.goneo.de ([212.90.139.81]:44652 "EHLO smtp1-1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab3IPQEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:04:04 -0400
X-Spam-Flag: NO
X-Spam-Score: -0.968
From: Lars Poeschel <poeschel@lemonage.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Balaji T K <balajitk@ti.com>,
        Tony Lindgren <tony@atomide.com>, Jon Hunter <jgchunter@gmail.com>,
        joelf@ti.com
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
Date: Mon, 16 Sep 2013 18:03:57 +0200
Message-ID: <3653629.tapNZSuWhS@lem-wkst-02>
User-Agent: KMail/4.10.5 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
In-Reply-To: <5230C7F6.3080803@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <522FBED9.9000305@collabora.co.uk> <5230C7F6.3080803@wwwdotorg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 September 2013 13:43:50, Stephen Warren wrote:
> On 09/10/2013 06:52 PM, Javier Martinez Canillas wrote:
> > On 09/11/2013 12:34 AM, Stephen Warren wrote:
> >> On 09/10/2013 03:37 PM, Mark Brown wrote:
> >>> On Tue, Sep 10, 2013 at 01:53:47PM -0600, Stephen Warren wrote:
> >>>> Doesn't this patch call gpio_request() on the GPIO first, and
> >>>> hence prevent the driver's own gpio_request() from succeeding,
> >>>> since the GPIO is already requested? If this is not a problem, it
> >>>> sounds like a bug in gpio_request() not ensuring mutual exclusion
> >>>> for the GPIO.
> >>> 
> >>> Or at the very least something that's likely to break in the
> >>> future.
> >> 
> >> Looking at the GPIO code, it already prevents double-requests:
> >>>         if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
> >>>         
> >>>                 desc_set_label(desc, label ? : "?");
> >>>                 status = 0;
> >>>         
> >>>         } else {
> >>>         
> >>>                 status = -EBUSY;
> >>>                 module_put(chip->owner);
> >>>                 goto done;
> >>>         
> >>>         }
> >> 
> >> And I tested it in practice, and it really does fail.
> > 
> > I'm a bit confused now. Doesn't the fact that gpio_request() prevents
> > double-requests mean that the use-case that you say that have not been
> > covered by this patch can't actually happen?
> > 
> > I mean, if when using board files an explicit call to gpio_request() is
> > made by platform code then a driver can't call gpio_request() for the
> > same gpio. So this patch shouldn't cause any regression since is just
> > auto-requesting a GPIO when is mapped as an IRQ in a DT which basically
> > will be the same that was made by board files before.
> 
> I'm not familiar with the board file path; Linus describe this.

It seems Linus is busy, I'll try to help out.

> It sounds like that path is for the case where a driver /only/ cares
> about using a pin as an IRQ, and hence the driver only calls
> request_irq(). The board file is (earlier) calling gpio_request() in
> order to set up that input pin to work correctly as an IRQ. Hence, there
> is no double-call to gpio_request().

No, a board file is not a path or something. A board file describes the wirings 
and specifics of an (embedded) computer in C code. The complete knowledge of 
how things are connected on a board and which drivers to use is in this piece 
of code. Devicetree replaces legacy board files. These two do pretty much the 
same, but board files have more power, because they are executed and can 
contain whatever code is needed to setup a board.
But you are right, the driver only calls request_irq(), the board file set up 
the pin before and told the driver which irq to use.
 
> The case I said wouldn't work is:
> 
> * This patch calls gpio_request() in order to make the pin work as an IRQ.
> 
> * Driver uses the pin as both a GPIO and an IRQ, and hence calls
> gpio_request() and request_irq().
> 
> So, there's a double-call to gpio_request(), which fails, and the driver
> fails to probe.

Again, no. In that case you don't define your pin as irq in the device tree, 
but only as gpio. The driver knows how to handle gpios and turn them into irqs 
so you have to present it a gpio not an irq. In that case the patch will not 
call gpio_request() and there is no double-call to gpio_request().
 
> I believe this situation is exactly what cause the original patch to the
> OMAP driver to be reverted; that patch should have touched the HW
> directly to solve the problem when the IRQ was requested, rather than
> calling into the GPIO subsystem (which also has the side-effect of
> touching the HW in the same way as desired).

The situation is different. You can try that out. Test your board/driver with 
this patch and test it with the original patch.

> > To give you an example of an use-case that this patch is trying to solve:
> > 
> > OMAP SoCs have a General-Purpose Memory Controller (GPMC) that can be used
> > to interface with Pseudo-SRAM devices such as ethernet controllers. So
> > with board files we currently have this
> > (arch/arm/mach-omap2/gpmc-smsc911x.c): ...
> 
> As we discussed on IRC (so mainly for the record in the mailing list
> archive), I believe that if a driver wants to use a pin as an interrupt
> and only an interrupt, even if the pin has the capability in HW to be a
> GPIO (or absolutely anything else at all), then the only call in the
> entire kernel (board code, DT core code, IRQ core, driver, ...) should
> be a single request_irq(), and the IRQ chip driver needs to program the
> HW appropriately to make that work.

I agree with you that it would be the best if the only call would be 
request_irq and the chip driver programs the HW appropriately. It would be a 
dream, but unfortunately this is not possible at the moment. This is something 
that Linus pointed out very very early in this whole discussion. The gpio and 
irq frameworks don't share any information. The irq framework has no chance to 
program the HW, because it will never find the related gpio.
For this to work the frameworks have to change (and possibly all drivers/board 
files/whatever using request_irq() and/or request_gpio()) have to change.
That is something that I do not dare to do alone.

Regards,
Lars
