Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751186AbaAWFqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 00:46:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:20442 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbaAWFqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 00:46:51 -0500
X-IronPort-AV: E=Sophos;i="4.95,704,1384272000"; 
   d="scan'208";a="9446578"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting kernel nodes to unhotpluggable.
Date: Thu, 23 Jan 2014 13:49:28 +0800
Message-Id: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/23 13:45:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/23 13:45:24,
	Serialize complete at 2014/01/23 13:45:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave found that the kernel will hang during boot. This is because
the nodemask_t type stack variable numa_kernel_nodes is large enough
to overflow the stack.

This doesn't always happen. According to Dave, this happened once
in about five boots. The backtrace is like the following:

dump_stack
panic
? numa_clear_kernel_node_hotplug
__stack_chk_fail
numa_clear_kernel_node_hotplug
? memblock_search_pfn_nid
? __early_pfn_to_nid
numa_init
x86_numa_init
initmem_init
setup_arch
start_kernel

This patch fix this problem by defining numa_kernel_nodes as a
static global variable in __initdata area.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 arch/x86/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 81b2750..ebefeb7 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -562,10 +562,10 @@ static void __init numa_init_array(void)
 	}
 }
 
+static nodemask_t numa_kernel_nodes __initdata;
 static void __init numa_clear_kernel_node_hotplug(void)
 {
 	int i, nid;
-	nodemask_t numa_kernel_nodes;
 	unsigned long start, end;
 	struct memblock_type *type = &memblock.reserved;
 
-- 
1.7.11.7

