Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966319AbaLLLW3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:22:29 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47203 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965845AbaLLLW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:22:28 -0500
Message-ID: <548ACFF2.2010601@kernel.org>
Date: Fri, 12 Dec 2014 11:22:26 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Irina Tirdea <irina.tirdea@intel.com>, linux-iio@vger.kernel.org
CC: linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>
Subject: Re: [PATCH v2 3/4] iio: accel: kxcjk-1013: error handling when set
 mode fails
References: <1418228634-10505-1-git-send-email-irina.tirdea@intel.com> <1418228634-10505-4-git-send-email-irina.tirdea@intel.com>
In-Reply-To: <1418228634-10505-4-git-send-email-irina.tirdea@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 16:23, Irina Tirdea wrote:
> If there is an error in set mode at runtime resume, reset the state of
> the runtime usage count.
> 
> If there is an error in set mode at runtime suspend, make sure the framework
> retries to suspend the device.
> 
> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Applied to the togreg branch of iio.git - to be pushed out as testing later
today.

Thanks,

Jonathan
> ---
>  drivers/iio/accel/kxcjk-1013.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 7b0a9da..0dc6ccf 100644
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
> @@ -859,6 +861,8 @@ static int kxcjk1013_write_event_config(struct iio_dev *indio_dev,
>  
>  	ret =  kxcjk1013_setup_any_motion_interrupt(data, state);
>  	if (ret < 0) {
> +		kxcjk1013_set_power_state(data, false);
> +		data->ev_enable_state = 0;
>  		mutex_unlock(&data->mutex);
>  		return ret;
>  	}
> @@ -1009,6 +1013,7 @@ static int kxcjk1013_data_rdy_trigger_set_state(struct iio_trigger *trig,
>  	else
>  		ret = kxcjk1013_setup_new_data_interrupt(data, state);
>  	if (ret < 0) {
> +		kxcjk1013_set_power_state(data, false);
>  		mutex_unlock(&data->mutex);
>  		return ret;
>  	}
> @@ -1368,8 +1373,14 @@ static int kxcjk1013_runtime_suspend(struct device *dev)
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

