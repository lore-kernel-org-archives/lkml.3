Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678AbaCFPLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 10:11:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:34480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbaCFPLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 10:11:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,600,1389772800"; 
   d="scan'208";a="416171025"
Date: Thu, 6 Mar 2014 07:11:33 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Robert Hancock <hancockrwd@gmail.com>,
        "Nyman, Mathias" <mathias.nyman@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-usb <linux-usb@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: xHCI regression in stable 3.13.5 with USB3 card reader (Bisected)
Message-ID: <20140306151133.GA5858@xanatos>
References: <531804E7.2040406@gmail.com>
 <5318156F.7050904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5318156F.7050904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Mathias.]

On Thu, Mar 06, 2014 at 12:27:59AM -0600, Robert Hancock wrote:
> On 05/03/14 11:17 PM, Robert Hancock wrote:
> >I have a USB 3.0 multi-card reader device:
> >
> >Bus 004 Device 002: ID 05e3:0743 Genesys Logic, Inc.
> >
> >which seems to work fine in 3.13.4 (Fedora version kernel-3.13.4-200
> >specifically) but fails in 3.13.5 (specifically kernel-3.13.5-202).
> >Below is what I get in dmesg. Essentially there's a bunch of
> >input/output errors making the reader mostly unusable.
> >
> >This is on an Intel Haswell machine with this controller:
> >
> >00:14.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series
> >Chipset Family USB xHCI [8086:8c31] (rev 05)
> >
> >It looks like there were some XHCI commits that went into 3.13.5 so it
> >seems likely one of those is the cause. I can try current git if there's
> >anything in there that's likely to fix it. But it does seem like a
> >regression got into the stable kernel in this respect.
> 
> Bisecting between 3.13.4 and 3.13.5 gives me this:
> 
> c8f44f98901994832ccecb87c3dd7900274b699a is the first bad commit
> commit c8f44f98901994832ccecb87c3dd7900274b699a
> Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Date:   Fri Jan 31 11:26:25 2014 -0800
> 
>     xhci 1.0: Limit arbitrarily-aligned scatter gather.

Yes, this is a known regression.  That commit should be reverted in
3.14-rc shortly, and the patch will be backported to stable kernels.
Mathias is taking over as xHCI maintainer, and he will queue the revert
patches to Greg shortly.

Sarah Sharp

> 
>     commit 247bf557273dd775505fb9240d2d152f4f20d304 upstream.
> 
>     xHCI 1.0 hosts have a set of requirements on how to align transfer
>     buffers on the endpoint rings called "TD fragment" rules.  When the
>     ax88179_178a driver added support for scatter gather in 3.12, with
>     commit 804fad45411b48233b48003e33a78f290d227c8 "USBNET: ax88179_178a:
>     enable tso if usb host supports sg dma", it broke the device under xHCI
>     1.0 hosts.  Under certain network loads, the device would see an
>     unexpected short packet from the host, which would cause the device to
>     stop sending ethernet packets, even through USB packets would still be
>     sent.
> 
>     Commit 35773dac5f86 "usb: xhci: Link TRB must not occur within a USB
>     payload burst" attempted to fix this.  It was a quick hack to partially
>     implement the TD fragment rules.  However, it caused regressions in the
>     usb-storage layer and userspace USB drivers using libusb.  The patches
>     to attempt to fix this are too far reaching into the USB core, and we
>     really need to implement the TD fragment rules correctly in the xHCI
>     driver, instead of continuing to wallpaper over the issues.
> 
>     Disable arbitrarily-aligned scatter-gather in the xHCI driver for 1.0
>     hosts.  Only the ax88179_178a driver checks the no_sg_constraint flag,
>     so don't set it for 1.0 hosts.  This should not impact usb-storage or
>     usbfs behavior, since they pass down max packet sized aligned sg-list
>     entries (512 for USB 2.0 and 1024 for USB 3.0).
> 
>     Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>     Tested-by: Mark Lord <mlord@pobox.com>
>     Cc: David Laight <David.Laight@ACULAB.COM>
>     Cc: Bjørn Mork <bjorn@mork.no>
>     Cc: Freddy Xin <freddy@asix.com.tw>
>     Cc: Ming Lei <ming.lei@canonical.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
