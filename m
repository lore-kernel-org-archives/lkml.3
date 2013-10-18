Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3JSGZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:25:20 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:11378 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750966Ab3JSGZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:25:18 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 06/29] PCI/MSI: Get rid of useless count of msi_desc leftovers
Date: Fri, 18 Oct 2013 19:12:06 +0200
Message-Id: <79a2aeb6a06563c5f09463d53d2e0146e44c92be.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an architecture failed to allocate requested number of
MSI-Xs we should not mislead device drivers and make them
retry based on how many MSI-Xs were possibly allocated by
the architecture in the process, before the failure. It is
rude for an architecture to leave any leftovers anyway.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/pci/msi.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index b43f391..bbe3d3d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -719,7 +719,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
-		goto out_avail;
+		goto out_free;
 
 	/*
 	 * Some devices require MSI-X to be enabled before we can touch the
@@ -744,23 +744,6 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	return 0;
 
-out_avail:
-	if (ret < 0) {
-		/*
-		 * If we had some success, report the number of irqs
-		 * we succeeded in setting up.
-		 */
-		struct msi_desc *entry;
-		int avail = 0;
-
-		list_for_each_entry(entry, &dev->msi_list, list) {
-			if (entry->irq != 0)
-				avail++;
-		}
-		if (avail != 0)
-			ret = avail;
-	}
-
 out_free:
 	free_msi_irqs(dev);
 
-- 
1.7.7.6

