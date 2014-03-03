Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaCCTBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:01:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56204 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128AbaCCTAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:00:48 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 61/67] x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
Date: Mon,  3 Mar 2014 10:55:49 -0800
Message-Id: <1393872955-28810-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 03bbd596ac04fef47ce93a730b8f086d797c3021 upstream.

If SMAP support is not compiled into the kernel, don't enable SMAP in
CR4 -- in fact, we should clear it, because the kernel doesn't contain
the proper STAC/CLAC instructions for SMAP support.

Found by Fengguang Wu's test system.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/20140213124550.GA30497@localhost
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kernel/cpu/common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9c3ab43..a93d20b 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -287,8 +287,13 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
 	raw_local_save_flags(eflags);
 	BUG_ON(eflags & X86_EFLAGS_AC);
 
-	if (cpu_has(c, X86_FEATURE_SMAP))
+	if (cpu_has(c, X86_FEATURE_SMAP)) {
+#ifdef CONFIG_X86_SMAP
 		set_in_cr4(X86_CR4_SMAP);
+#else
+		clear_in_cr4(X86_CR4_SMAP);
+#endif
+	}
 }
 
 /*
-- 
1.8.3.2

