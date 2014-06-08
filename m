Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaFHWPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 18:15:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbaFHWO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 18:14:57 -0400
Date: Sun, 8 Jun 2014 18:14:36 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: akpm@linux-foundation.org
Cc: andi@firstfloor.org, riel@redhat.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] x86: numa: drop ZONE_ALIGN
Message-ID: <20140608181436.17de69ac@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In short, I believe this is just dead code for the upstream kernel but this
causes a bug for 2.6.32 based kernels.

The setup_node_data() function is used to initialize NODE_DATA() for a node.
It gets a node id and a memory range. The start address for the memory range
is rounded up to ZONE_ALIGN and then it's used to initialize
NODE_DATA(nid)->node_start_pfn.

However, a few function calls later free_area_init_node() is called and it
overwrites NODE_DATA()->node_start_pfn with the lowest PFN for the node.
Here's the call callchain:

setup_arch()
  initmem_init()
    x86_numa_init()
      numa_init()
        numa_register_memblks()
          setup_node_data()        <-- initializes NODE_DATA()->node_start_pfn
  ...
  x86_init.paging.pagetable_init()
    paging_init()
      zone_sizes_init()
        free_area_init_nodes()
          free_area_init_node()    <-- overwrites NODE_DATA()->node_start_pfn

This doesn't seem to cause any problems to the current kernel because the
rounded up start address is not really used. However, I came accross this
dead assignment while debugging a real issue on a 2.6.32 based kernel.

The 2.6.32 kernel did use the rounded up range start to register a node's
memory range with the bootmem interface by calling init_bootmem_node().
A few steps later during bootmem initialization, the 2.6.32 kernel calls
free_bootmem_with_active_regions() to initialize the bootmem bitmap. This
function goes through all memory ranges read from the SRAT table and try
to mark them as usable for bootmem usage. However, before marking a range
as usable, mark_bootmem_node() asserts if the memory range start address
(as read from the SRAT table) is less than the value registered with
init_bootmem_node(). The assertion will trigger whenever the memory range
start address is rounded up, as it will always be greater than what is
reported in the SRAT table. This is true when the 2.6.32 kernel runs as a
HyperV guest on Windows Server 2012. Dropping ZONE_ALIGN solves the
problem there.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 arch/x86/include/asm/numa.h | 1 -
 arch/x86/mm/numa.c          | 2 --
 2 files changed, 3 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 4064aca..01b493e 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -9,7 +9,6 @@
 #ifdef CONFIG_NUMA
 
 #define NR_NODE_MEMBLKS		(MAX_NUMNODES*2)
-#define ZONE_ALIGN (1UL << (MAX_ORDER+PAGE_SHIFT))
 
 /*
  * Too small node sizes may confuse the VM badly. Usually they
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 1d045f9..69f6362 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -200,8 +200,6 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	if (end && (end - start) < NODE_MIN_SIZE)
 		return;
 
-	start = roundup(start, ZONE_ALIGN);
-
 	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n",
 	       nid, start, end - 1);
 
-- 
1.9.3

