Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3IWTxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:53:12 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:58268 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab3IWTxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <5230C7F6.3080803@wwwdotorg.org>
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de>
	<52279524.8090006@wwwdotorg.org>
	<20130909161924.GT29403@sirena.org.uk>
	<2052193.CMUEUJFRgS@lem-wkst-02>
	<522F78CB.2020507@wwwdotorg.org>
	<20130910213718.GH29403@sirena.org.uk>
	<522F9E6C.2010905@wwwdotorg.org>
	<522FBED9.9000305@collabora.co.uk>
	<5230C7F6.3080803@wwwdotorg.org>
Date: Mon, 23 Sep 2013 21:53:07 +0200
Message-ID: <CACRpkdacx-e01i_h4cj1qMX2zNOiiDshbTV__wi_LfQrLkrL6g@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Lars Poeschel <poeschel@lemonage.de>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 9:43 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> I believe this situation is exactly what cause the original patch to the
> OMAP driver to be reverted; that patch should have touched the HW
> directly to solve the problem when the IRQ was requested, rather than
> calling into the GPIO subsystem (which also has the side-effect of
> touching the HW in the same way as desired).

And that has the side-effect that this line, which is now set up
in the HW as an input line, can be gpio_request()ed by some other
code path and set up as output, screwing around with the very
same registers.

I think the kernel should prevent such things.

But I think you're making it sound like the kernel should not prevent
such things, but instead give the drivers enough rope to shoot itself
in the foot if it so desires.

But a third solution is possible: the driver keep track of whether
a line is already requested as IRQ and if that happens, will not
allow gpio_set_direction_output() and other incompatible uses,
but still allow gpio_set_direction_input() and gpio_get_value(),
that would be OK.

In the GPIO descriptor we can flag this, so it would be preferable
to have that tracking in the gpiolib core rather than the driver
though.

> As we discussed on IRC (so mainly for the record in the mailing list
> archive), I believe that if a driver wants to use a pin as an interrupt
> and only an interrupt, even if the pin has the capability in HW to be a
> GPIO (or absolutely anything else at all), then the only call in the
> entire kernel (board code, DT core code, IRQ core, driver, ...) should
> be a single request_irq(), and the IRQ chip driver needs to program the
> HW appropriately to make that work.

I agree with this, but also think that the kernel should prevent the
same resource for being used in an incompatible way.

Yours,
Linus Walleij
