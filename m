Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966287Ab3E2OXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:23:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38937 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759576Ab3E2OXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:23:03 -0400
Date: Wed, 29 May 2013 10:23:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Shawn Nematbakhsh <shawnn@google.com>, <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: xhci: Disable runtime PM suspend for quirky
 controllers.
In-Reply-To: <CAODwPW8ynh3238T6gOVmneMqsbdR2m+wPnVLbS7c38mQxCpBSQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1305291015230.1473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013, Julius Werner wrote:

> The policy we want to achieve is to disable runtime PM iff there is a
> device connected that doesn't have persist_enabled or a reset_resume()
> handler and whose parent/root hub resets on resume, right? So couldn't

Probably just root hub, not parent.  A non-root hub that resets upon 
resume wouldn't be a good idea.  Also, we know in advance that the hub 
driver _does_ have a reset-resume handler.

> we remove the HCD-specific XHCI_RESET_ON_RESUME and set the (existing)
> generic USB_QUIRK_RESET_RESUME on the root hub instead? Then we could
> handle all of this in the USB core (during device initialization and
> when changing persist_enabled through sysfs) by just checking for
> udev->reset_resume on all parent hubs of the device in question (and
> use pm_runtime_get/put() on said device to prevent its parents from
> suspending as appropriate).

This sounds too intricate to me.  You might want to prevent resets even 
if the device does support reset-resume, because they consume time.  Or 
you might not care about resets even if persist isn't enabled (consider 
a USB mouse, for example).

I agree that setting the RESET_RESUME quirk on the root hub is a good
way to represent the situation.  And perhaps the kernel could implement 
a useful default policy -- but userspace should ultimately remain in 
control.

Alan Stern

