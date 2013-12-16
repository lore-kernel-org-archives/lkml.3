Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab3LPSkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 13:40:52 -0500
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:28455 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754143Ab3LPSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 13:40:50 -0500
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Dec 2013 13:40:50 EST
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH v4 3/9] PCI/MSI: Fix return value when populate_msi_sysfs() failed
Date: Mon, 16 Dec 2013 09:34:56 +0100
Message-Id: <798797dbdc198cb4d6fbb08c2e431558e56f51b8.1387140921.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1387140921.git.agordeev@redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If populate_msi_sysfs() function failed msix_capability_init()
must return the error code, but it returns the success instead.
This update fixes the described misbehaviour.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
---
 drivers/pci/msi.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index c0baa3d..623322d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -740,7 +740,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
-		goto error;
+		goto out_avail;
 
 	/*
 	 * Some devices require MSI-X to be enabled before we can touch the
@@ -753,10 +753,8 @@ static int msix_capability_init(struct pci_dev *dev,
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
@@ -767,7 +765,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	return 0;
 
-error:
+out_avail:
 	if (ret < 0) {
 		/*
 		 * If we had some success, report the number of irqs
@@ -784,6 +782,7 @@ error:
 			ret = avail;
 	}
 
+out_free:
 	free_msi_irqs(dev);
 
 	return ret;
-- 
1.7.7.6

