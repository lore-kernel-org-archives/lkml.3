Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138AbaDIQVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:21:15 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:36159 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbaDIQVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:21:09 -0400
Date: Wed, 9 Apr 2014 10:20:40 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window
 size
Message-ID: <20140409162040.GA19743@obsidianresearch.com>
References: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <20140409061128.GC16465@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409061128.GC16465@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 08:11:29AM +0200, Willy Tarreau wrote:

> OK I just got it by adding two printk() in pci-mvebu.c. Both functions
> mvebu_pcie_handle_iobase_change() and mvebu_pcie_handle_membase_change()
> do pass a size which is in fact a mask (size - 1) and not the real size.
> So the mbus is fed with an incorrect size which is off by one :

Yes, that is right. I tested my patch here and didn't see any problem,
but I realize now that the mbus code is bailing early due to this:

kernel: mvebu_mbus: cannot add window '4:e8', conflicts with another window

Which I've never got around to fixing.. (whole other story there)

Your patch looks fine, and it obviously needs to be sequenced before
mine. (Thomas/Jason C: how do you want to do this?)

Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

> From de000611015c7490a07ced6e36bfffbfdd136832 Mon Sep 17 00:00:00 2001
> From: Willy Tarreau <w@1wt.eu>
> Date: Wed, 9 Apr 2014 08:05:09 +0200
> Subject: pci: mvebu: fix off-by-one in the computed size of the mbus windows
> 
> mvebu_pcie_handle_membase_change() and mvebu_pcie_handle_iobase_change()
> compute a window size which is in fact a mask. This size is fed to
> mvebu_mbus_add_window_by_id() which itself subtracts 1 to get the
> mask. So clearly the two functions above are wrong.

Mask isn't the right word, maybe:

mvebu_pcie_handle_membase_change() and
mvebu_pcie_handle_iobase_change() do not correctly compute the window
size. PCI uses an inclusive start/end address pair, which requires a
+1 when converting to size.

This only worked because a bug in the mbus driver allowed it to
silently accept and round up bogus sizes.

Fix this by adding one to the computed size.

Regards,
Jason
