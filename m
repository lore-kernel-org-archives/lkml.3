Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaIQOSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:18:31 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35630 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaIQOS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:18:29 -0400
From: Martin Kelly <martin@martingkelly.com>
To: x86@kernel.org, mingo@redhat.com
Cc: vishwesh.m.rudramuni@intel.com, joe@perches.com, hpa@linux.intel.com,
        aubrey.li@linux.intel.com, linux-kernel@vger.kernel.org,
        Martin Kelly <martin@martingkelly.com>,
        Martin Kelly <martkell@amazon.com>
Subject: [PATCH v3] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
Date: Wed, 17 Sep 2014 07:17:56 -0700
Message-Id: <1410963476-8360-1-git-send-email-martin@martingkelly.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling with CONFIG_DEBUG_FS=n, gcc emits an unused variable
warning for pmc_atom.c because "ret" is used only within the
CONFIG_DEBUG_FS block. This patch adds a dummy #ifdef for
pmc_dbgfs_register when CONFIG_DEBUG_FS=n to simplify the code and
remove the warning.

Signed-off-by: Martin Kelly <martkell@amazon.com>
---
Changes in v3:
  - Further unified the return code logic, as suggested by Ingo Molnar

Changes in v2:
  - Implemented Ingo Molnar's suggestion to #ifdef the function rather
    than the lines.
---
 arch/x86/kernel/pmc_atom.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 0c424a6..0ee5025e 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -235,6 +235,11 @@ err:
 	pmc_dbgfs_unregister(pmc);
 	return -ENODEV;
 }
+#else
+static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
+{
+	return 0;
+}
 #endif /* CONFIG_DEBUG_FS */
 
 static int pmc_setup_dev(struct pci_dev *pdev)
@@ -262,14 +267,12 @@ static int pmc_setup_dev(struct pci_dev *pdev)
 	/* PMC hardware registers setup */
 	pmc_hw_reg_setup(pmc);
 
-#ifdef CONFIG_DEBUG_FS
 	ret = pmc_dbgfs_register(pmc, pdev);
 	if (ret) {
 		iounmap(pmc->regmap);
-		return ret;
 	}
-#endif /* CONFIG_DEBUG_FS */
-	return 0;
+
+	return ret;
 }
 
 /*
-- 
2.1.0

