Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaLIASM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 19:18:12 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:45763 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751030AbaLIASK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 19:18:10 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Mon, 08 Dec 2014 16:42:15 -0800
Message-ID: <54863F72.1060401@synaptics.com>
Date: Mon, 8 Dec 2014 16:16:50 -0800
From: Andrew Duggan <aduggan@synaptics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: Re: [PATCH v2] HID: rmi: Scan the report descriptor to determine
 if the device is suitable for the hid-rmi driver
References: <1416872246-9632-1-git-send-email-aduggan@synaptics.com>
In-Reply-To: <1416872246-9632-1-git-send-email-aduggan@synaptics.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.4.10.98]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 03:37 PM, Andrew Duggan wrote:
> On composite HID devices there may be multiple HID devices on separate interfaces, but hid-rmi
> should only bind to the touchpad. The previous version simply checked that the interface protocol
> was set to mouse. Unfortuately, it is not always the case that the touchpad has the mouse interface
> protocol set. This patch takes a different approach and scans the report descriptor looking for
> the Generic Desktop Pointer usage and the Vendor Specific Top Level Collection needed by the
> hid-rmi driver to interface with the device.
>
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---
> This is a second attempt at the patch I submitted back in October. Instead of looking for specific
> HID reports this patch looks for the Generic Desktop Pointer usage. Having that usage along with
> the vendor specific collection seems to be a distinctive enough to id the Synaptics touchpad in
> the composite USB device.
Any comments on this patch?

Thanks,
Andrew
>   drivers/hid/hid-core.c | 21 ++++++++++++++++-----
>   include/linux/hid.h    |  4 +++-
>   2 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 12b6e67..ba9dc59 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -698,10 +698,20 @@ static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
>   static void hid_scan_collection(struct hid_parser *parser, unsigned type)
>   {
>   	struct hid_device *hid = parser->device;
> +	int i;
>   
>   	if (((parser->global.usage_page << 16) == HID_UP_SENSOR) &&
>   	    type == HID_COLLECTION_PHYSICAL)
>   		hid->group = HID_GROUP_SENSOR_HUB;
> +
> +	if ((parser->global.usage_page << 16) == HID_UP_GENDESK)
> +		for (i = 0; i < parser->local.usage_index; i++)
> +			if (parser->local.usage[i] == HID_GD_POINTER)
> +				parser->scan_flags
> +					|= HID_SCAN_FLAG_GENDESK_POINTER;
> +
> +	if ((parser->global.usage_page << 16) == HID_UP_MSVENDOR)
> +		parser->scan_flags |= HID_SCAN_FLAG_VENDOR_SPECIFIC;
>   }
>   
>   static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
> @@ -783,11 +793,12 @@ static int hid_scan_report(struct hid_device *hid)
>   	* Vendor specific handlings
>   	*/
>   	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
> -	    (hid->group == HID_GROUP_GENERIC) &&
> -	    /* only bind to the mouse interface of composite USB devices */
> -	    (hid->bus != BUS_USB || hid->type == HID_TYPE_USBMOUSE))
> -		/* hid-rmi should take care of them, not hid-generic */
> -		hid->group = HID_GROUP_RMI;
> +	    (hid->group == HID_GROUP_GENERIC)) {
> +		if ((parser->scan_flags & HID_SCAN_FLAG_VENDOR_SPECIFIC)
> +		    && (parser->scan_flags & HID_SCAN_FLAG_GENDESK_POINTER))
> +			/* hid-rmi should take care of them, not hid-generic */
> +			hid->group = HID_GROUP_RMI;
> +	}
>   
>   	/*
>   	 * Vendor specific handlings
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index f53c4a9..b019f15 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -547,7 +547,9 @@ static inline void hid_set_drvdata(struct hid_device *hdev, void *data)
>   #define HID_GLOBAL_STACK_SIZE 4
>   #define HID_COLLECTION_STACK_SIZE 4
>   
> -#define HID_SCAN_FLAG_MT_WIN_8			0x00000001
> +#define HID_SCAN_FLAG_MT_WIN_8			BIT(0)
> +#define HID_SCAN_FLAG_VENDOR_SPECIFIC		BIT(1)
> +#define HID_SCAN_FLAG_GENDESK_POINTER		BIT(2)
>   
>   struct hid_parser {
>   	struct hid_global     global;

