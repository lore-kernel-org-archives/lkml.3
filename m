Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbaKFXJY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:09:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58763 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaKFWlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: sparclinux@vger.kernel.org, Bob Picco <bob.picco@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 033/162] sparc64: find_node adjustment
Date: Thu,  6 Nov 2014 14:34:57 -0800
Message-Id: <1415313426-9622-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: bob picco <bpicco@meloft.net>

[ Upstream commit 3dee9df54836d5f844f3d58281d3f3e6331b467f ]

We have seen an issue with guest boot into LDOM that causes early boot failures
because of no matching rules for node identitity of the memory. I analyzed this
on my T4 and concluded there might not be a solution. I saw the issue in
mainline too when booting into the control/primary domain - with guests
configured.  Note, this could be a firmware bug on some older machines.

I'll provide a full explanation of the issues below. Should we not find a
matching BEST latency group for a real address (RA) then we will assume node 0.
On the T4-2 here with the information provided I can't see an alternative.

Technically the LDOM shown below should match the MBLOCK to the
favorable latency group. However other factors must be considered too. Were
the memory controllers configured "fine" grained interleave or "coarse"
grain interleaved -  T4. Also should a "group" MD node be considered a NUMA
node?

There has to be at least one Machine Description (MD) "group" and hence one
NUMA node. The group can have one or more latency groups (lg) - more than one
memory controller. The current code chooses the smallest latency as the most
favorable per group. The latency and lg information is in MLGROUP below.
MBLOCK is the base and size of the RAs for the machine as fetched from OBP
/memory "available" property. My machine has one MBLOCK but more would be
possible - with holes?

For a T4-2 the following information has been gathered:
with LDOM guest
MEMBLOCK configuration:
 memory size = 0x27f870000
 memory.cnt  = 0x3
 memory[0x0]    [0x00000020400000-0x0000029fc67fff], 0x27f868000 bytes
 memory[0x1]    [0x0000029fd8a000-0x0000029fd8bfff], 0x2000 bytes
 memory[0x2]    [0x0000029fd92000-0x0000029fd97fff], 0x6000 bytes
 reserved.cnt  = 0x2
 reserved[0x0]  [0x00000020800000-0x000000216c15c0], 0xec15c1 bytes
 reserved[0x1]  [0x00000024800000-0x0000002c180c1e], 0x7980c1f bytes
MBLOCK[0]: base[20000000] size[280000000] offset[0]
(note: "base" and "size" reported in "MBLOCK" encompass the "memory[X]" values)
(note: (RA + offset) & mask = val is the formula to detect a match for the
memory controller. should there be no match for find_node node, a return
value of -1 resulted for the node - BAD)

There is one group. It has these forward links
MLGROUP[1]: node[545] latency[1f7e8] match[200000000] mask[200000000]
MLGROUP[2]: node[54d] latency[2de60] match[0] mask[200000000]
NUMA NODE[0]: node[545] mask[200000000] val[200000000] (latency[1f7e8])
(note: "val" is the best lg's (smallest latency) "match")

no LDOM guest - bare metal
MEMBLOCK configuration:
 memory size = 0xfdf2d0000
 memory.cnt  = 0x3
 memory[0x0]    [0x00000020400000-0x00000fff6adfff], 0xfdf2ae000 bytes
 memory[0x1]    [0x00000fff6d2000-0x00000fff6e7fff], 0x16000 bytes
 memory[0x2]    [0x00000fff766000-0x00000fff771fff], 0xc000 bytes
 reserved.cnt  = 0x2
 reserved[0x0]  [0x00000020800000-0x00000021a04580], 0x1204581 bytes
 reserved[0x1]  [0x00000024800000-0x0000002c7d29fc], 0x7fd29fd bytes
MBLOCK[0]: base[20000000] size[fe0000000] offset[0]

there are two groups
group node[16d5]
MLGROUP[0]: node[1765] latency[1f7e8] match[0] mask[200000000]
MLGROUP[3]: node[177d] latency[2de60] match[200000000] mask[200000000]
NUMA NODE[0]: node[1765] mask[200000000] val[0] (latency[1f7e8])
group node[171d]
MLGROUP[2]: node[1775] latency[2de60] match[0] mask[200000000]
MLGROUP[1]: node[176d] latency[1f7e8] match[200000000] mask[200000000]
NUMA NODE[1]: node[176d] mask[200000000] val[200000000] (latency[1f7e8])
(note: for this two "group" bare metal machine, 1/2 memory is in group one's
lg and 1/2 memory is in group two's lg).

Cc: sparclinux@vger.kernel.org
Signed-off-by: Bob Picco <bob.picco@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/mm/init_64.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index e275cde..a1d48b9 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -838,7 +838,10 @@ static int find_node(unsigned long addr)
 		if ((addr & p->mask) == p->val)
 			return i;
 	}
-	return -1;
+	/* The following condition has been observed on LDOM guests.*/
+	WARN_ONCE(1, "find_node: A physical address doesn't match a NUMA node"
+		" rule. Some physical memory will be owned by node 0.");
+	return 0;
 }
 
 static u64 memblock_nid_range(u64 start, u64 end, int *nid)
-- 
1.9.1

