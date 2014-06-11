Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbaFKHnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:43:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59333 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751311AbaFKHnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:43:03 -0400
Message-ID: <53980883.5030402@free-electrons.com>
Date: Wed, 11 Jun 2014 09:42:59 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH v5 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
References: <1402408036-5235-1-git-send-email-boris.brezillon@free-electrons.com> <1402408036-5235-3-git-send-email-boris.brezillon@free-electrons.com> <20140610194511.GC3122@katana>
In-Reply-To: <20140610194511.GC3122@katana>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

On 10/06/2014 21:45, Wolfram Sang wrote:
> Hi,
>
> compiling this driver gives me:
>
> drivers/i2c/busses/i2c-sun6i-p2wi.c: In function 'p2wi_probe':
> drivers/i2c/busses/i2c-sun6i-p2wi.c:272:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]
> drivers/i2c/busses/i2c-sun6i-p2wi.c:272:13: warning: assignment makes pointer from integer without a cast [enabled by default]

Yes, there's a missing "depends on RESET_CONTROLLER" in the Kconfig
entry, which I didn't notice because this option was selected by the
sun6i platform.

>> diff --git a/drivers/i2c/busses/i2c-sun6i-p2wi.c b/drivers/i2c/busses/i2c-sun6i-p2wi.c
>> new file mode 100644
>> index 0000000..4f7b93f
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-sun6i-p2wi.c
>> @@ -0,0 +1,356 @@
>> +/*
>> + * P2WI (Push-Pull Two Wire Interface) bus driver.
>> + *
>> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public License
>> + * version 2.  This program is licensed "as is" without any warranty of any
>> + * kind, whether express or implied.
>> + *
>> + * The P2WI controller looks like an SMBus controller which only supports byte
>> + * data transfers. But, it differs from standard SMBus protocol on several
>> + * aspects:
>> + * - it supports only one slave device, and thus drop the address field
>> + * - it adds a parity bit every 8bits of data
>> + * - only one read access is required to read a byte (instead of a write
>> + *   followed by a read access in standard SMBus protocol)
>> + * - there's no Ack bit after each byte transfer
>> + *
>> + * This means this bus cannot be used to interface with standard SMBus
>> + * devices (the only known device to support this interface is the AXP221
>> + * PMIC).
>> + *
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/spinlock.h>
> Unneeded. Please check other includes, too.

Okay, I'll clean it up.
>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/delay.h>
>> +#include <linux/clk.h>
>> +#include <linux/reset.h>
>> +
> ...
>
>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	p2wi->regs = devm_ioremap_resource(dev, r);
>> +	if (IS_ERR(p2wi->regs)) {
>> +		ret = PTR_ERR(p2wi->regs);
>> +		return ret;
>> +	}
> return PTR_ERR(...)?

Oops, some vestige of my previous dev_err call.

>
>> +
>> +	snprintf(p2wi->adapter.name, sizeof(p2wi->adapter.name), pdev->name);
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (irq < 0) {
>> +		dev_err(dev, "failed to retrieve irq: %d\n", ret);
>> +		return irq;
>> +	}
>> +
>> +	p2wi->clk = devm_clk_get(dev, NULL);
>> +	if (IS_ERR(p2wi->clk)) {
>> +		ret = PTR_ERR(p2wi->clk);
>> +		dev_err(dev, "failed to retrieve clk: %d\n",
>> +			ret);
> dangling ret.

I'll fix it.

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

