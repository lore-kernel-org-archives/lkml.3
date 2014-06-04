Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaFDXWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbaFDXWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Neil Greatorex <neil@fatboyfat.co.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 3.14 157/228] PCI: mvebu: fix off-by-one in the computed size of the mbus windows
Date: Wed,  4 Jun 2014 16:23:06 -0700
Message-Id: <20140604232353.061221744@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/host/pci-mvebu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -329,7 +329,7 @@ static void mvebu_pcie_handle_iobase_cha
 	port->iowin_base = port->pcie->io.start + iobase;
 	port->iowin_size = ((0xFFF | ((port->bridge.iolimit & 0xF0) << 8) |
 			    (port->bridge.iolimitupper << 16)) -
-			    iobase);
+			    iobase) + 1;
 
 	mvebu_mbus_add_window_remap_by_id(port->io_target, port->io_attr,
 					  port->iowin_base, port->iowin_size,
@@ -362,7 +362,7 @@ static void mvebu_pcie_handle_membase_ch
 	port->memwin_base  = ((port->bridge.membase & 0xFFF0) << 16);
 	port->memwin_size  =
 		(((port->bridge.memlimit & 0xFFF0) << 16) | 0xFFFFF) -
-		port->memwin_base;
+		port->memwin_base + 1;
 
 	mvebu_mbus_add_window_by_id(port->mem_target, port->mem_attr,
 				    port->memwin_base, port->memwin_size);


