Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab3HMSip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 14:38:45 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:34707 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756886Ab3HMSim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 14:38:42 -0400
Message-ID: <520A7CDF.3070808@ahsoftware.de>
Date: Tue, 13 Aug 2013 20:37:19 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
CC: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: Re: [PATCH 1/3] HID: Use existing parser for pre-scanning the report
 descriptors
References: <1376405889-12378-1-git-send-email-benjamin.tissoires@redhat.com> <1376405889-12378-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1376405889-12378-2-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.08.2013 16:58, schrieb Benjamin Tissoires:
> hid_scan_report() implements its own HID report descriptor parsing. It was
> fine until we added the SENSOR_HUB detection. It is going to be even worse
> with the detection of Win 8 certified touchscreen, as this detection
> relies on a special feature and on the report_size and report_count fields.

Sorry, but I can't agree with your wording here.

If you look at the if expression I've added to support HID sensor hubs, 
you will notice that the first expression was a test for the usage page 
of sensor hubs. That wasn't the first test by accident, instead I've 
choosen the order of those 4 tests very carefully to make the impact on 
the existing parsing of other HID devices very small. So it might not 
have be pleasing to your eyes, but it was for sure an appropriate solution.

Anyway, I've tested your patch 1/3 on top of 3.11-rc5 here and the 
detection of sensor hubs doesn't work anymore with your patch applied. 
Up to now I only had a quick look at it, but it looks like the test in 
hid_scan_open_collection() isn't hit for my device.

Another problem is that I don't have any commercial sensor hub and I'm 
therefor not a very relvant as tester (I've implemented the firmware for 
my HID (sensor hub) device too). Therefor I've added Srinivas Pandruvada 
to cc, because he's the only one I know who has HID sensor hubs.

And, as said, I've implemented the other side here too, therefor I've 
added the descriptor I'm using below.

Regards,

Alexander Holler


--my-descriptor--
	0x05, 0x20, // HID_USAGE_PAGE_SENSOR
	0xa1, 0x01, // COLLECTION (Application)
		0x09, 0xa0, // HID_USAGE_SENSOR_CATEGORY_TIME
		0xa1, 0x00, // COLLECTION (Physical)
#ifndef USE_FULL_YEAR
			0x75, 0x08, // REPORT_SIZE (8 bits)
#endif
			0x95, 0x01, // REPORT_COUNT (1)
			0x85, HID_REPORT_ID_TIME, // REPORT_ID

			0x0a, 0x21, 0x05, // USAGE (Year)
#ifdef USE_FULL_YEAR
			0x75, 0x10, // REPORT_SIZE (16 bits)
#else
			0x15, 0x00, // LOGICAL_MINIMUM (0) (Range is currently not specified 
in HUTRR39)
			0x25, 0x63, // LOGICAL_MAXIMUM (99)
#endif
			0x65, 0x00, // UNIT (None)
			0x81, 0x02, // INPUT (Data,Var,Abs)

			0x0a, 0x22, 0x05, // USAGE (Month)
#ifdef USE_FULL_YEAR
			0x75, 0x08, // REPORT_SIZE (8 bits)
#endif
			0x15, 0x01, // LOGICAL_MINIMUM (1)
			0x25, 0x0c, // LOGICAL_MAXIMUM (12)
			0x65, 0x00, // UNIT (None)
			0x81, 0x02, // INPUT (Data,Var,Abs)

			0x0a, 0x23, 0x05, // USAGE (Day)
			0x15, 0x01, // LOGICAL_MINIMUM (1)
			0x25, 0x1f, // LOGICAL_MAXIMUM (31)
			0x65, 0x00, // UNIT (None)
			0x81, 0x02, // INPUT (Data,Var,Abs)

			0x0a, 0x24, 0x05, // USAGE (Day of Week)
			0x15, 0x00, // LOGICAL_MINIMUM (0)
			0x25, 0x06, // LOGICAL_MAXIMUM (6)
			0xa1, 0x02, // COLLECTION (Logical)
				0x0a, 0xc0, 0x08, // Day of Week: Sunday
				0x0a, 0xc1, 0x08, // Day of Week: Monday
				0x0a, 0xc2, 0x08, // Day of Week: Tuesday
				0x0a, 0xc3, 0x08, // Day of Week: Wednesday
				0x0a, 0xc4, 0x08, // Day of Week: Thursday
				0x0a, 0xc5, 0x08, // Day of Week: Friday
				0x0a, 0xc6, 0x08, // Day of Week: Saturday
				0x81, 0x02, // INPUT (Const,Arr,Abs)
			0xc0, // END_COLLECTION

			0x0a, 0x25, 0x05, // USAGE (Hour)
			0x15, 0x00, // LOGICAL_MINIMUM (0)
			0x25, 0x17, // LOGICAL_MAXIMUM (23)
			0x65, 0x00, // UNIT (None)
			0x81, 0x02, // INPUT (Data,Var,Abs)

			0x0a, 0x26, 0x05, // USAGE (Minute)
			0x15, 0x00, // LOGICAL_MINIMUM (0)
			0x25, 0x3b, // LOGICAL_MAXIMUM (59)
			0x65, 0x00, // UNIT (None)
			0x81, 0x02, // INPUT (Data,Var,Abs)

			0x0a, 0x27, 0x05, // USAGE (Second)
			0x15, 0x00, // LOGICAL_MINIMUM (0)
			0x25, 0x3b, // LOGICAL_MAXIMUM (59)
			0x65, 0x00, // UNIT (None)
			//0x66, 0x10, 0x01, // UNIT (second)
			0x81, 0x02, // INPUT (Data,Var,Abs)

			0x0a, 0x28, 0x05, // USAGE (Millisecond)
			0x75, 0x10, // REPORT_SIZE (16 bits)
			0x65, 0x00, // UNIT (None)
			0x81, 0x02, // INPUT (Data,Var,Abs)

		0xc0, // END_COLLECTION
	0xc0, // END_COLLECTION
--my-descriptor--

>
> We can use the existing HID parser in hid-core for hid_scan_report()
> by re-using the code from hid_open_report(). hid_parser_global,
> hid_parser_local and hid_parser_reserved does not have any side effects.
> We just need to reimplement the MAIN_ITEM callback to have a proper
> parsing without side effects.
>
> Instead of directly overwriting the ->group field, this patch introduce
> a ->flags field and then decide which group the device belongs to,
> depending on the whole parsing (not just the local item). This will be
> useful for Win 8 multitouch devices, which are multitouch devices and
> Win 8 certified (so 2 flags to check).
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>   drivers/hid/hid-core.c | 131 +++++++++++++++++++++++++++++++++++--------------
>   include/linux/hid.h    |   4 ++
>   2 files changed, 97 insertions(+), 38 deletions(-)
>
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 3efe19f..d8cdb0a 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -677,10 +677,49 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
>   	return NULL;
>   }
>
> -static void hid_scan_usage(struct hid_device *hid, u32 usage)
> +static void hid_scan_input_usage(struct hid_parser *parser, u32 usage)
>   {
>   	if (usage == HID_DG_CONTACTID)
> -		hid->group = HID_GROUP_MULTITOUCH;
> +		parser->flags |= HID_FLAG_MULTITOUCH;
> +}
> +
> +static void hid_scan_open_collection(struct hid_parser *parser, unsigned type)
> +{
> +	if (parser->global.usage_page == HID_UP_SENSOR &&
> +	    type == HID_COLLECTION_PHYSICAL)
> +		parser->flags |= HID_FLAG_SENSOR_HUB;
> +}
> +
> +static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
> +{
> +	__u32 data;
> +	int i;
> +
> +	data = item_udata(item);
> +
> +	switch (item->tag) {
> +	case HID_MAIN_ITEM_TAG_BEGIN_COLLECTION:
> +		hid_scan_open_collection(parser, data & 0xff);
> +		break;
> +	case HID_MAIN_ITEM_TAG_END_COLLECTION:
> +		break;
> +	case HID_MAIN_ITEM_TAG_INPUT:
> +		for (i = 0; i < parser->local.usage_index; i++)
> +			hid_scan_input_usage(parser, parser->local.usage[i]);
> +		break;
> +	case HID_MAIN_ITEM_TAG_OUTPUT:
> +		break;
> +	case HID_MAIN_ITEM_TAG_FEATURE:
> +		break;
> +	default:
> +		hid_err(parser->device, "unknown main item tag 0x%x\n",
> +			item->tag);
> +	}
> +
> +	/* Reset the local parser environment */
> +	memset(&parser->local, 0, sizeof(parser->local));
> +
> +	return 0;
>   }
>
>   /*
> @@ -690,49 +729,65 @@ static void hid_scan_usage(struct hid_device *hid, u32 usage)
>    */
>   static int hid_scan_report(struct hid_device *hid)
>   {
> -	unsigned int page = 0, delim = 0;
> +	struct hid_parser *parser;
> +	struct hid_item item;
>   	__u8 *start = hid->dev_rdesc;
>   	__u8 *end = start + hid->dev_rsize;
> -	unsigned int u, u_min = 0, u_max = 0;
> -	struct hid_item item;
> +	int ret;
> +	static int (*dispatch_type[])(struct hid_parser *parser,
> +				      struct hid_item *item) = {
> +		hid_scan_main,
> +		hid_parser_global,
> +		hid_parser_local,
> +		hid_parser_reserved
> +	};
>
> -	hid->group = HID_GROUP_GENERIC;
> +	parser = vzalloc(sizeof(struct hid_parser));
> +	if (!parser)
> +		return -ENOMEM;
> +
> +	parser->device = hid;
> +
> +	ret = -EINVAL;
>   	while ((start = fetch_item(start, end, &item)) != NULL) {
> -		if (item.format != HID_ITEM_FORMAT_SHORT)
> -			return -EINVAL;
> -		if (item.type == HID_ITEM_TYPE_GLOBAL) {
> -			if (item.tag == HID_GLOBAL_ITEM_TAG_USAGE_PAGE)
> -				page = item_udata(&item) << 16;
> -		} else if (item.type == HID_ITEM_TYPE_LOCAL) {
> -			if (delim > 1)
> -				break;
> -			u = item_udata(&item);
> -			if (item.size <= 2)
> -				u += page;
> -			switch (item.tag) {
> -			case HID_LOCAL_ITEM_TAG_DELIMITER:
> -				delim += !!u;
> -				break;
> -			case HID_LOCAL_ITEM_TAG_USAGE:
> -				hid_scan_usage(hid, u);
> -				break;
> -			case HID_LOCAL_ITEM_TAG_USAGE_MINIMUM:
> -				u_min = u;
> -				break;
> -			case HID_LOCAL_ITEM_TAG_USAGE_MAXIMUM:
> -				u_max = u;
> -				for (u = u_min; u <= u_max; u++)
> -					hid_scan_usage(hid, u);
> -				break;
> +
> +		if (item.format != HID_ITEM_FORMAT_SHORT) {
> +			hid_err(hid, "unexpected long global item\n");
> +			goto out;
> +		}
> +
> +		if (dispatch_type[item.type](parser, &item)) {
> +			hid_err(hid, "item %u %u %u %u parsing failed\n",
> +				item.format, (unsigned)item.size,
> +				(unsigned)item.type, (unsigned)item.tag);
> +			goto out;
> +		}
> +
> +		if (start == end) {
> +			if (parser->local.delimiter_depth) {
> +				hid_err(hid, "unbalanced delimiter at end of report description\n");
> +				goto out;
>   			}
> -		} else if (page == HID_UP_SENSOR &&
> -			item.type == HID_ITEM_TYPE_MAIN &&
> -			item.tag == HID_MAIN_ITEM_TAG_BEGIN_COLLECTION &&
> -			(item_udata(&item) & 0xff) == HID_COLLECTION_PHYSICAL)
> -			hid->group = HID_GROUP_SENSOR_HUB;
> +			ret = 0;
> +			goto out;
> +		}
>   	}
>
> -	return 0;
> +	hid_err(hid, "item fetching failed at offset %d\n", (int)(end - start));
> +out:
> +	switch (parser->flags) {
> +	case HID_FLAG_MULTITOUCH:
> +		hid->group = HID_GROUP_MULTITOUCH;
> +		break;
> +	case HID_FLAG_SENSOR_HUB:
> +		hid->group = HID_GROUP_SENSOR_HUB;
> +		break;
> +	default:
> +		hid->group = HID_GROUP_GENERIC;
> +	}
> +
> +	vfree(parser);
> +	return ret;
>   }
>
>   /**
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 5a4e789..7d823db 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -533,6 +533,9 @@ static inline void hid_set_drvdata(struct hid_device *hdev, void *data)
>   #define HID_GLOBAL_STACK_SIZE 4
>   #define HID_COLLECTION_STACK_SIZE 4
>
> +#define HID_FLAG_MULTITOUCH		0x0001
> +#define HID_FLAG_SENSOR_HUB		0x0002
> +
>   struct hid_parser {
>   	struct hid_global     global;
>   	struct hid_global     global_stack[HID_GLOBAL_STACK_SIZE];
> @@ -541,6 +544,7 @@ struct hid_parser {
>   	unsigned              collection_stack[HID_COLLECTION_STACK_SIZE];
>   	unsigned              collection_stack_ptr;
>   	struct hid_device    *device;
> +	unsigned              flags;
>   };
>
>   struct hid_class_descriptor {
>

