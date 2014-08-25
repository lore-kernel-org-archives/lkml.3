Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaHYHul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 03:50:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754AbaHYHuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 03:50:40 -0400
Date: Mon, 25 Aug 2014 02:50:37 -0500 (CDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Ben Hawkes <hawkes@google.com>
Subject: Re: [PATCH 1/2] HID: logitech-dj: prevent false errors to be shown
In-Reply-To: <1408738566-6805-1-git-send-email-benjamin.tissoires@redhat.com>
Message-ID: <alpine.LNX.2.00.1408250249150.23162@pobox.suse.cz>
References: <1408738566-6805-1-git-send-email-benjamin.tissoires@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Benjamin Tissoires wrote:

> Commit "HID: logitech: perform bounds checking on device_id early
> enough" unfortunately leaks some errors to dmesg which are not real
> ones:
> - if the report is not a DJ one, then there is not point in checking
>   the device_id
> - the receiver (index 0) can also receive some notifications which
>   can be safely ignored given the current implementation
> 
> Move out the test regarding the report_id and also discards
> printing errors when the receiver got notified.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

I have now queued this one for 3.17. Adding Markus to CC -- Markus, this 
should make the spurious error messages you have reported go away.

Thanks.

> ---
>  drivers/hid/hid-logitech-dj.c | 43 +++++++++++++++++++++++++------------------
>  drivers/hid/hid-logitech-dj.h |  1 +
>  2 files changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> index b7ba829..9bf8637 100644
> --- a/drivers/hid/hid-logitech-dj.c
> +++ b/drivers/hid/hid-logitech-dj.c
> @@ -656,7 +656,6 @@ static int logi_dj_raw_event(struct hid_device *hdev,
>  	struct dj_receiver_dev *djrcv_dev = hid_get_drvdata(hdev);
>  	struct dj_report *dj_report = (struct dj_report *) data;
>  	unsigned long flags;
> -	bool report_processed = false;
>  
>  	dbg_hid("%s, size:%d\n", __func__, size);
>  
> @@ -683,34 +682,42 @@ static int logi_dj_raw_event(struct hid_device *hdev,
>  	 * device (via hid_input_report() ) and return 1 so hid-core does not do
>  	 * anything else with it.
>  	 */
> +
> +	/* case 1) */
> +	if (data[0] != REPORT_ID_DJ_SHORT)
> +		return false;
> +
>  	if ((dj_report->device_index < DJ_DEVICE_INDEX_MIN) ||
>  	    (dj_report->device_index > DJ_DEVICE_INDEX_MAX)) {
> -		dev_err(&hdev->dev, "%s: invalid device index:%d\n",
> +		/*
> +		 * Device index is wrong, bail out.
> +		 * This driver can ignore safely the receiver notifications,
> +		 * so ignore those reports too.
> +		 */
> +		if (dj_report->device_index != DJ_RECEIVER_INDEX)
> +			dev_err(&hdev->dev, "%s: invalid device index:%d\n",
>  				__func__, dj_report->device_index);
>  		return false;
>  	}
>  
>  	spin_lock_irqsave(&djrcv_dev->lock, flags);
> -	if (dj_report->report_id == REPORT_ID_DJ_SHORT) {
> -		switch (dj_report->report_type) {
> -		case REPORT_TYPE_NOTIF_DEVICE_PAIRED:
> -		case REPORT_TYPE_NOTIF_DEVICE_UNPAIRED:
> -			logi_dj_recv_queue_notification(djrcv_dev, dj_report);
> -			break;
> -		case REPORT_TYPE_NOTIF_CONNECTION_STATUS:
> -			if (dj_report->report_params[CONNECTION_STATUS_PARAM_STATUS] ==
> -			    STATUS_LINKLOSS) {
> -				logi_dj_recv_forward_null_report(djrcv_dev, dj_report);
> -			}
> -			break;
> -		default:
> -			logi_dj_recv_forward_report(djrcv_dev, dj_report);
> +	switch (dj_report->report_type) {
> +	case REPORT_TYPE_NOTIF_DEVICE_PAIRED:
> +	case REPORT_TYPE_NOTIF_DEVICE_UNPAIRED:
> +		logi_dj_recv_queue_notification(djrcv_dev, dj_report);
> +		break;
> +	case REPORT_TYPE_NOTIF_CONNECTION_STATUS:
> +		if (dj_report->report_params[CONNECTION_STATUS_PARAM_STATUS] ==
> +		    STATUS_LINKLOSS) {
> +			logi_dj_recv_forward_null_report(djrcv_dev, dj_report);
>  		}
> -		report_processed = true;
> +		break;
> +	default:
> +		logi_dj_recv_forward_report(djrcv_dev, dj_report);
>  	}
>  	spin_unlock_irqrestore(&djrcv_dev->lock, flags);
>  
> -	return report_processed;
> +	return true;
>  }
>  
>  static int logi_dj_probe(struct hid_device *hdev,
> diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
> index 4a40003..daeb0aa 100644
> --- a/drivers/hid/hid-logitech-dj.h
> +++ b/drivers/hid/hid-logitech-dj.h
> @@ -27,6 +27,7 @@
>  
>  #define DJ_MAX_PAIRED_DEVICES			6
>  #define DJ_MAX_NUMBER_NOTIFICATIONS		8
> +#define DJ_RECEIVER_INDEX			0
>  #define DJ_DEVICE_INDEX_MIN 			1
>  #define DJ_DEVICE_INDEX_MAX 			6
>  
> -- 
> 2.1.0
> 

-- 
Jiri Kosina
SUSE Labs
