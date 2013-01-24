Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3AXUVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:21:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49732 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522Ab3AXUVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:21:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/35] x86, realmode: Set real_mode permissions early
Date: Thu, 24 Jan 2013 12:19:47 -0800
Message-Id: <1359058816-7615-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trampoline code is executed by APs with kernel low mapping on 64bit.
We need to set trampoline code to EXEC early before we boot APs.

Found the problem after switching to #PF handler set page table,
and we do not set initial kernel low mapping with EXEC anymore in
arch/x86/kernel/head_64.S.

Change to use early_initcall instead that will make sure trampoline
will have EXEC set.

-v2: Merge two comments according to Borislav Petkov <bp@alien8.de>

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/realmode/init.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
index 8045026..dfe65ae 100644
--- a/arch/x86/realmode/init.c
+++ b/arch/x86/realmode/init.c
@@ -84,10 +84,12 @@ void __init setup_real_mode(void)
 }
 
 /*
- * set_real_mode_permissions() gets called very early, to guarantee the
- * availability of low memory.  This is before the proper kernel page
+ * setup_real_mode() gets called very early, to guarantee the
+ * availability of low memory. This is before the proper kernel page
  * tables are set up, so we cannot set page permissions in that
- * function.  Thus, we use an arch_initcall instead.
+ * function. Also trampoline code will be executed by APs so we
+ * need to mark it executable at do_pre_smp_initcalls() at least,
+ * thus run it as a early_initcall().
  */
 static int __init set_real_mode_permissions(void)
 {
@@ -111,5 +113,4 @@ static int __init set_real_mode_permissions(void)
 
 	return 0;
 }
-
-arch_initcall(set_real_mode_permissions);
+early_initcall(set_real_mode_permissions);
-- 
1.7.10.4

