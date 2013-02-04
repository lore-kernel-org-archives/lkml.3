Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3BDJN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 04:13:28 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44859 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201Ab3BDJN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 04:13:26 -0500
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, intel_cacheinfo: Shut up annoying warning
Date: Mon,  4 Feb 2013 10:13:15 +0100
Message-Id: <1359969195-27362-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.2.422.g08c0e7f
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

I've been getting the following warning when doing randbuilds since
forever. Now it finally pissed me off just the perfect amount so that I
can fix it.

arch/x86/kernel/cpu/intel_cacheinfo.c:489:27: warning: ‘cache_disable_0’ defined but not used [-Wunused-variable]
arch/x86/kernel/cpu/intel_cacheinfo.c:491:27: warning: ‘cache_disable_1’ defined but not used [-Wunused-variable]
arch/x86/kernel/cpu/intel_cacheinfo.c:524:27: warning: ‘subcaches’ defined but not used [-Wunused-variable]

It happens because in randconfigs where CONFIG_SYSFS is not set, the
whole sysfs-interface to L3 cache index disabling is remaining unused
and gcc correctly warns about it. Make it optional, depending on
CONFIG_SYSFS too, as is the case with other sysfs-related machinery in
this file.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 0e462404d6f1..7c6f7d548c0f 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -298,8 +298,7 @@ struct _cache_attr {
 			 unsigned int);
 };
 
-#ifdef CONFIG_AMD_NB
-
+#if defined(CONFIG_AMD_NB) && defined(CONFIG_SYSFS)
 /*
  * L3 cache descriptors
  */
@@ -524,9 +523,9 @@ store_subcaches(struct _cpuid4_info *this_leaf, const char *buf, size_t count,
 static struct _cache_attr subcaches =
 	__ATTR(subcaches, 0644, show_subcaches, store_subcaches);
 
-#else	/* CONFIG_AMD_NB */
+#else
 #define amd_init_l3_cache(x, y)
-#endif /* CONFIG_AMD_NB */
+#endif  /* CONFIG_AMD_NB && CONFIG_SYSFS */
 
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
-- 
1.8.1.2.422.g08c0e7f

