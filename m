Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaLTBxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:53:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaLTBxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:53:37 -0500
Date: Fri, 19 Dec 2014 20:53:31 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 2/3] HID: rmi: Support touchpads with external buttons
Message-ID: <20141220015331.GD32189@mail.corp.redhat.com>
References: <1419029143-20484-1-git-send-email-aduggan@synaptics.com>
 <1419029143-20484-2-git-send-email-aduggan@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1419029143-20484-2-git-send-email-aduggan@synaptics.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19 2014 or thereabouts, Andrew Duggan wrote:
> The external buttons on HID touchpads are connected as pass through devices and
> button events are not reported in the rmi registers. As a result on these
> devices we need to allow the HID generic desktop button events to be processed
> by hid-input.
> 
> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> ---

Just to be sure, could you also add in the commit message that the flag
RMI_DEVICE_HAS_PHYS_BUTTONS is not auto-detected by the driver and that
it has to be added manually when adding a device to rmi_id[].

BTW, you can use .driver_data in in struct hid_device_id to pass the
flags directly. So here, it would be nice to add such retrieval in
probe:
data->device_flags = id->driver_data;
and then check for RMI_DEVICE.

>  drivers/hid/hid-rmi.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
> index 018f80f..cdfe165 100644
> --- a/drivers/hid/hid-rmi.c
> +++ b/drivers/hid/hid-rmi.c
> @@ -35,6 +35,7 @@
>  
>  /* device flags */
>  #define RMI_DEVICE			BIT(0)
> +#define RMI_DEVICE_HAS_PHYS_BUTTONS	BIT(1)
>  
>  enum rmi_mode_type {
>  	RMI_MODE_OFF			= 0,
> @@ -472,6 +473,9 @@ static int rmi_event(struct hid_device *hdev, struct hid_field *field,
>  	if ((data->device_flags & RMI_DEVICE) &&
>  	    (field->application == HID_GD_POINTER ||
>  	    field->application == HID_GD_MOUSE)) {
> +		if ((usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON)
> +			return 0;
> +
>  		rmi_schedule_reset(hdev);

I think here you will get a reset for each button press. I believe the
mouse collection is pretty generic and you should also get the relX|Y
events with the button press.

>  		return 1;
>  	}
> @@ -942,6 +946,10 @@ static int rmi_input_mapping(struct hid_device *hdev,
>  	 * we want to make HID ignore the advertised HID collection
>  	 * for RMI deivces
>  	 */
> +	if ((data->device_flags & RMI_DEVICE_HAS_PHYS_BUTTONS) &&
> +	    ((usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON))
> +		return 0;
> +
>  	if (data->device_flags & RMI_DEVICE)
>  		return -1;
>  
> -- 
> 2.1.0
> 

Cheers,
Benjamin

