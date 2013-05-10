Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3EJOUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:20:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56979 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754328Ab3EJOUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:18 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael Ellerman" <michael@ellerman.id.au>,
        "Vaidyanathan Srinivasan" <svaidy@linux.vnet.ibm.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.947793552@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [116/118] powerpc: fix numa distance for form0 device tree
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -221,7 +221,7 @@ int __node_distance(int a, int b)
 	int distance = LOCAL_DISTANCE;
 
 	if (!form1_affinity)
-		return distance;
+		return ((a == b) ? LOCAL_DISTANCE : REMOTE_DISTANCE);
 
 	for (i = 0; i < distance_ref_points_depth; i++) {
 		if (distance_lookup_table[a][i] == distance_lookup_table[b][i])

