Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaLTB40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:56:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaLTB4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:56:25 -0500
Date: Fri, 19 Dec 2014 20:56:19 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3/3] HID: rmi: Add support for the touchpad in the Razer
 Blade 14 laptop
Message-ID: <20141220015619.GE32189@mail.corp.redhat.com>
References: <1419029143-20484-1-git-send-email-aduggan@synaptics.com>
 <1419029143-20484-3-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419029143-20484-3-git-send-email-aduggan@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19 2014 or thereabouts, Andrew Duggan wrote:
> Have hid-rmi handle all of the Razer Blade HID devices that are part of the
> composite USB device. This will allow hid-rmi to operate the touchpad in rmi
> mode while passing events from the other devices to hid-input.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---
>  drivers/hid/hid-core.c |  1 +
>  drivers/hid/hid-ids.h  |  3 +++
>  drivers/hid/hid-rmi.c  | 15 +++++++++++++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 81665b4..ef718f9 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1982,6 +1982,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
>  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_BT) },
>  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE) },
>  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_NINTENDO, USB_DEVICE_ID_NINTENDO_WIIMOTE2) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_RAZER, USB_DEVICE_ID_RAZER_BLADE_14) },
>  	{ }
>  };
>  
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 7460f34..7d0912d 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -767,6 +767,9 @@
>  #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001		0x3001
>  #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008		0x3008
>  
> +#define USB_VENDOR_ID_RAZER            0x1532
> +#define USB_DEVICE_ID_RAZER_BLADE_14   0x011D
> +
>  #define USB_VENDOR_ID_REALTEK		0x0bda
>  #define USB_DEVICE_ID_REALTEK_READER	0x0152
>  
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index cdfe165..849b35a 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -1038,6 +1038,20 @@ static int rmi_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  
>  	data->readReport = data->writeReport + data->output_report_size;
>  
> +	/*
> +	 * Unfortunately there is no way to query the touchpad in the
> +	 * Razer system to determine that it has pass through buttons
> +	 * so the only solution is to set phys buttons flag based on the
> +	 * vid and pid. In the future we should be able to query devices
> +	 * to find out. However, we need to know if the touchpad has
> +	 * physical buttons before the input_mapping gets called which
> +	 * is before we query the device. So we may have to resort to creating
> +	 * a list of devices based on product id.
> +	 */
> +	if (hdev->vendor == USB_VENDOR_ID_RAZER &&
> +	    hdev->product == USB_DEVICE_ID_RAZER_BLADE_14)
> +		data->device_flags |= RMI_DEVICE_HAS_PHYS_BUTTONS;

This whole test can be replace by a field in rmi_id (.driver_data) as
mentioned in 2/3.

> +
>  	init_waitqueue_head(&data->wait);
>  
>  	mutex_init(&data->page_mutex);
> @@ -1074,6 +1088,7 @@ static void rmi_remove(struct hid_device *hdev)
>  
>  static const struct hid_device_id rmi_id[] = {
>  	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_RMI, HID_ANY_ID, HID_ANY_ID) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_RAZER, USB_DEVICE_ID_RAZER_BLADE_14) },

Nitpicking, I'd prefer having the most generic one at the end. In case
you need to specify other flags to some specific devices, they will have
to be inserted before the catchall rule, so let's start now :).

>  	{ }
>  };
>  MODULE_DEVICE_TABLE(hid, rmi_id);
> -- 
> 2.1.0
> 

Cheers,
Benjamin
