Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaGZMFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 08:05:42 -0400
Received: from aso-006-i453.relay.mailchannels.net ([23.91.64.134]:24805 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751168AbaGZMFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 08:05:40 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
Message-ID: <1406376331.2611.3.camel@fedora-lan>
Subject: Re: [PATCH 11/10] Input - wacom: Check for bluetooth protocol while
 setting OLEDs
From: Przemo Firszt <przemo@firszt.eu>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Date: Sat, 26 Jul 2014 13:05:31 +0100
In-Reply-To: <1406330411-7851-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
	 <1406330411-7851-1-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-AuthUser: przemo@firszt.eu
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whole series (after including bt image fix):
Tested-By: Przemo Firszt <przemo@firszt.eu>

Dnia 2014-07-25, pią o godzinie 19:20 -0400, Benjamin Tissoires pisze:
> Bluetooth Intuos 4 use 1-bit definition while the USB ones use a 4-bits
> definition. This changes the size of the raw image we receive, and thus
> the kernel will only accept 1-bit images for Bluetooth and 4-bits for
> USB.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/wacom_sys.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> index 3adc6ef..42f139f 100644
> --- a/drivers/hid/wacom_sys.c
> +++ b/drivers/hid/wacom_sys.c
> @@ -531,12 +531,14 @@ static int wacom_led_control(struct wacom *wacom)
>  	return retval;
>  }
>  
> -static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *img)
> +static int wacom_led_putimage(struct wacom *wacom, int button_id,
> +		const unsigned len, const void *img)
>  {
>  	unsigned char *buf;
>  	int i, retval;
> +	const unsigned chunk_len = len / 4; /* 4 chunks are needed to be sent */
>  
> -	buf = kzalloc(259, GFP_KERNEL);
> +	buf = kzalloc(chunk_len + 3 , GFP_KERNEL);
>  	if (!buf)
>  		return -ENOMEM;
>  
> @@ -552,11 +554,11 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id, const void *im
>  	buf[1] = button_id & 0x07;
>  	for (i = 0; i < 4; i++) {
>  		buf[2] = i;
> -		memcpy(buf + 3, img + i * 256, 256);
> +		memcpy(buf + 3, img + i * chunk_len, chunk_len);
>  
>  		retval = wacom_set_report(wacom->hdev, HID_FEATURE_REPORT,
>  					  WAC_CMD_ICON_XFER,
> -					  buf, 259, WAC_CMD_RETRIES);
> +					  buf, chunk_len + 3, WAC_CMD_RETRIES);
>  		if (retval < 0)
>  			break;
>  	}
> @@ -657,13 +659,14 @@ static ssize_t wacom_button_image_store(struct device *dev, int button_id,
>  	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
>  	struct wacom *wacom = hid_get_drvdata(hdev);
>  	int err;
> +	const unsigned len = hdev->bus == BUS_BLUETOOTH ? 256 : 1024;
>  
> -	if (count != 1024)
> +	if (count != len)
>  		return -EINVAL;
>  
>  	mutex_lock(&wacom->lock);
>  
> -	err = wacom_led_putimage(wacom, button_id, buf);
> +	err = wacom_led_putimage(wacom, button_id, len, buf);
>  
>  	mutex_unlock(&wacom->lock);
>  

-- 
Kind regards,
Przemo Firszt


