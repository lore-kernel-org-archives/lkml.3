Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab3HUSV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:21:56 -0400
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:52072 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab3HUSVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:21:53 -0400
X-SENDER-IP: [85.230.171.181]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArtMAHIEFVJV5qu1PGdsb2JhbABagwWDN4UjuBCBHhcDAQEBATg1giQBAQQBJxMcIwULCAMhJQ8FJQoaEx6HbAquExaQPweDG3kDl2KGO448OoEtJA
X-IronPort-AV: E=Sophos;i="4.89,929,1367964000"; 
   d="scan'208";a="382142724"
Date: Wed, 21 Aug 2013 20:26:54 +0200
From: Henrik Rydberg <rydberg@euromail.se>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Alexander Holler <holler@ahsoftware.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] HID: detect Win 8 multitouch devices in core
Message-ID: <20130821182654.GA3926@polaris.bitmath.org>
References: <1377099620-23947-1-git-send-email-benjamin.tissoires@redhat.com>
 <1377099620-23947-3-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377099620-23947-3-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Detecting Win 8 multitouch devices in core allows us to set quirks
> before the device is parsed through hid_hw_start().
> It also simplifies the detection of those devices in hid-multitouch and
> makes the handling of those devices cleaner.
> 
> As Win 8 multitouch panels are in the group multitouch and rely on a
> special feature to be detected, this patch also temporary convert
> hid->group into a bitfield, before reverting it to the actual
> group information. If we ever have more than 16 groups to detect,
> we can then add a .flags field in hid_parser for instance, and then
> use this to get the actual group.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
> 
> changes in v2:
> - moved "flags" processing here
> - do not introduce parser->flags, but use hid->group as a temporary flag placeholder
> - #define and #undef HID_FLAG_* in hid-core.c instead of hid.h
> - amended commit message
> 
>  drivers/hid/hid-core.c       | 41 +++++++++++++++++++++++++++++++++++++++--
>  drivers/hid/hid-multitouch.c | 24 +++++++++++-------------
>  include/linux/hid.h          |  1 +
>  3 files changed, 51 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index e072b15..c749966 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -677,12 +677,25 @@ static u8 *fetch_item(__u8 *start, __u8 *end, struct hid_item *item)
>  	return NULL;
>  }
>  
> +#define HID_FLAG_MULTITOUCH		(1 << HID_GROUP_MULTITOUCH)
> +#define HID_FLAG_WIN_8_CERTIFIED	(1 << HID_GROUP_MULTITOUCH_WIN_8)
> +#define HID_FLAG_SENSOR_HUB		(1 << HID_GROUP_SENSOR_HUB)
> +

Why not use the existing defines directly? If you worry about being
able to combine bit positions in a simple mask rather than using the
existing bitmask (which could be good), how about a priority list for
the groups instead? My own preference would be to leave structure for
the future to the future, and use a single state in the parser for the
case you are adding.

>  static void hid_scan_input_usage(struct hid_parser *parser, u32 usage)
>  {
>  	struct hid_device *hid = parser->device;
>  
>  	if (usage == HID_DG_CONTACTID)
> -		hid->group = HID_GROUP_MULTITOUCH;
> +		hid->group |= HID_FLAG_MULTITOUCH;
> +}

Dynamic semantics, please no :-) My suggestion: leave this line be...

> +
> +static void hid_scan_feature_usage(struct hid_parser *parser, u32 usage)
> +{
> +	struct hid_device *hid = parser->device;
> +
> +	if (usage == 0xff0000c5 && parser->global.report_count == 256 &&
> +	    parser->global.report_size == 8)
> +		hid->group |= HID_FLAG_WIN_8_CERTIFIED;

And set 'parser->is_win8 = true' here.

>  }
>  
>  static void hid_scan_collection(struct hid_parser *parser, unsigned type)
> @@ -691,7 +704,7 @@ static void hid_scan_collection(struct hid_parser *parser, unsigned type)
>  
>  	if (((parser->global.usage_page << 16) == HID_UP_SENSOR) &&
>  	    type == HID_COLLECTION_PHYSICAL)
> -		hid->group = HID_GROUP_SENSOR_HUB;
> +		hid->group |= HID_FLAG_SENSOR_HUB;

Leave this...

>  }
>  
>  static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
> @@ -714,6 +727,8 @@ static int hid_scan_main(struct hid_parser *parser, struct hid_item *item)
>  	case HID_MAIN_ITEM_TAG_OUTPUT:
>  		break;
>  	case HID_MAIN_ITEM_TAG_FEATURE:
> +		for (i = 0; i < parser->local.usage_index; i++)
> +			hid_scan_feature_usage(parser, parser->local.usage[i]);
>  		break;
>  	default:
>  		hid_err(parser->device, "unknown main item tag 0x%x\n",
> @@ -759,10 +774,32 @@ static int hid_scan_report(struct hid_device *hid)
>  	while ((start = fetch_item(start, end, &item)) != NULL)
>  		dispatch_type[item.type](parser, &item);
>  
> +	/*
> +	 * Re-interprete the group field to keep the same group definitions than
> +	 * we had in previous kernels.
> +	 */
> +	switch (hid->group) {
> +	case HID_FLAG_MULTITOUCH:
> +		hid->group = HID_GROUP_MULTITOUCH;
> +		break;
> +	case HID_FLAG_MULTITOUCH | HID_FLAG_WIN_8_CERTIFIED:
> +		hid->group = HID_GROUP_MULTITOUCH_WIN_8;
> +		break;
> +	case HID_FLAG_SENSOR_HUB:
> +		hid->group = HID_GROUP_SENSOR_HUB;
> +		break;
> +	default:
> +		hid->group = HID_GROUP_GENERIC;
> +	}
> +

... and replace this with 'if (parser->is_win8) hid->group = HID_GROUP_MULTITOUCH_WIN_8'.

>  	vfree(parser);
>  	return 0;
>  }
>  
> +#undef HID_FLAG_MULTITOUCH
> +#undef HID_FLAG_WIN_8_CERTIFIED
> +#undef HID_FLAG_SENSOR_HUB
> +

No comment ;-)

>  /**
>   * hid_parse_report - parse device report
>   *
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 0fe00e2..c28ef86 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -133,6 +133,7 @@ static void mt_post_parse(struct mt_device *td);
>  #define MT_CLS_NSMU				0x000a
>  #define MT_CLS_DUAL_CONTACT_NUMBER		0x0010
>  #define MT_CLS_DUAL_CONTACT_ID			0x0011
> +#define MT_CLS_WIN_8				0x0012
>  
>  /* vendor specific classes */
>  #define MT_CLS_3M				0x0101
> @@ -205,6 +206,11 @@ static struct mt_class mt_classes[] = {
>  			MT_QUIRK_CONTACT_CNT_ACCURATE |
>  			MT_QUIRK_SLOT_IS_CONTACTID,
>  		.maxcontacts = 2 },
> +	{ .name = MT_CLS_WIN_8,
> +		.quirks = MT_QUIRK_ALWAYS_VALID |
> +			MT_QUIRK_IGNORE_DUPLICATES |
> +			MT_QUIRK_HOVERING |
> +			MT_QUIRK_CONTACT_CNT_ACCURATE },
>  
>  	/*
>  	 * vendor specific classes
> @@ -332,19 +338,6 @@ static void mt_feature_mapping(struct hid_device *hdev,
>  			td->maxcontacts = td->mtclass.maxcontacts;
>  
>  		break;
> -	case 0xff0000c5:
> -		if (field->report_count == 256 && field->report_size == 8) {
> -			/* Win 8 devices need special quirks */
> -			__s32 *quirks = &td->mtclass.quirks;
> -			*quirks |= MT_QUIRK_ALWAYS_VALID;
> -			*quirks |= MT_QUIRK_IGNORE_DUPLICATES;
> -			*quirks |= MT_QUIRK_HOVERING;
> -			*quirks |= MT_QUIRK_CONTACT_CNT_ACCURATE;
> -			*quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;
> -			*quirks &= ~MT_QUIRK_VALID_IS_INRANGE;
> -			*quirks &= ~MT_QUIRK_VALID_IS_CONFIDENCE;
> -		}
> -		break;
>  	}
>  }
>  
> @@ -1346,6 +1339,11 @@ static const struct hid_device_id mt_devices[] = {
>  
>  	/* Generic MT device */
>  	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH, HID_ANY_ID, HID_ANY_ID) },
> +
> +	/* Generic Win 8 certified MT device */
> +	{  .driver_data = MT_CLS_WIN_8,
> +		HID_DEVICE(HID_BUS_ANY, HID_GROUP_MULTITOUCH_WIN_8,
> +			HID_ANY_ID, HID_ANY_ID) },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(hid, mt_devices);
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 5a4e789..45b7f3f 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -295,6 +295,7 @@ struct hid_item {
>  #define HID_GROUP_GENERIC			0x0001
>  #define HID_GROUP_MULTITOUCH			0x0002
>  #define HID_GROUP_SENSOR_HUB			0x0003
> +#define HID_GROUP_MULTITOUCH_WIN_8		0x0004
>  
>  /*
>   * This is the global environment of the parser. This information is
> -- 
> 1.8.3.1
> 

Thanks,
Henrik
