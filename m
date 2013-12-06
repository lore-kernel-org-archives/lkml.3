Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab3LFVES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:04:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:28043 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851Ab3LFVEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:04:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,842,1378882800"; 
   d="scan'208";a="420657594"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] x86, microcode: Add option to allow downgrading of microcode
Date: Fri,  6 Dec 2013 13:04:03 -0800
Message-Id: <1386363843-32530-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386363843-32530-1-git-send-email-andi@firstfloor.org>
References: <1386363843-32530-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For testing purposes it can be useful to downgrade microcode.
Normally the driver only allows upgrading.

Add a module_param (default off) that allows downgrading.

Note the module_param can currently not be set for early
ucode update, only for late.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/microcode_intel_lib.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/microcode_intel_lib.c b/arch/x86/kernel/microcode_intel_lib.c
index 68503d1..17d63f3 100644
--- a/arch/x86/kernel/microcode_intel_lib.c
+++ b/arch/x86/kernel/microcode_intel_lib.c
@@ -26,11 +26,16 @@
 #include <linux/uaccess.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 
 #include <asm/microcode_intel.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
 
+static bool allow_downgrade;
+module_param(allow_downgrade, bool, 0644);
+MODULE_PARM_DESC(allow_downgrade, "Allow downgrading microcode");
+
 static inline int
 update_match_cpu(unsigned int csig, unsigned int cpf,
 		 unsigned int sig, unsigned int pf)
@@ -41,6 +46,8 @@ update_match_cpu(unsigned int csig, unsigned int cpf,
 int
 update_match_revision(struct microcode_header_intel *mc_header, int rev)
 {
+	if (allow_downgrade)
+		return 1;
 	return ((int)mc_header->rev <= rev) ? 0 : 1;
 }
 
-- 
1.8.3.1

