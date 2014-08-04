Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaHDKko (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:40:44 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17750 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaHDKkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:40:42 -0400
Date: Mon, 4 Aug 2014 13:40:16 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.chehab@samsung.com
Subject: Re: [PATCHv2] staging: media: as102: replace custom dprintk() with
 dev_dbg()
Message-ID: <20140804104016.GQ4804@mwanda>
References: <20140804091023.GP4856@mwanda>
 <1407147434-27732-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407147434-27732-1-git-send-email-martink@posteo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On thinking about it some more the proper way to redo this would have
been to remove the bogus check.  Also a couple trivial things below.

On Mon, Aug 04, 2014 at 12:17:14PM +0200, Martin Kepplinger wrote:
> @@ -82,10 +83,17 @@ static int as102_fe_get_tune_settings(struct dvb_frontend *fe,
>  			struct dvb_frontend_tune_settings *settings) {
>  
>  #if 0
> -	dprintk(debug, "step_size    = %d\n", settings->step_size);
> -	dprintk(debug, "max_drift    = %d\n", settings->max_drift);
> -	dprintk(debug, "min_delay_ms = %d -> %d\n", settings->min_delay_ms,
> -		1000);
> +	struct as102_dev_t *dev;
> +
> +	dev = (struct as102_dev_t *) fe->tuner_priv;
> +	if (dev == NULL)
> +		return -EINVAL;

This doesn't make sense.  Why are we crapping out just because we can't
print some useless debug info?

Debugging code annoys me because of stuff like this.  Debugging code is
buggier than normal code because it never gets tested.  It complicates
the code.  People think they are helping when they add lots of debug
code, but normally they are just making the situation worse.

Also it bloats the kernel a bit.

Just remove this whole block because it is ifdef 0.

> +	dev_dbg(&dev->bus_adap.usb_dev->dev,
> +		"step_size    = %d\n", settings->step_size);
> +	dev_dbg(&dev->bus_adap.usb_dev->dev,
> +		"max_drift    = %d\n", settings->max_drift);
> +	dev_dbg(&dev->bus_adap.usb_dev->dev,
> +		"min_delay_ms = %d -> %d\n", settings->min_delay_ms, 1000);
>  #endif
>  
>  	settings->min_delay_ms = 1000;
> @@ -141,10 +151,10 @@ static int as102_fe_read_status(struct dvb_frontend *fe, fe_status_t *status)
>  		if (as10x_cmd_get_demod_stats(&dev->bus_adap,
>  			(struct as10x_demod_stats *) &dev->demod_stats) < 0) {
>  			memset(&dev->demod_stats, 0, sizeof(dev->demod_stats));
> -			dprintk(debug,
> -				"as10x_cmd_get_demod_stats failed (probably not tuned)\n");
> +			dev_dbg(&dev->bus_adap.usb_dev->dev,
> +			"as10x_cmd_get_demod_stats failed (probably not tuned)\n");

This isn't indented correctly.

>  		} else {
> -			dprintk(debug,
> +			dev_dbg(&dev->bus_adap.usb_dev->dev,
>  				"demod status: fc: 0x%08x, bad fc: 0x%08x, "
>  				"bytes corrected: 0x%08x , MER: 0x%04x\n",
>  				dev->demod_stats.frame_count,
> @@ -447,6 +457,15 @@ static uint8_t as102_fe_get_code_rate(fe_code_rate_t arg)
>  static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
>  			  struct dtv_frontend_properties *params)
>  {
> +	struct dvb_frontend *fe;
> +	struct as102_dev_t *dev;
> +
> +	fe = container_of(params, struct dvb_frontend, dtv_property_cache);
> +	dev = (struct as102_dev_t *) fe->tuner_priv;
> +	if (dev == NULL)
> +		pr_err("as102: No device found\n");

This condition is never true.  Don't add tests if you know the answer.

> +	else
> +		dev_err(&dev->bus_adap.usb_dev->dev, "No device found\n");
>  
>  	/* set frequency */
>  	tune_args->freq = params->frequency / 1000;
> @@ -531,10 +550,18 @@ static void as102_fe_copy_tune_parameters(struct as10x_tune_args *tune_args,
>  		break;
>  	}
>  
> -	dprintk(debug, "tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
> +	if (dev) {
> +		dev_dbg(&dev->bus_adap.usb_dev->dev,
> +		"tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
> +			params->frequency,
> +			tune_args->bandwidth,
> +			tune_args->guard_interval);
> +	} else {
> +	pr_debug("as102: tuner parameters: freq: %d  bw: 0x%02x  gi: 0x%02x\n",
>  			params->frequency,
>  			tune_args->bandwidth,
>  			tune_args->guard_interval);
> +	}


This isn't indented correctly.  I wish checkpatch.pl would catch that...
Anyway, the else side can be removed as explained earlier.

regards,
dan carpenter
