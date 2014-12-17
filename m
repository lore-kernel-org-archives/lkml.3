Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaLQBSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 20:18:43 -0500
Received: from lekensteyn.nl ([178.21.112.251]:52363 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbaLQBSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 20:18:41 -0500
From: Peter Wu <peter@lekensteyn.nl>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: logitech-hidpp: store the name of the device in struct hidpp
Date: Wed, 17 Dec 2014 02:18:30 +0100
Message-ID: <3321911.knGKb1BsCe@al>
User-Agent: KMail/4.14.3 (Linux/3.17.0-rc4-custom-00168-g7ec62d4; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1418767562-4136-2-git-send-email-benjamin.tissoires@redhat.com>
References: <1418767562-4136-1-git-send-email-benjamin.tissoires@redhat.com> <1418767562-4136-2-git-send-email-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 December 2014 17:06:02 Benjamin Tissoires wrote:
> If a disconnect occurs while getting the actual name of the device
> (which can take several HID transactions), the name of the device will
> be the hid name, provided by the Unifying Receiver.
> This means that in some cases, the user space will see a different
> name that what it usually sees when there is no disconnect.
> 
> We should store the name of the device in the struct hidpp. That way,
> if a disconnect occurs while we are accessing the name,
> hidpp_connect_event() can fail, and the input node is not created.
> 
> The input node will be created only if we have a connection which
> lasts long enough to retrieve all the requested information:
> name, protocol, and specific configuration.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-logitech-hidpp.c | 31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> index c0fb5fe..4bc8714 100644
> --- a/drivers/hid/hid-logitech-hidpp.c
> +++ b/drivers/hid/hid-logitech-hidpp.c
> @@ -89,6 +89,7 @@ struct hidpp_device {
>  	struct hid_device *hid_dev;
>  	struct mutex send_mutex;
>  	void *send_receive_buf;
> +	char *name;
>  	wait_queue_head_t wait;
>  	bool answer_available;
>  	u8 protocol_major;
> @@ -1087,6 +1088,7 @@ static void hidpp_input_close(struct input_dev *dev)
>  static struct input_dev *hidpp_allocate_input(struct hid_device *hdev)
>  {
>  	struct input_dev *input_dev = devm_input_allocate_device(&hdev->dev);
> +	struct hidpp_device *hidpp = hid_get_drvdata(hdev);
>  
>  	if (!input_dev)
>  		return NULL;
> @@ -1095,7 +1097,7 @@ static struct input_dev *hidpp_allocate_input(struct hid_device *hdev)
>  	input_dev->open = hidpp_input_open;
>  	input_dev->close = hidpp_input_close;
>  
> -	input_dev->name = hdev->name;
> +	input_dev->name = hidpp->name;
>  	input_dev->phys = hdev->phys;
>  	input_dev->uniq = hdev->uniq;
>  	input_dev->id.bustype = hdev->bus;
> @@ -1137,22 +1139,28 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
>  	hid_info(hdev, "HID++ %u.%u device connected.\n",
>  		 hidpp->protocol_major, hidpp->protocol_minor);
>  
> +	if (!hidpp->name || hidpp->name == hdev->name) {

Hm, is it ever possible that hidpp->name is NULL? probe sets the pointer
to an array (hdev->name). Defence in depth I guess, but perhaps a
comment could clarify this?

Otherwise the changes look OK. I have tested this situation:

 1. Insert receiver
 2. Return a HID++ version for the WTP.
 3. Return -9 (ResourceError) for the device name feature request (via
    the QEMU emulation).
 4. Observe that this fails.

So maybe you could add a comment for the above and add these tags:

Reviewed-by: Peter Wu <peter@lekensteyn.nl>
Tested-by: Peter Wu <peter@lekensteyn.nl>

Kind regards,
Peter

> +		name = hidpp_get_device_name(hidpp);
> +		if (!name) {
> +			hid_err(hdev,
> +				"unable to retrieve the name of the device");
> +			return;
> +		}
> +
> +		devm_name = devm_kasprintf(&hdev->dev, GFP_KERNEL, "%s", name);
> +		kfree(name);
> +		if (!devm_name)
> +			return;
> +
> +		hidpp->name = devm_name;
> +	}
> +
>  	input = hidpp_allocate_input(hdev);
>  	if (!input) {
>  		hid_err(hdev, "cannot allocate new input device: %d\n", ret);
>  		return;
>  	}
>  
> -	name = hidpp_get_device_name(hidpp);
> -	if (!name) {
> -		hid_err(hdev, "unable to retrieve the name of the device");
> -	} else {
> -		devm_name = devm_kasprintf(&hdev->dev, GFP_KERNEL, "%s", name);
> -		if (devm_name)
> -			input->name = devm_name;
> -		kfree(name);
> -	}
> -
>  	hidpp_populate_input(hidpp, input, false);
>  
>  	ret = input_register_device(input);
> @@ -1175,6 +1183,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  		return -ENOMEM;
>  
>  	hidpp->hid_dev = hdev;
> +	hidpp->name = hdev->name;
>  	hid_set_drvdata(hdev, hidpp);
>  
>  	hidpp->quirks = id->driver_data;
> 

