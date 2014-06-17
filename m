Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967504AbaFQWEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:04:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967018AbaFQVwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:12 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Willy Tarreau <w@1wt.eu>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 076/212] PCI: mvebu: fix off-by-one in the computed size of the mbus windows
Date: Tue, 17 Jun 2014 14:42:50 -0700
Message-Id: <1403041506-13646-77-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

commit b6d07e0273d3296cfbdc88145b8a00ddbefb310a upstream.

mvebu_pcie_handle_membase_change() and
mvebu_pcie_handle_iobase_change() do not correctly compute the window
size. PCI uses an inclusive start/end address pair, which requires a
+1 when converting to size.

This only worked because a bug in the mbus driver allowed it to
silently accept and round up bogus sizes.

Fix this by adding one to the computed size.

Fixes: 45361a4fe446 ('PCIe driver for Marvell Armada 370/XP systems')
Signed-off-by: Willy Tarreau <w@1wt.eu>
Reviewed-By: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397823593-1932-5-git-send-email-thomas.petazzoni@free-electrons.com
Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/host/pci-mvebu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index f26731c..045cbb5 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -317,7 +317,7 @@ static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 	port->iowin_base = port->pcie->io.start + iobase;
 	port->iowin_size = ((0xFFF | ((port->bridge.iolimit & 0xF0) << 8) |
 			    (port->bridge.iolimitupper << 16)) -
-			    iobase);
+			    iobase) + 1;
 
 	mvebu_mbus_add_window_remap_by_id(port->io_target, port->io_attr,
 					  port->iowin_base, port->iowin_size,
@@ -351,7 +351,7 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 	port->memwin_base  = ((port->bridge.membase & 0xFFF0) << 16);
 	port->memwin_size  =
 		(((port->bridge.memlimit & 0xFFF0) << 16) | 0xFFFFF) -
-		port->memwin_base;
+		port->memwin_base + 1;
 
 	mvebu_mbus_add_window_by_id(port->mem_target, port->mem_attr,
 				    port->memwin_base, port->memwin_size);
-- 
1.9.1

