Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaISLtL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:49:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbaISLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:49:08 -0400
Date: Fri, 19 Sep 2014 04:48:53 -0700
From: tip-bot for Martin Kelly <tipbot@zytor.com>
Message-ID: <tip-9575a6a23a8081bc4c9d47d001621e2af0957c02@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        martin@martingkelly.com, tglx@linutronix.de, aubrey.li@linux.intel.com,
        martkell@amazon.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        martin@martingkelly.com, tglx@linutronix.de, martkell@amazon.com,
        aubrey.li@linux.intel.com
In-Reply-To: <1410963476-8360-1-git-send-email-martin@martingkelly.com>
References: <1410963476-8360-1-git-send-email-martin@martingkelly.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform/pmc_atom:
  Fix warning when CONFIG_DEBUG_FS=n
Git-Commit-ID: 9575a6a23a8081bc4c9d47d001621e2af0957c02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9575a6a23a8081bc4c9d47d001621e2af0957c02
Gitweb:     http://git.kernel.org/tip/9575a6a23a8081bc4c9d47d001621e2af0957c02
Author:     Martin Kelly <martin@martingkelly.com>
AuthorDate: Wed, 17 Sep 2014 07:17:56 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 13:02:21 +0200

x86/platform/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n

When compiling with CONFIG_DEBUG_FS=n, GCC emits an unused
variable warning for pmc_atom.c because "ret" is used only
within the CONFIG_DEBUG_FS block.

This patch adds a dummy #ifdef for pmc_dbgfs_register() when
CONFIG_DEBUG_FS=n to simplify the code and remove the warning.

Signed-off-by: Martin Kelly <martkell@amazon.com>
Acked-by: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: vishwesh.m.rudramuni@intel.com
Link: http://lkml.kernel.org/r/1410963476-8360-1-git-send-email-martin@martingkelly.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
