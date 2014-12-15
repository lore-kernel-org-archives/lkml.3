Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaLOPpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:45:12 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:18249 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaLOPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:45:10 -0500
X-ME-Helo: beldin
X-ME-Date: Mon, 15 Dec 2014 16:45:08 +0100
X-ME-IP: 86.199.199.51
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] mfd: cottula: add cottula board
References: <1418598606-21352-1-git-send-email-robert.jarzmik@free.fr>
	<4307800.p21Sk5E3dV@wuerfel>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 15 Dec 2014 16:45:03 +0100
In-Reply-To: <4307800.p21Sk5E3dV@wuerfel> (Arnd Bergmann's message of "Mon, 15
	Dec 2014 11:46:20 +0100")
Message-ID: <877fxsapds.fsf@free.fr>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Monday 15 December 2014 00:10:06 Robert Jarzmik wrote:
>> +
>> +       platform_set_drvdata(pdev, cot);
>> +       cot->gpio0 = gpiod_get(&pdev->dev, "lubbock_irq", 0);
>> +       if (IS_ERR(cot->gpio0)) {
>> +               dev_err(&pdev->dev, "Couldn't request GPIO : ret = %d\n", ret);
>> +               return PTR_ERR(cot->gpio0);
>> +       }
>> +       cot->irq = gpiod_to_irq(cot->gpio0);
>> +       if (cot->irq < 0)
>> +               return cot->irq;
>> +
>> +       cot->irqdomain =
>> +               irq_domain_add_linear(pdev->dev.of_node, COTTULA_NB_IRQ,
>> +                                     &cottula_irq_domain_ops, cot);
>> +       if (!cot->irqdomain)
>> +               return -ENODEV;
>> +
>> +       ret = 0;
>> +       if (base_irq)
>> +               ret = irq_create_strict_mappings(cot->irqdomain, base_irq, 0,
>> +                                                COTTULA_NB_IRQ);
>> 
>
> This looks a bit ambiguous: You get a GPIO line for the purpose of the
> IRQ nesting but don't use the GPIO otherwise, and you pass the device's
> own irq domain start as an IORESOURCE_IRQ resource.
>
> For consistency between DT and ATAGS based uses, and with similar DT
> based drivers, I would instead recommend passing the parent irq (from
> the GPIO) as an IORESOURCE_IRQ resource instead of a gpio lookup,
> and passing the base_irq as platform_data for the ATAGS case.

I understand Arnd, yet I wanted to avoid any platform data if possible, as this
is a motherboard, it will not be plugged anywhere else with different
parameters.

What would you say if I did this :
 - remove the gpio
 - use IORESOURCE_IRQ(0) as the parent irq (as you suggested)
 - use IORESOURCE_IRQ(1) as the base_irq
   => this resource would be optional
        - if exists, use it as base_irq
        - if doesn't exist, let base_irq = 0

Will that look correct ?

Cheers.

-- 
Robert
