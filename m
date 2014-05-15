Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbaEOBqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 21:46:45 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58366 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaEOBqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 21:46:44 -0400
Message-ID: <53741C60.70209@ahsoftware.de>
Date: Thu, 15 May 2014 03:46:08 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jon Loeliger <jdl@jdl.com>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>	<20140514141914.446F7C4153D@trevor.secretlab.ca>	<53738580.7000902@ahsoftware.de>	<CACxGe6s4px_9CNk3bkc1OF1KGZGYdyh4gE_VufCKU5dLFBG48g@mail.gmail.com>	<53739871.9070407@ahsoftware.de>	<CAL_JsqJB4CAO60m1HTGQGHQRYVWcARxm_roOhn-PJh+ZR7OONg@mail.gmail.com>	<5373ABD2.9010508@ahsoftware.de> <CAL_JsqJ-=amrmRR9FfnOH1ELDQ1kTaG3e1n878mgpZP1FUw_jA@mail.gmail.com> <5373C2F4.50803@ahsoftware.de>
In-Reply-To: <5373C2F4.50803@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.05.2014 21:24, schrieb Alexander Holler:
> Am 14.05.2014 21:06, schrieb Rob Herring:

>> I still have not seen an example of A depends on B, deferred probe
>> fails because of ? and here is the code for A that works around the
>> problem.
>>
>>> Anyway, this feature is totally independ of the deferred probe stuff and
>>> both can friendly live together.
>>
>> Yes, except then we get to maintain both.

And just in case someone still hasn't realized what the goal of a
deterministic initialization order is, have a look at this snippet from
arch/arm/mach-omap2/gpio.c:

--------
/*
 * gpio_init needs to be done before
 * machine_init functions access gpio APIs.
 * Hence gpio_init is a omap_postcore_initcall.
 */
static int __init omap2_gpio_init(void)
{
	/* If dtb is there, the devices will be created dynamically */
	if (of_have_populated_dt())
		return -ENODEV;

	return omap_hwmod_for_each_by_class("gpio", omap2_gpio_dev_init, NULL);
}
omap_postcore_initcall(omap2_gpio_init);
--------
(Sorry to the OMAP guys, it isn't there fault that it has to look like
this.)

But this is ecactly what should be avoided and why the kernel is in need
of a deterministic, easy to setup, initialization order. And deferred
probes are in now way a help to reach that target, in fact they even
support such stuff. Does anybody outside the OMAP crew do understand
what that piece of code does? The answer is pretty likely no. Again
sorry to the OMAP guys, I'm pretty sure that code was born out of
necessity because no other mechanism is available to get things in order.

Regards,

Alexander Holler

