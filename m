Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbaAGA4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:56:53 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:64108 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbaAGA4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:56:47 -0500
Subject: [PATCH v7 13/15] PCI: Split out bridge window override of minimum
 allocation address
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:56:44 -0700
Message-ID: <20140107005644.10786.41340.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_bus_alloc_resource() avoids allocating space below the "min" supplied
by the caller (usually PCIBIOS_MIN_IO or PCIBIOS_MIN_MEM).  This is to
protect badly documented motherboard resources.  But if we're allocating
space inside an already-configured PCI-PCI bridge window, we ignore "min".

See 688d191821de ("pci: make bus resource start address override minimum IO
address").

This patch moves the check to make it more visible and simplify future
patches.  No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/bus.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index fc1b74013743..6f2f47a7b6c6 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -147,11 +147,18 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 		    !(res->flags & IORESOURCE_PREFETCH))
 			continue;
 
+		/*
+		 * "min" is typically PCIBIOS_MIN_IO or PCIBIOS_MIN_MEM to
+		 * protect badly documented motherboard resources, but if
+		 * this is an already-configured bridge window, its start
+		 * overrides "min".
+		 */
+		if (r->start)
+			min = r->start;
+
 		/* Ok, try it out.. */
-		ret = allocate_resource(r, res, size,
-					r->start ? : min,
-					max, align,
-					alignf, alignf_data);
+		ret = allocate_resource(r, res, size, min, max,
+					align, alignf, alignf_data);
 		if (ret == 0)
 			break;
 	}

