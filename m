Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaLQPa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:30:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaLQPa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:30:56 -0500
Date: Wed, 17 Dec 2014 10:30:39 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] HID: logitech-hidpp: detect HID++ 2.0 errors too
Message-ID: <20141217153039.GB16047@mail.corp.redhat.com>
References: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl>
 <1418691016-30681-2-git-send-email-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1418691016-30681-2-git-send-email-peter@lekensteyn.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 16 2014 or thereabouts, Peter Wu wrote:
> Devices speaking HID++ 2.0 report a different error code (0xff). Detect
> these errors too to avoid 5 second delays when the device reports an
> error. Caught by... well, a bug in the QEMU emulation of this receiver.
> 
> Renamed fap to rap for HID++ 1.0 errors because it is more logical,
> it has no functional difference.
> 
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---

Jiri, it looks like this one fall off from your radar.

It's not a problem per-se, I'd like to have some feedbacks from Logitech
first, but still, there is a bug and Peter fixed it :)

Cheers,
Benjamin

>  drivers/hid/hid-logitech-hidpp.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index 2f420c0..ae23dec 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -105,6 +105,7 @@ struct hidpp_device {
>  };
>  
>  
> +/* HID++ 1.0 error codes */
>  #define HIDPP_ERROR				0x8f
>  #define HIDPP_ERROR_SUCCESS			0x00
>  #define HIDPP_ERROR_INVALID_SUBID		0x01
> @@ -119,6 +120,8 @@ struct hidpp_device {
>  #define HIDPP_ERROR_REQUEST_UNAVAILABLE		0x0a
>  #define HIDPP_ERROR_INVALID_PARAM_VALUE		0x0b
>  #define HIDPP_ERROR_WRONG_PIN_CODE		0x0c
> +/* HID++ 2.0 error codes */
> +#define HIDPP20_ERROR				0xff
>  
>  static void hidpp_connect_event(struct hidpp_device *hidpp_dev);
>  
> @@ -192,9 +195,16 @@ static int hidpp_send_message_sync(struct hidpp_device *hidpp,
>  	}
>  
>  	if (response->report_id == REPORT_ID_HIDPP_SHORT &&
> -	    response->fap.feature_index == HIDPP_ERROR) {
> +	    response->rap.sub_id == HIDPP_ERROR) {
> +		ret = response->rap.params[1];
> +		dbg_hid("%s:got hidpp error %02X\n", __func__, ret);
> +		goto exit;
> +	}
> +
> +	if (response->report_id == REPORT_ID_HIDPP_LONG &&
> +	    response->fap.feature_index == HIDPP20_ERROR) {
>  		ret = response->fap.params[1];
> -		dbg_hid("__hidpp_send_report got hidpp error %02X\n", ret);
> +		dbg_hid("%s:got hidpp 2.0 error %02X\n", __func__, ret);
>  		goto exit;
>  	}
>  
> @@ -271,7 +281,8 @@ static inline bool hidpp_match_answer(struct hidpp_report *question,
>  static inline bool hidpp_match_error(struct hidpp_report *question,
>  		struct hidpp_report *answer)
>  {
> -	return (answer->fap.feature_index == HIDPP_ERROR) &&
> +	return ((answer->rap.sub_id == HIDPP_ERROR) ||
> +	    (answer->fap.feature_index == HIDPP20_ERROR)) &&
>  	    (answer->fap.funcindex_clientid == question->fap.feature_index) &&
>  	    (answer->fap.params[0] == question->fap.funcindex_clientid);
>  }
> -- 
> 2.1.3
> 
