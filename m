Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711Ab3GQXBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:01:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab3GQW4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:56:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Best <sbest@us.ibm.com>, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 027/145] powerpc/eeh: Fix fetching bus for single-dev-PE
Date: Wed, 17 Jul 2013 15:45:59 -0700
Message-Id: <1374101277-7915-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Shan <shangw@linux.vnet.ibm.com>

commit 5fb621698e94e3af8b413d9439041fde48e2784d upstream.

While running Linux as guest on top of phyp, we possiblly have
PE that includes single PCI device. However, we didn't return
its PCI bus correctly and it leads to failure on recovery from
EEH errors for single-dev-PE. The patch fixes the issue.

Cc: Steve Best <sbest@us.ibm.com>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/platforms/pseries/eeh_pe.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/eeh_pe.c b/arch/powerpc/platforms/pseries/eeh_pe.c
index fe43d1a..9d4a9e8 100644
--- a/arch/powerpc/platforms/pseries/eeh_pe.c
+++ b/arch/powerpc/platforms/pseries/eeh_pe.c
@@ -639,7 +639,8 @@ struct pci_bus *eeh_pe_bus_get(struct eeh_pe *pe)
 
 	if (pe->type & EEH_PE_PHB) {
 		bus = pe->phb->bus;
-	} else if (pe->type & EEH_PE_BUS) {
+	} else if (pe->type & EEH_PE_BUS ||
+		   pe->type & EEH_PE_DEVICE) {
 		edev = list_first_entry(&pe->edevs, struct eeh_dev, list);
 		pdev = eeh_dev_to_pci_dev(edev);
 		if (pdev)
-- 
1.8.1.2

