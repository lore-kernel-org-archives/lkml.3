Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaKVPzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 10:55:24 -0500
Received: from netrider.rowland.org ([192.131.102.5]:47741 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752039AbaKVPzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 10:55:22 -0500
Date: Sat, 22 Nov 2014 10:55:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benson Leung <bleung@chromium.org>
cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>,
        <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
In-Reply-To: <CANLzEkuPr0hhjecVHaMkGfX7_DZr4wUV=-yP2+V6uBaYdAkhXw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1411221043060.23393-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Benson Leung wrote:

> Sorry for the delay in my response. I did some more checking of my
> particular failure, and my commit message is incorrect. The
> usb_kill_urb is actually not the cause of this problem. It does not
> result in autosuspend_check() itself, and is only serving to add some
> delay.
> 
> hidraw_release() in hidraw.c calls drop_ref(), which calls the
> following in sequence upon clearing the last reader :
> /* close device for last reader */
> hid_hw_power(hidraw->hid, PM_HINT_NORMAL);
> hid_hw_close(hidraw->hid);
> 
> hid_hw_power results in a usb_autopm_put_interface. In this case, the
> reference count is decremented to 0, and a delayed autosuspend request
> is attempted.
> hid_hw_close leads to usbhid_close, which clears needs_remote_wakeup.
> 
> However, there's no guarantee that the clear of needs_remote_wakeup
> will occur before the delayed work ( runtime_idle() ->
> autosuspend_check() )  runs. Moving usbhid->intf->needs_remote_wakeup
> = 0 to before the usb_kill_urb(usbhid->urbin) only serves to reduce
> the amount of time between these events and makes this particular
> failure less likely.
> 
> The correct solution is to put get/put around each change of
> needs_remote_wakeup, as that will correctly trigger another delayed
> autosuspend_check(), whose result is affected by the state of
> needs_remote_wakeup.
> 
> Since autosuspend_check() occurs as delayed work, I think it is
> appropriate to add get/put around the clear in usbhid_stop as well.

As Oliver pointed out, there's no real need to resume a device which is
already suspended (the only effect would be to allow it to suspend
again but with wakeup disabled -- and this would happen anyway if a
wakeup occurred).  Instead of using get and put, we should have an idle
call.

There is no USB wrapper for pm_runtime_idle calls, but one could be
added.  Still, in the meantime can you check to see what happens if you
add

	pm_runtime_idle(&usbhid->intf->dev);

in usbhid_close() just after needs_remote_wakeup is set to 0?  You can 
do the same thing in usbhid_stop() if you want.

Alan Stern

