Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbbAEXBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:01:04 -0500
Received: from mout.gmx.net ([212.227.15.19]:54374 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbbAEXBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:01:01 -0500
Message-ID: <54AB179F.8020206@gmx.de>
Date: Tue, 06 Jan 2015 00:00:47 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, jic23@kernel.org
CC: lars@metafoo.de, pmeerw@pmeerw.net, srinivas.pandruvada@linux.intel.com,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: imu: kmx61: Drop odr_bits from
 kmx61_samp_freq_table
References: <1420449702-2085-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1420449702-2085-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:H1y6WxAEsShAXyCVzIwNBJuPH22HsV7pOCj5jOOdbLdY5kS8UVz
 yzgakxwImhSTr0GfSpUt+ZPFHJX0Wjheb7fxI0Ef9bvAWFJCsG+nFYgUDe2OnE8yk84ydHE
 47CgoLuRqk5lqS8KMiMUmMlbj9RWRWIlS5B2sT+BU5REtkyS0mX8vfRbWxpNtRS6Mehrhui
 uHpbEHnjnJ2VpisyVkK5Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Baluta schrieb am 05.01.2015 um 10:21:
> odr_bits values are between 0 and 11, so we can use the index
> in kmx61_samp_freq_table instead of odr_bits structure member.
> 
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Reviewed-by: Hartmut Knaack <knaack.h@gmx.de>
> ---
> Changes since v1:
> 	* use ARRAY_SIZE instead of an hardcoded value
> 	* review is at: https://lkml.org/lkml/2015/1/1/46
> 
>  drivers/iio/imu/kmx61.c | 64 ++++++++++++++++++++-----------------------------
>  1 file changed, 26 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
> index b60b22d..a32ddbb 100644
> --- a/drivers/iio/imu/kmx61.c
> +++ b/drivers/iio/imu/kmx61.c
> @@ -169,19 +169,18 @@ static const u16 kmx61_uscale_table[] = {9582, 19163, 38326};
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
> +	if (lodr_bits >= ARRAY_SIZE(kmx61_samp_freq_table))
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

