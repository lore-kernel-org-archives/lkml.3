Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab3GRRTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:19:32 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:46871 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216Ab3GRRTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:19:20 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap1bAGEi6FFV5qu1PGdsb2JhbABagwY1gm2+IQQBgREXAwEBAQE4NYIkAQEEAScTHCMQCAMYCSUPBSUKGhOICgoItiwWjlyBHQeDDm4Dl1yBKoUJg3CKPzo
X-IronPort-AV: E=Sophos;i="4.89,695,1367964000"; 
   d="scan'208";a="361486792"
From: rydberg@euromail.se
Date: Thu, 18 Jul 2013 19:20:29 +0200
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 37/51] Input: atmel_mxt_ts - Implement vector/orientation
 support
Message-ID: <20130718172029.GF32381@polaris.bitmath.org>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-38-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372337366-9286-38-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:49:12PM +0100, Nick Dyer wrote:
> The atmel touch messages contain orientation information as a byte in a packed
> format which can be passed straight on to Android if the input device
> configuration is correct, see
> http://source.android.com/tech/input/touch-devices.html#touchorientationcalibration
> 
> This requires vector reports to be enabled in maXTouch config (zero DISVECT
> bit in T9 CTRL field)
> 
> Android converts the format in frameworks/base/services/input/Input.cpp,
> search for ORIENTATION_CALIBRATION_VECTOR.

How does this compare to the input mt documentation?

> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Acked-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 1c5e640..9188cf7 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -716,6 +716,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
>  	int y;
>  	int area;
>  	int amplitude;
> +	u8 vector;
>  
>  	/* do not report events if input device not yet registered */
>  	if (!data->enable_reporting)
> @@ -734,9 +735,10 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
>  
>  	area = message[5];
>  	amplitude = message[6];
> +	vector = message[7];
>  
>  	dev_dbg(dev,
> -		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u\n",
> +		"[%u] %c%c%c%c%c%c%c%c x: %5u y: %5u area: %3u amp: %3u vector: %02X\n",
>  		id,
>  		(status & MXT_T9_DETECT) ? 'D' : '.',
>  		(status & MXT_T9_PRESS) ? 'P' : '.',
> @@ -746,7 +748,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
>  		(status & MXT_T9_AMP) ? 'A' : '.',
>  		(status & MXT_T9_SUPPRESS) ? 'S' : '.',
>  		(status & MXT_T9_UNGRIP) ? 'U' : '.',
> -		x, y, area, amplitude);
> +		x, y, area, amplitude, vector);
>  
>  	input_mt_slot(input_dev, id);
>  
> @@ -766,6 +768,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
>  		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
>  		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
>  		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
> +		input_report_abs(input_dev, ABS_MT_ORIENTATION, vector);
>  	} else {
>  		/* Touch no longer active, close out slot */
>  		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
> @@ -2100,6 +2103,8 @@ static int mxt_initialize_t9_input_device(struct mxt_data *data)
>  			     0, data->max_y, 0, 0);
>  	input_set_abs_params(input_dev, ABS_MT_PRESSURE,
>  			     0, 255, 0, 0);
> +	input_set_abs_params(input_dev, ABS_MT_ORIENTATION,
> +			     0, 255, 0, 0);
>  
>  	input_set_drvdata(input_dev, data);
>  
> -- 
> 1.7.10.4
> 

Thanks,
Henrik
