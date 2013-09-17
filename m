Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab3IQJ4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 05:56:20 -0400
Received: from plane.gmane.org ([80.91.229.3]:56536 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab3IQJ4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 05:56:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: [PATCH 2/2] staging: rts5139: Use correct USB transfer interval
 to fix syslog spamming
Date: Tue, 17 Sep 2013 11:56:07 +0200
Message-ID: <52382737.7030608@5t9.de>
References: <1370283242-24434-1-git-send-email-marcus.overhagen@gmail.com> <1370283242-24434-3-git-send-email-marcus.overhagen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
X-Gmane-NNTP-Posting-Host: barriere.frankfurter-softwarefabrik.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
In-Reply-To: <1370283242-24434-3-git-send-email-marcus.overhagen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 08:14 PM, Marcus Overhagen wrote:
> Using correct transfer interval as specified by the USB endpoint
> when doing the interrupt transfer fixes the warning printed by
> xhci USB core on every transfer that resulted in spamming
> "xhci_queue_intr_tx: 74 callbacks suppressed" to syslog
> every 5 seconds.
>
> Signed-off-by: Marcus Overhagen <marcus.overhagen@gmail.com>
> ---
>   drivers/staging/rts5139/rts51x_transport.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/staging/rts5139/rts51x_transport.c b/drivers/staging/rts5139/rts51x_transport.c
> index c573618..c172f4a 100644
> --- a/drivers/staging/rts5139/rts51x_transport.c
> +++ b/drivers/staging/rts5139/rts51x_transport.c
> @@ -635,10 +635,10 @@ int rts51x_get_epc_status(struct rts51x_chip *chip, u16 *status)
>   	ep = chip->usb->pusb_dev->ep_in[usb_pipeendpoint(pipe)];
>
>   	/* fill and submit the URB */
> -	/* We set interval to 1 here, so the polling interval is controlled
> -	 * by our polling thread */
> +	/* Set interval to 10 here to match the endpoint descriptor,
> +	 * the polling interval is controlled by the polling thread */
>   	usb_fill_int_urb(chip->usb->intr_urb, chip->usb->pusb_dev, pipe,
> -			 status, 2, urb_done_completion, &urb_done, 1);
> +			 status, 2, urb_done_completion, &urb_done, 10);
>
>   	result = rts51x_msg_common(chip, chip->usb->intr_urb, 100);

This change breaks the rts5139 driver for me: I have been using the
rts5139 driver with the built-in card reader of an Asus UX32VD (see
http://www.linlap.com/asus_ux32vd for all Details on that hardware)
and linux-3.8.8 successfully for quite a long time.

I recently upgraded to linux-3.11.1, which includes the above patch.

After upgrading I got I/O-errors like the following ones while reading -
when I just "dd" from the device to /dev/null, these errors occur
after transferring somewhere from ~700MB to ~7GB, and even though this
sounds like an erratic behaviour, it is perfectly reproducable every
time I just read continously from the device:

> kernel: [ 1540.909901] sd 8:0:0:0: [sdc] Device not ready
> kernel: [ 1540.909905] sd 8:0:0:0: [sdc]
> kernel: [ 1540.909906] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> kernel: [ 1540.909908] sd 8:0:0:0: [sdc]
> kernel: [ 1540.909909] Sense Key : Not Ready [current]
> kernel: [ 1540.909912] sd 8:0:0:0: [sdc]
> kernel: [ 1540.909915] Add. Sense: Medium not present
> kernel: [ 1540.909917] sd 8:0:0:0: [sdc] CDB:
> kernel: [ 1540.909918] Read(10): 28 00 00 0f 8d f0 00 00 10 00
> kernel: [ 1540.909923] end_request: I/O error, dev sdc, sector 1019376
> kernel: [ 1540.909926] quiet_error: 26 callbacks suppressed
> kernel: [ 1540.909927] Buffer I/O error on device sdc, logical block 127422
> kernel: [ 1540.909931] Buffer I/O error on device sdc, logical block 127423
> kernel: [ 1540.909961] sd 8:0:0:0: [sdc] Device not ready
> kernel: [ 1540.909963] sd 8:0:0:0: [sdc]
> kernel: [ 1540.909963] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> kernel: [ 1540.909965] sd 8:0:0:0: [sdc]
> kernel: [ 1540.909965] Sense Key : Not Ready [current]
> kernel: [ 1540.909967] sd 8:0:0:0: [sdc]
> kernel: [ 1540.909968] Add. Sense: Medium not present
> kernel: [ 1540.909970] sd 8:0:0:0: [sdc] CDB:
> kernel: [ 1540.909970] Read(10): 28 00 00 0f 8e 00 00 00 f0 00
> kernel: [ 1540.909975] end_request: I/O error, dev sdc, sector 1019392
> kernel: [ 1540.909976] Buffer I/O error on device sdc, logical block 127424
> kernel: [ 1540.909977] Buffer I/O error on device sdc, logical block 127425
> kernel: [ 1540.909978] Buffer I/O error on device sdc, logical block 127426
> kernel: [ 1540.909980] Buffer I/O error on device sdc, logical block 127427
> kernel: [ 1540.909981] Buffer I/O error on device sdc, logical block 127428
> kernel: [ 1540.909982] Buffer I/O error on device sdc, logical block 127429
> kernel: [ 1540.909983] Buffer I/O error on device sdc, logical block 127430
> kernel: [ 1540.909985] Buffer I/O error on device sdc, logical block 127431

I verified, with different SDXC cards, that I reliably do not get these
errors when booting linux-3.8.8, then I reverted
> 			 status, 2, urb_done_completion, &urb_done, 10);
back into
> 			 status, 2, urb_done_completion, &urb_done, 1);
in the linux-3.11.1 source, and verified that then linux-3.11.1
works as good as linux-3.8.8 with the "dd to /dev/null" again, no more
I/O-errors like the above.
(BTW: The SDXC card I was using most was a SanDisk Extreme Pro 64GB SDXC.)

Your comment on the change says it is meant to get rid of syslog messages like:
  "xhci_queue_intr_tx: 74 callbacks suppressed"
I do not have such messages, neither with or without the above change.

Regards,

Lutz Vieweg

