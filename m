Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaFOOtI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 10:49:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:51043 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750989AbaFOOtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 10:49:05 -0400
Message-ID: <539DB25A.4000201@free-electrons.com>
Date: Sun, 15 Jun 2014 16:48:58 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: jjhiblot@traphandler.com, Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 1/7] mfd: add atmel-hlcdc driver
References: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com> <1402329860-27520-2-git-send-email-boris.brezillon@free-electrons.com> <539D5F24.1020304@traphandler.com>
In-Reply-To: <539D5F24.1020304@traphandler.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello JJ,

On 15/06/2014 10:53, Jean-Jacques Hiblot wrote:
> On 06/09/2014 06:04 PM, Boris BREZILLON wrote:
>> The HLCDC IP available on some Atmel SoCs (i.e. at91sam9n12, at91sam9x5
>> family or sama5d3 family) exposes 2 subdevices:
>> - a display controller (controlled by a DRM driver)
>> - a PWM chip
>>
>> Add support for the MFD device which will just retrieve HLCDC clocks and
>> create a regmap so that subdevices can access the HLCDC register range
>> concurrently.
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>>  .../devicetree/bindings/mfd/atmel-hlcdc.txt        |  41 ++++++++
>>  drivers/mfd/Kconfig                                |  11 ++
>>  drivers/mfd/Makefile                               |   1 +
[...]
>> +	memset(&config, 0, sizeof(config));
>> +	config.reg_bits = 32;
>> +	config.val_bits = 32;
>> +	config.reg_stride = 4;
>> +	config.max_register = (resource_size(res) / 4) - 1;
>> +	hlcdc->regmap = devm_regmap_init_mmio_clk(dev, "periph_clk", regs,
>> +						  &config);
> I don't think it's necessary to use "periph_clk" here. This clock will
> always be running because the HLCDC needs it to work (it's not just an
> interface clock). In the end it's just some extra work for each register
> access.

Yes, I thought about removing this clk from regmap registration too (for
the exact same reason: avoiding extra enable/disable work when accessing
registers), but ATM I do not prepare/enable periph_clk in the hlcdc-pwm
driver, this means the regmap won't work until the hlcdc-dc driver has
probed the display controller device.

How about preparing/enabling the periph_clk in the MFD device, so that
PWM and Display Controller subdevices won't have to bother about this
clk, and the regmap will work as expected ?
Or, should we just prepare/enable the periph clock in each subdevices ?


Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

