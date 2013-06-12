Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab3FLRVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:21:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873Ab3FLRVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:21:47 -0400
Date: Wed, 12 Jun 2013 19:21:32 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Subject: pcie aspm link setup, grandparent instead of parent?
Message-ID: <20130612172132.GG27284@hpx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as a consequence of hitting a NULL dereference bug[1] while downstream
aspm is setting up link_state, I started to wonder why is the code
skipping its parent bus in favour of grandparent's link_state.[2]

Is this right? (I have no device to test on ...)

Thanks.

---
1: https://bugzilla.redhat.com/show_bug.cgi?id=972381
   The bug is hit because "pdev->bus->parent" has NULL "->parent" and thus
   NULL "->self".
2: "pdev = bus->self", so "pdev->bus->parent == bus->parent->parent"


diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 403a443..d58e282 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -527,7 +527,7 @@ static struct pcie_link_state *alloc_pcie_link_state(struct pci_dev *pdev)
 	link->pdev = pdev;
 	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM) {
 		struct pcie_link_state *parent;
-		parent = pdev->bus->parent->self->link_state;
+		parent = pdev->bus->self->link_state;
 		if (!parent) {
 			kfree(link);
 			return NULL;
