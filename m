Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaAZVBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:01:00 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38894 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaAZVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:00:59 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2] x86, mm: Avoid duplicated pxm_to_node() calling.
Date: Sun, 26 Jan 2014 13:01:42 -0800
Message-Id: <1390770102-4007-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20140126084604.GA30853@gmail.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In slit init code, more pxm_to_node() calling are added.

We can store from_node/to_node instead of keep calling pxm_to_node().

After this patch: pxm_to_node() is called n*(1+n)
Before this patch: pxm_to_node() is called n*(1+n*3)

for 8 socket, it will be 72 instead of 200.
for 32 socket, it will be 1056 instead of 3104.

-v2: update title and change log according to Ingo.
     move from_node/to_node in loop and change to const according to
	David Rientjes.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
 
---
 arch/x86/mm/srat.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/srat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat.c
+++ linux-2.6/arch/x86/mm/srat.c
@@ -52,12 +52,18 @@ void __init acpi_numa_slit_init(struct a
 	int i, j;
 
 	for (i = 0; i < slit->locality_count; i++) {
-		if (pxm_to_node(i) == NUMA_NO_NODE)
+		const int from_node = pxm_to_node(i);
+
+		if (from_node == NUMA_NO_NODE)
 			continue;
+
 		for (j = 0; j < slit->locality_count; j++) {
-			if (pxm_to_node(j) == NUMA_NO_NODE)
+			const int to_node = pxm_to_node(j);
+
+			if (to_node == NUMA_NO_NODE)
 				continue;
-			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
+
+			numa_set_distance(from_node, to_node,
 				slit->entry[slit->locality_count * i + j]);
 		}
 	}
