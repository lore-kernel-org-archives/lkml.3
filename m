Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaLTJoD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 04:44:03 -0500
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:26276 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673AbaLTJoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 04:44:00 -0500
X-ME-Helo: beldin
X-ME-Date: Sat, 20 Dec 2014 10:43:56 +0100
X-ME-IP: 86.199.199.51
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] mfd: cottula: add cottula board
References: <1418598606-21352-1-git-send-email-robert.jarzmik@free.fr>
	<4307800.p21Sk5E3dV@wuerfel> <877fxsapds.fsf@free.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Sat, 20 Dec 2014 10:43:48 +0100
In-Reply-To: <877fxsapds.fsf@free.fr> (Robert Jarzmik's message of "Mon, 15
	Dec 2014 16:45:03 +0100")
Message-ID: <8761d68xm3.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> Arnd Bergmann <arnd@arndb.de> writes:
>
>> On Monday 15 December 2014 00:10:06 Robert Jarzmik wrote:
>>> +
>>> +       platform_set_drvdata(pdev, cot);
>>> +       cot->gpio0 = gpiod_get(&pdev->dev, "lubbock_irq", 0);
>>> +       if (IS_ERR(cot->gpio0)) {
>>> +               dev_err(&pdev->dev, "Couldn't request GPIO : ret = %d\n", ret);
>>> +               return PTR_ERR(cot->gpio0);
>>> +       }
>>> +       cot->irq = gpiod_to_irq(cot->gpio0);
>>> +       if (cot->irq < 0)
>>> +               return cot->irq;
>>> +
>>> +       cot->irqdomain =
>>> +               irq_domain_add_linear(pdev->dev.of_node, COTTULA_NB_IRQ,
>>> +                                     &cottula_irq_domain_ops, cot);
>>> +       if (!cot->irqdomain)
>>> +               return -ENODEV;
>>> +
>>> +       ret = 0;
>>> +       if (base_irq)
>>> +               ret = irq_create_strict_mappings(cot->irqdomain, base_irq, 0,
>>> +                                                COTTULA_NB_IRQ);
>>> 
>>
>> This looks a bit ambiguous: You get a GPIO line for the purpose of the
>> IRQ nesting but don't use the GPIO otherwise, and you pass the device's
>> own irq domain start as an IORESOURCE_IRQ resource.
>>
>> For consistency between DT and ATAGS based uses, and with similar DT
>> based drivers, I would instead recommend passing the parent irq (from
>> the GPIO) as an IORESOURCE_IRQ resource instead of a gpio lookup,
>> and passing the base_irq as platform_data for the ATAGS case.

Hi Arnd,

I thought again about the GPIO.

I put in the "gpiod_get()" call to ensure proper ordering between the gpio
probing and this driver probing. It ensured that this driver's probe will be
defered until the gpio driver is probed, which is the main purpose of this
patch (commit message).

If I pass an irq from the machine code, I loose this guarantee, don't I ?

Cheers.

-- 
Robert
