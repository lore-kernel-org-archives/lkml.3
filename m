Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3BDNsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:48:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60845 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab3BDNso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:48:44 -0500
Date: Mon, 4 Feb 2013 05:47:42 -0800
From: tip-bot for Borislav Petkov <bp@suse.de>
Message-ID: <tip-f76e39c531304b114e27c3dd3e0036f56cd33df1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, bp@suse.de
In-Reply-To: <1359969195-27362-1-git-send-email-bp@alien8.de>
References: <1359969195-27362-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/intel/cacheinfo: Shut up annoying warning
Git-Commit-ID: f76e39c531304b114e27c3dd3e0036f56cd33df1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:47:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f76e39c531304b114e27c3dd3e0036f56cd33df1
Gitweb:     http://git.kernel.org/tip/f76e39c531304b114e27c3dd3e0036f56cd33df1
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 4 Feb 2013 10:13:15 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:29:52 +0100

x86/intel/cacheinfo: Shut up annoying warning

I've been getting the following warning when doing randbuilds
since forever. Now it finally pissed me off just the perfect
amount so that I can fix it.

  arch/x86/kernel/cpu/intel_cacheinfo.c:489:27: warning: ‘cache_disable_0’ defined but not used [-Wunused-variable]
  arch/x86/kernel/cpu/intel_cacheinfo.c:491:27: warning: ‘cache_disable_1’ defined but not used [-Wunused-variable] arch/x86/kernel/cpu/intel_cacheinfo.c:524:27: warning: ‘subcaches’ defined but not used [-Wunused-variable]

It happens because in randconfigs where CONFIG_SYSFS is not set,
the whole sysfs-interface to L3 cache index disabling is
remaining unused and gcc correctly warns about it. Make it
optional, depending on CONFIG_SYSFS too, as is the case with
other sysfs-related machinery in this file.

Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Link: http://lkml.kernel.org/r/1359969195-27362-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fe9edec..84c1309 100644
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
