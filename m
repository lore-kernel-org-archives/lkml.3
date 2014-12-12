Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968070AbaLLNpb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:45:31 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48297 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967799AbaLLNpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:45:30 -0500
Message-ID: <548AF177.9010307@kernel.org>
Date: Fri, 12 Dec 2014 13:45:27 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, pmeerw@pmeerw.net,
        srinivas.pandruvada@linux.intel.com, knaack.h@gmx.de
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/6] iio: imu: kmx61: Add PM sleep support
References: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com> <1417613513-28285-5-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1417613513-28285-5-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/14 13:31, Daniel Baluta wrote:
> Per sensor state (ACTIVE/STANDBY) is saved in driver's
> private data (acc_stby/mag_stby) and restored when
> resume is called.
> 
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
applied.
> ---
>  drivers/iio/imu/kmx61.c | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index 7536043..f69ae5a7 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -16,6 +16,7 @@
>  #include <linux/acpi.h>
>  #include <linux/gpio/consumer.h>
>  #include <linux/interrupt.h>
> +#include <linux/pm.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/iio/iio.h>
>  #include <linux/iio/sysfs.h>
> @@ -796,6 +797,33 @@ static int kmx61_remove(struct i2c_client *client)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int kmx61_suspend(struct device *dev)
> +{
> +	int ret;
> +	struct kmx61_data *data = i2c_get_clientdata(to_i2c_client(dev));
> +
> +	mutex_lock(&data->lock);
> +	ret = kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG,
> +			     false);
> +	mutex_unlock(&data->lock);
> +
> +	return ret;
> +}
> +
> +static int kmx61_resume(struct device *dev)
> +{
> +	u8 stby = 0;
> +	struct kmx61_data *data = i2c_get_clientdata(to_i2c_client(dev));
> +
> +	if (data->acc_stby)
> +		stby |= KMX61_ACC_STBY_BIT;
> +	if (data->mag_stby)
> +		stby |= KMX61_MAG_STBY_BIT;
> +
> +	return kmx61_set_mode(data, stby, KMX61_ACC | KMX61_MAG, true);
> +}
> +#endif
>  
>  #ifdef CONFIG_PM_RUNTIME
>  static int kmx61_runtime_suspend(struct device *dev)
> @@ -825,6 +853,7 @@ static int kmx61_runtime_resume(struct device *dev)
>  #endif
>  
>  static const struct dev_pm_ops kmx61_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(kmx61_suspend, kmx61_resume)
>  	SET_RUNTIME_PM_OPS(kmx61_runtime_suspend, kmx61_runtime_resume, NULL)
>  };
>  
> 

