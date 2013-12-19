Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3LSPnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:43:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3LSPnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:43:01 -0500
Date: Thu, 19 Dec 2013 07:42:24 -0800
From: tip-bot for Lans Zhang <tipbot@zytor.com>
Message-ID: <tip-f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, andi@firstfloor.org, jia.zhang@windriver.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, yinghai@kernel.org, jia.zhang@windriver.com,
        tglx@linutronix.de
In-Reply-To: <1386303510-18574-1-git-send-email-jia.zhang@windriver.com>
References: <1386303510-18574-1-git-send-email-jia.zhang@windriver.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm/numa: Fix 32-bit kernel NUMA boot
Git-Commit-ID: f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 19 Dec 2013 07:42:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4
Gitweb:     http://git.kernel.org/tip/f3d815cb854b2f6262ade56a4d91a1ed3f1e50c4
Author:     Lans Zhang <jia.zhang@windriver.com>
AuthorDate: Fri, 6 Dec 2013 12:18:30 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 19 Dec 2013 13:58:36 +0100

x86/mm/numa: Fix 32-bit kernel NUMA boot

When booting a 32-bit x86 kernel on a NUMA machine, node data
cannot be allocated from local node if the account of memory for
node 0 covers the low memory space entirely:

  [    0.000000] Initmem setup node 0 [mem 0x00000000-0x83fffffff]
  [    0.000000]   NODE_DATA [mem 0x367ed000-0x367edfff]
  [    0.000000] Initmem setup node 1 [mem 0x840000000-0xfffffffff]
  [    0.000000] Cannot find 4096 bytes in node 1
  [    0.000000] 64664MB HIGHMEM available.
  [    0.000000] 871MB LOWMEM available.

To fix this issue, node data is allowed to be allocated from
other nodes if the memory of local node is still not mapped. The
expected result looks like this:

  [    0.000000] Initmem setup node 0 [mem 0x00000000-0x83fffffff]
  [    0.000000]   NODE_DATA [mem 0x367ed000-0x367edfff]
  [    0.000000] Initmem setup node 1 [mem 0x840000000-0xfffffffff]
  [    0.000000]   NODE_DATA [mem 0x367ec000-0x367ecfff]
  [    0.000000]     NODE_DATA(1) on node 0
  [    0.000000] 64664MB HIGHMEM available.
  [    0.000000] 871MB LOWMEM available.

Signed-off-by: Lans Zhang <jia.zhang@windriver.com>
Cc: <andi@firstfloor.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1386303510-18574-1-git-send-email-jia.zhang@windriver.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/numa.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 24aec58..c85da7b 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -211,9 +211,13 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	 */
 	nd_pa = memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
 	if (!nd_pa) {
-		pr_err("Cannot find %zu bytes in node %d\n",
-		       nd_size, nid);
-		return;
+		nd_pa = __memblock_alloc_base(nd_size, SMP_CACHE_BYTES,
+					      MEMBLOCK_ALLOC_ACCESSIBLE);
+		if (!nd_pa) {
+			pr_err("Cannot find %zu bytes in node %d\n",
+			       nd_size, nid);
+			return;
+		}
 	}
 	nd = __va(nd_pa);
 
