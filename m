Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725Ab3EIWjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:39:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142Ab3EIWhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:37:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: [ 01/12] powerpc: fix numa distance for form0 device tree
Date: Thu,  9 May 2013 15:37:14 -0700
Message-Id: <20130509223611.574980673@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509223611.432377360@linuxfoundation.org>
References: <20130509223611.432377360@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


