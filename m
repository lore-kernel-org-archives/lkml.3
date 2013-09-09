Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab3IIP1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 11:27:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab3IIP1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 11:27:14 -0400
Date: Mon, 9 Sep 2013 17:29:08 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>
Subject: [PATCH 8/9] PCI/MSI: Fix return value when populate_msi_sysfs()
 failed
Message-ID: <20130909152907.GJ24962@dhcp-26-207.brq.redhat.com>
References: <20130905150259.GA30984@dhcp-26-207.brq.redhat.com>
 <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/pci/msi.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index aca7578..21e6471 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -702,7 +702,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	ret = arch_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
-		goto error;
+		goto out_avail;
 
 	/*
 	 * Some devices require MSI-X to be enabled before we can touch the
@@ -715,10 +715,8 @@ static int msix_capability_init(struct pci_dev *dev,
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
@@ -729,7 +727,7 @@ static int msix_capability_init(struct pci_dev *dev,
 
 	return 0;
 
-error:
+out_avail:
 	if (ret < 0) {
 		/*
 		 * If we had some success, report the number of irqs
@@ -746,6 +744,7 @@ error:
 			ret = avail;
 	}
 
+out_free:
 	free_msi_irqs(dev);
 
 	return ret;
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
