Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486AbaIAPg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:36:29 -0400
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:55587 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754022AbaIAPg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:36:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2559:2562:2693:2828:2914:3138:3139:3140:3141:3142:3353:3622:3865:3867:3871:3872:3874:4250:4321:5007:7652:7875:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12296:12438:12517:12519:12740:13161:13229:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: balls30_722fa2329d416
X-Filterd-Recvd-Size: 3121
Message-ID: <1409585783.2664.18.camel@joe-AO725>
Subject: Re: [PATCH v3 3/3] iio: accel: BMC150: add support for other Bosch
 chips
From: Joe Perches <joe@perches.com>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 01 Sep 2014 08:36:23 -0700
In-Reply-To: <1409562698-13202-1-git-send-email-laurentiu.palcu@intel.com>
References: <1409301488-22166-4-git-send-email-laurentiu.palcu@intel.com>
	 <1409562698-13202-1-git-send-email-laurentiu.palcu@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-01 at 12:11 +0300, Laurentiu Palcu wrote:
> The following chips are either similar or have only the resolution
> different. Hence, change this driver to support these chips too:
> 
> BMI055  - combo chip (accelerometer part is identical to BMC150's)
> BMA255  - identical to BMC150's accelerometer
> BMA222E - 8 bit resolution
> BMA250E - 10 bit resolution
> BMA280  - 14 bit resolution
> 
> Additionally:
>  * add bmc150_accel_match_acpi_device() function to check that the device
>    has been enumerated through ACPI;
>  * rename bmc150_accel_acpi_gpio_probe() to bmc150_accel_gpio_probe()
>    since the ACPI matching has been moved to the new function.  Also, this
>    will allow for the GPIO matching to be done against a device tree too, not only
>    ACPI tree;
[]
> diff --git a/drivers/iio/accel/bmc150-accel.c b/drivers/iio/accel/bmc150-accel.c
[]
> @@ -647,12 +659,13 @@ static int bmc150_accel_read_raw(struct iio_dev *indio_dev,
>  		{
>  			int i;
>  
> -			for (i = 0; i < ARRAY_SIZE(bmc150_accel_scale_table);
> -									 ++i) {
> -				if (bmc150_accel_scale_table[i].range ==
> +			for (i = 0;
> +			     i < ARRAY_SIZE(data->chip_info->scale_table);
> +			     ++i) {
> +				if (data->chip_info->scale_table[i].range ==
>  								data->range) {
>  					*val2 =
> -					bmc150_accel_scale_table[i].scale;
> +					data->chip_info->scale_table[i].scale;
>  					return IIO_VAL_INT_PLUS_MICRO;
>  				}
>  			}

This looks like it would read a lot better with
a temporary for data->chip_info->scale_table[i]

so these could become:

			for (i = 0; i < etc; i++) {
				type *temp = &data->chip_info->scale_table[i];
				if (temp->range == data->range) {
					*val2 = temp->scale;
					return IIO_VAL_INT_PLUS_MICRO;
				}

Maybe all the bmc150_ variable names could be removed.
The prefixes don't seem to serve a purpose other than
to make the code longer.

The filename could be changed to be more generic.


