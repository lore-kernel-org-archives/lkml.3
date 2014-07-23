Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607AbaGWUsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:48:53 -0400
Received: from mail.kernel.org ([198.145.19.201]:34821 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaGWUsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:48:51 -0400
Message-ID: <53D02040.1030005@kernel.org>
Date: Wed, 23 Jul 2014 21:51:12 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atalax.net>, linux-iio@vger.kernel.org
CC: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net,
        dan.carpenter@oracle.com, lars@metafoo.de
Subject: Re: [PATCH v5 (staging-next) 3/5] staging:iio:hmc5843: register <->
 value arrays now can have different lengths
References: <20140722150009.GA7845@dashie> <20140722150214.GD7845@dashie>
In-Reply-To: <20140722150214.GD7845@dashie>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 16:02, Josef Gajdusek wrote:
> Changed structure of struct hmc5843_chip_info to include length of translation
> arrays. Code previously using #defined constant has been changed accordingly.
> This allows to integrate devices which do have different amounts of available
> rates/scales.
>
> Signed-off-by: Josef Gajdusek <atx@atx.name>
Applied to the togreg branch of iio.git - initially pushed out as testing.
> ---
>   drivers/staging/iio/magnetometer/hmc5843_core.c | 34 +++++++++++++++++--------
>   1 file changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/staging/iio/magnetometer/hmc5843_core.c b/drivers/staging/iio/magnetometer/hmc5843_core.c
> index bdeaf43..08fb0be 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843_core.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843_core.c
> @@ -39,7 +39,6 @@
>    */
>   #define HMC5843_RANGE_GAIN_OFFSET		0x05
>   #define HMC5843_RANGE_GAIN_DEFAULT		0x01
> -#define HMC5843_RANGE_GAINS			8
>   #define HMC5843_RANGE_GAIN_MASK		0xe0
>
>   /* Device status */
> @@ -59,7 +58,6 @@
>    */
>   #define HMC5843_RATE_OFFSET			0x02
>   #define HMC5843_RATE_DEFAULT			0x04
> -#define HMC5843_RATES				7
>   #define HMC5843_RATE_MASK		0x1c
>
>   /* Device measurement configuration */
> @@ -69,15 +67,15 @@
>   #define HMC5843_MEAS_CONF_MASK			0x03
>
>   /* Scaling factors: 10000000/Gain */
> -static const int hmc5843_regval_to_nanoscale[HMC5843_RANGE_GAINS] = {
> +static const int hmc5843_regval_to_nanoscale[] = {
>   	6173, 7692, 10309, 12821, 18868, 21739, 25641, 35714
>   };
>
> -static const int hmc5883_regval_to_nanoscale[HMC5843_RANGE_GAINS] = {
> +static const int hmc5883_regval_to_nanoscale[] = {
>   	7812, 9766, 13021, 16287, 24096, 27701, 32573, 45662
>   };
>
> -static const int hmc5883l_regval_to_nanoscale[HMC5843_RANGE_GAINS] = {
> +static const int hmc5883l_regval_to_nanoscale[] = {
>   	7299, 9174, 12195, 15152, 22727, 25641, 30303, 43478
>   };
>
> @@ -94,11 +92,11 @@ static const int hmc5883l_regval_to_nanoscale[HMC5843_RANGE_GAINS] = {
>    * 6		| 50			| 75
>    * 7		| Not used		| Not used
>    */
> -static const int hmc5843_regval_to_samp_freq[7][2] = {
> +static const int hmc5843_regval_to_samp_freq[][2] = {
>   	{0, 500000}, {1, 0}, {2, 0}, {5, 0}, {10, 0}, {20, 0}, {50, 0}
>   };
>
> -static const int hmc5883_regval_to_samp_freq[7][2] = {
> +static const int hmc5883_regval_to_samp_freq[][2] = {
>   	{0, 750000}, {1, 500000}, {3, 0}, {7, 500000}, {15, 0}, {30, 0},
>   	{75, 0}
>   };
> @@ -107,7 +105,9 @@ static const int hmc5883_regval_to_samp_freq[7][2] = {
>   struct hmc5843_chip_info {
>   	const struct iio_chan_spec *channels;
>   	const int (*regval_to_samp_freq)[2];
> +	const int n_regval_to_samp_freq;
>   	const int *regval_to_nanoscale;
> +	const int n_regval_to_nanoscale;
>   };
>
>   /* The lower two bits contain the current conversion mode */
> @@ -248,7 +248,7 @@ static ssize_t hmc5843_show_samp_freq_avail(struct device *dev,
>   	size_t len = 0;
>   	int i;
>
> -	for (i = 0; i < HMC5843_RATES; i++)
> +	for (i = 0; i < data->variant->n_regval_to_samp_freq; i++)
>   		len += scnprintf(buf + len, PAGE_SIZE - len,
>   			"%d.%d ", data->variant->regval_to_samp_freq[i][0],
>   			data->variant->regval_to_samp_freq[i][1]);
> @@ -278,7 +278,7 @@ static int hmc5843_get_samp_freq_index(struct hmc5843_data *data,
>   {
>   	int i;
>
> -	for (i = 0; i < HMC5843_RATES; i++)
> +	for (i = 0; i < data->variant->n_regval_to_samp_freq; i++)
>   		if (val == data->variant->regval_to_samp_freq[i][0] &&
>   			val2 == data->variant->regval_to_samp_freq[i][1])
>   			return i;
> @@ -307,7 +307,7 @@ static ssize_t hmc5843_show_scale_avail(struct device *dev,
>   	size_t len = 0;
>   	int i;
>
> -	for (i = 0; i < HMC5843_RANGE_GAINS; i++)
> +	for (i = 0; i < data->variant->n_regval_to_nanoscale; i++)
>   		len += scnprintf(buf + len, PAGE_SIZE - len,
>   			"0.%09d ", data->variant->regval_to_nanoscale[i]);
>
> @@ -327,7 +327,7 @@ static int hmc5843_get_scale_index(struct hmc5843_data *data, int val, int val2)
>   	if (val != 0)
>   		return -EINVAL;
>
> -	for (i = 0; i < HMC5843_RANGE_GAINS; i++)
> +	for (i = 0; i < data->variant->n_regval_to_nanoscale; i++)
>   		if (val2 == data->variant->regval_to_nanoscale[i])
>   			return i;
>
> @@ -480,17 +480,29 @@ static const struct hmc5843_chip_info hmc5843_chip_info_tbl[] = {
>   	[HMC5843_ID] = {
>   		.channels = hmc5843_channels,
>   		.regval_to_samp_freq = hmc5843_regval_to_samp_freq,
> +		.n_regval_to_samp_freq =
> +				ARRAY_SIZE(hmc5843_regval_to_samp_freq),
>   		.regval_to_nanoscale = hmc5843_regval_to_nanoscale,
> +		.n_regval_to_nanoscale =
> +				ARRAY_SIZE(hmc5843_regval_to_nanoscale),
>   	},
>   	[HMC5883_ID] = {
>   		.channels = hmc5883_channels,
>   		.regval_to_samp_freq = hmc5883_regval_to_samp_freq,
> +		.n_regval_to_samp_freq =
> +				ARRAY_SIZE(hmc5883_regval_to_samp_freq),
>   		.regval_to_nanoscale = hmc5883_regval_to_nanoscale,
> +		.n_regval_to_nanoscale =
> +				ARRAY_SIZE(hmc5883_regval_to_nanoscale),
>   	},
>   	[HMC5883L_ID] = {
>   		.channels = hmc5883_channels,
>   		.regval_to_samp_freq = hmc5883_regval_to_samp_freq,
> +		.n_regval_to_samp_freq =
> +				ARRAY_SIZE(hmc5883_regval_to_samp_freq),
>   		.regval_to_nanoscale = hmc5883l_regval_to_nanoscale,
> +		.n_regval_to_nanoscale =
> +				ARRAY_SIZE(hmc5883l_regval_to_nanoscale),
>   	},
>   };
>
>

