Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756471AbaGVSBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 14:01:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36272 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaGVSBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 14:01:36 -0400
Message-ID: <53CEB196.9060903@ti.com>
Date: Tue, 22 Jul 2014 21:46:46 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bastian Hecht <hechtb@gmail.com>, <linux-i2c@vger.kernel.org>
CC: Wolfram Sang <wsa@the-dreams.de>, Linux-SH <linux-sh@vger.kernel.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, "Menon, Nishanth" <nm@ti.com>
Subject: Re: [PATCH v2 1/5] i2c: Don't start transfers when suspended
References: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
In-Reply-To: <1405608520-5644-1-git-send-email-hechtb@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 07/17/2014 05:48 PM, Bastian Hecht wrote:
> i2c transfer requests come in very uncontrolled, like from interrupt routines.
> We might be suspended when this happens. To avoid i2c timeouts caused by
> powered down busses we check for suspension.
> 
> Several bus drivers handle this problem on their own. We can clean things up
> by moving the protection mechanism into the core.

 I'm not sure, this optimization is safe  (
Because, in many cases the access to PMIC IC needs to be allowed till late
stages of suspending (at least till suspend_noirq stage or even later).
For example, on some OMAP SoC Voltage management code need to use services
provided by PMIC IC, which is connected to I2C.

As result, it may cause regression and break PM functionality on some SoCs
if i2c-core will block I2c transfers unconditionally at device's
suspending stage.

May be it will be useful to add just "suspended" field in i2c adapter
structure and provide corresponding accessors.

> 
> Signed-off-by: Bastian Hecht <hechtb@gmail.com>
> ---
> changelog v2:
> 
> - commit message extended.
> - initialization added for adap->suspended
> - swapped branch for increased performance
> 
> 
>   drivers/i2c/i2c-core.c | 25 ++++++++++++++++++++++++-
>   include/linux/i2c.h    |  1 +
>   2 files changed, 25 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 7c7f4b8..b15dc20 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -343,6 +343,13 @@ static int i2c_legacy_resume(struct device *dev)
>   static int i2c_device_pm_suspend(struct device *dev)
>   {
>   	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +	struct i2c_adapter *adap = i2c_verify_adapter(dev);
> +
> +	if (adap) {
> +		i2c_lock_adapter(adap);
> +		adap->suspended = true;
> +		i2c_unlock_adapter(adap);
> +	}
>   
>   	if (pm)
>   		return pm_generic_suspend(dev);
> @@ -353,6 +360,13 @@ static int i2c_device_pm_suspend(struct device *dev)
>   static int i2c_device_pm_resume(struct device *dev)
>   {
>   	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
> +	struct i2c_adapter *adap = i2c_verify_adapter(dev);
> +
> +	if (adap) {
> +		i2c_lock_adapter(adap);
> +		adap->suspended = false;
> +		i2c_unlock_adapter(adap);
> +	}
>   
>   	if (pm)
>   		return pm_generic_resume(dev);
> @@ -1243,6 +1257,7 @@ static int i2c_register_adapter(struct i2c_adapter *adap)
>   	dev_set_name(&adap->dev, "i2c-%d", adap->nr);
>   	adap->dev.bus = &i2c_bus_type;
>   	adap->dev.type = &i2c_adapter_type;
> +	adap->suspended = false;
>   	res = device_register(&adap->dev);
>   	if (res)
>   		goto out_list;
> @@ -1819,7 +1834,10 @@ int i2c_transfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
>   			i2c_lock_adapter(adap);
>   		}
>   
> -		ret = __i2c_transfer(adap, msgs, num);
> +		if (!adap->suspended)
> +			ret = __i2c_transfer(adap, msgs, num);
> +		else
> +			ret = -EIO;
>   		i2c_unlock_adapter(adap);
>   
>   		return ret;
> @@ -2577,6 +2595,10 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
>   
>   	if (adapter->algo->smbus_xfer) {
>   		i2c_lock_adapter(adapter);
> +		if (adapter->suspended) {
> +			res = -EIO;
> +			goto unlock;
> +		}
>   
>   		/* Retry automatically on arbitration loss */
>   		orig_jiffies = jiffies;
> @@ -2590,6 +2612,7 @@ s32 i2c_smbus_xfer(struct i2c_adapter *adapter, u16 addr, unsigned short flags,
>   				       orig_jiffies + adapter->timeout))
>   				break;
>   		}
> +unlock:
>   		i2c_unlock_adapter(adapter);
>   
>   		if (res != -EOPNOTSUPP || !adapter->algo->master_xfer)
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index b556e0a..af08c75 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -434,6 +434,7 @@ struct i2c_adapter {
>   	int timeout;			/* in jiffies */
>   	int retries;
>   	struct device dev;		/* the adapter device */
> +	unsigned int suspended:1;
>   
>   	int nr;
>   	char name[48];
> 

Regards,
- grygroii
