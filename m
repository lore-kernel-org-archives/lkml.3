Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab3FHQsj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 12:48:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48479 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3FHQsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 12:48:38 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, intel_cacheinfo: Shut up last long-standing warning
Date: Sat,  8 Jun 2013 18:48:15 +0200
Message-Id: <1370710095-20547-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

arch/x86/kernel/cpu/intel_cacheinfo.c: In function ‘init_intel_cacheinfo’:
arch/x86/kernel/cpu/intel_cacheinfo.c:642:28: warning: ‘this_leaf.size’ may be used uninitialized in this function [-Wmaybe-uninitialized]
arch/x86/kernel/cpu/intel_cacheinfo.c:643:29: warning: ‘this_leaf.eax.split.num_threads_sharing’ may be used uninitialized in this function [-Wmaybe-uninitialized]

This keeps on happening during randbuilds and the compiler is wrong
here:

In the case where cpuid4_cache_lookup_regs() returns 0, both
this_leaf.size and this_leaf.eax get initialized. In the case where
the CPUID leaf doesn't contain valid cache info, we error out which
init_intel_cacheinfo() handles correctly without touching the
abovementioned fields.

So shut up the warning by clearing out the struct which we hand down.

While at it, reverse error handling and gain one indentation level.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c | 52 +++++++++++++++++------------------
 1 file changed, 25 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7c6f7d548c0f..8dc72dda66fe 100644
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
-- 
1.8.3

