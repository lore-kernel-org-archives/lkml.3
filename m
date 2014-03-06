Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaCFG2F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 01:28:05 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:58096 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaCFG2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 01:28:02 -0500
Message-ID: <5318156F.7050904@gmail.com>
Date: Thu, 06 Mar 2014 00:27:59 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-usb <linux-usb@vger.kernel.org>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: xHCI regression in stable 3.13.5 with USB3 card reader (Bisected)
References: <531804E7.2040406@gmail.com>
In-Reply-To: <531804E7.2040406@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 11:17 PM, Robert Hancock wrote:
> I have a USB 3.0 multi-card reader device:
>
> Bus 004 Device 002: ID 05e3:0743 Genesys Logic, Inc.
>
> which seems to work fine in 3.13.4 (Fedora version kernel-3.13.4-200
> specifically) but fails in 3.13.5 (specifically kernel-3.13.5-202).
> Below is what I get in dmesg. Essentially there's a bunch of
> input/output errors making the reader mostly unusable.
>
> This is on an Intel Haswell machine with this controller:
>
> 00:14.0 USB controller [0c03]: Intel Corporation 8 Series/C220 Series
> Chipset Family USB xHCI [8086:8c31] (rev 05)
>
> It looks like there were some XHCI commits that went into 3.13.5 so it
> seems likely one of those is the cause. I can try current git if there's
> anything in there that's likely to fix it. But it does seem like a
> regression got into the stable kernel in this respect.

Bisecting between 3.13.4 and 3.13.5 gives me this:

c8f44f98901994832ccecb87c3dd7900274b699a is the first bad commit
commit c8f44f98901994832ccecb87c3dd7900274b699a
Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Date:   Fri Jan 31 11:26:25 2014 -0800

     xhci 1.0: Limit arbitrarily-aligned scatter gather.

     commit 247bf557273dd775505fb9240d2d152f4f20d304 upstream.

     xHCI 1.0 hosts have a set of requirements on how to align transfer
     buffers on the endpoint rings called "TD fragment" rules.  When the
     ax88179_178a driver added support for scatter gather in 3.12, with
     commit 804fad45411b48233b48003e33a78f290d227c8 "USBNET: ax88179_178a:
     enable tso if usb host supports sg dma", it broke the device under xHCI
     1.0 hosts.  Under certain network loads, the device would see an
     unexpected short packet from the host, which would cause the device to
     stop sending ethernet packets, even through USB packets would still be
     sent.

     Commit 35773dac5f86 "usb: xhci: Link TRB must not occur within a USB
     payload burst" attempted to fix this.  It was a quick hack to partially
     implement the TD fragment rules.  However, it caused regressions in the
     usb-storage layer and userspace USB drivers using libusb.  The patches
     to attempt to fix this are too far reaching into the USB core, and we
     really need to implement the TD fragment rules correctly in the xHCI
     driver, instead of continuing to wallpaper over the issues.

     Disable arbitrarily-aligned scatter-gather in the xHCI driver for 1.0
     hosts.  Only the ax88179_178a driver checks the no_sg_constraint flag,
     so don't set it for 1.0 hosts.  This should not impact usb-storage or
     usbfs behavior, since they pass down max packet sized aligned sg-list
     entries (512 for USB 2.0 and 1024 for USB 3.0).

     Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
     Tested-by: Mark Lord <mlord@pobox.com>
     Cc: David Laight <David.Laight@ACULAB.COM>
     Cc: Bjørn Mork <bjorn@mork.no>
     Cc: Freddy Xin <freddy@asix.com.tw>
     Cc: Ming Lei <ming.lei@canonical.com>
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>



