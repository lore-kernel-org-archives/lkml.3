Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438AbaGQQHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933701AbaGQQHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:07:20 -0400
Date: Thu, 17 Jul 2014 12:07:05 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] HID: rmi: check that report ids exist in the
 report_id_hash before accessing their size
Message-ID: <20140717160704.GA27586@mail.corp.redhat.com>
References: <1405546717-6582-1-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405546717-6582-1-git-send-email-aduggan@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 16 2014 or thereabouts, Andrew Duggan wrote:
> It is possible that the hid-rmi driver could get loaded onto a device which does not have the
> expected report ids. This should not happen because it would indicate that the hid-rmi driver is
> not compatible with that device. However, if it does happen it should return an error from probe
> instead of dereferencing a null pointer.
> 
> related bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=80091
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---

Hi Andrew,

I think this patch is required. We can not afford having a null pointer
in a driver. So yes, I think Jiri should take this one. I just have a
few nitpick inlined in the code.

However, this patch will prevent the driver to fail, but the falsely
bound device will not be driven by anybody, which means that you will
break the keyboard/touchpad/whatever which is not using the right
driver.

So yes, we need that, but we also defintively have to fix hid-core too
to not bind them to hid-rmi.

>  drivers/hid/hid-rmi.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 3221a95..7f0927a 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -848,6 +848,8 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	struct rmi_data *data = NULL;
>  	int ret;
>  	size_t alloc_size;
> +	struct hid_report *input_report;
> +	struct hid_report *output_report;
>  
>  	data = devm_kzalloc(&hdev->dev, sizeof(struct rmi_data), GFP_KERNEL);
>  	if (!data)
> @@ -866,12 +868,24 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  		return ret;
>  	}
>  
> -	data->input_report_size = (hdev->report_enum[HID_INPUT_REPORT]
> -		.report_id_hash[RMI_ATTN_REPORT_ID]->size >> 3)
> -		+ 1 /* report id */;
> -	data->output_report_size = (hdev->report_enum[HID_OUTPUT_REPORT]
> -		.report_id_hash[RMI_WRITE_REPORT_ID]->size >> 3)
> -		+ 1 /* report id */;
> +	input_report = hdev->report_enum[HID_INPUT_REPORT]
> +			.report_id_hash[RMI_ATTN_REPORT_ID];
> +	if (!input_report) {
> +		ret = -ENODEV;
> +		return ret;

In its current state, the driver will be silently unbound, and the user
will never get any explanations on why nothing works. So please add an
hid_err message telling why hid-rmi gave up.

> +	}
> +
> +	data->input_report_size = (input_report->size >> 3) + 1 /* report id */;
> +
> +	output_report = hdev->report_enum[HID_OUTPUT_REPORT]
> +			.report_id_hash[RMI_WRITE_REPORT_ID];
> +	if (!output_report) {
> +		ret = -ENODEV;
> +		return ret;

ditto.

Cheers,
Benjamin

> +	}
> +
> +	data->output_report_size = (output_report->size >> 3)
> +					+ 1 /* report id */;
>  
>  	alloc_size = data->output_report_size + data->input_report_size;
>  
> -- 
> 1.9.1
> 
