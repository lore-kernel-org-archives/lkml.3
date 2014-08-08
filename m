Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbaHHQjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:39:03 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36143 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbaHHQjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:39:00 -0400
Message-ID: <53E4FD1B.6060600@collabora.co.uk>
Date: Fri, 08 Aug 2014 18:38:51 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>
CC: Stephen Warren <swarren@nvidia.com>, Yufeng Shen <miletus@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Abraham <thomas.ab@samsung.com>
Subject: Re: [PATCH v2 1/1] Input: atmel_mxt_ts - Get IRQ edge/level flags
 on DT booting
References: <1407397492-17475-1-git-send-email-javier.martinez@collabora.co.uk> <53E4D9A5.908@itdev.co.uk> <20140808162146.GC26820@core.coreip.homeip.net>
In-Reply-To: <20140808162146.GC26820@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Thomas Gleixner, Jason Cooper, Benjamin Herrenschmidt and Thomas Abraham

Hello Dmitry,

On 08/08/2014 06:21 PM, Dmitry Torokhov wrote:
> On Fri, Aug 08, 2014 at 03:07:33PM +0100, Nick Dyer wrote:
>> On 07/08/14 08:44, Javier Martinez Canillas wrote:
>> > The Atmel maXTouch driver assumed that the IRQ type flags will
>> > always be passed using platform data but this is not true when
>> > booting using Device Trees. In these setups the interrupt type
>> > was ignored by the driver when requesting an IRQ.
>> > 
>> > This means that it will fail if a machine specified other type
>> > than IRQ_TYPE_NONE. The right approach is to get the IRQ flags
>> > that was parsed by OF from the "interrupt" Device Tree propery.
>> > 
>> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> 
>> I'm happy for this to go in if Dmitry will accept it. It does seem to be a
>> quirk of some platforms that it is necessary, but it's only one line.
> 
> I'd rather not as it masks the deeper platform issue. There might be
> other drovers also expecting platform/OF code set up interrupt triggers
> and working/not working by chance.
> 

I totally agree. When posted the patch I thought that it was the right fix but
after your explanation and studying the IRQ core I see that as you said this i
just hiding a more fundamental issue. We should fix the root cause instead of
adding a workaround for every driver.

> Can we figure out why the platform in question needs this change?
> 

I dig further on this. First I wanted to see if the problem was on IRQ core or
in the irqchip driver so I tried calling the chip's .irq_set_type function
handler directly using the flags set by __irq_set_trigger() the first time that
it's called from OF when the "interrupts" property is parsed.

Doing that makes the device to trigger interrupts so the problem seems to be
related to the pinctrl-exynos driver and is not in the IRQ core.

So, this is the change I did just for testing purposes to make it work again:

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3dc6a61..ed76b25 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1176,6 +1176,10 @@ __setup_irq(unsigned int irq, struct irq_desc *desc,
struct irqaction *new)

 			if (ret)
 				goto out_mask;
+		} else if (irq == 283 /* mapped IRQ number for touchpad */) {
+			struct irq_chip *chip = desc->irq_data.chip;
+			chip->irq_set_type(&desc->irq_data,
+					   irq_get_trigger_type(irq));
 		}

 		desc->istate &= ~(IRQS_AUTODETECT | IRQS_SPURIOUS_DISABLED | \


It seems as if the first call to exynos_irq_set_type() that is made by OF is a
no-op while the second call is the one that actually setups the hw correctly.
Does this make any sense? Maybe is related to the pin not being muxed in the
correct function when the "interrupts" property is parsed by OF?

Now I added some debug logs to see what could be different but all the variables
have the same values in both cases:

When called happens due irq_parse_and_map():

irq 283 type 2 pin 1 shift 4 base 4026679296 reg_con 3588 con 32 flags 0 mask 0

When called happens due request_threaded_irq():

irq 283 type 2 pin 1 shift 4 base 4026679296 reg_con 3588 con 32 flags 0 mask 0

I would really appreciate if someone that is more familiar with the driver or
this chip can provide some hints.

Thanks a lot and best regards,
Javier
