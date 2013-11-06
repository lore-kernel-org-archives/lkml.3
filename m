Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064Ab3KFWmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 17:42:00 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:56816 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3KFWlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 17:41:55 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1311061648220.1220-100000@iolanthe.rowland.org>
References: <1383769641-22910-1-git-send-email-jwerner@chromium.org>
	<Pine.LNX.4.44L0.1311061648220.1220-100000@iolanthe.rowland.org>
Date: Wed, 6 Nov 2013 14:41:54 -0800
X-Google-Sender-Auth: i9T3j5A-MsqwOBpRk4JZBrrqiKo
Message-ID: <CAODwPW8j2wGGgH_HjuXuH=95jd_B1iqWeifoT89xgJoEZRvphw@mail.gmail.com>
Subject: Re: [PATCH] usb: hub: Use correct reset for wedged USB3 devices that
 are NOTATTACHED
From: Julius Werner <jwerner@chromium.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Who makes those calls, drivers?  Any specific ones that you know need to
be fixed?

Well, the one I'm worried about is the one this patch is fixing, in
hub_events(). I have seen this happen when having certain USB3 devices
plugged into a host controller that always looses power on
suspend-to-ram (dwc3-exynos). Since the host controller resets itself
the port no longer has PORT_STAT_ENABLE set and that causes
hub_activate() to mark the device as USB_STATE_NOTATTACHED. The next
time khubd runs hub_events(), the port may be in Compliance Mode
(because the unexpected HC reset can confuse the link state machines
on both sides) and the kernel correctly tries to reset it, but doesn't
take the fact into account that usb_reset_device() doesn't work on
NOTATTACHED devices.

> But what can a user do if those messages show up?

Nothing. I was just thinking this might help developers follow the
kernel decisions better and understand a potential problem faster
(e.g. if the user posted his log in a bug report somewhere).

> What if the device is in USB_STATE_SUSPENDED?

I'm not sure that is possible at that point in hub_events(), I don't
know of a way that could lead to this situation. I could still add the
check just to be sure if you want it, though.

> Not at all.  If a device is unplugged, its state changes to NOTATTACHED
> before the driver is unbound.  During that time, the driver will see
> all its URBs failing, so it may very well try to reset the device.
> (For example, usbhid behaves like this.)  That isn't a bug.

Oh, okay, I wasn't quite sure how that plays together. Would you think
it's still valuable to print it out (maybe as dev_info() instead of
dev_warn()) instead of just silently ignoring the reset request? It
would have certainly been useful for me to find this problem faster,
but I can take it out again if you think it would result in too much
noise.
