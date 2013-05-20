Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3ETLN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:13:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56129 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3ETKxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 045/115] powerpc: fix numa distance for form0 device tree
Date: Mon, 20 May 2013 11:50:45 +0100
Message-Id: <1369047116-9378-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

commit 7122beeee7bc1757682049780179d7c216dd1c83 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 1e95556..4ec32a6 100644
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
1.8.1.2

