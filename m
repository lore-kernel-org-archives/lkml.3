Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209Ab3GRU2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:28:09 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37196 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933027Ab3GRU2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:28:07 -0400
Message-ID: <51E84FD1.4050400@hurleysoftware.com>
Date: Thu, 18 Jul 2013 16:28:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Nestor Lopez Casado <nlopezcasad@logitech.com>
CC: jkosina@suse.cz, benjamin.tissoires@gmail.com, adlr@chromium.org,
        joseph.salisbury@canonical.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "Revert "HID: Fix logitech-dj: missing Unifying
 device issue""
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
In-Reply-To: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ +cc Sarah Sharp, linux-usb ]

On 07/18/2013 09:21 AM, Nestor Lopez Casado wrote:
> This reverts commit 8af6c08830b1ae114d1a8b548b1f8b056e068887.
>
> This patch re-adds the workaround introduced by 596264082f10dd4
> which was reverted by 8af6c08830b1ae114.
>
> The original patch 596264 was needed to overcome a situation where
> the hid-core would drop incoming reports while probe() was being
> executed.
>
> This issue was solved by c849a6143bec520af which added
> hid_device_io_start() and hid_device_io_stop() that enable a specific
> hid driver to opt-in for input reports while its probe() is being
> executed.
>
> Commit a9dd22b730857347 modified hid-logitech-dj so as to use the
> functionality added to hid-core. Having done that, workaround 596264
> was no longer necessary and was reverted by 8af6c08.
>
> We now encounter a different problem that ends up 'again' thwarting
> the Unifying receiver enumeration. The problem is time and usb controller
> dependent. Ocasionally the reports sent to the usb receiver to start
> the paired devices enumeration fail with -EPIPE and the receiver never
> gets to enumerate the paired devices.
>
> With dcd9006b1b053c7b1c the problem was "hidden" as the call to the usb
> driver became asynchronous and none was catching the error from the
> failing URB.
>
> As the root cause for this failing SET_REPORT is not understood yet,
> -possibly a race on the usb controller drivers or a problem with the
> Unifying receiver- reintroducing this workaround solves the problem.


Before we revert to using the workaround, I'd like to suggest that
this new "hidden" problem may be an interaction with the xhci_hcd host
controller driver only.

Looking at the related bug, the OP indicates the machine only has
USB3 ports. Additionally, comments #7, #100, and #104 of the original
bug report [1] add additional information that would seem to confirm
this suspicion.

Let me add I have this USB device running on the uhci_hcd driver
with or without this workaround on v3.10.


> Overall what this workaround does is: If an input report from an
> unknown device is received, then a (re)enumeration is performed.
>
> related bug:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1194649

I thought I saw someone reporting this problem recently on LKML;
where is the Reported-by so that Sarah can follow-up with the
reporter directly, if desired?

Regards,
Peter Hurley

[1]
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1039143


> Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
> ---
>   drivers/hid/hid-logitech-dj.c |   45 +++++++++++++++++++++++++++++++++++++++++
>   drivers/hid/hid-logitech-dj.h |    1 +
>   2 files changed, 46 insertions(+)
>
> diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
> index db3192b..0d13389 100644
> --- a/drivers/hid/hid-logitech-dj.c
> +++ b/drivers/hid/hid-logitech-dj.c
> @@ -192,6 +192,7 @@ static struct hid_ll_driver logi_dj_ll_driver;
>   static int logi_dj_output_hidraw_report(struct hid_device *hid, u8 * buf,
>   					size_t count,
>   					unsigned char report_type);
> +static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev);
>
>   static void logi_dj_recv_destroy_djhid_device(struct dj_receiver_dev *djrcv_dev,
>   						struct dj_report *dj_report)
> @@ -232,6 +233,7 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
>   	if (dj_report->report_params[DEVICE_PAIRED_PARAM_SPFUNCTION] &
>   	    SPFUNCTION_DEVICE_LIST_EMPTY) {
>   		dbg_hid("%s: device list is empty\n", __func__);
> +		djrcv_dev->querying_devices = false;
>   		return;
>   	}
>
> @@ -242,6 +244,12 @@ static void logi_dj_recv_add_djhid_device(struct dj_receiver_dev *djrcv_dev,
>   		return;
>   	}
>
> +	if (djrcv_dev->paired_dj_devices[dj_report->device_index]) {
> +		/* The device is already known. No need to reallocate it. */
> +		dbg_hid("%s: device is already known\n", __func__);
> +		return;
> +	}
> +
>   	dj_hiddev = hid_allocate_device();
>   	if (IS_ERR(dj_hiddev)) {
>   		dev_err(&djrcv_hdev->dev, "%s: hid_allocate_device failed\n",
> @@ -305,6 +313,7 @@ static void delayedwork_callback(struct work_struct *work)
>   	struct dj_report dj_report;
>   	unsigned long flags;
>   	int count;
> +	int retval;
>
>   	dbg_hid("%s\n", __func__);
>
> @@ -337,6 +346,25 @@ static void delayedwork_callback(struct work_struct *work)
>   		logi_dj_recv_destroy_djhid_device(djrcv_dev, &dj_report);
>   		break;
>   	default:
> +	/* A normal report (i. e. not belonging to a pair/unpair notification)
> +	 * arriving here, means that the report arrived but we did not have a
> +	 * paired dj_device associated to the report's device_index, this
> +	 * means that the original "device paired" notification corresponding
> +	 * to this dj_device never arrived to this driver. The reason is that
> +	 * hid-core discards all packets coming from a device while probe() is
> +	 * executing. */
> +	if (!djrcv_dev->paired_dj_devices[dj_report.device_index]) {
> +		/* ok, we don't know the device, just re-ask the
> +		 * receiver for the list of connected devices. */
> +		retval = logi_dj_recv_query_paired_devices(djrcv_dev);
> +		if (!retval) {
> +			/* everything went fine, so just leave */
> +			break;
> +		}
> +		dev_err(&djrcv_dev->hdev->dev,
> +			"%s:logi_dj_recv_query_paired_devices "
> +			"error:%d\n", __func__, retval);
> +		}
>   		dbg_hid("%s: unexpected report type\n", __func__);
>   	}
>   }
> @@ -367,6 +395,12 @@ static void logi_dj_recv_forward_null_report(struct dj_receiver_dev *djrcv_dev,
>   	if (!djdev) {
>   		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
>   			" is NULL, index %d\n", dj_report->device_index);
> +		kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
> +
> +		if (schedule_work(&djrcv_dev->work) == 0) {
> +			dbg_hid("%s: did not schedule the work item, was already "
> +			"queued\n", __func__);
> +		}
>   		return;
>   	}
>
> @@ -397,6 +431,12 @@ static void logi_dj_recv_forward_report(struct dj_receiver_dev *djrcv_dev,
>   	if (dj_device == NULL) {
>   		dbg_hid("djrcv_dev->paired_dj_devices[dj_report->device_index]"
>   			" is NULL, index %d\n", dj_report->device_index);
> +		kfifo_in(&djrcv_dev->notif_fifo, dj_report, sizeof(struct dj_report));
> +
> +		if (schedule_work(&djrcv_dev->work) == 0) {
> +			dbg_hid("%s: did not schedule the work item, was already "
> +			"queued\n", __func__);
> +		}
>   		return;
>   	}
>
> @@ -444,6 +484,10 @@ static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
>   	struct dj_report *dj_report;
>   	int retval;
>
> +	/* no need to protect djrcv_dev->querying_devices */
> +	if (djrcv_dev->querying_devices)
> +		return 0;
> +
>   	dj_report = kzalloc(sizeof(struct dj_report), GFP_KERNEL);
>   	if (!dj_report)
>   		return -ENOMEM;
> @@ -455,6 +499,7 @@ static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
>   	return retval;
>   }
>
> +
>   static int logi_dj_recv_switch_to_dj_mode(struct dj_receiver_dev *djrcv_dev,
>   					  unsigned timeout)
>   {
> diff --git a/drivers/hid/hid-logitech-dj.h b/drivers/hid/hid-logitech-dj.h
> index fd28a5e..4a40003 100644
> --- a/drivers/hid/hid-logitech-dj.h
> +++ b/drivers/hid/hid-logitech-dj.h
> @@ -101,6 +101,7 @@ struct dj_receiver_dev {
>   	struct work_struct work;
>   	struct kfifo notif_fifo;
>   	spinlock_t lock;
> +	bool querying_devices;
>   };
>
>   struct dj_device {
>

