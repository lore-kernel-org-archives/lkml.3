Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbbAANx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 08:53:58 -0500
Received: from mout.gmx.net ([212.227.15.18]:59562 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbbAANxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 08:53:55 -0500
Message-ID: <54A5516D.5050209@gmx.de>
Date: Thu, 01 Jan 2015 14:53:49 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH 09/10] iio: imu: kmx61: Drop odr_bits from
 kmx61_samp_freq_table
References: <1419340953-23161-1-git-send-email-daniel.baluta@intel.com> <1419340953-23161-10-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1419340953-23161-10-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V03:K0:Fr4RRyLce8Su9pf1KDSpihyH7C58MkbQqbFUZbC+uQpa90dMI51
 qMxzFaeCfVBSS94NWnvcoJimZWAdPACtN/KJ4H3MXFWPAib+75e5lO6CmTobxL1uFt7UaVs
 3UR+XtOe/DIX8OSE4z2KrpXfHs3wA9IK5xWk6MNSEUzECYH34a+e9u67ksoMUBCyLrvIfIj
 kVEq4KnH8iFUK0v+cbCNw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 23.12.2014 um 14:22:
> odr_bits values are between 0 and 11, so we can use the index
> in kmx61_samp_freq_table instead of odr_bits structure member.
Basically looking good, but I would feel more comfortable to check
against the boundaries of the table. Please see inline.

> 
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
> ---
>  drivers/iio/imu/kmx61.c | 64 ++++++++++++++++++++-----------------------------
>  1 file changed, 26 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index eb3900e..98369eb 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -169,19 +169,18 @@ u16 kmx61_uscale_table[] = {9582, 19163, 38326};
>  static const struct {
>  	int val;
>  	int val2;
> -	u8 odr_bits;
> -} kmx61_samp_freq_table[] = { {12, 500000, 0x00},
> -			{25, 0, 0x01},
> -			{50, 0, 0x02},
> -			{100, 0, 0x03},
> -			{200, 0, 0x04},
> -			{400, 0, 0x05},
> -			{800, 0, 0x06},
> -			{1600, 0, 0x07},
> -			{0, 781000, 0x08},
> -			{1, 563000, 0x09},
> -			{3, 125000, 0x0A},
> -			{6, 250000, 0x0B} };
> +} kmx61_samp_freq_table[] = { {12, 500000},
> +			{25, 0},
> +			{50, 0},
> +			{100, 0},
> +			{200, 0},
> +			{400, 0},
> +			{800, 0},
> +			{1600, 0},
> +			{0, 781000},
> +			{1, 563000},
> +			{3, 125000},
> +			{6, 250000} };
>  
>  static const struct {
>  	int val;
> @@ -302,24 +301,10 @@ static int kmx61_convert_freq_to_bit(int val, int val2)
>  	for (i = 0; i < ARRAY_SIZE(kmx61_samp_freq_table); i++)
>  		if (val == kmx61_samp_freq_table[i].val &&
>  		    val2 == kmx61_samp_freq_table[i].val2)
> -			return kmx61_samp_freq_table[i].odr_bits;
> -	return -EINVAL;
> -}
> -
> -static int kmx61_convert_bit_to_freq(u8 odr_bits, int *val, int *val2)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(kmx61_samp_freq_table); i++)
> -		if (odr_bits == kmx61_samp_freq_table[i].odr_bits) {
> -			*val = kmx61_samp_freq_table[i].val;
> -			*val2 = kmx61_samp_freq_table[i].val2;
> -			return 0;
> -		}
> +			return i;
>  	return -EINVAL;
>  }
>  
> -
>  static int kmx61_convert_wake_up_odr_to_bit(int val, int val2)
>  {
>  	int i;
> @@ -478,7 +463,7 @@ static int kmx61_set_odr(struct kmx61_data *data, int val, int val2, u8 device)
>  
>  static int kmx61_get_odr(struct kmx61_data *data, int *val, int *val2,
>  			 u8 device)
> -{	int i;
> +{
>  	u8 lodr_bits;
>  
>  	if (device & KMX61_ACC)
> @@ -490,13 +475,13 @@ static int kmx61_get_odr(struct kmx61_data *data, int *val, int *val2,
>  	else
>  		return -EINVAL;
>  
> -	for (i = 0; i < ARRAY_SIZE(kmx61_samp_freq_table); i++)
> -		if (lodr_bits == kmx61_samp_freq_table[i].odr_bits) {
> -			*val = kmx61_samp_freq_table[i].val;
> -			*val2 = kmx61_samp_freq_table[i].val2;
> -			return 0;
> -		}
> -	return -EINVAL;
> +	if (lodr_bits > 0xB)
Since we use it as an index, I regard it safer to check against
ARRAY_SIZE(kmx61_samp_freq_table) rather than a fix value.

> +		return -EINVAL;
> +
> +	*val = kmx61_samp_freq_table[lodr_bits].val;
> +	*val2 = kmx61_samp_freq_table[lodr_bits].val2;
> +
> +	return 0;
>  }
>  
>  static int kmx61_set_range(struct kmx61_data *data, u8 range)
> @@ -580,8 +565,11 @@ static int kmx61_chip_init(struct kmx61_data *data)
>  	}
>  	data->odr_bits = ret;
>  
> -	/* set output data rate for wake up (motion detection) function */
> -	ret = kmx61_convert_bit_to_freq(data->odr_bits, &val, &val2);
> +	/*
> +	 * set output data rate for wake up (motion detection) function
> +	 * to match data rate for accelerometer sampling
> +	 */
> +	ret = kmx61_get_odr(data, &val, &val2, KMX61_ACC);
>  	if (ret < 0)
>  		return ret;
>  
> 

