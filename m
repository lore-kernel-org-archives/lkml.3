Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaBMPyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:54:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40289 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaBMPyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:54:41 -0500
Date: Thu, 13 Feb 2014 07:54:28 -0800
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-03bbd596ac04fef47ce93a730b8f086d797c3021@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, fengguang.wu@intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, fengguang.wu@intel.com
In-Reply-To: <20140213124550.GA30497@localhost>
References: <20140213124550.GA30497@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, smap: Don'
 t enable SMAP if CONFIG_X86_SMAP is disabled
Git-Commit-ID: 03bbd596ac04fef47ce93a730b8f086d797c3021
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 07:54:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03bbd596ac04fef47ce93a730b8f086d797c3021
Gitweb:     http://git.kernel.org/tip/03bbd596ac04fef47ce93a730b8f086d797c3021
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Thu, 13 Feb 2014 07:34:30 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 07:50:25 -0800

x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled

If SMAP support is not compiled into the kernel, don't enable SMAP in
CR4 -- in fact, we should clear it, because the kernel doesn't contain
the proper STAC/CLAC instructions for SMAP support.

Found by Fengguang Wu's test system.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/20140213124550.GA30497@localhost
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> # v3.7+
---
 arch/x86/kernel/cpu/common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 24b6fd1..8e28bf2 100644
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
