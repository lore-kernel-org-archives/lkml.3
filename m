Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaBWGsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 01:48:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaBWGsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 01:48:46 -0500
Date: Sun, 23 Feb 2014 07:50:41 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy King <acking@vmware.com>, Dmitry Torokhov <dtor@vmware.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH v2] vmw_vmci: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140223065041.GA24747@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-5-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392804931-30671-5-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy King <acking@vmware.com>
Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/misc/vmw_vmci/vmci_guest.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index d35cda0..e0d5017 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -383,11 +383,12 @@ static int vmci_enable_msix(struct pci_dev *pdev,
 		vmci_dev->msix_entries[i].vector = i;
 	}
 
-	result = pci_enable_msix(pdev, vmci_dev->msix_entries, VMCI_MAX_INTRS);
+	result = pci_enable_msix_exact(pdev,
+				       vmci_dev->msix_entries, VMCI_MAX_INTRS);
 	if (result == 0)
 		vmci_dev->exclusive_vectors = true;
-	else if (result > 0)
-		result = pci_enable_msix(pdev, vmci_dev->msix_entries, 1);
+	else if (result == -ENOSPC)
+		result = pci_enable_msix_exact(pdev, vmci_dev->msix_entries, 1);
 
 	return result;
 }
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
