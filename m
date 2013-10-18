Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab3JSGQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:16:00 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:11130 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751066Ab3JSGP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:15:59 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 18/29] ntb: Fix missed call to pci_enable_msix()
Date: Fri, 18 Oct 2013 19:12:18 +0200
Message-Id: <cb525949fe5df255e1c512b1095c8e52658a2388.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current MSI-X enablement code assumes MSI-Xs were successfully
allocated in case less than requested vectors were available.
That assumption is wrong, since MSI-Xs should be enabled with
a repeated call to pci_enable_msix(). This update fixes this.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Acked-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 1cb6e51..de2062c 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1075,6 +1075,10 @@ static int ntb_setup_msix(struct ntb_device *ndev)
 			 "Only %d MSI-X vectors.  Limiting the number of queues to that number.\n",
 			 rc);
 		msix_entries = rc;
+
+		rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
+		if (rc)
+			goto err1;
 	}
 
 	for (i = 0; i < msix_entries; i++) {
-- 
1.7.7.6

