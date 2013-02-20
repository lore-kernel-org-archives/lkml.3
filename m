Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935837Ab3BTUcN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:32:13 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:45712 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934126Ab3BTUcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:32:12 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AptGAKgxJVFV5qjOOWdsb2JhbABFhWCFILVfgQEXAwEBAQEhFzSCHwEBBScTHBMBDxAIAxgJJQ8FDRgKGhOIAAMTtn0NiVoVjCKCVweCX2EDlFGBWoYCg1mBbIgd
X-IronPort-AV: E=Sophos;i="4.84,704,1355094000"; 
   d="scan'208";a="500974835"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Feb 2013 21:33:35 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Rafi Rubin <rafi@seas.upenn.edu>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: ntrig: use input_configured() callback to set the
 name
Message-ID: <20130220203335.GA1430@polaris.bitmath.org>
References: <1360335090-24024-1-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360335090-24024-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 03:51:30PM +0100, Benjamin Tissoires wrote:
> The use of input_configured() allows the ntrig driver to actually
> change the name of the input and its bitmask before it is added to the
> input subsystem. Thus, the logs are coherents and udev catch the real
> bitmask when the device is added.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-ntrig.c | 68 ++++++++++++++++++++++++-------------------------
>  1 file changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
> index 2ffc0e3..7757e82 100644
> --- a/drivers/hid/hid-ntrig.c
> +++ b/drivers/hid/hid-ntrig.c
> @@ -858,12 +858,43 @@ not_claimed_input:
>  	return 1;
>  }
>  
> +static void ntrig_input_configured(struct hid_device *hid,
> +		struct hid_input *hidinput)
> +
> +{
> +	struct input_dev *input = hidinput->input;
> +
> +	if (hidinput->report->maxfield < 1)
> +		return;
> +
> +	switch (hidinput->report->field[0]->application) {
> +	case HID_DG_PEN:
> +		input->name = "N-Trig Pen";
> +		break;
> +	case HID_DG_TOUCHSCREEN:
> +		/* These keys are redundant for fingers, clear them
> +		 * to prevent incorrect identification */
> +		__clear_bit(BTN_TOOL_PEN, input->keybit);
> +		__clear_bit(BTN_TOOL_FINGER, input->keybit);
> +		__clear_bit(BTN_0, input->keybit);
> +		__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
> +		/*
> +		 * The physical touchscreen (single touch)
> +		 * input has a value for physical, whereas
> +		 * the multitouch only has logical input
> +		 * fields.
> +		 */
> +		input->name = (hidinput->report->field[0]->physical) ?
> +							"N-Trig Touchscreen" :
> +							"N-Trig MultiTouch";
> +		break;
> +	}
> +}
> +
>  static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  {
>  	int ret;
>  	struct ntrig_data *nd;
> -	struct hid_input *hidinput;
> -	struct input_dev *input;
>  	struct hid_report *report;
>  
>  	if (id->driver_data)
> @@ -901,38 +932,6 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  		goto err_free;
>  	}
>  
> -
> -	list_for_each_entry(hidinput, &hdev->inputs, list) {
> -		if (hidinput->report->maxfield < 1)
> -			continue;
> -
> -		input = hidinput->input;
> -		switch (hidinput->report->field[0]->application) {
> -		case HID_DG_PEN:
> -			input->name = "N-Trig Pen";
> -			break;
> -		case HID_DG_TOUCHSCREEN:
> -			/* These keys are redundant for fingers, clear them
> -			 * to prevent incorrect identification */
> -			__clear_bit(BTN_TOOL_PEN, input->keybit);
> -			__clear_bit(BTN_TOOL_FINGER, input->keybit);
> -			__clear_bit(BTN_0, input->keybit);
> -			__set_bit(BTN_TOOL_DOUBLETAP, input->keybit);
> -			/*
> -			 * The physical touchscreen (single touch)
> -			 * input has a value for physical, whereas
> -			 * the multitouch only has logical input
> -			 * fields.
> -			 */
> -			input->name =
> -				(hidinput->report->field[0]
> -				 ->physical) ?
> -				"N-Trig Touchscreen" :
> -				"N-Trig MultiTouch";
> -			break;
> -		}
> -	}
> -
>  	/* This is needed for devices with more recent firmware versions */
>  	report = hdev->report_enum[HID_FEATURE_REPORT].report_id_hash[0x0a];
>  	if (report) {
> @@ -1023,6 +1022,7 @@ static struct hid_driver ntrig_driver = {
>  	.remove = ntrig_remove,
>  	.input_mapping = ntrig_input_mapping,
>  	.input_mapped = ntrig_input_mapped,
> +	.input_configured = ntrig_input_configured,
>  	.usage_table = ntrig_grabbed_usages,
>  	.event = ntrig_event,
>  };
> -- 
> 1.8.1
> 

    Acked-by: Henrik Rydberg <rydberg@euromail.se>

Thanks,
Henrik
