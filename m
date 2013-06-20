Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348Ab3FTL6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:58:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935353Ab3FTL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:58:39 -0400
Date: Thu, 20 Jun 2013 04:58:14 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-719038de98bc8479b771c582a1e4a1e86079da22@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1370710095-20547-1-git-send-email-bp@alien8.de>
References: <1370710095-20547-1-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86/intel/cacheinfo:
  Shut up last long-standing warning
Git-Commit-ID: 719038de98bc8479b771c582a1e4a1e86079da22
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 04:58:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  719038de98bc8479b771c582a1e4a1e86079da22
Gitweb:     http://git.kernel.org/tip/719038de98bc8479b771c582a1e4a1e86079da22
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Sat, 8 Jun 2013 18:48:15 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 12:27:41 +0200

x86/intel/cacheinfo: Shut up last long-standing warning

arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘init_intel_cacheinfo’:
arch/x86/kernel/cpu/intel_cacheinfo.c:642:28: warning: ‘this_leaf.size’ may be used uninitialized in this function [-Wmaybe-uninitialized] arch/x86/kernel/cpu/intel_cacheinfo.c:643:29: warning: ‘this_leaf.eax.split.num_threads_sharing’ may be used uninitialized in this function [-Wmaybe-uninitialized]

This keeps on happening during randbuilds and the compiler is
wrong here:

In the case where cpuid4_cache_lookup_regs() returns 0, both
this_leaf.size and this_leaf.eax get initialized. In the case
where the CPUID leaf doesn't contain valid cache info, we error
out which init_intel_cacheinfo() handles correctly without
touching the abovementioned fields.

So shut up the warning by clearing out the struct which we hand
down.

While at it, reverse error handling and gain one indentation
level.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1370710095-20547-1-git-send-email-bp@alien8.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 52 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7c6f7d5..8dc72dd 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -618,36 +618,34 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 		 * parameters cpuid leaf to find the cache details
 		 */
 		for (i = 0; i < num_cache_leaves; i++) {
-			struct _cpuid4_info_regs this_leaf;
+			struct _cpuid4_info_regs this_leaf = {};
 			int retval;
 
 			retval = cpuid4_cache_lookup_regs(i, &this_leaf);
-			if (retval >= 0) {
-				switch (this_leaf.eax.split.level) {
-				case 1:
-					if (this_leaf.eax.split.type ==
-							CACHE_TYPE_DATA)
-						new_l1d = this_leaf.size/1024;
-					else if (this_leaf.eax.split.type ==
-							CACHE_TYPE_INST)
-						new_l1i = this_leaf.size/1024;
-					break;
-				case 2:
-					new_l2 = this_leaf.size/1024;
-					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
-					index_msb = get_count_order(num_threads_sharing);
-					l2_id = c->apicid & ~((1 << index_msb) - 1);
-					break;
-				case 3:
-					new_l3 = this_leaf.size/1024;
-					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
-					index_msb = get_count_order(
-							num_threads_sharing);
-					l3_id = c->apicid & ~((1 << index_msb) - 1);
-					break;
-				default:
-					break;
-				}
+			if (retval < 0)
+				continue;
+
+			switch (this_leaf.eax.split.level) {
+			case 1:
+				if (this_leaf.eax.split.type == CACHE_TYPE_DATA)
+					new_l1d = this_leaf.size/1024;
+				else if (this_leaf.eax.split.type == CACHE_TYPE_INST)
+					new_l1i = this_leaf.size/1024;
+				break;
+			case 2:
+				new_l2 = this_leaf.size/1024;
+				num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
+				index_msb = get_count_order(num_threads_sharing);
+				l2_id = c->apicid & ~((1 << index_msb) - 1);
+				break;
+			case 3:
+				new_l3 = this_leaf.size/1024;
+				num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
+				index_msb = get_count_order(num_threads_sharing);
+				l3_id = c->apicid & ~((1 << index_msb) - 1);
+				break;
+			default:
+				break;
 			}
 		}
 	}
