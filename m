Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaLFLLK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 06:11:10 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60462 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaLFLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 06:11:08 -0500
Message-ID: <5482E449.7050503@kernel.org>
Date: Sat, 06 Dec 2014 11:11:05 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] iio: accel: kxcjk-1013: error handling when set mode
 fails
References: <1417817890-10252-1-git-send-email-irina.tirdea@intel.com> <1417817890-10252-4-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1417817890-10252-4-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 22:18, Irina Tirdea wrote:
> If there is an error in set mode at runtime resume, reset the state of
> the runtime usage count.
> 
> If there is an error in set mode at runtime suspend, make sure the framework
> retries to suspend the device.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Looks superficially fine to me, but I'd like Srinivas to take a look before
I apply this one or the next one.

If you have officially taken over support of this driver, just let me know
and I'll stop pestering Srinivas :)




> ---
>  drivers/iio/accel/kxcjk-1013.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 7b0a9da..74b196f 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -388,6 +388,8 @@ static int kxcjk1013_set_power_state(struct kxcjk1013_data *data, bool on)
>  	if (ret < 0) {
>  		dev_err(&data->client->dev,
>  			"Failed: kxcjk1013_set_power_state for %d\n", on);
> +		if (on)
> +			pm_runtime_put_noidle(&data->client->dev);
>  		return ret;
>  	}
>  #endif
> @@ -859,6 +861,7 @@ static int kxcjk1013_write_event_config(struct iio_dev *indio_dev,
>  
>  	ret =  kxcjk1013_setup_any_motion_interrupt(data, state);
>  	if (ret < 0) {
> +		kxcjk1013_set_power_state(data, !state);
>  		mutex_unlock(&data->mutex);
>  		return ret;
>  	}
> @@ -1009,6 +1012,7 @@ static int kxcjk1013_data_rdy_trigger_set_state(struct iio_trigger *trig,
>  	else
>  		ret = kxcjk1013_setup_new_data_interrupt(data, state);
>  	if (ret < 0) {
> +		kxcjk1013_set_power_state(data, !state);
>  		mutex_unlock(&data->mutex);
>  		return ret;
>  	}
> @@ -1368,8 +1372,14 @@ static int kxcjk1013_runtime_suspend(struct device *dev)
>  {
>  	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
>  	struct kxcjk1013_data *data = iio_priv(indio_dev);
> +	int ret;
>  
> -	return kxcjk1013_set_mode(data, STANDBY);
> +	ret = kxcjk1013_set_mode(data, STANDBY);
> +	if (ret < 0) {
> +		dev_err(&data->client->dev, "powering off device failed\n");
> +		return -EAGAIN;
> +	}
> +	return 0;
>  }
>  
>  static int kxcjk1013_runtime_resume(struct device *dev)
> 

