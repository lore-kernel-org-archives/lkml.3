Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624AbaAaGY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 01:24:26 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8961 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaAaGYZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 01:24:25 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 30 Jan 2014 22:22:54 -0800
From: Manoj Chourasia <mchourasia@nvidia.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Date: Fri, 31 Jan 2014 11:54:46 +0530
Subject: RE: [PATCH] usb: hub: Avoid tight loop holding hdev lock
Thread-Topic: [PATCH] usb: hub: Avoid tight loop holding hdev lock
Thread-Index: Ac8QkFBBQk4whKLXSkSuSus6OiO/jQNu5I5g
Message-ID: <F1F6C959961EA744BBD5B8EEF8B8FEA16DE03B5041@BGMAIL02.nvidia.com>
References: <F1F6C959961EA744BBD5B8EEF8B8FEA16DDFCA6A2E@BGMAIL02.nvidia.com>
 <20140113185034.GB11751@kroah.com>
In-Reply-To: <20140113185034.GB11751@kroah.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Sorry, I forgot to mentioned base kernel version. Following patch based on linux-3.13.y till date.
I don't find a better way to avoid infinite loops. Moreover in worst case I find that device lock is held forever. Usually usb_open was able to get this lock in less than 5 seconds but rarely issue reproduces when it never gets lock for more than 2 minutes. 

--- drivers/usb/core/hub.c.orig 2014-01-30 12:49:39.797839231 +0530
+++ drivers/usb/core/hub.c      2014-01-30 12:49:56.189839229 +0530
@@ -4895,6 +4895,9 @@ static void hub_events(void)
                usb_unlock_device(hdev);
                kref_put(&hub->kref, hub_release);

+               /* preventing tight loop holding hdev lock */
+               msleep(20);
+
        } /* end while (1) */
 }

-Manoj


-----Original Message-----
From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org] 
Sent: Tuesday, January 14, 2014 12:21 AM
To: Manoj Chourasia
Cc: linux-kernel@vger.kernel.org; stable@kernel.org
Subject: Re: [PATCH] usb: hub: Avoid tight loop holding hdev lock

On Tue, Dec 31, 2013 at 02:26:41PM +0530, Manoj Chourasia wrote:
> Hi All,
> 
> I was facing an issue bad usb device which was affecting other system. Kernel was trying to enumerate the device but it was failing continuously. Unfortunately that device was on mounted onboard in the platform so I cannot remove it.
> The continuous re-enumeration of the device causing other application malfunctioning which were using libusb. I found that usb_find_devices() call was stuck in usb_open for very long time. It was stuck in getting device lock which was taken in hub_event thread.
> Solution was to add msleep in the loop to prevent is spinning tightly. 
> 
> ----------------------------------------------------------------------
> -----
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

Please don't make me hand-edit patches in order to be able to apply them.  I don't scale at all, so if you want this applied, please resend it.

Also, this isn't how you submit patches to the stable kernel tree, please read Documentation/stable_kernel_rules.txt for how to do that.

> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c index 
> c5c3667..b968fd5 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -4899,6 +4899,9 @@ static void hub_events(void)
>                 usb_unlock_device(hdev);
>                 kref_put(&hub->kref, hub_release);
> 
> +               /* preventing tight loop holding hdev lock */
> +               msleep(20);

This feels like a horrible hack for some seriously broken hardware.  Now I know we work around broken hardware all the time, is this really the only way the system can recover?

thanks,

greg k-h
