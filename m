Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934168AbaKMUlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 15:41:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42556 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932767AbaKMUlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 15:41:44 -0500
Date: Thu, 13 Nov 2014 15:41:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Benson Leung <bleung@chromium.org>
cc: johan@kernel.org, <jkosina@suse.cz>, <linux-usb@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <snanda@chromium.org>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
In-Reply-To: <1415909806-23848-1-git-send-email-bleung@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1411131539330.929-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2014, Benson Leung wrote:

> usbhid->intf->needs_remote_wakeup is set when a device is
> opened, and is cleared when a device is closed.
> 
> When a usbhid device that does not support remote wake
> ( i.e. !device_can_wakeup() ) is closed, we fail out of
> autosuspend_check() because the autosuspend check is called
> before the flag is cleared as a result of usb_kill_urb(usbhid->urbin);
> 
> The result is that a device that may otherwise autosuspend will
> fail to enter suspend again after all handles to it are closed.
> 
> In usbhid_open, usb_autopm_get_interface is called
> before setting the needs_remote_wakeup flag, and
> usb_autopm_put_interface is called after hid_start_in.
> 
> However, when the device is closed in usbhid_close, the same
> protection isn't there when clearing needs_remote_wakeup. This will
> add that to usbhid_close as well as usbhid_stop.

usbhid_stop probably doesn't need it.  And it should be possible to fix 
usbhid_close more easily just by interchanging the two lines:

-			usb_kill_urb(usbhid->urbin);
 			usbhid->intf->needs_remote_wakeup = 0;
+			usb_kill_urb(usbhid->urbin);

Have you tried this?

Alan Stern

