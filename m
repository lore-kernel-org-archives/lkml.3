Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934693AbaDJGgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 02:36:19 -0400
Received: from 1wt.eu ([62.212.114.60]:3863 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934647AbaDJGgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 02:36:18 -0400
Date: Thu, 10 Apr 2014 08:35:40 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        linux-arm-kernel@lists.infradead.org,
        Matthew Minter <matthew_minter@xyratex.com>,
        linux-kernel@vger.kernel.org, Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH v2] bus: mvebu-mbus: Avoid setting an undefined window size
Message-ID: <20140410063540.GA25198@1wt.eu>
References: <1397000654-10849-1-git-send-email-jgunthorpe@obsidianresearch.com> <20140409061128.GC16465@1wt.eu> <20140409162040.GA19743@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <20140409162040.GA19743@obsidianresearch.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jason,

On Wed, Apr 09, 2014 at 10:20:40AM -0600, Jason Gunthorpe wrote:
> On Wed, Apr 09, 2014 at 08:11:29AM +0200, Willy Tarreau wrote:
> 
> > OK I just got it by adding two printk() in pci-mvebu.c. Both functions
> > mvebu_pcie_handle_iobase_change() and mvebu_pcie_handle_membase_change()
> > do pass a size which is in fact a mask (size - 1) and not the real size.
> > So the mbus is fed with an incorrect size which is off by one :
> 
> Yes, that is right. I tested my patch here and didn't see any problem,
> but I realize now that the mbus code is bailing early due to this:
> 
> kernel: mvebu_mbus: cannot add window '4:e8', conflicts with another window
> 
> Which I've never got around to fixing.. (whole other story there)
> 
> Your patch looks fine, and it obviously needs to be sequenced before
> mine. (Thomas/Jason C: how do you want to do this?)
> 
> Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

OK, thank you. I've updated the attached patch with your better description.

Cheers,
Willy


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-pci-mvebu-fix-off-by-one-in-the-computed-size-of-the.patch"

>From f90886f625d95781a3302bbc025304635dd97e9c Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Wed, 9 Apr 2014 08:05:09 +0200
Subject: pci: mvebu: fix off-by-one in the computed size of the mbus windows

mvebu_pcie_handle_membase_change() and
mvebu_pcie_handle_iobase_change() do not correctly compute the window
size. PCI uses an inclusive start/end address pair, which requires a
+1 when converting to size.

This only worked because a bug in the mbus driver allowed it to
silently accept and round up bogus sizes.

Fix this by adding one to the computed size.

Signed-off-by: Willy Tarreau <w@1wt.eu>
Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/pci/host/pci-mvebu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 0e79665..eff0ab5 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -329,7 +329,7 @@ static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 	port->iowin_base = port->pcie->io.start + iobase;
 	port->iowin_size = ((0xFFF | ((port->bridge.iolimit & 0xF0) << 8) |
 			    (port->bridge.iolimitupper << 16)) -
-			    iobase);
+			    iobase) + 1;
 
 	mvebu_mbus_add_window_remap_by_id(port->io_target, port->io_attr,
 					  port->iowin_base, port->iowin_size,
@@ -362,7 +362,7 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 	port->memwin_base  = ((port->bridge.membase & 0xFFF0) << 16);
 	port->memwin_size  =
 		(((port->bridge.memlimit & 0xFFF0) << 16) | 0xFFFFF) -
-		port->memwin_base;
+		port->memwin_base + 1;
 
 	mvebu_mbus_add_window_by_id(port->mem_target, port->mem_attr,
 				    port->memwin_base, port->memwin_size);
-- 
1.7.12.2.21.g234cd45.dirty


--jI8keyz6grp/JLjh--
