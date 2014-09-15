Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaIOG60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 02:58:26 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:35833 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751897AbaIOG6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 02:58:24 -0400
Message-ID: <54168DE2.8020303@st.com>
Date: Mon, 15 Sep 2014 08:57:38 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: "David E. Box" <david.e.box@linux.intel.com>, <wsa@the-dreams.de>
Cc: <jdelvare@suse.de>, <arnd@arndb.de>, <dianders@chromium.org>,
        <sjg@chromium.org>, <laurent.pinchart+renesas@ideasonboard.com>,
        <u.kleine-koenig@pengutronix.de>, <boris.brezillon@free-electrons.com>,
        <max.schwarz@online.de>, <schwidefsky@de.ibm.com>,
        <iivanov@mm-sol.com>, <jacob.jun.pan@linux.intel.com>,
        <soren.brinkmann@xilinx.com>, <bjorn.andersson@sonymobile.com>,
        <andrew@lunn.ch>, <skuribay@pobox.com>, <christian.ruppert@abilis.com>,
        <Romain.Baeriswyl@abilis.com>, <mika.westerberg@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] i2c-designware: Intel BayTrail PMIC I2C bus support
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-15_01:2014-09-12,2014-09-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 09/12/2014 07:36 PM, David E. Box wrote:
> This patch implements an I2C bus sharing mechanism between the host and platform
> hardware on select Intel BayTrail SoC platforms using the XPower AXP288 PMIC.
>
> On these platforms access to the PMIC must be shared with platform hardware. The
> hardware unit assumes full control of the I2C bus and the host must request
> access through a special semaphore. Hardware control of the bus also makes it
> necessary to disable runtime pm to avoid interfering with hardware transactions.
>
> Signed-off-by: David E. Box <david.e.box@linux.intel.com>
> ---
>   drivers/i2c/busses/Kconfig                  |  10 +++
>   drivers/i2c/busses/Makefile                 |   1 +
>   drivers/i2c/busses/i2c-designware-core.h    |  14 ++++
>   drivers/i2c/busses/i2c-designware-platdrv.c |  78 +++++++++++++++++++--
>   drivers/i2c/busses/i2c-shared-controller.c  | 101 ++++++++++++++++++++++++++++
>   5 files changed, 200 insertions(+), 4 deletions(-)
>   create mode 100644 drivers/i2c/busses/i2c-shared-controller.c
>
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index 2ac87fa..672ef23 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -441,6 +441,16 @@ config I2C_DESIGNWARE_PCI
>   	  This driver can also be built as a module.  If so, the module
>   	  will be called i2c-designware-pci.
>
> +config I2C_SHARED_CONTROLLER
This config name is too generic.
 From what I understand, it is very Intel dependant.

> +	tristate "Intel Baytrail PMIC shared I2C bus support"
> +	depends on ACPI
> +	select IOSF_MBI
> +	select I2C_DESIGNWARE_CORE
> +	help
> +	  This driver enables shared access to the PMIC I2C bus on select Intel
> +	  BayTrail platforms using the XPower AXP288 PMIC. This driver is
> +	  required for host access to the PMIC on these platforms.
> +
>   config I2C_EFM32
>   	tristate "EFM32 I2C controller"
>   	depends on ARCH_EFM32 || COMPILE_TEST
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 49bf07e..33d62d1 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -41,6 +41,7 @@ obj-$(CONFIG_I2C_DESIGNWARE_CORE)	+= i2c-designware-core.o
>   obj-$(CONFIG_I2C_DESIGNWARE_PLATFORM)	+= i2c-designware-platform.o
>   i2c-designware-platform-objs := i2c-designware-platdrv.o
>   obj-$(CONFIG_I2C_DESIGNWARE_PCI)	+= i2c-designware-pci.o
> +obj-$(CONFIG_I2C_SHARED_CONTROLLER)	+= i2c-shared-controller.o
Ditto, the file name is too generic.

>   i2c-designware-pci-objs := i2c-designware-pcidrv.o
>   obj-$(CONFIG_I2C_EFM32)		+= i2c-efm32.o
>   obj-$(CONFIG_I2C_EG20T)		+= i2c-eg20t.o
> diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
> index d66b6cb..a2b72f4 100644
> --- a/drivers/i2c/busses/i2c-designware-core.h
> +++ b/drivers/i2c/busses/i2c-designware-core.h
> @@ -65,6 +65,10 @@
>    * @ss_lcnt: standard speed LCNT value
>    * @fs_hcnt: fast speed HCNT value
>    * @fs_lcnt: fast speed LCNT value
> + * @shared_host: if host must share access to adapter with other
> + * firmware/hardware units
> + * @acquire_ownership: function to acquire exclusive use of the controller
> + * @release_ownership: function to release exclusive use of the controller
>    *
>    * HCNT and LCNT parameters can be used if the platform knows more accurate
>    * values than the one computed based only on the input clock frequency.
> @@ -105,6 +109,11 @@ struct dw_i2c_dev {
>   	u16			ss_lcnt;
>   	u16			fs_hcnt;
>   	u16			fs_lcnt;
> +#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> +	int			shared_host;
> +	int			(*acquire_ownership)(struct device *dev);
> +	int			(*release_ownership)(struct device *dev);
> +#endif
>   };
>
>   #define ACCESS_SWAP		0x00000001
> @@ -123,3 +132,8 @@ extern void i2c_dw_disable(struct dw_i2c_dev *dev);
>   extern void i2c_dw_clear_int(struct dw_i2c_dev *dev);
>   extern void i2c_dw_disable_int(struct dw_i2c_dev *dev);
>   extern u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev);
> +
> +#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> +extern int i2c_acquire_ownership(struct device *dev);
> +extern int i2c_release_ownership(struct device *dev);
> +#endif
> diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
> index f9b1dec..f86c285 100644
> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c
> @@ -52,6 +52,32 @@ static u32 i2c_dw_get_clk_rate_khz(struct dw_i2c_dev *dev)
>   	return clk_get_rate(dev->clk)/1000;
>   }
>
> +#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> +int i2c_shared_controller_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
> +	int num)
> +{
> +	struct dw_i2c_dev *dev = i2c_get_adapdata(adap);
> +	int err;
> +
> +	if (dev->shared_host) {
this share_host variable is not needed, you could just check whether 
acquire callback is set.
> +		err = dev->acquire_ownership(dev->dev);
Have you considered using hwspinlocks instead?

> +		if (!err) {
Please prefer checking for error, no succes.


> +			err = i2c_dw_xfer(adap, msgs, num);
> +			dev->release_ownership(dev->dev);
> +		} else
You need braces here too.
> +			dev_WARN(dev->dev, "couldnt acquire ownership\n");
why not dev_warn? or better, dev_err?
> +
> +		return err;
> +	} else
Braces around this too.
> +		return i2c_dw_xfer(adap, msgs, num);
> +}
> +
> +static struct i2c_algorithm i2c_sc_algo = {
> +	.master_xfer	= i2c_shared_controller_xfer,
> +	.functionality	= i2c_dw_func,
> +};
> +#endif
> +
>   #ifdef CONFIG_ACPI
>   static void dw_i2c_acpi_params(struct platform_device *pdev, char method[],
>   			       u16 *hcnt, u16 *lcnt, u32 *sda_hold)
> @@ -80,8 +106,11 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
>   {
>   	struct dw_i2c_dev *dev = platform_get_drvdata(pdev);
>   	bool fs_mode = dev->master_cfg & DW_IC_CON_SPEED_FAST;
> +	acpi_handle handle = ACPI_HANDLE(&pdev->dev);
> +	acpi_status status;
> +	unsigned long long shared_host = 0;
>
> -	if (!ACPI_HANDLE(&pdev->dev))
> +	if (!handle)
>   		return -ENODEV;
>
>   	dev->adapter.nr = -1;
> @@ -97,6 +126,24 @@ static int dw_i2c_acpi_configure(struct platform_device *pdev)
>   	dw_i2c_acpi_params(pdev, "FMCN", &dev->fs_hcnt, &dev->fs_lcnt,
>   			   fs_mode ? &dev->sda_hold_time : NULL);
>
> +#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> +	/*
> +	 * For Intel SOC's determine if i2c bus must be shared with PUNIT
> +	 * hardware
> +	 */
> +	status = acpi_evaluate_integer(handle, "_SEM", NULL, &shared_host);
> +
> +	if (ACPI_SUCCESS(status))
> +		dev_info(&pdev->dev, "_SEM=%ld\n", (long)shared_host);
> +
> +	if (shared_host != 0) {
> +		dev_info(&pdev->dev,
> +			"Host shares controller with other hardware\n");
> +		dev->shared_host = 1;
> +		dev->acquire_ownership = i2c_acquire_ownership;
> +		dev->release_ownership = i2c_release_ownership;
> +	}
> +#endif /* CONFIG_I2C_SHARED_CONTROLLER */
>   	return 0;
>   }
>
> @@ -115,7 +162,7 @@ static inline int dw_i2c_acpi_configure(struct platform_device *pdev)
>   {
>   	return -ENODEV;
>   }
> -#endif
> +#endif /* CONFIG_ACPI */
>
>   static int dw_i2c_probe(struct platform_device *pdev)
>   {
> @@ -212,6 +259,25 @@ static int dw_i2c_probe(struct platform_device *pdev)
>   	adap->dev.parent = &pdev->dev;
>   	adap->dev.of_node = pdev->dev.of_node;
>
> +#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> +	if (dev->shared_host)
> +		adap->algo = &i2c_sc_algo;
> +
> +	r = i2c_add_numbered_adapter(adap);
> +	if (r) {
> +		dev_err(&pdev->dev, "failure adding adapter\n");
> +		return r;
> +	}
> +
> +	if (dev->shared_host)
> +		pm_runtime_forbid(&pdev->dev);
> +	else {
> +		pm_runtime_set_autosuspend_delay(&pdev->dev, 1000);
> +		pm_runtime_use_autosuspend(&pdev->dev);
> +		pm_runtime_set_active(&pdev->dev);
> +		pm_runtime_enable(&pdev->dev);
> +	}
> +#else
Why do you put all this under config flags?

>   	r = i2c_add_numbered_adapter(adap);
>   	if (r) {
>   		dev_err(&pdev->dev, "failure adding adapter\n");
> @@ -222,7 +288,7 @@ static int dw_i2c_probe(struct platform_device *pdev)
>   	pm_runtime_use_autosuspend(&pdev->dev);
>   	pm_runtime_set_active(&pdev->dev);
>   	pm_runtime_enable(&pdev->dev);
> -
> +#endif
>   	return 0;
>   }
>
> @@ -268,7 +334,11 @@ static int dw_i2c_resume(struct device *dev)
>   	struct dw_i2c_dev *i_dev = platform_get_drvdata(pdev);
>
>   	clk_prepare_enable(i_dev->clk);
> -	i2c_dw_init(i_dev);
> +
> +#if IS_ENABLED(CONFIG_I2C_SHARED_CONTROLLER)
> +	if (!i_dev->shared_host)
> +#endif
Putting this under config flag should not be needed.

And even not under config flags, why don't you re-initialize your device 
in case of resume?
> +		i2c_dw_init(i_dev);
>
>   	return 0;
>   }
> diff --git a/drivers/i2c/busses/i2c-shared-controller.c b/drivers/i2c/busses/i2c-shared-controller.c
> new file mode 100644
> index 0000000..b9119a0
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-shared-controller.c
> @@ -0,0 +1,101 @@
> +/*
> + * Intel SOC I2C bus sharing semphore implementation
s/semphore/semaphore/
> + * Copyright (c) 2014, Intel Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + */
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/device.h>
> +#include <asm/iosf_mbi.h>
This driver should depend on x86, as this include file is only present 
in this architecture.

> +
> +#define PUNIT_SEMAPHORE 0x7
> +static unsigned long start_time, end_time;
> +
> +static int get_sem(struct device *dev, u32 *sem)
> +{
> +	u32 reg_val;
> +	int ret;
> +
> +	ret = iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ, PUNIT_SEMAPHORE,
> +			    &reg_val);
> +	if (ret) {
> +		dev_WARN(dev, "iosf failed to read punit semaphore\n");
dev_err?
> +		return ret;
> +	}
> +
> +	*sem = reg_val & 0x1;
> +
> +	return 0;
> +}
> +
> +static void reset_semaphore(struct device *dev)
> +{
> +	u32 data;
> +
> +	if (iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ,
> +				PUNIT_SEMAPHORE, &data)) {
> +		dev_err(dev, "iosf failed to reset punit semaphore\n");
> +		return;
> +	}
> +
> +	data = data & 0xfffffffe;
> +	if (iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
> +				 PUNIT_SEMAPHORE, data))
> +		dev_err(dev, "iosf failed to reset punit semaphore\n");
> +}
> +
> +int i2c_acquire_ownership(struct device *dev)
> +{
> +	u32 sem = 0;
> +	int ret;
> +	int timeout = 100;
> +
> +	/* host driver writes 0x2 to side band semaphore register */
> +	ret = iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
> +				 PUNIT_SEMAPHORE, 0x2);
> +	if (ret) {
> +		dev_WARN(dev, "iosf failed to request punit semaphore\n");
> +		return ret;
> +	}
> +
> +	/* host driver waits for bit 0 to be set in semaphore register */
> +	while (1) {
> +		ret = get_sem(dev, &sem);
> +		if (!ret && sem) {
> +			start_time = jiffies;
> +			dev_dbg(dev, "punit semaphore acquired after %d attempts\n",
> +				101 - timeout);
> +			return 0;
> +		}
> +
> +		usleep_range(1000, 2000);
> +		timeout--;
> +		if (timeout <= 0) {
Couldn't you use time_after(jiffies, jiffies + timeout)...?

> +			dev_err(dev, "punit semaphore timed out, resetting\n");
> +			reset_semaphore(dev);
> +			iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ,
> +				PUNIT_SEMAPHORE, &sem);
> +			dev_err(dev, "PUNIT SEM: %d\n", sem);
> +			WARN_ON(1);
> +			return -ETIMEDOUT;
> +		}
> +
> +	}
> +}
> +
> +int i2c_release_ownership(struct device *dev)
> +{
> +	reset_semaphore(dev);
> +	end_time = jiffies;
> +	dev_dbg(dev, "punit semaphore release call finish, held for %ldms\n",
> +		(end_time - start_time) * 1000 / HZ);
> +	return 0;
> +}
>
