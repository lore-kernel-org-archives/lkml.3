Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaI3Vsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:48:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40850 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615AbaI3Vsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:48:40 -0400
Message-ID: <542B2523.7050001@ti.com>
Date: Tue, 30 Sep 2014 16:48:19 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>,
        Eric Holmberg <eholmber@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v4] hwspinlock: qcom: Add support for Qualcomm HW Mutex
 block
References: <1412051728-3289-1-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1412051728-3289-1-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On 09/29/2014 11:35 PM, Bjorn Andersson wrote:
> From: Kumar Gala <galak@codeaurora.org>
> 
> Add driver for Qualcomm Hardware Mutex block that exists on newer
> Qualcomm SoCs.
> 
> Cc: Jeffrey Hugo <jhugo@codeaurora.org>
> Cc: Eric Holmberg <eholmber@codeaurora.org>
> Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Kumar Gala <galak@codeaurora.org>
> [bjorn: added pm_runtime calls, from Courtney,
> 	added sfpb-mutex compatible,
> 	updated DT binding documentation formatting,
> 	replaced msm prefix with qcom,
> 	cleaned up includes]
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> 
> We need this driver to add support for the shared memory manager, so I'm
> reviving Kumars patch from a year ago, with some additional sprinkles on top.
> 
> Changes since v3:
>  - Reverted back to getting stride from of_match, per Kumars request
> 
> Changes since v2:
>  - MODULE_DEVICE_TABLE
>  - Changed prefix to qcom
>  - Cleaned up includes
>  - Rely on reg and num-locks to figure out stride, instead of of_match data
> 
> Changes since v1:
>  - Added the pm_runtime calls needed to be able to boot a kernel with
>    pm_runtime and this driver, patch from Courtney.
>  - Added sfpb-mutex compatible, for re-use of the driver in family A platforms.
>  - Updated formatting of DT binding documentation, while adding the extra
>    compatible.
>  - Dropped Stephen Boyds Reviewed-by due to these changes.
>  .../devicetree/bindings/hwlock/qcom-hwspinlock.txt |   35 +++++
>  drivers/hwspinlock/Kconfig                         |   11 ++
>  drivers/hwspinlock/Makefile                        |    1 +
>  drivers/hwspinlock/qcom_hwspinlock.c               |  151 ++++++++++++++++++++
>  4 files changed, 198 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
>  create mode 100644 drivers/hwspinlock/qcom_hwspinlock.c
> 
> diff --git a/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt b/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
> new file mode 100644
> index 0000000..27c7c80
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwlock/qcom-hwspinlock.txt
> @@ -0,0 +1,35 @@
> +Qualcomm Hardware Mutex Block:
> +
> +The hardware block provides mutexes utilized between different processors
> +on the SoC as part of the communication protocol used by these processors.
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,sfpb-mutex",
> +		    "qcom,tcsr-mutex"
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: base address and size of the mutex registers
> +
> +- reg-names:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be "mutex-base"
> +
> +- qcom,num-locks:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: the number of locks/mutex available in this block

Please use the common hwlock-num-locks property defined in the common
bindings, instead of a qcom specific property name.

> +
> +Example:
> +
> +	hwlock@fd484000 {
> +		compatible = "qcom,tcsr-mutex";
> +		reg = <0xfd484000 0x1000>;
> +		reg-names = "mutex-base";
> +		qcom,num-locks = <32>;

You also need to add the #hwlock-cells = <1>, without which you won't be
able to parse a client user's lock id.

> +	};
> diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
> index 3612cb5..af4c7e6 100644
> --- a/drivers/hwspinlock/Kconfig
> +++ b/drivers/hwspinlock/Kconfig
> @@ -8,6 +8,17 @@ config HWSPINLOCK
>  
>  menu "Hardware Spinlock drivers"
>  
> +config HWSPINLOCK_QCOM
> +	tristate "Qualcomm Hardware Spinlock device"
> +	depends on ARCH_QCOM
> +	select HWSPINLOCK
> +	help
> +	  Say y here to support the Qualcomm Hardware Mutex functionality, which
> +	  provides a synchronisation mechanism for the various processors on
> +	  the SoC.
> +
> +	  If unsure, say N.
> +
>  config HWSPINLOCK_OMAP
>  	tristate "OMAP Hardware Spinlock device"
>  	depends on ARCH_OMAP4 || SOC_OMAP5 || SOC_DRA7XX || SOC_AM33XX || SOC_AM43XX
> diff --git a/drivers/hwspinlock/Makefile b/drivers/hwspinlock/Makefile
> index 93eb64b..f3bff48 100644
> --- a/drivers/hwspinlock/Makefile
> +++ b/drivers/hwspinlock/Makefile
> @@ -3,5 +3,6 @@
>  #
>  
>  obj-$(CONFIG_HWSPINLOCK)		+= hwspinlock_core.o
> +obj-$(CONFIG_HWSPINLOCK_QCOM)		+= qcom_hwspinlock.o
>  obj-$(CONFIG_HWSPINLOCK_OMAP)		+= omap_hwspinlock.o
>  obj-$(CONFIG_HSEM_U8500)		+= u8500_hsem.o
> diff --git a/drivers/hwspinlock/qcom_hwspinlock.c b/drivers/hwspinlock/qcom_hwspinlock.c
> new file mode 100644
> index 0000000..d1b3328
> --- /dev/null
> +++ b/drivers/hwspinlock/qcom_hwspinlock.c
> @@ -0,0 +1,151 @@
> +/*
> + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
> + * Copyright (c) 2014, Sony Mobile Communications AB
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/hwspinlock.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
> +
> +#include "hwspinlock_internal.h"
> +
> +#define SPINLOCK_ID_APPS_PROC	1
> +#define BASE_ID			0
> +
> +static int qcom_hwspinlock_trylock(struct hwspinlock *lock)
> +{
> +	void __iomem *lock_addr = lock->priv;
> +
> +	writel_relaxed(SPINLOCK_ID_APPS_PROC, lock_addr);
> +
> +	return readl_relaxed(lock_addr) == SPINLOCK_ID_APPS_PROC;
> +}
> +
> +static void qcom_hwspinlock_unlock(struct hwspinlock *lock)
> +{
> +	void __iomem *lock_addr = lock->priv;
> +	u32 lock_owner;
> +
> +	lock_owner = readl_relaxed(lock_addr);
> +	if (lock_owner != SPINLOCK_ID_APPS_PROC) {
> +		pr_err("%s: spinlock not owned by us (actual owner is %d)\n",
> +				__func__, lock_owner);
> +	}
> +
> +	writel_relaxed(0, lock_addr);
> +}
> +
> +static const struct hwspinlock_ops qcom_hwspinlock_ops = {
> +	.trylock	= qcom_hwspinlock_trylock,
> +	.unlock		= qcom_hwspinlock_unlock,
> +};
> +
> +static const struct of_device_id qcom_hwspinlock_of_match[] = {
> +	{ .compatible = "qcom,sfpb-mutex", .data = (void *)0x4 },
> +	{ .compatible = "qcom,tcsr-mutex" , .data = (void *)0x80 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, qcom_hwspinlock_of_match);
> +
> +static int qcom_hwspinlock_probe(struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +	const struct of_device_id *match;
> +	struct hwspinlock_device *bank;
> +	struct hwspinlock *hwlock;
> +	struct resource *res;
> +	void __iomem *iobase;
> +	unsigned stride, i;
> +	size_t array_size;
> +	u32 num_locks;
> +	int ret;
> +
> +	match = of_match_device(qcom_hwspinlock_of_match, &pdev->dev);
> +
> +	ret = of_property_read_u32(node, "qcom,num-locks", &num_locks);
> +	if (ret || num_locks == 0)
> +		return -ENODEV;
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "mutex-base");
> +	iobase = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(iobase))
> +		return PTR_ERR(iobase);
> +
> +	array_size = num_locks * sizeof(*hwlock);
> +	bank = devm_kzalloc(&pdev->dev, sizeof(*bank) + array_size, GFP_KERNEL);
> +	if (!bank)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, bank);
> +
> +	stride = (unsigned)match->data;
> +	for (i = 0, hwlock = &bank->lock[0]; i < num_locks; i++, hwlock++)
> +		hwlock->priv = iobase + i * stride;
> +
> +	pm_runtime_enable(&pdev->dev);
> +
> +	ret = hwspin_lock_register(bank, &pdev->dev, &qcom_hwspinlock_ops,
> +						BASE_ID, num_locks);

I had also done the registration for OMAP hwspinlock driver using a
constant id in my v5, but had revised it based on Ohad's review comment,
so you may have to revise here as well. Please see [1] for details.

> +	if (ret)
> +		pm_runtime_disable(&pdev->dev);
> +
> +	return ret;
> +}
> +
> +static int qcom_hwspinlock_remove(struct platform_device *pdev)
> +{
> +	struct hwspinlock_device *bank = platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret = hwspin_lock_unregister(bank);
> +	if (ret) {
> +		dev_err(&pdev->dev, "%s failed: %d\n", __func__, ret);
> +		return ret;
> +	}
> +
> +	pm_runtime_disable(&pdev->dev);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver qcom_hwspinlock_driver = {
> +	.probe		= qcom_hwspinlock_probe,
> +	.remove		= qcom_hwspinlock_remove,
> +	.driver		= {
> +		.name	= "qcom_hwspinlock",
> +		.of_match_table = qcom_hwspinlock_of_match,
> +	},
> +};
> +
> +static int __init qcom_hwspinlock_init(void)
> +{
> +	return platform_driver_register(&qcom_hwspinlock_driver);
> +}
> +/* board init code might need to reserve hwspinlocks for predefined purposes */
> +postcore_initcall(qcom_hwspinlock_init);
> +
> +static void __exit qcom_hwspinlock_exit(void)
> +{
> +	platform_driver_unregister(&qcom_hwspinlock_driver);
> +}
> +module_exit(qcom_hwspinlock_exit);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Hardware spinlock driver for Qualcomm SoCs");
> +MODULE_AUTHOR("Kumar Gala <galak@codeaurora.org>");
> +MODULE_AUTHOR("Jeffrey Hugo <jhugo@codeaurora.org>");
> +MODULE_AUTHOR("Eric Holmberg <eholmber@codeaurora.org>");
> 

regards
Suman

[1] https://patchwork.kernel.org/patch/4096881/
