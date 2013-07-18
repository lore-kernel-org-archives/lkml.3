Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab3GRRRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:17:16 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:34498 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394Ab3GRRRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:17:14 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak1mAPQi6FFV5qu1PGdsb2JhbABagwaDIoUjuH4EAYERFwMBAQEBODWCJAEBBAEnExwjBQsIAyElDwUlChoTiAoKtjQWjlyBHQeDDm4Dl1yGM4NwiQSBOzo
X-IronPort-AV: E=Sophos;i="4.89,695,1367964000"; 
   d="scan'208";a="583261671"
From: rydberg@euromail.se
Date: Thu, 18 Jul 2013 19:18:24 +0200
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 25/51] Input: atmel_mxt_ts - Handle multiple input
 reports in one message
Message-ID: <20130718171824.GD32381@polaris.bitmath.org>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-26-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372337366-9286-26-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Acked-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   34 +++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 5a16383..8632133 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -628,6 +628,12 @@ static void mxt_input_button(struct mxt_data *data, struct mxt_message *message)
>  	}
>  }
>  
> +static void mxt_input_sync(struct input_dev *input_dev)
> +{
> +	input_mt_report_pointer_emulation(input_dev, false);
> +	input_sync(input_dev);
> +}

Why not handle the enable_reporting and update_input logic here as
well? The logic is inconsistent with the rest of the patchset.

> +
>  static void mxt_input_touchevent(struct mxt_data *data,
>  				      struct mxt_message *message, int id)
>  {
> @@ -645,10 +651,12 @@ static void mxt_input_touchevent(struct mxt_data *data,
>  
>  	x = (message->message[1] << 4) | ((message->message[3] >> 4) & 0xf);
>  	y = (message->message[2] << 4) | ((message->message[3] & 0xf));
> +
> +	/* Handle 10/12 bit switching */
>  	if (data->max_x < 1024)
> -		x = x >> 2;
> +		x >>= 2;
>  	if (data->max_y < 1024)
> -		y = y >> 2;
> +		y >>= 2;

Unrelated changes.

>  
>  	area = message->message[4];
>  	amplitude = message->message[5];
> @@ -667,14 +675,26 @@ static void mxt_input_touchevent(struct mxt_data *data,
>  		x, y, area, amplitude);
>  
>  	input_mt_slot(input_dev, id);
> -	input_mt_report_slot_state(input_dev, MT_TOOL_FINGER,
> -				   status & MXT_T9_DETECT);
>  
>  	if (status & MXT_T9_DETECT) {
> +		/* Multiple bits may be set if the host is slow to read the
> +		 * status messages, indicating all the events that have
> +		 * happened */
> +		if (status & MXT_T9_RELEASE) {
> +			input_mt_report_slot_state(input_dev,
> +						   MT_TOOL_FINGER, 0);
> +			mxt_input_sync(input_dev);

What are the guarantees that nobody else expects the frame to not be
cut off here? What is the update_input state after this operation?

> +		}
> +
> +		/* Touch active */
> +		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 1);
>  		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
>  		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
>  		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
>  		input_report_abs(input_dev, ABS_MT_TOUCH_MAJOR, area);
> +	} else {
> +		/* Touch no longer active, close out slot */
> +		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 0);
>  	}
>  }
>  
> @@ -732,10 +752,8 @@ static irqreturn_t mxt_process_messages_until_invalid(struct mxt_data *data)
>  		}
>  	} while (reportid != 0xff);
>  
> -	if (data->enable_reporting && update_input) {
> -		input_mt_report_pointer_emulation(data->input_dev, false);
> -		input_sync(data->input_dev);
> -	}
> +	if (data->enable_reporting && update_input)
> +		mxt_input_sync(data->input_dev);
>  
>  	return IRQ_HANDLED;
>  }
> -- 
> 1.7.10.4
> 

Thanks,
Henrik
