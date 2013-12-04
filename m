Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab3LDPVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:21:10 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50824 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932443Ab3LDPVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:21:09 -0500
Date: Wed, 4 Dec 2013 10:21:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: Re: [PATCH] usb: core: Abort deauthorization if unsetting configuration
 fails
In-Reply-To: <1386116201-22131-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1312041014460.1329-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Julius Werner wrote:

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
> This patch ensures that usb_deauthorize_device() aborts when
> usb_set_configuration() fails, and the underlying status code (such as
> ENODEV) is returned to userspace.

I don't like this approach at all.  It should always be possible to
deauthorize a device, no matter what.

Instead, how about changing usb_set_configuration() so that it will
never fail when the new config is -1?  Except perhaps for -ENODEV 
errors (the device has been disconnected), which 
usb_deauthorize_device() could check for.

Alan Stern

