Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3IKAxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:53:04 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:37790 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3IKAxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:53:02 -0400
Message-ID: <522FBED9.9000305@collabora.co.uk>
Date: Wed, 11 Sep 2013 02:52:41 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130704 Icedove/17.0.7
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mark Brown <broonie@kernel.org>, Lars Poeschel <poeschel@lemonage.de>,
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
References: <1377526030-32024-1-git-send-email-larsi@wh2.tu-dresden.de> <52279524.8090006@wwwdotorg.org> <20130909161924.GT29403@sirena.org.uk> <2052193.CMUEUJFRgS@lem-wkst-02> <522F78CB.2020507@wwwdotorg.org> <20130910213718.GH29403@sirena.org.uk> <522F9E6C.2010905@wwwdotorg.org>
In-Reply-To: <522F9E6C.2010905@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 12:34 AM, Stephen Warren wrote:
> On 09/10/2013 03:37 PM, Mark Brown wrote:
>> On Tue, Sep 10, 2013 at 01:53:47PM -0600, Stephen Warren wrote:
>> 
>>> Doesn't this patch call gpio_request() on the GPIO first, and
>>> hence prevent the driver's own gpio_request() from succeeding,
>>> since the GPIO is already requested? If this is not a problem, it
>>> sounds like a bug in gpio_request() not ensuring mutual exclusion
>>> for the GPIO.
>> 
>> Or at the very least something that's likely to break in the
>> future.
> 
> Looking at the GPIO code, it already prevents double-requests:
> 
>>         if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
>>                 desc_set_label(desc, label ? : "?");
>>                 status = 0;
>>         } else {
>>                 status = -EBUSY;
>>                 module_put(chip->owner);
>>                 goto done;
>>         }
> 
> And I tested it in practice, and it really does fail.
> 

I'm a bit confused now. Doesn't the fact that gpio_request() prevents
double-requests mean that the use-case that you say that have not been covered
by this patch can't actually happen?

I mean, if when using board files an explicit call to gpio_request() is made by
platform code then a driver can't call gpio_request() for the same gpio. So this
patch shouldn't cause any regression since is just auto-requesting a GPIO when
is mapped as an IRQ in a DT which basically will be the same that was made by
board files before.

To give you an example of an use-case that this patch is trying to solve:

OMAP SoCs have a General-Purpose Memory Controller (GPMC) that can be used to
interface with Pseudo-SRAM devices such as ethernet controllers. So with board
files we currently have this (arch/arm/mach-omap2/gpmc-smsc911x.c):

void __init gpmc_smsc911x_init(struct omap_smsc911x_platform_data *gpmc_cfg)
{
       ....
       if (gpio_request_one(gpmc_cfg->gpio_irq, GPIOF_IN, "smsc911x irq")) {
                pr_err("Failed to request IRQ GPIO%d\n", gpmc_cfg->gpio_irq);
                goto free1;
       }
       ....
       gpmc_smsc911x_resources[1].start = gpio_to_irq(gpmc_cfg->gpio_irq);
       ...
       pdev = platform_device_register_resndata(NULL, "smsc911x", gpmc_cfg->id,
                 gpmc_smsc911x_resources, ARRAY_SIZE(gpmc_smsc911x_resources),
                 &gpmc_smsc911x_config, sizeof(gpmc_smsc911x_config));
       ...
}

and later in the smsc911x ethernet driver probe function:

static int smsc911x_drv_probe(struct platform_device *pdev)
{
       retval = request_irq(dev->irq, smsc911x_irqhandler,
                             irq_flags | IRQF_SHARED, dev->name, dev);
       ...
       irq_res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
       ...
       dev->irq = irq_res->start;
       ...
       retval = request_irq(dev->irq, smsc911x_irqhandler,
                             irq_flags | IRQF_SHARED, dev->name, dev);
       ...
}

The driver just knows that it has to get the IRQ from a struct resource and it
doesn't care if that is a real IRQ line from an interrupt controller or a GPIO
pin mapped as an IRQ. With linus patch I just can define on a DT (GPMC
properties omitted for simplicity):

        ethernet@5,0 {
                pinctrl-names = "default";
                pinctrl-0 = <&smsc911x_pins>;
                compatible = "smsc,lan9221", "smsc,lan9115";
                reg = <5 0 0xff>;
                bank-width = <2>;
                interrupt-parent = <&gpio6>;
                interrupts = <16 8>;
                vmmc-supply = <&vddvario>;
                vmmc_aux-supply = <&vdd33a>;
                reg-io-width = <4>;

                smsc,save-mac-address;
        };

and it will just work. Without Linus patch the call to request_irq() will fail
because a call to gpio_request() has not been made (and thus the GPIO bank was
not enabled).

Thanks a lot and best regards,
Javier
