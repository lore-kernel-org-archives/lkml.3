Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3HUSKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:10:54 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:43950 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3HUSKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:10:52 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArtMAFsBFVJV5qu1PGdsb2JhbABagwWDN4UjuBCBHhcDAQEBATg1giQBAQQBJxMcIwULCAMhJQ8FJQoaEx6HbAquFRaQPweDG3kDl2KGO4Nvik06
X-IronPort-AV: E=Sophos;i="4.89,929,1367964000"; 
   d="scan'208";a="304537996"
Date: Wed, 21 Aug 2013 20:15:55 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] HID: Use hid_parser for pre-scanning the report
 descriptors
Message-ID: <20130821181555.GA3851@polaris.bitmath.org>
References: <1377099620-23947-1-git-send-email-benjamin.tissoires@redhat.com>
 <1377099620-23947-2-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377099620-23947-2-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

this looks pretty good to me, just a few nitpicks below.

> hid_scan_report() implements its own HID report descriptor parsing. It is
> going to be really bad with the detection of Win 8 certified touchscreen,
> as this detection relies on a special feature and on the report_size and
> report_count fields.

How about 'The Win 8 detection is sufficiently complex to warrant use
of the full parser code, in spite of the inferred memory
usage. Therefore...'

> 
> We can use the existing HID parser in hid-core for hid_scan_report()
> by re-using the code from hid_open_report(). hid_parser_global,
> hid_parser_local and hid_parser_reserved does not have any side effects.
> We just need to reimplement the MAIN_ITEM callback to have a proper
> parsing without side effects.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> changes in v2:
> - moved "flags" processing in patch 2/3 (so use hid->group in this patch)
> - hid_scan_report() is less verbose when errors are found in the descriptor
> - hid_scan_report() is tolerant to parsing errors
> - fixed usage_page handling in hid_scan_collection(), which fixes sensors detection
> - amended commit message
> 
>  drivers/hid/hid-core.c | 106 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 67 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 3efe19f..e072b15 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -677,12 +677,55 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
>  	return NULL;
>  }
>  
> -static void hid_scan_usage(struct hid_device *hid, u32 usage)
> +static void hid_scan_input_usage(struct hid_parser *parser, u32 usage)
>  {
> +	struct hid_device *hid = parser->device;
> +
>  	if (usage == HID_DG_CONTACTID)
>  		hid->group = HID_GROUP_MULTITOUCH;
>  }
>  
> +static void hid_scan_collection(struct hid_parser *parser, unsigned type)
> +{
> +	struct hid_device *hid = parser->device;
> +
> +	if (((parser->global.usage_page << 16) == HID_UP_SENSOR) &&
> +	    type == HID_COLLECTION_PHYSICAL)
> +		hid->group = HID_GROUP_SENSOR_HUB;
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
> +		hid_scan_collection(parser, data & 0xff);
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

Looks this this message is a duplicate as well.

> +	}
> +
> +	/* Reset the local parser environment */
> +	memset(&parser->local, 0, sizeof(parser->local));
> +
> +	return 0;
> +}
> +
>  /*
>   * Scan a report descriptor before the device is added to the bus.
>   * Sets device groups and other properties that determine what driver
> @@ -690,48 +733,33 @@ static void hid_scan_usage(struct hid_device *hid, u32 usage)
>   */
>  static int hid_scan_report(struct hid_device *hid)
>  {
> -	unsigned int page = 0, delim = 0;
> +	struct hid_parser *parser;
> +	struct hid_item item;
>  	__u8 *start = hid->dev_rdesc;
>  	__u8 *end = start + hid->dev_rsize;
> -	unsigned int u, u_min = 0, u_max = 0;
> -	struct hid_item item;
> +	static int (*dispatch_type[])(struct hid_parser *parser,
> +				      struct hid_item *item) = {
> +		hid_scan_main,
> +		hid_parser_global,
> +		hid_parser_local,
> +		hid_parser_reserved
> +	};
>  
> -	hid->group = HID_GROUP_GENERIC;
> -	while ((start = fetch_item(start, end, &item)) != NULL) {
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
> -			}
> -		} else if (page == HID_UP_SENSOR &&
> -			item.type == HID_ITEM_TYPE_MAIN &&
> -			item.tag == HID_MAIN_ITEM_TAG_BEGIN_COLLECTION &&
> -			(item_udata(&item) & 0xff) == HID_COLLECTION_PHYSICAL)
> -			hid->group = HID_GROUP_SENSOR_HUB;
> -	}
> +	parser = vzalloc(sizeof(struct hid_parser));
> +	if (!parser)
> +		return -ENOMEM;
> +
> +	parser->device = hid;
> +
> +	/*
> +	 * The parsing is simpler than the one in hid_open_report() as we should
> +	 * be robust against hid errors. Those errors will be raised by
> +	 * hid_open_report() anyway.
> +	 */
> +	while ((start = fetch_item(start, end, &item)) != NULL)
> +		dispatch_type[item.type](parser, &item);
>  
> +	vfree(parser);
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
> 

Thanks,
Henrik
