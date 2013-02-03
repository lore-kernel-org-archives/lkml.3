Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268Ab3BCMVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 07:21:55 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:56313 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3BCMVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:21:53 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiBlAO9VDlFV5qjOPGdsb2JhbABEhV+FILMvBIEAFwMBAQEBODSCHwEBBAEnExwjBQsIAyElDwUNGAoaE4d/AwkKtRYNiVYVjAiBLoMmYQOUR4FXhgCFQIgP
X-IronPort-AV: E=Sophos;i="4.84,594,1355094000"; 
   d="scan'208";a="492142182"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 3 Feb 2013 13:27:48 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] HID: core: add "report" hook, called once the
 report has been parsed
Message-ID: <20130203122748.GA2513@polaris.bitmath.org>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
 <1359649351-11092-2-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359649351-11092-2-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> This callback is called when the parsing of the report has been done
> by hid-core (so after the calls to .event). The hid drivers can now
> have access to the whole report by relying on the values stored in
> the different fields.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-core.c | 4 ++++
>  include/linux/hid.h    | 2 ++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 5ae2cb1..b671e4e 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1195,6 +1195,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>  {
>  	struct hid_report_enum *report_enum = hid->report_enum + type;
>  	struct hid_report *report;
> +	struct hid_driver *hdrv;
>  	unsigned int a;
>  	int rsize, csize = size;
>  	u8 *cdata = data;
> @@ -1231,6 +1232,9 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, int size,
>  	if (hid->claimed != HID_CLAIMED_HIDRAW) {
>  		for (a = 0; a < report->maxfield; a++)
>  			hid_input_field(hid, report->field[a], cdata, interrupt);
> +		hdrv = hid->driver;
> +		if (hdrv && hdrv->report)
> +			hdrv->report(hid, report);

I think this is more useful if called before the individual fields. In
fact, it seems raw_event() is already doing exactly that. No need for
a new callback, in other words.

>  	}
>  
>  	if (hid->claimed & HID_CLAIMED_INPUT)
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 828726c..e14b465 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -589,6 +589,7 @@ struct hid_usage_id {
>   * @raw_event: if report in report_table, this hook is called (NULL means nop)
>   * @usage_table: on which events to call event (NULL means all)
>   * @event: if usage in usage_table, this hook is called (NULL means nop)
> + * @report: this hook is called after parsing a report (NULL means nop)
>   * @report_fixup: called before report descriptor parsing (NULL means nop)
>   * @input_mapping: invoked on input registering before mapping an usage
>   * @input_mapped: invoked on input registering after mapping an usage
> @@ -627,6 +628,7 @@ struct hid_driver {
>  	const struct hid_usage_id *usage_table;
>  	int (*event)(struct hid_device *hdev, struct hid_field *field,
>  			struct hid_usage *usage, __s32 value);
> +	void (*report)(struct hid_device *hdev, struct hid_report *report);
>  
>  	__u8 *(*report_fixup)(struct hid_device *hdev, __u8 *buf,
>  			unsigned int *size);
> -- 
> 1.8.1
> 

Thanks,
Henrik
