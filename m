Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3JSGX2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 02:23:28 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:11306 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750985Ab3JSGX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 02:23:27 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: [PATCH RFC v2 17/29] megaraid: Make use of pcim_enable_msix() interface
Date: Fri, 18 Oct 2013 19:12:17 +0200
Message-Id: <857b0c2709f6f6ecf0ab1090fabba8c14c4b2d70.1382103786.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1382103786.git.agordeev@redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3020921..e54c2e7 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3727,18 +3727,12 @@ static int megasas_init_fw(struct megasas_instance *instance)
 					     (unsigned int)num_online_cpus());
 		for (i = 0; i < instance->msix_vectors; i++)
 			instance->msixentry[i].entry = i;
-		i = pci_enable_msix(instance->pdev, instance->msixentry,
-				    instance->msix_vectors);
-		if (i >= 0) {
-			if (i) {
-				if (!pci_enable_msix(instance->pdev,
-						     instance->msixentry, i))
-					instance->msix_vectors = i;
-				else
-					instance->msix_vectors = 0;
-			}
-		} else
+		i = pcim_enable_msix(instance->pdev, instance->msixentry,
+				     instance->msix_vectors);
+		if (i < 0)
 			instance->msix_vectors = 0;
+		else
+			instance->msix_vectors = i;
 
 		dev_info(&instance->pdev->dev, "[scsi%d]: FW supports"
 			"<%d> MSIX vector,Online CPUs: <%d>,"
-- 
1.7.7.6

