Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbaJ1UEG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:04:06 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:46803 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaJ1UEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <1412101702-2752-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1412101702-2752-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Tue, 28 Oct 2014 16:04:02 -0400
Message-ID: <CAN+gG=F6HSXmYb9umO4ZT5hbGy=dL4ncgm4nTe1bL86meZHL3w@mail.gmail.com>
Subject: Re: [PATCH] HID: usbhid: prevent unwanted events to be sent when
 re-opening the device
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 2:28 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> When events occurs while no one is listening to the node (hid->open == 0
> and usb_kill_urb() called) some events are still stacked somewhere in
> the USB (kernel or device?) stack. When the node gets reopened, these
> events are drained, and this results in spurious touch down/up, or mouse
> button clicks.
>
> The problem was spotted with touchscreens in fdo bug #81781 [1], but it
> actually occurs with any mouse using hid-generic or touchscreen.
>
> A way to reproduce it is to call:
>
> $ xinput disable 9 ; sleep 5 ; xinput enable 9
>
> With 9 being the device ID for the touchscreen/mouse. During the "sleep",
> produce some touch events or click events. When "xinput enable" is called,
> at least one click is generated.
>
> This patch tries to fix this by draining the queue for 50 msec and
> during this time frame, not forwarding these old events to the hid layer.
>
> Hans completed the explanation:
> """
> Devices like mice (basically any hid device) will have a fifo
> on the device side, when we stop submitting urbs to get hid reports from
> it, that fifo will fill up, and when we resume we will get whatever
> is there in that fifo.
> """
>
> [1] https://bugs.freedesktop.org/show_bug.cgi?id=81781
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> ---

My turn to raise patches lost in the mailboxes during the merge window....

Jiri, can you re-add this one to the pile of "things that you don't
want to do but some people are really relying on it so somebody still
needs to review it, sigh" list?

Cheers,
Benjamin

>
> OK, I know this is uggly, but I could not find a better way :(
>
> Cheers,
> Benjamin
>
>  drivers/hid/usbhid/hid-core.c | 36 ++++++++++++++++++++++++------------
>  drivers/hid/usbhid/usbhid.h   |  1 +
>  2 files changed, 25 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index ca6849a..04e34b9 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -278,18 +278,20 @@ static void hid_irq_in(struct urb *urb)
>                 usbhid->retry_delay = 0;
>                 if ((hid->quirks & HID_QUIRK_ALWAYS_POLL) && !hid->open)
>                         break;
> -               hid_input_report(urb->context, HID_INPUT_REPORT,
> -                                urb->transfer_buffer,
> -                                urb->actual_length, 1);
> -               /*
> -                * autosuspend refused while keys are pressed
> -                * because most keyboards don't wake up when
> -                * a key is released
> -                */
> -               if (hid_check_keys_pressed(hid))
> -                       set_bit(HID_KEYS_PRESSED, &usbhid->iofl);
> -               else
> -                       clear_bit(HID_KEYS_PRESSED, &usbhid->iofl);
> +               if (!test_bit(HID_RESUME_RUNNING, &usbhid->iofl)) {
> +                       hid_input_report(urb->context, HID_INPUT_REPORT,
> +                                        urb->transfer_buffer,
> +                                        urb->actual_length, 1);
> +                       /*
> +                        * autosuspend refused while keys are pressed
> +                        * because most keyboards don't wake up when
> +                        * a key is released
> +                        */
> +                       if (hid_check_keys_pressed(hid))
> +                               set_bit(HID_KEYS_PRESSED, &usbhid->iofl);
> +                       else
> +                               clear_bit(HID_KEYS_PRESSED, &usbhid->iofl);
> +               }
>                 break;
>         case -EPIPE:            /* stall */
>                 usbhid_mark_busy(usbhid);
> @@ -688,6 +690,7 @@ int usbhid_open(struct hid_device *hid)
>                         goto done;
>                 }
>                 usbhid->intf->needs_remote_wakeup = 1;
> +               set_bit(HID_RESUME_RUNNING, &usbhid->iofl);
>                 res = hid_start_in(hid);
>                 if (res) {
>                         if (res != -ENOSPC) {
> @@ -701,6 +704,15 @@ int usbhid_open(struct hid_device *hid)
>                         }
>                 }
>                 usb_autopm_put_interface(usbhid->intf);
> +
> +               /*
> +                * In case events are generated while nobody was listening,
> +                * some are released when the device is re-opened.
> +                * Wait 50 msec for the queue to empty before allowing events
> +                * to go through hid.
> +                */
> +               msleep(50);
> +               clear_bit(HID_RESUME_RUNNING, &usbhid->iofl);
>         }
>  done:
>         mutex_unlock(&hid_open_mut);
> diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
> index f633c24..807922b 100644
> --- a/drivers/hid/usbhid/usbhid.h
> +++ b/drivers/hid/usbhid/usbhid.h
> @@ -52,6 +52,7 @@ struct usb_interface *usbhid_find_interface(int minor);
>  #define HID_STARTED            8
>  #define HID_KEYS_PRESSED       10
>  #define HID_NO_BANDWIDTH       11
> +#define HID_RESUME_RUNNING     12
>
>  /*
>   * USB-specific HID struct, to be pointed to
> --
> 2.1.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
