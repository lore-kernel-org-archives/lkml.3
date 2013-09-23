Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3IWUM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:12:59 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35448 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3IWUM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:12:57 -0400
Message-ID: <5240A0C2.4010502@wwwdotorg.org>
Date: Mon, 23 Sep 2013 14:12:50 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
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
Subject: Re: [PATCH v3] gpio: interrupt consistency check for OF GPIO IRQs
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk> <2052193.CMUEUJFRgS@lem-wkst-02> <522F78CB.2020507@wwwdotorg.org> <20130910213718.GH29403@sirena.org.uk> <522F9E6C.2010905@wwwdotorg.org> <522FBED9.9000305@collabora.co.uk> <5230C7F6.3080803@wwwdotorg.org> <CACRpkdacx-e01i_h4cj1qMX2zNOiiDshbTV__wi_LfQrLkrL6g@mail.gmail.com>
In-Reply-To: <CACRpkdacx-e01i_h4cj1qMX2zNOiiDshbTV__wi_LfQrLkrL6g@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 01:53 PM, Linus Walleij wrote:
> On Wed, Sep 11, 2013 at 9:43 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> I believe this situation is exactly what cause the original patch to the
>> OMAP driver to be reverted; that patch should have touched the HW
>> directly to solve the problem when the IRQ was requested, rather than
>> calling into the GPIO subsystem (which also has the side-effect of
>> touching the HW in the same way as desired).
> 
> And that has the side-effect that this line, which is now set up
> in the HW as an input line, can be gpio_request()ed by some other
> code path and set up as output, screwing around with the very
> same registers.
> 
> I think the kernel should prevent such things.

It might be nice if it could do that.

However, that is 100% unrelated to the problem at hand.

A driver which only cares about an IRQ should be able to call just IRQ
APIs and have the HW work. Since not all IRQs are GPIOs, the thing that
causes the HW to work should not involve the GPIO subsystem in any way
at all.

So, the first issue - making a correctly configured system functionally
work without resorting to hacks such as requesting a GPIO to make an IRQ
work, is one thing. This issue should be solved purely inside the
specific HW driver.

Having the kernel detect when two different drivers both request the
same resource is entirely another thing. The solution to the first issue
must not rely on any solution to this second issue.

I'm also not convinced it's possible to solve this second issue given
the current kernel APIs, since there's not enough semantic information;
requests of GPIOs and IRQs aren't actually tied to a particular driver
at present (there's no "struct device *dev" parameter to request_irq or
gpio_request) and so the subsystems can't actually tell who is
requesting the GPIO/IRQ, and hence can't detect when the same driver, or
a different driver, is requesting the same core resource for different
purposes.

Equally, I am actually not 100% sure we want the core to prevent this.
Why shouldn't two different drivers request the same IRQ? Why shouldn't
at least one driver, perhaps more, request the pin as a GPIO (assuming
it will only read the GPIO value, not flip the pin to output). This
exact situation might happen on some Tegra boards where there's a GPIO
for VBUS_EN that affects 2 USB ports. It's supposed to be driven
open-collector. If an external entity forces it low, it means
over-current. Drivers for both ports might want to receive interrupts on
both edges, and even request the GPIO for input so they can both tell
which level the signal is at, in order to report OC/not-OC back up to
higher levels, as soon as any change occurs.
