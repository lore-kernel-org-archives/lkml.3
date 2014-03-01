Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaCAMWy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 07:22:54 -0500
Received: from smtp207.alice.it ([82.57.200.103]:42080 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbaCAMWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 07:22:51 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Mar 2014 07:22:50 EST
Date: Sat, 1 Mar 2014 13:16:58 +0100
From: Antonio Ospite <ao2@ao2.it>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] HID: sony: do not rely on hid_output_raw_report
Message-Id: <20140301131658.2168c54b91ade7a0a63d9fb6@ao2.it>
In-Reply-To: <1393633237-26496-4-git-send-email-benjamin.tissoires@redhat.com>
References: <1393633237-26496-1-git-send-email-benjamin.tissoires@redhat.com>
	<1393633237-26496-4-git-send-email-benjamin.tissoires@redhat.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

On Fri, 28 Feb 2014 19:20:36 -0500
Benjamin Tissoires <benjamin.tissoires@redhat.com> wrote:

> hid_out_raw_report is going to be obsoleted as it is not part of the
> unified HID low level transport documentation
> (Documentation/hid/hid-transport.txt)
> 
> To do so, we need to introduce two new quirks:
> * HID_QUIRK_NO_OUTPUT_REPORTS: this quirks prevents the transport
>   driver to use the interrupt channel to send output report (and thus
>   force to use HID_REQ_SET_REPORT command)

Maybe a little more informative name? Like:
	HID_QUIRK_NON_STD_OUTPUT_REPORTS
or
	HID_QUIRK_NO_OUTPUT_REPORTS_ON_INTR_EP
or expansions of the above.

The rationale being that, from outside, these are still output reports
(kind of), it's the channel they are sent over to which changes.

Another comment about a typo is inlined below.

Thanks,
   Antonio

> * HID_QUIRK_SKIP_OUTPUT_REPORT_ID: this one forces usbhid to not
>   include the report ID in the buffer it sends to the device through
>   HID_REQ_SET_REPORT in case of an output report
> 
> This also fixes a regression introduced in commit 3a75b24949a8
> (HID: hidraw: replace hid_output_raw_report() calls by appropriates ones).
> The hidraw API was not able to communicate with the PS3 SixAxis
> controllers in USB mode.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---
>  drivers/hid/hid-sony.c        | 59 ++++++++++---------------------------------
>  drivers/hid/hidraw.c          |  3 ++-
>  drivers/hid/usbhid/hid-core.c |  7 ++++-
>  include/linux/hid.h           |  2 ++
>  4 files changed, 24 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
> index b5fe65e..08eac71 100644
> --- a/drivers/hid/hid-sony.c
> +++ b/drivers/hid/hid-sony.c
> @@ -1007,45 +1007,6 @@ static int sony_mapping(struct hid_device *hdev, struct hid_input *hi,
>  }
>  
>  /*
> - * The Sony Sixaxis does not handle HID Output Reports on the Interrupt EP
> - * like it should according to usbhid/hid-core.c::usbhid_output_raw_report()
> - * so we need to override that forcing HID Output Reports on the Control EP.
> - *
> - * There is also another issue about HID Output Reports via USB, the Sixaxis
> - * does not want the report_id as part of the data packet, so we have to
> - * discard buf[0] when sending the actual control message, even for numbered
> - * reports, humpf!
> - */
> -static int sixaxis_usb_output_raw_report(struct hid_device *hid, __u8 *buf,
> -		size_t count, unsigned char report_type)
> -{
> -	struct usb_interface *intf = to_usb_interface(hid->dev.parent);
> -	struct usb_device *dev = interface_to_usbdev(intf);
> -	struct usb_host_interface *interface = intf->cur_altsetting;
> -	int report_id = buf[0];
> -	int ret;
> -
> -	if (report_type == HID_OUTPUT_REPORT) {
> -		/* Don't send the Report ID */
> -		buf++;
> -		count--;
> -	}
> -
> -	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
> -		HID_REQ_SET_REPORT,
> -		USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> -		((report_type + 1) << 8) | report_id,
> -		interface->desc.bInterfaceNumber, buf, count,
> -		USB_CTRL_SET_TIMEOUT);
> -
> -	/* Count also the Report ID, in case of an Output report. */
> -	if (ret > 0 && report_type == HID_OUTPUT_REPORT)
> -		ret++;
> -
> -	return ret;
> -}
> -
> -/*
>   * Sending HID_REQ_GET_REPORT changes the operation mode of the ps3 controller
>   * to "operational".  Without this, the ps3 controller will not report any
>   * events.
> @@ -1305,11 +1266,8 @@ static void sixaxis_state_worker(struct work_struct *work)
>  	buf[10] |= sc->led_state[2] << 3;
>  	buf[10] |= sc->led_state[3] << 4;
>  
> -	if (sc->quirks & SIXAXIS_CONTROLLER_USB)
> -		hid_output_raw_report(sc->hdev, buf, sizeof(buf), HID_OUTPUT_REPORT);
> -	else
> -		hid_hw_raw_request(sc->hdev, 0x01, buf, sizeof(buf),
> -				HID_OUTPUT_REPORT, HID_REQ_SET_REPORT);
> +	hid_hw_raw_request(sc->hdev, 0x01, buf, sizeof(buf), HID_OUTPUT_REPORT,
> +			HID_REQ_SET_REPORT);
>  }
>  
>  static void dualshock4_state_worker(struct work_struct *work)
> @@ -1659,7 +1617,18 @@ static int sony_probe(struct hid_device *hdev, const struct hid_device_id *id)
>  	}
>  
>  	if (sc->quirks & SIXAXIS_CONTROLLER_USB) {
> -		hdev->hid_output_raw_report = sixaxis_usb_output_raw_report;
> +		/*
> +		 * The Sony Sixaxis does not handle HID Output Reports on the
> +		 * Interrupt EP like it could, so we need to forcing HID Output
                                                             ^^^^
typo: "we need to force".

> +		 * Reports to use HID_REQ_SET_REPORT on the Control EP.
> +		 *
> +		 * There is also another issue about HID Output Reports via USB,
> +		 * the Sixaxis does not want the report_id as part of the data
> +		 * packet, so we have to discard buf[0] when sending the actual
> +		 * control message, even for numbered reports, humpf!
> +		 */
> +		hdev->quirks |= HID_QUIRK_NO_OUTPUT_REPORTS;
> +		hdev->quirks |= HID_QUIRK_SKIP_OUTPUT_REPORT_ID;
>  		ret = sixaxis_set_operational_usb(hdev);
>  		sc->worker_initialized = 1;
>  		INIT_WORK(&sc->state_worker, sixaxis_state_worker);
> diff --git a/drivers/hid/hidraw.c b/drivers/hid/hidraw.c
> index 2cc484c..6537e58 100644
> --- a/drivers/hid/hidraw.c
> +++ b/drivers/hid/hidraw.c
> @@ -149,7 +149,8 @@ static ssize_t hidraw_send_report(struct file *file, const char __user *buffer,
>  		goto out_free;
>  	}
>  
> -	if (report_type == HID_OUTPUT_REPORT) {
> +	if ((report_type == HID_OUTPUT_REPORT) &&
> +	    !(dev->quirks & HID_QUIRK_NO_OUTPUT_REPORTS)) {
>  		ret = hid_hw_output_report(dev, buf, count);
>  		/*
>  		 * compatibility with old implementation of USB-HID and I2C-HID:
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 0d1d875..3bc7cad 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -894,7 +894,12 @@ static int usbhid_set_raw_report(struct hid_device *hid, unsigned int reportnum,
>  	int ret, skipped_report_id = 0;
>  
>  	/* Byte 0 is the report number. Report data starts at byte 1.*/
> -	buf[0] = reportnum;
> +	if ((rtype == HID_OUTPUT_REPORT) &&
> +	    (hid->quirks & HID_QUIRK_SKIP_OUTPUT_REPORT_ID))
> +		buf[0] = 0;
> +	else
> +		buf[0] = reportnum;
> +
>  	if (buf[0] == 0x0) {
>  		/* Don't send the Report ID */
>  		buf++;
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 5eb282e..2baf834 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -287,6 +287,8 @@ struct hid_item {
>  #define HID_QUIRK_NO_EMPTY_INPUT		0x00000100
>  #define HID_QUIRK_NO_INIT_INPUT_REPORTS		0x00000200
>  #define HID_QUIRK_SKIP_OUTPUT_REPORTS		0x00010000
> +#define HID_QUIRK_SKIP_OUTPUT_REPORT_ID		0x00020000
> +#define HID_QUIRK_NO_OUTPUT_REPORTS		0x00040000
>  #define HID_QUIRK_FULLSPEED_INTERVAL		0x10000000
>  #define HID_QUIRK_NO_INIT_REPORTS		0x20000000
>  #define HID_QUIRK_NO_IGNORE			0x40000000
> -- 
> 1.8.5.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
