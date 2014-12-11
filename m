Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964991AbaLKPWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:22:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933874AbaLKPWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:22:40 -0500
Date: Thu, 11 Dec 2014 10:22:25 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] HID: logitech-hidpp: do not return the name length
Message-ID: <20141211152225.GC29747@mail.corp.redhat.com>
References: <1418302280-14794-1-git-send-email-peter@lekensteyn.nl>
 <1418302280-14794-2-git-send-email-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418302280-14794-2-git-send-email-peter@lekensteyn.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11 2014 or thereabouts, Peter Wu wrote:
> We do not make any use of the actual name length get through
> hidpp_get_device_name(). Original patch by Benjamin Tissoires, this
> patch also replaces a (now) unnecessary goto by return NULL.
> 
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Thanks for the v2 Peter.

Cheers,
Benjamin

>  drivers/hid/hid-logitech-hidpp.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index 1a6395d..5066df8 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -461,7 +461,7 @@ static int hidpp_devicenametype_get_device_name(struct hidpp_device *hidpp,
>  	return count;
>  }
>  
> -static char *hidpp_get_device_name(struct hidpp_device *hidpp, u8 *name_length)
> +static char *hidpp_get_device_name(struct hidpp_device *hidpp)
>  {
>  	u8 feature_type;
>  	u8 feature_index;
> @@ -473,28 +473,23 @@ static char *hidpp_get_device_name(struct hidpp_device *hidpp, u8 *name_length)
>  	ret = hidpp_root_get_feature(hidpp, HIDPP_PAGE_GET_DEVICE_NAME_TYPE,
>  		&feature_index, &feature_type);
>  	if (ret)
> -		goto out_err;
> +		return NULL;
>  
>  	ret = hidpp_devicenametype_get_count(hidpp, feature_index,
>  		&__name_length);
>  	if (ret)
> -		goto out_err;
> +		return NULL;
>  
>  	name = kzalloc(__name_length + 1, GFP_KERNEL);
>  	if (!name)
> -		goto out_err;
> +		return NULL;
>  
> -	*name_length = __name_length + 1;
>  	while (index < __name_length)
>  		index += hidpp_devicenametype_get_device_name(hidpp,
>  			feature_index, index, name + index,
>  			__name_length - index);
>  
>  	return name;
> -
> -out_err:
> -	*name_length = 0;
> -	return NULL;
>  }
>  
>  /* -------------------------------------------------------------------------- */
> @@ -989,7 +984,6 @@ static void hidpp_overwrite_name(struct hid_device *hdev, bool use_unifying)
>  {
>  	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
>  	char *name;
> -	u8 name_length;
>  
>  	if (use_unifying)
>  		/*
> @@ -999,7 +993,7 @@ static void hidpp_overwrite_name(struct hid_device *hdev, bool use_unifying)
>  		 */
>  		name = hidpp_get_unifying_name(hidpp);
>  	else
> -		name = hidpp_get_device_name(hidpp, &name_length);
> +		name = hidpp_get_device_name(hidpp);
>  
>  	if (!name)
>  		hid_err(hdev, "unable to retrieve the name of the device");
> @@ -1053,7 +1047,6 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
>  	bool connected = atomic_read(&hidpp->connected);
>  	struct input_dev *input;
>  	char *name, *devm_name;
> -	u8 name_length;
>  
>  	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
>  		wtp_connect(hdev, connected);
> @@ -1080,7 +1073,7 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
>  		return;
>  	}
>  
> -	name = hidpp_get_device_name(hidpp, &name_length);
> +	name = hidpp_get_device_name(hidpp);
>  	if (!name) {
>  		hid_err(hdev, "unable to retrieve the name of the device");
>  	} else {
> -- 
> 2.1.3
> 
