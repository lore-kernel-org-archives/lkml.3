Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3A1O7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:59:20 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:58559 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3A1O7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:59:16 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtdHAByRBlFV5qjOPGdsb2JhbABEin6zWhcDAQEBATg0gh4BAQQBJxMcIwULCAMhJQ8FDRgKGhOHfwMJCrYCDYlVFYt7hDRhA5Q3gVWFe4NSgWqICg
X-IronPort-AV: E=Sophos;i="4.84,552,1355094000"; 
   d="scan'208";a="488900824"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 28 Jan 2013 16:04:29 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/25] HID: break out hid_extract_field
Message-ID: <20130128150429.GA3465@polaris.bitmath.org>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
 <1359120190-18281-2-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359120190-18281-2-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Breaking out this function allows third parties hid drivers to retrieve
> the data fields of a hid report in the raw_event callback.
> 
> No functional changes, only exports the function.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-core.c | 60 ++++++++++++++++++++++++++++++++++----------------
>  include/linux/hid.h    |  1 +
>  2 files changed, 42 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 5ae2cb1..ea478f5 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -962,6 +962,45 @@ static void implement(const struct hid_device *hid, __u8 *report,
>  }
>  
>  /*
> + * Extract and allocate a data field from a little endian report (bit array).
> + */
> +
> +s32 *hid_extract_field(const struct hid_device *hid, struct hid_field *field,
> +		       __u8 *data)
> +{
> +	unsigned n;
> +	unsigned count = field->report_count;
> +	unsigned offset = field->report_offset;
> +	unsigned size = field->report_size;
> +	__s32 min = field->logical_minimum;
> +	__s32 max = field->logical_maximum;
> +	__s32 *value;
> +
> +	value = kmalloc(sizeof(__s32) * count, GFP_ATOMIC);
> +	if (!value)
> +		return value;
> +
> +	for (n = 0; n < count; n++) {
> +
> +		value[n] = min < 0 ?
> +			snto32(extract(hid, data, offset + n * size, size),
> +			       size) :
> +			extract(hid, data, offset + n * size, size);
> +
> +		/* Ignore report if ErrorRollOver */
> +		if (!(field->flags & HID_MAIN_ITEM_VARIABLE) &&
> +		    value[n] >= min && value[n] <= max &&
> +		    field->usage[value[n] - min].hid == HID_UP_KEYBOARD + 1) {
> +			kfree(value);
> +			return NULL;
> +		}
> +	}
> +
> +	return value;
> +}
> +EXPORT_SYMBOL_GPL(hid_extract_field);
> +

I would rather see the extensive use of malloc go away than extend its
usage to drivers.

Thanks,
Henrik
