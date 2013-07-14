Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3GNVOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 17:14:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43642 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3GNVOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 17:14:10 -0400
Date: Sun, 14 Jul 2013 23:14:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Honza Brazdil <jbrazdil@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: kye: Add report fixup for Genius Gx Imperator
 Keyboard
In-Reply-To: <1373633613-4947-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1307142313220.29788@pobox.suse.cz>
References: <1373633613-4947-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013, Benjamin Tissoires wrote:

> Genius Gx Imperator Keyboard presents the same problem in its report
> descriptors than Genius Gila Gaming Mouse.
> Use the same fixup for both.
> 
> Fixes:
> https://bugzilla.redhat.com/show_bug.cgi?id=928561
> 
> Reported-and-tested-by: Honza Brazdil <jbrazdil@redhat.com>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> Hi Jiri,
> 
> I have been reported this broken Genius device too.
> The patch applies on top of the branch for-3.11/upstream, but feel free to
> schedule it for 3.11 or 3.12. This time, only the multimedia (and macros) keys
> are broken. The core keyboard part is working fine without the patch.
> 
> Cheers,
> Benjamin
> 
>  drivers/hid/hid-ids.h |  1 +
>  drivers/hid/hid-kye.c | 45 ++++++++++++++++++++++++++++-----------------
>  2 files changed, 29 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index b2b692e..1f28df9 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -475,6 +475,7 @@
>  #define USB_VENDOR_ID_KYE		0x0458
>  #define USB_DEVICE_ID_KYE_ERGO_525V	0x0087
>  #define USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE	0x0138
> +#define USB_DEVICE_ID_GENIUS_GX_IMPERATOR	0x4018
>  #define USB_DEVICE_ID_KYE_GPEN_560	0x5003
>  #define USB_DEVICE_ID_KYE_EASYPEN_I405X	0x5010
>  #define USB_DEVICE_ID_KYE_MOUSEPEN_I608X	0x5011
> diff --git a/drivers/hid/hid-kye.c b/drivers/hid/hid-kye.c
> index 1e2ee2aa..7384512 100644
> --- a/drivers/hid/hid-kye.c
> +++ b/drivers/hid/hid-kye.c
> @@ -268,6 +268,26 @@ static __u8 easypen_m610x_rdesc_fixed[] = {
>  	0xC0                          /*  End Collection                  */
>  };
>  
> +static __u8 *kye_consumer_control_fixup(struct hid_device *hdev, __u8 *rdesc,
> +		unsigned int *rsize, int offset, const char *device_name) {
> +	/*
> +	 * the fixup that need to be done:
> +	 *   - change Usage Maximum in the Comsumer Control
> +	 *     (report ID 3) to a reasonable value
> +	 */
> +	if (*rsize >= offset + 31 &&
> +	    /* Usage Page (Consumer Devices) */
> +	    rdesc[offset] == 0x05 && rdesc[offset + 1] == 0x0c &&
> +	    /* Usage (Consumer Control) */
> +	    rdesc[offset + 2] == 0x09 && rdesc[offset + 3] == 0x01 &&
> +	    /*   Usage Maximum > 12287 */
> +	    rdesc[offset + 10] == 0x2a && rdesc[offset + 12] > 0x2f) {
> +		hid_info(hdev, "fixing up %s report descriptor\n", device_name);
> +		rdesc[offset + 12] = 0x2f;
> +	}
> +	return rdesc;
> +}
> +
>  static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>  		unsigned int *rsize)
>  {
> @@ -315,23 +335,12 @@ static __u8 *kye_report_fixup(struct hid_device *hdev, __u8 *rdesc,
>  		}
>  		break;
>  	case USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE:
> -		/*
> -		 * the fixup that need to be done:
> -		 *   - change Usage Maximum in the Comsumer Control
> -		 *     (report ID 3) to a reasonable value
> -		 */
> -		if (*rsize >= 135 &&
> -			/* Usage Page (Consumer Devices) */
> -			rdesc[104] == 0x05 && rdesc[105] == 0x0c &&
> -			/* Usage (Consumer Control) */
> -			rdesc[106] == 0x09 && rdesc[107] == 0x01 &&
> -			/*   Usage Maximum > 12287 */
> -			rdesc[114] == 0x2a && rdesc[116] > 0x2f) {
> -			hid_info(hdev,
> -				 "fixing up Genius Gila Gaming Mouse "
> -				 "report descriptor\n");
> -			rdesc[116] = 0x2f;
> -		}
> +		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 104,
> +					"Genius Gila Gaming Mouse");
> +		break;
> +	case USB_DEVICE_ID_GENIUS_GX_IMPERATOR:
> +		rdesc = kye_consumer_control_fixup(hdev, rdesc, rsize, 83,
> +					"Genius Gx Imperator Keyboard");
>  		break;
>  	}
>  	return rdesc;
> @@ -428,6 +437,8 @@ static const struct hid_device_id kye_devices[] = {
>  				USB_DEVICE_ID_KYE_EASYPEN_M610X) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
>  				USB_DEVICE_ID_GENIUS_GILA_GAMING_MOUSE) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_KYE,
> +				USB_DEVICE_ID_GENIUS_GX_IMPERATOR) },
>  	{ }
>  };

Hi Benjamin,

I guess you are missing update of hid_have_special_driver[] list?

-- 
Jiri Kosina
SUSE Labs
