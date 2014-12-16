Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaLPXeN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:34:13 -0500
Received: from lekensteyn.nl ([178.21.112.251]:49248 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaLPXeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:34:12 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] HID: logitech-hidpp: bail out if wtp_connect fails
Date: Wed, 17 Dec 2014 00:33:55 +0100
Message-ID: <1771836.oYfhfEolNx@al>
User-Agent: KMail/4.14.3 (Linux/3.17.0-rc4-custom-00168-g7ec62d4; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2014 17:06:01 Benjamin Tissoires wrote:
> If wtp_connect() fails, that means most of the time that the device has
> been disconnected. Subsequent attempts to contact the device will fail
> too, so it's simpler to bail out earlier.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-logitech-hidpp.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index d008d71..c0fb5fe 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -914,24 +914,24 @@ static int wtp_allocate(struct hid_device *hdev, const struct hid_device_id *id)
>  	return 0;
>  };
>  
> -static void wtp_connect(struct hid_device *hdev, bool connected)
> +static int wtp_connect(struct hid_device *hdev, bool connected)
>  {
>  	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
>  	struct wtp_data *wd = hidpp->private_data;
>  	int ret;
>  
>  	if (!connected)
> -		return;
> +		return 0;

"0" is success, what about -1 or -ENODEV here to signal an error? The
following line (in hidpp_connect_event) returns on !connected, but that
is no reason to return 0 here.

("No connection" sounds like an error condition to me as "[wtp_]connect"
cannot do something meaningful.)

Whether or not you change the return value is up to you. This patch is
Reviewed-by: Peter Wu <peter@lekensteyn.nl>

Kind regards,
Peter

>  	if (!wd->x_size) {
>  		ret = wtp_get_config(hidpp);
>  		if (ret) {
>  			hid_err(hdev, "Can not get wtp config: %d\n", ret);
> -			return;
> +			return ret;
>  		}
>  	}
>  
> -	hidpp_touchpad_set_raw_report_state(hidpp, wd->mt_feature_index,
> +	return hidpp_touchpad_set_raw_report_state(hidpp, wd->mt_feature_index,
>  			true, true);
>  }
>  
> @@ -1115,8 +1115,11 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
>  	struct input_dev *input;
>  	char *name, *devm_name;
>  
> -	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
> -		wtp_connect(hdev, connected);
> +	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
> +		ret = wtp_connect(hdev, connected);
> +		if (ret)
> +			return;
> +	}
>  
>  	if (!connected || hidpp->delayed_input)
>  		return;
> 

