Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191Ab3GRRW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 13:22:28 -0400
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:59228 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758705Ab3GRRW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 13:22:27 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak5mADMk6FFV5qu1PGdsb2JhbABagwaDIoUjuH4EAYERFwMBAQEBODWCJAEBBScTHBMBDxAIAxgJJQ8FJQoaE4gUtjkWjjUngR0Hg3wDl1yGM4NwiF6BYTqBLA
X-IronPort-AV: E=Sophos;i="4.89,695,1367964000"; 
   d="scan'208";a="287145999"
From: rydberg@euromail.se
Date: Thu, 18 Jul 2013 19:23:21 +0200
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 44/51] Input: atmel_mxt_ts - Handle reports from T47
 Stylus object
Message-ID: <20130718172321.GH32381@polaris.bitmath.org>
References: <1372337366-9286-1-git-send-email-nick.dyer@itdev.co.uk>
 <1372337366-9286-45-git-send-email-nick.dyer@itdev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372337366-9286-45-git-send-email-nick.dyer@itdev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:49:19PM +0100, Nick Dyer wrote:
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> Acked-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index ee39683..ceb090a 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -128,6 +128,9 @@ struct t9_range {
>  /* Define for MXT_PROCI_TOUCHSUPPRESSION_T42 */
>  #define MXT_T42_MSG_TCHSUP	(1 << 0)
>  
> +/* T47 Stylus */
> +#define MXT_TOUCH_MAJOR_T47_STYLUS	1
> +

Ok - normally, creating dummy values is not recommended, but for the
shared touch/stylys implementation there is obviously no alternative.

>  /* T63 Stylus */
>  #define MXT_T63_STYLUS_PRESS	(1 << 0)
>  #define MXT_T63_STYLUS_RELEASE	(1 << 1)
> @@ -696,6 +699,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
>  	int area;
>  	int amplitude;
>  	u8 vector;
> +	int tool;
>  
>  	/* do not report events if input device not yet registered */
>  	if (!data->enable_reporting)
> @@ -713,6 +717,7 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
>  		y >>= 2;
>  
>  	area = message[5];
> +
>  	amplitude = message[6];
>  	vector = message[7];
>  
> @@ -741,8 +746,17 @@ static void mxt_proc_t9_message(struct mxt_data *data, u8 *message)
>  			mxt_input_sync(input_dev);
>  		}
>  
> +		/* A reported size of zero indicates that the reported touch
> +		 * is a stylus from a linked Stylus T47 object. */
> +		if (area == 0) {
> +			area = MXT_TOUCH_MAJOR_T47_STYLUS;
> +			tool = MT_TOOL_PEN;
> +		} else {
> +			tool = MT_TOOL_FINGER;
> +		}
> +
>  		/* Touch active */
> -		input_mt_report_slot_state(input_dev, MT_TOOL_FINGER, 1);
> +		input_mt_report_slot_state(input_dev, tool, 1);
>  		input_report_abs(input_dev, ABS_MT_POSITION_X, x);
>  		input_report_abs(input_dev, ABS_MT_POSITION_Y, y);
>  		input_report_abs(input_dev, ABS_MT_PRESSURE, amplitude);
> -- 
> 1.7.10.4
> 

    Reviewed-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
