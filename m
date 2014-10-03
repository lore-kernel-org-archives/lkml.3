Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaJCVZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaJCVZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:25:46 -0400
Date: Fri, 3 Oct 2014 17:25:33 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] HID: rmi: Scan the report descriptor to determine if the
 device is suitable for the hid-rmi driver
Message-ID: <20141003212533.GC23710@mail.corp.redhat.com>
References: <1412273720-4431-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1412273720-4431-1-git-send-email-aduggan@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Oct 02 2014 or thereabouts, Andrew Duggan wrote:
> On composite HID devices there may be multiple HID devices on separate interfaces, but hid-rmi
> should only bind to the touchpad. Commit e19ff99f256aeeff6c07b373e01883b72e049552 simply checked
> that the interface protocol was set to mouse. Unfortuately, it is not always the case that the
> touchpad has the mouse interface protocol set. This patch takes a different approach and scans
> the report descriptor looking for the Vendor Specific Top Level Collection and the associated
> usages and report IDs needed by the hid-rmi driver to interface with the device.

I am going to leave for XDC 2014 next week and then I'll have one week
off, so I prefer sending my impressions now (or it will have to wait 2
more weeks).

I am not sure this solution is sustainable in the long term. If every
driver starts checking each vendor collection in core, there is no point
in having core and drivers separated.
Unfortunately, I can not think of an easier way of doing it. So I think
(but Jiri can choose to ignore me) that we should at least hold this
until 3.19 development starts.

One or two more comments inlined:

> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---
>  drivers/hid/hid-core.c | 42 +++++++++++++++++++++++++++++++++++++-----
>  include/linux/hid.h    |  8 +++++++-
>  2 files changed, 44 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 12b6e67..498f674 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -686,6 +686,23 @@ static void hid_scan_input_usage(struct hid_parser *parser, u32 usage)
>  
>  	if (usage == HID_DG_CONTACTID)
>  		hid->group = HID_GROUP_MULTITOUCH;
> +
> +	if (usage == 0xff000004 && parser->global.report_id == 0xb)
> +		parser->scan_flags |= HID_SCAN_FLAG_RMI_INPUT_READ;
> +
> +	if (usage == 0xff000005 && parser->global.report_id == 0xc)
> +		parser->scan_flags |= HID_SCAN_FLAG_RMI_ATTN;
> +}
> +
> +static void hid_scan_output_usage(struct hid_parser *parser, u32 usage)
> +{
> +	struct hid_device *hid = parser->device;
> +
> +	if (usage == 0xff000002 && parser->global.report_id == 0x9)
> +		parser->scan_flags |= HID_SCAN_FLAG_RMI_WRITE;
> +
> +	if (usage == 0xff000003 && parser->global.report_id == 0xa)
> +		parser->scan_flags |= HID_SCAN_FLAG_RMI_OUTPUT_READ;
>  }
>  
>  static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
> @@ -693,6 +710,9 @@ static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
>  	if (usage == 0xff0000c5 && parser->global.report_count == 256 &&
>  	    parser->global.report_size == 8)
>  		parser->scan_flags |= HID_SCAN_FLAG_MT_WIN_8;
> +
> +	if (usage == 0xff000006 && parser->global.report_id == 0xf)
> +		parser->scan_flags |= HID_SCAN_FLAG_RMI_MODE;
>  }
>  
>  static void hid_scan_collection(struct hid_parser *parser, unsigned type)
> @@ -702,6 +722,9 @@ static void hid_scan_collection(struct hid_parser *parser, unsigned type)
>  	if (((parser->global.usage_page << 16) == HID_UP_SENSOR) &&
>  	    type == HID_COLLECTION_PHYSICAL)
>  		hid->group = HID_GROUP_SENSOR_HUB;
> +
> +	if ((parser->global.usage_page << 16) == HID_UP_MSVENDOR)
> +		parser->scan_flags |= HID_SCAN_FLAG_VENDOR_SPECIFIC;
>  }
>  
>  static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
> @@ -725,6 +748,10 @@ static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
>  			hid_scan_input_usage(parser, parser->local.usage[i]);
>  		break;
>  	case HID_MAIN_ITEM_TAG_OUTPUT:
> +		if (data & HID_MAIN_ITEM_CONSTANT)
> +			break;
> +		for (i = 0; i < parser->local.usage_index; i++)
> +			hid_scan_output_usage(parser, parser->local.usage[i]);
>  		break;
>  	case HID_MAIN_ITEM_TAG_FEATURE:
>  		for (i = 0; i < parser->local.usage_index; i++)
> @@ -783,11 +810,16 @@ static int hid_scan_report(struct hid_device *hid)
>  	* Vendor specific handlings
>  	*/
>  	if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
> -	    (hid->group == HID_GROUP_GENERIC) &&
> -	    /* only bind to the mouse interface of composite USB devices */
> -	    (hid->bus != BUS_USB || hid->type == HID_TYPE_USBMOUSE))
> -		/* hid-rmi should take care of them, not hid-generic */
> -		hid->group = HID_GROUP_RMI;
> +	    (hid->group == HID_GROUP_GENERIC)) {
> +		if ((parser->scan_flags & HID_SCAN_FLAG_VENDOR_SPECIFIC)
> +			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_WRITE)
> +			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_INPUT_READ)
> +			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_OUTPUT_READ)
> +			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_ATTN)
> +			&& (parser->scan_flags & HID_SCAN_FLAG_RMI_MODE))

Maybe you should consider defining:
#define HID_SCAN_FLAGS_RMI HID_SCAN_FLAG_VENDOR_SPECIFIC | \
			   HID_SCAN_FLAG_RMI_WRITE | \
			   HID_SCAN_FLAG_RMI_INPUT_READ | \
			   HID_SCAN_FLAG_RMI_OUTPUT_READ | \
			   HID_SCAN_FLAG_RMI_ATTN | \
			   HID_SCAN_FLAG_RMI_MODE

and then just test:
if ((parser->scan_flags & HID_SCAN_FLAGS_RMI) == HID_SCAN_FLAGS_RMI)

> +			/* hid-rmi should take care of them, not hid-generic */
> +			hid->group = HID_GROUP_RMI;
> +	}
>  
>  	/*
>  	 * Vendor specific handlings
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index f53c4a9..82d1f82 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -547,7 +547,13 @@ static inline void hid_set_drvdata(struct hid_device *hdev, void *data)
>  #define HID_GLOBAL_STACK_SIZE 4
>  #define HID_COLLECTION_STACK_SIZE 4
>  
> -#define HID_SCAN_FLAG_MT_WIN_8			0x00000001
> +#define HID_SCAN_FLAG_MT_WIN_8			BIT(0)
> +#define HID_SCAN_FLAG_VENDOR_SPECIFIC		BIT(1)
> +#define HID_SCAN_FLAG_RMI_WRITE			BIT(2)
> +#define HID_SCAN_FLAG_RMI_INPUT_READ		BIT(3)
> +#define HID_SCAN_FLAG_RMI_OUTPUT_READ		BIT(3)
I guess this one should be BIT(4) and the two after should be shifted by
one too.
> +#define HID_SCAN_FLAG_RMI_ATTN			BIT(4)
> +#define HID_SCAN_FLAG_RMI_MODE			BIT(5)
>  
>  struct hid_parser {
>  	struct hid_global     global;
> -- 
> 1.9.1
> 

Cheers,
Benjamin
