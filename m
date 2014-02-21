Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbaBUM6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:58:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbaBUMvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 104/121] x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
Date: Fri, 21 Feb 2014 12:48:48 +0000
Message-Id: <1392986945-9693-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 25eb274..3a2e113 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -284,8 +284,13 @@ static __always_inline void setup_smap(struct cpuinfo_x86 *c)
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
1.9.0

