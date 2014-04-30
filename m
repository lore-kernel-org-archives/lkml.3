Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbaD3BAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:00:44 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:57659 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbaD3BA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:00:28 -0400
Subject: [PATCH 7/7] PCI: Don't add disabled subtractive decode bus resources
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 19:00:25 -0600
Message-ID: <20140430010025.13138.79382.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For a subtractive decode bridge, we previously added and printed all
resources of the primary bus, even if they were not valid.  In the example
below, the bridge 00:1c.3 has no windows enabled, so there are no valid
resources on bus 02.  But since 02:00.0 is subtractive decode bridge, we
add and print all those invalid resources, which don't really make sense:

  pci 0000:00:1c.3: PCI bridge to [bus 02-03]
  pci 0000:02:00.0: PCI bridge to [bus 03] (subtractive decode)
  pci 0000:02:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)

Add and print the subtractively-decoded resources only if they are valid.

There's an example in the dmesg log attached to the bugzilla below (but
this patch doesn't fix the bug reported there).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=73141
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 3bc149b848a8..966514010974 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -475,7 +475,7 @@ void pci_read_bridge_bases(struct pci_bus *child)
 
 	if (dev->transparent) {
 		pci_bus_for_each_resource(child->parent, res, i) {
-			if (res) {
+			if (res && res->flags) {
 				pci_bus_add_resource(child, res,
 						     PCI_SUBTRACTIVE_DECODE);
 				dev_printk(KERN_DEBUG, &dev->dev,

