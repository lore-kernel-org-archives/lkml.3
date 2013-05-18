Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548Ab3ERDAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab3ERDAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:25 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qZc4hD3Ze1cA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=wzR49PFbg70A:10 a=VnNF1IyMAAAA:8 a=K-5VRoIfy9xCMiGJDm4A:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021655.588522455@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [ 086/136 ] powerpc: fix numa distance for form0 device tree
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0086-powerpc-fix-numa-distance-for-form0-device-tree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

[ Upstream commit 7122beeee7bc1757682049780179d7c216dd1c83 ]

The following commit breaks numa distance setup for old powerpc
systems that use form0 encoding in device tree.

commit 41eab6f88f24124df89e38067b3766b7bef06ddb
powerpc/numa: Use form 1 affinity to setup node distance

Device tree node /rtas/ibm,associativity-reference-points would
index into /cpus/PowerPCxxxx/ibm,associativity based on form0 or
form1 encoding detected by ibm,architecture-vec-5 property.

All modern systems use form1 and current kernel code is correct.
However, on older systems with form0 encoding, the numa distance
will get hard coded as LOCAL_DISTANCE for all nodes.  This causes
task scheduling anomaly since scheduler will skip building numa
level domain (topmost domain with all cpus) if all numa distances
are same.  (value of 'level' in sched_init_numa() will remain 0)

Prior to the above commit:
((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)

Restoring compatible behavior with this patch for old powerpc systems
with device tree where numa distance are encoded as form0.

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 59213cf..d53fa78 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -201,7 +201,7 @@ int __node_distance(int a, int b)
 	int distance = LOCAL_DISTANCE;
 
 	if (!form1_affinity)
-		return distance;
+		return ((a == b) ? LOCAL_DISTANCE : REMOTE_DISTANCE);
 
 	for (i = 0; i < distance_ref_points_depth; i++) {
 		if (distance_lookup_table[a][i] == distance_lookup_table[b][i])
-- 
1.7.10.4


