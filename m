Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab3JSGgi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:36:38 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:12511 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750985Ab3JSGgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:36:37 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 05/29] PCI/MSI: Fix return value when populate_msi_sysfs() failed
Date: Fri, 18 Oct 2013 19:12:05 +0200
Message-Id: <0607a740e8df7971c8132ef68f8c8a7bbdd6a181.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If populate_msi_sysfs() function failed msix_capability_init()
must return the error code, but it returns the success instead.
This update fixes the described misbehaviour.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/pci/msi.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d5f90d6..b43f391 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -719,7 +719,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
-		goto error;
+		goto out_avail;
 
 	/*
 	 * Some devices require MSI-X to be enabled before we can touch the
@@ -732,10 +732,8 @@ static int msix_capability_init(struct pci_dev *dev,
 	msix_program_entries(dev, entries);
 
 	ret = populate_msi_sysfs(dev);
-	if (ret) {
-		ret = 0;
-		goto error;
-	}
+	if (ret)
+		goto out_free;
 
 	/* Set MSI-X enabled bits and unmask the function */
 	pci_intx_for_msi(dev, 0);
@@ -746,7 +744,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	return 0;
 
-error:
+out_avail:
 	if (ret < 0) {
 		/*
 		 * If we had some success, report the number of irqs
@@ -763,6 +761,7 @@ error:
 			ret = avail;
 	}
 
+out_free:
 	free_msi_irqs(dev);
 
 	return ret;
-- 
1.7.7.6

