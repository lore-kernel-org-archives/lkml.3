Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965979Ab3GSFkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:40:47 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43066 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965646Ab3GSFkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:40:45 -0400
Date: Thu, 18 Jul 2013 22:40:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: Re: [ 37/72] Input: bcm5974 - add support for the 2013 MacBook Air
Message-ID: <20130719054040.GA20435@core.coreip.homeip.net>
References: <20130719052559.852627424@linuxfoundation.org>
 <20130719052602.400119106@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130719052602.400119106@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Thu, Jul 18, 2013 at 10:25:54PM -0700, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dmitry Torokhov <rydberg@euromail.se>

Any chance you could change this to read "Henrik Rydberg"? My import
script messed up. And on hid part as well...

Thanks!

> 
> commit 148c1c8ad3c4170186ebe6ea5900adde27d2a0e7 upstream.
> 
> The June 2013 Macbook Air (13'') has a new trackpad protocol; four new
> values are inserted in the header, and the mode switch is no longer
> needed. This patch adds support for the new devices.
> 
> Reported-and-tested-by: Brad Ford <plymouthffl@gmail.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/input/mouse/bcm5974.c |   36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
> 
> --- a/drivers/input/mouse/bcm5974.c
> +++ b/drivers/input/mouse/bcm5974.c
> @@ -88,6 +88,10 @@
>  #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ANSI	0x0259
>  #define USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO	0x025a
>  #define USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS	0x025b
> +/* MacbookAir6,2 (unibody, June 2013) */
> +#define USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI	0x0291
> +#define USB_DEVICE_ID_APPLE_WELLSPRING8_ISO	0x0292
> +#define USB_DEVICE_ID_APPLE_WELLSPRING8_JIS	0x0293
>  
>  #define BCM5974_DEVICE(prod) {					\
>  	.match_flags = (USB_DEVICE_ID_MATCH_DEVICE |		\
> @@ -145,6 +149,10 @@ static const struct usb_device_id bcm597
>  	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_ANSI),
>  	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_ISO),
>  	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING7A_JIS),
> +	/* MacbookAir6,2 */
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI),
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8_ISO),
> +	BCM5974_DEVICE(USB_DEVICE_ID_APPLE_WELLSPRING8_JIS),
>  	/* Terminating entry */
>  	{}
>  };
> @@ -172,15 +180,18 @@ struct bt_data {
>  /* trackpad header types */
>  enum tp_type {
>  	TYPE1,			/* plain trackpad */
> -	TYPE2			/* button integrated in trackpad */
> +	TYPE2,			/* button integrated in trackpad */
> +	TYPE3			/* additional header fields since June 2013 */
>  };
>  
>  /* trackpad finger data offsets, le16-aligned */
>  #define FINGER_TYPE1		(13 * sizeof(__le16))
>  #define FINGER_TYPE2		(15 * sizeof(__le16))
> +#define FINGER_TYPE3		(19 * sizeof(__le16))
>  
>  /* trackpad button data offsets */
>  #define BUTTON_TYPE2		15
> +#define BUTTON_TYPE3		23
>  
>  /* list of device capability bits */
>  #define HAS_INTEGRATED_BUTTON	1
> @@ -400,6 +411,19 @@ static const struct bcm5974_config bcm59
>  		{ SN_COORD, -150, 6730 },
>  		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
>  	},
> +	{
> +		USB_DEVICE_ID_APPLE_WELLSPRING8_ANSI,
> +		USB_DEVICE_ID_APPLE_WELLSPRING8_ISO,
> +		USB_DEVICE_ID_APPLE_WELLSPRING8_JIS,
> +		HAS_INTEGRATED_BUTTON,
> +		0, sizeof(struct bt_data),
> +		0x83, TYPE3, FINGER_TYPE3, FINGER_TYPE3 + SIZEOF_ALL_FINGERS,
> +		{ SN_PRESSURE, 0, 300 },
> +		{ SN_WIDTH, 0, 2048 },
> +		{ SN_COORD, -4620, 5140 },
> +		{ SN_COORD, -150, 6600 },
> +		{ SN_ORIENT, -MAX_FINGER_ORIENTATION, MAX_FINGER_ORIENTATION }
> +	},
>  	{}
>  };
>  
> @@ -557,6 +581,9 @@ static int report_tp_state(struct bcm597
>  		input_report_key(input, BTN_LEFT, ibt);
>  	}
>  
> +	if (c->tp_type == TYPE3)
> +		input_report_key(input, BTN_LEFT, dev->tp_data[BUTTON_TYPE3]);
> +
>  	input_sync(input);
>  
>  	return 0;
> @@ -572,9 +599,14 @@ static int report_tp_state(struct bcm597
>  
>  static int bcm5974_wellspring_mode(struct bcm5974 *dev, bool on)
>  {
> -	char *data = kmalloc(8, GFP_KERNEL);
>  	int retval = 0, size;
> +	char *data;
> +
> +	/* Type 3 does not require a mode switch */
> +	if (dev->cfg.tp_type == TYPE3)
> +		return 0;
>  
> +	data = kmalloc(8, GFP_KERNEL);
>  	if (!data) {
>  		dev_err(&dev->intf->dev, "out of memory\n");
>  		retval = -ENOMEM;
> 
> 

-- 
Dmitry
