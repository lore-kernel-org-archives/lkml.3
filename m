Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab3GSQRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 12:17:32 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43492 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3GSQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 12:17:30 -0400
X-Auth-Info: n3Q3heHxlcTxBo6P9swOVmn5AqR88Kku8PHB1u11C3U=
From: Marek Vasut <marex@denx.de>
To: Hector Palacios <hector.palacios@digi.com>
Subject: Re: [PATCH v2 5/5] iio: mxs-lradc: add write_raw function to modify scale
Date: Fri, 19 Jul 2013 18:17:26 +0200
User-Agent: KMail/1.13.7 (Linux/3.9-1-amd64; KDE/4.8.4; x86_64; ; )
Cc: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <201307191639.01240.marex@denx.de> <51E95BEC.5080703@digi.com>
In-Reply-To: <51E95BEC.5080703@digi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201307191817.27102.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Hector Palacios,

> Dear Marek,
> 
> On 07/19/2013 04:39 PM, Marek Vasut wrote:
> > Dear Hector Palacios,
> > 
> >> Added write_raw function to manipulate the optional divider_by_two
> >> through the scaling attribute out of the available scales.
> >> 
> >> Signed-off-by: Hector Palacios <hector.palacios@digi.com>
> >> ---
> >> 
> >>   drivers/staging/iio/adc/mxs-lradc.c | 55
> >> 
> >> ++++++++++++++++++++++++++++++++++++- 1 file changed, 54 insertions(+),
> >> 1 deletion(-)
> >> 
> >> diff --git a/drivers/staging/iio/adc/mxs-lradc.c
> >> b/drivers/staging/iio/adc/mxs-lradc.c index c929733..286cde2 100644
> >> --- a/drivers/staging/iio/adc/mxs-lradc.c
> >> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> >> @@ -144,6 +144,7 @@ struct mxs_lradc {
> >> 
> >>   	uint32_t		vref_mv[LRADC_MAX_TOTAL_CHANS];
> >>   	unsigned int		scale_avail[LRADC_MAX_TOTAL_CHANS][2][2];
> >> 
> >> +	unsigned int		is_divided[LRADC_MAX_TOTAL_CHANS];
> > 
> > Why not use bitfield ? ;-)
> 
> This is used in some math below and an unsigned int looked more
> appropriate:
> 
> 	case IIO_CHAN_INFO_SCALE:
> 		*val = lradc->vref_mv[chan->channel];
> 		*val2 = chan->scan_type.realbits -
> 			lradc->is_divided[chan->channel];
> 		ret = IIO_VAL_FRACTIONAL_LOG2;
> 		break;

Oh ok.

> >>   	/*
> >>   	
> >>   	 * Touchscreen LRADC channels receives a private slot in the CTRL4
> >> 
> >> @@ -202,6 +203,7 @@ struct mxs_lradc {
> >> 
> >>   #define	LRADC_CTRL1_LRADC_IRQ_OFFSET		0
> >>   
> >>   #define	LRADC_CTRL2				0x20
> >> 
> >> +#define	LRADC_CTRL2_DIVIDE_BY_TWO_OFFSET	24
> >> 
> >>   #define	LRADC_CTRL2_TEMPSENSE_PWD		(1 << 15)
> >>   
> >>   #define	LRADC_STATUS				0x40
> >> 
> >> @@ -310,7 +312,8 @@ static int mxs_lradc_read_raw(struct iio_dev
> >> *iio_dev,
> >> 
> >>   		break;
> >>   	
> >>   	case IIO_CHAN_INFO_SCALE:
> >>   		*val = lradc->vref_mv[chan->channel];
> >> 
> >> -		*val2 = chan->scan_type.realbits;
> >> +		*val2 = chan->scan_type.realbits -
> >> +			lradc->is_divided[chan->channel];
> >> 
> >>   		ret = IIO_VAL_FRACTIONAL_LOG2;
> >>   		break;
> >>   	
> >>   	default:
> >> @@ -323,6 +326,54 @@ static int mxs_lradc_read_raw(struct iio_dev
> >> *iio_dev,
> >> 
> >>   	return ret;
> >>   
> >>   }
> >> 
> >> +static int mxs_lradc_write_raw(struct iio_dev *iio_dev,
> >> +			       const struct iio_chan_spec *chan,
> >> +			       int val, int val2, long m)
> >> +{
> >> +	struct mxs_lradc *lradc = iio_priv(iio_dev);
> >> +	int ret;
> >> +
> >> +	ret = mutex_trylock(&lradc->lock);
> >> +	if (!ret)
> >> +		return -EBUSY;
> >> +
> >> +	switch (m) {
> >> +	case IIO_CHAN_INFO_SCALE:
> >> +		ret = -EINVAL;
> >> +		if (val == lradc->scale_avail[chan->channel][0][0] &&
> >> +		    val2 == lradc->scale_avail[chan->channel][0][1]) {
> >> +			/* [0] -> divider by two disabled */
> > 
> > This comment is confusing, you use [0] in different dimensions of the
> > array. So is the stuff below.
> > 
> > Still, how does this even work, can you show me and example how to set
> > the divider from userland ? Sorry, I'm a bit confused with this
> > 3D-business here, even if the comment in previous patch made it a bit
> > clearer. Actually you can use some #define to specify if you're
> > accessing div/2 or div/1 portion of the array to make it more readable.
> > 
> > Like ... scale_avail[chan->channel][LRADC_DIV_BY_2][LRADC_DECIMAL_PART]
> > ... would by nice.
> 
> Agreed.
> 
> How it works:
> # cd /sys/devices/80000000.apb/80040000.apbx/80050000.lradc/iio:device0
> 
> Here you have three entries per channel:
> in_voltageX_raw		-> the sample raw value
> in_voltageX_scale	-> the scale to multiply the raw value to get the 
voltage
> in mV in_voltageX_scale_available -> lists the available scales of the
> channel
> 
> For example for channel 0:
> 
> # cat in_voltage0_scale_available
> 0.451660156 0.903320312	(two scales available, first with divider by two
> disabled, second with divider by two enabled)
> 
> # cat in_voltage0_scale
> 0.451660156			(divider by two is currently disabled)
> 
> # cat in_voltage0_raw		(shows measured value)
> 1000
> 
> If you multiply the value by the scale you get: 1000 * 0.451660156 = 451.6
> mV
> 
> # echo 0.903320312 > in_voltage0_scale	(enables the divider by two)

Ok, so I have to remember this value : '0.903320312' in case I want to enable 
divide-by-two functionality? Hmmmm ... why would this interface not work:

echo 2 > in_voltage0_scale

or 

echo 1 > in_voltage0_scale

?

> # cat in_voltage0_raw		(shows measured value)
> 500
> 
> Voltage at channel is the same but now measured value is applying the scale
> so it shows half the value than before. Now if you multiply: 500 *
> 0.903320312 = 451.6 mV (the same voltage but you now have a bigger scale
> and can measure up to 3.7V).
> 
> Other channels (like 10 on the MX28) will show different scales because of
> fixed predividers.
> The multi-dimension array is needed to store the big decimal number.

Yes, understood. Thanks for the explanation, it really helped!
