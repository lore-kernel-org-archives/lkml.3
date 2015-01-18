Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbbARVMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 16:12:31 -0500
Received: from netrider.rowland.org ([192.131.102.5]:49574 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751244AbbARVM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 16:12:27 -0500
Date: Sun, 18 Jan 2015 16:12:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jim Keir <jimkeir@oracledbadirect.com>
cc: linux-input@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <jkosina@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 001/001] usbhid: Fix initialisation and force effect
 modifications for the Microsoft Sidewinder Force Feedback Pro 2 joystick
In-Reply-To: <0000014afdcc643d-a943b494-4c10-4fa0-a85b-d36e89d6b09a-000000@email.amazonses.com>
Message-ID: <Pine.LNX.4.44L0.1501181605050.5911-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2015, Jim Keir wrote:

> From: Jim Keir <jimkeir@yahoo.co.uk>
> Signed-off-by: Jim Keir <jimkeir@yahoo.co.uk>
> 
> Currently the SWFF2 driver fails during initialisation, making the force
> capability of the joystick unusable. Further, there is a long-standing
> bug in the same driver where commands to update force parameters are
> addressed to the last-created force effect instead of the specified one,
> making it impossible to modify effects after their creation.
> 
> Three bugs are addressed:
> 
> 1) The FF2 driver (usbhid/hid-pidff.c) sends commands to the stick
> during ff_init. However, this is called inside a block where
> driver_input_lock is locked, so the results of these initial commands
> are discarded. This one is the "killer", without this nothing else works.
> 
> ff_init issues commands using "hid_hw_request". This eventually goes to
> hid_input_report, which returns -EBUSY because driver_input_lock is
> locked. The change is to delay the ff_init call in hid-core.c until
> after this lock has been released.
> 
> 2) The usbhid driver ignores an endpoint stall when sending control
> commands, causing the first few commands of the hid-pidff.c
> initialisation to get lost.
> 
> usbhid/hid-core.c has been modified by copying lines into "hid_ctrl"
> from the "hid_irq_in" function in the same file.
> 
> 3) The FF2 driver (usbhid/hid-pidff.c) does not set the effect ID when
> uploading an effect. The result is that the initial upload works but
> subsequent uploads to modify effect parameters are all directed at the
> last-created effect.
> 
> The targeted effect ID must be passed back to the device when effect
> parameters are changed. This is done at the start of
> "pidff_set_condition_report", "pidff_set_periodic_report" etc. based on
> the value of "pidff->block_load[PID_EFFECT_BLOCK_INDEX].value[0]".
> However, this value is only ever set during pidff_request_effect_upload.
> The result is stored in "pidff->pid_id[effect->id]" at the end of
> pid_upload_effect, for later use. However, if an effect is modified and
> re-sent then this identifier is not being copied back from
> pidff->pid_id[effect->id] before sending the command to the device. The
> fix is to do this at the start of pidff_upload_effect.
> 
> This patch taken against kernel 3.13.0

Three different changes should be split up into three different 
patches.  Also, you should test the patch by running it through 
checkpatch.pl before submitting it.

Regardless of those things, the second change (stall response to
control messages) is wrong for several reasons.

> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index 029965e..5d34dd7 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -505,7 +505,12 @@ static void hid_ctrl(struct urb *urb)
>       case -EPROTO:        /* protocol error or unplug */
>       case -ECONNRESET:    /* unlink */
>       case -ENOENT:
> +        break;
>       case -EPIPE:        /* report not available */
> +        usbhid_mark_busy(usbhid);
> +        clear_bit(HID_IN_RUNNING, &usbhid->iofl);

This is wrong.  The interrupt-IN endpoint is still running, because it 
is unaffected by an error on the control endpoint.

> +        set_bit(HID_CLEAR_HALT, &usbhid->iofl);

This makes no sense.  Stalls on a control endpoint do not need a
clear-halt because the endpoint does not halt.  In any case, this flag
tells the driver to clear a halt condition on the interrupt-IN 
endpoint, not on the control endpoint.

> +        schedule_work(&usbhid->reset_work);
>           break;
>       default:        /* error */
>           hid_warn(urb->dev, "ctrl urb status %d received\n", status);

In general, there isn't much you can do about a control stall.  It 
means the device did not understand or does not support the request it 
received.  You can't force the device to respond to a request it 
doesn't understand; all you can do is report that the transfer failed.  
Which is what the driver currently does.

Alan Stern

