Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3BLUmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:42:35 -0500
Received: from mga11.intel.com ([192.55.52.93]:27161 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757393Ab3BLUm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:42:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,652,1355126400"; 
   d="scan'208";a="290247303"
Date: Tue, 12 Feb 2013 12:42:24 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, Tilman Schmidt <tilman@imap.cc>,
        Matthias Schniedermeyer <ms@citd.de>
Subject: Re: [regression] external HDD in USB3 enclosure cannot be
 dynamically removed (Re: Linux 3.7.5)
Message-ID: <20130212204224.GC8427@xanatos>
References: <20130128045658.GA3488@kroah.com>
 <pan.2013.01.28.11.42.16.556318@googlemail.com>
 <20130128143907.GA2940@kroah.com>
 <pan.2013.01.28.20.33.44.918987@googlemail.com>
 <20130128204639.GB7759@google.com>
 <20130212004023.GA8427@xanatos>
 <511A1AF1.9080107@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <511A1AF1.9080107@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 11:35:29AM +0100, Holger Hoffstätte wrote:
> On 02/12/13 01:40, Sarah Sharp wrote:
> > Can you turn on CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING,
> > recompile the 3.7.5 kernel, and send me dmesg starting from the point
> > you unmount the device and then power it off?
> 
> I don't even need to mount/unmount; just plugging in/unplugging
> reproduces the problem. Note again that this is independent of both the
> used USB 3.0 card (might be the same chipset though?) and the attached
> device/enclosure.
> 
> So time to make a freshly built 3.8-rc7 go Ding Dong! :)

xHCI doorbells are fun. :)

I think I see the issue.  Your host controller reports the Inactive
state after a USB disconnect.  My host controllers go to the RxDetect
state on a disconnect.

The patches that went into 3.8 and the stable kernels to better handle
the Inactive state were not designed to handle a connected device going
to the Inactive state.  I thought that would be a rare case, but
apparently it's not.

There was a further set of patches queued for 3.9 to deal with connected
devices going to the Inactive state, but they looked like they were too
big for stable:

d3b9d7a USB: Fix connected device switch to Inactive state.
a24a607 USB: Rip out recursive call on warm port reset.
2d4fa94 USB: Prepare for refactoring by adding extra udev checks.
0fe51aa USB: Don't use EHCI port sempahore for USB 3.0 hubs.

Can you retry with Greg's usb-next branch?

git clone git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git -b usb-next

If that fixes your problem, we should either get those additional
patches into 3.8 and the stable trees, or do a revert of the whole
series and just let 3.9 carry the full patchset.

Sarah Sharp
