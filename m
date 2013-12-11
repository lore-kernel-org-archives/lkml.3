Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab3LKRCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:02:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55829 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751439Ab3LKRCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:02:16 -0500
Date: Wed, 11 Dec 2013 12:02:15 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: Re: [PATCH v2] usb: core: Make sure usb_set_configuration(-1) cannot
 fail
In-Reply-To: <1386300593-1270-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1312111155450.1531-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013, Julius Werner wrote:

> usb_deauthorize_device() tries to unset the configuration of a USB
> device and then unconditionally blows away the configuration descriptors
> with usb_destroy_configuration(). This is bad if the
> usb_set_configuration() call failed before the configuration could be
> correctly unset, since pointers like udev->actconfig can keep pointing
> to the now invalid memory. We have encountered hard to reproduce crashes
> from devices disconnected during suspend due to this, where khubd's
> disconnect handling races with userspace tools that change authorization
> on resume.
> 
> It seems desirable that a USB device can always be marked as
> unconfigured (reclaiming its bandwidth) in the kernel, regardless of
> communication problems. This patch changes usb_set_configuration() to
> ignore all failures in the case where no new configuration is being set.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>

Sorry for not getting back to this sooner.  Ironically, it looks like 
this change isn't needed any more, thanks to Thomas Pugliese's patch:

	http://marc.info/?l=linux-usb&m=138661805209999&w=2

> --- a/drivers/usb/core/message.c
> +++ b/drivers/usb/core/message.c

> @@ -1774,7 +1775,7 @@ free_interfaces:
>  
>  	/* Wake up the device so we can send it the Set-Config request */
>  	ret = usb_autoresume_device(dev);
> -	if (ret)
> +	if (ret && cp)
>  		goto free_interfaces;

That isn't quite right.  If the autoresume fails then we have to skip 
the autosuspend call later on.

Alan Stern

