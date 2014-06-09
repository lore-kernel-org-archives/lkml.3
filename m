Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaFII6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:58:15 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58568 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932216AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 106/146] PCI: mvebu: fix off-by-one in the computed size of the mbus windows
Date: Mon,  9 Jun 2014 10:50:41 +0200
Message-Id: <caa4b45c92c0ee289d2e20875ec1c3cea7580587.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pci/host/pci-mvebu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index b4214cba58b7..fdd81f24a9cf 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -297,7 +297,7 @@ static void mvebu_pcie_handle_iobase_change(struct mvebu_pcie_port *port)
 	port->iowin_base = port->pcie->io.start + iobase;
 	port->iowin_size = ((0xFFF | ((port->bridge.iolimit & 0xF0) << 8) |
 			    (port->bridge.iolimitupper << 16)) -
-			    iobase);
+			    iobase) + 1;
 
 	mvebu_mbus_add_window_remap_by_id(port->io_target, port->io_attr,
 					  port->iowin_base, port->iowin_size,
@@ -331,7 +331,7 @@ static void mvebu_pcie_handle_membase_change(struct mvebu_pcie_port *port)
 	port->memwin_base  = ((port->bridge.membase & 0xFFF0) << 16);
 	port->memwin_size  =
 		(((port->bridge.memlimit & 0xFFF0) << 16) | 0xFFFFF) -
-		port->memwin_base;
+		port->memwin_base + 1;
 
 	mvebu_mbus_add_window_by_id(port->mem_target, port->mem_attr,
 				    port->memwin_base, port->memwin_size);
-- 
1.9.3

