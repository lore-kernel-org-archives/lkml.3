Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3LLX6F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:58:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:11328 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab3LLX6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:58:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,475,1384329600"; 
   d="scan'208";a="449239743"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/2] x86, microcode: Add option to allow downgrading of microcode
Date: Thu, 12 Dec 2013 15:57:48 -0800
Message-Id: <1386892668-22256-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386892668-22256-1-git-send-email-andi@firstfloor.org>
References: <1386892668-22256-1-git-send-email-andi@firstfloor.org>
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
index ce69320..18d5325 100644
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
 	return (mc_header->rev <= rev) ? 0 : 1;
 }
 
-- 
1.8.3.1

