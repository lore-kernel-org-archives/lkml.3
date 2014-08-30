Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603AbaH3Kpi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 06:45:38 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60894 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaH3Kpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 06:45:35 -0400
Message-ID: <5401AB4D.4000103@kernel.org>
Date: Sat, 30 Aug 2014 11:45:33 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-iio@vger.kernel.org
CC: srinivas.pandruvada@linux.intel.com, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] iio: accel: BMC150: fix issues when CONFIG_PM_RUNTIME
 is not set
References: <1409301488-22166-1-git-send-email-laurentiu.palcu@intel.com> <1409301488-22166-3-git-send-email-laurentiu.palcu@intel.com>
In-Reply-To: <1409301488-22166-3-git-send-email-laurentiu.palcu@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/08/14 09:38, Laurentiu Palcu wrote:
> When CONFIG_PM_RUNTIME is not set, the following issues are seen:
>  * warning message at compilation time:
>     warning: 'bmc150_accel_get_startup_times' defined but not used [-Wunused-function]
>  * bmc150_accel_set_power_state() will always fail and reading the
>    accelerometer data is impossible;
Why? Would be good to have an explanation here...

If on is true then it will call pm_runtime_get_sync which calls __pm_runtime_resume
which when CONFIG_PM_RUNTIME is not defined returns 1 which is not an error.

In the on = false case it calls pm_runtime_put_autosuspend which calls __pm_runtime_suspend
which returns -ENOSYS and gives our error.

I'll add something to the patch description to this effect.
> 
> This commit fixes these.
> 
> Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
> ---
>  drivers/iio/accel/bmc150-accel.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/iio/accel/bmc150-accel.c b/drivers/iio/accel/bmc150-accel.c
> index ccb6cf8..0e6566a 100644
> --- a/drivers/iio/accel/bmc150-accel.c
> +++ b/drivers/iio/accel/bmc150-accel.c
> @@ -499,6 +499,7 @@ static int bmc150_accel_get_bw(struct bmc150_accel_data *data, int *val,
>  	return -EINVAL;
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME
>  static int bmc150_accel_get_startup_times(struct bmc150_accel_data *data)
>  {
>  	int i;
> @@ -529,6 +530,12 @@ static int bmc150_accel_set_power_state(struct bmc150_accel_data *data, bool on)
>  
>  	return 0;
>  }
> +#else
> +static int bmc150_accel_set_power_state(struct bmc150_accel_data *data, bool on)
> +{
> +	return 0;
> +}
> +#endif
>  
>  static int bmc150_accel_set_scale(struct bmc150_accel_data *data, int val)
>  {
> 
