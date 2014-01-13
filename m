Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaAMSuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:50:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbaAMSt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:49:58 -0500
Date: Mon, 13 Jan 2014 10:50:34 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Manoj Chourasia <mchourasia@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] usb: hub: Avoid tight loop holding hdev lock
Message-ID: <20140113185034.GB11751@kroah.com>
References: <F1F6C959961EA744BBD5B8EEF8B8FEA16DDFCA6A2E@BGMAIL02.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F1F6C959961EA744BBD5B8EEF8B8FEA16DDFCA6A2E@BGMAIL02.nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 31, 2013 at 02:26:41PM +0530, Manoj Chourasia wrote:
> Hi All,
> 
> I was facing an issue bad usb device which was affecting other system. Kernel was trying to enumerate the device but it was failing continuously. Unfortunately that device was on mounted onboard in the platform so I cannot remove it.
> The continuous re-enumeration of the device causing other application malfunctioning which were using libusb. I found that usb_find_devices() call was stuck in usb_open for very long time. It was stuck in getting device lock which was taken in hub_event thread.
> Solution was to add msleep in the loop to prevent is spinning tightly. 
> 
> ---------------------------------------------------------------------------
> usb: hub: Avoid tight loop holding hdev lock
> 
>    Other system call(like usb_open) to root port device
>     starved in getting device lock when the while loop
>     in hub_event loops tightly because of misbehaving device.
> 
>     Adding a small msleep provides chance to system calls to
>     schedule.
> 
>     The issue was returning -EPROTO and re-enumerating with
>     continuous hub_events. That was makes the while loop in
>     hub_event to spin tightly.
> 
>     usb_find_devices call from libusb tries to open all devices
>     including root hub. The call to usb_open stuck for very
>     long time(sometimes forever) because the priority of
>     kernel thread is higher than that system call in this case.
> 
>     Signed-off-by: Manoj Chourasia <mchourasia@nvidia.com>  

Please don't make me hand-edit patches in order to be able to apply
them.  I don't scale at all, so if you want this applied, please resend
it.

Also, this isn't how you submit patches to the stable kernel tree,
please read Documentation/stable_kernel_rules.txt for how to do that.

> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index c5c3667..b968fd5 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -4899,6 +4899,9 @@ static void hub_events(void)
>                 usb_unlock_device(hdev);
>                 kref_put(&hub->kref, hub_release);
> 
> +               /* preventing tight loop holding hdev lock */
> +               msleep(20);

This feels like a horrible hack for some seriously broken hardware.  Now
I know we work around broken hardware all the time, is this really the
only way the system can recover?

thanks,

greg k-h
