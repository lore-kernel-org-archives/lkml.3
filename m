Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaAZJJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:09:48 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29861 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaAZJJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:09:42 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, mm: Avoid extra pxm_to_node()
Date: Sun, 26 Jan 2014 01:10:15 -0800
Message-Id: <1390727415-26376-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <20140126084604.GA30853@gmail.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In slit init code, more pxm_to_node() calling are added.

We can cache return with from_node/to_node to avoid them.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
 
---
 arch/x86/mm/srat.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/srat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat.c
+++ linux-2.6/arch/x86/mm/srat.c
@@ -50,14 +50,19 @@ static __init inline int srat_disabled(v
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
 	int i, j;
+	int from_node, to_node;
 
 	for (i = 0; i < slit->locality_count; i++) {
-		if (pxm_to_node(i) == NUMA_NO_NODE)
+		from_node = pxm_to_node(i);
+		if (from_node == NUMA_NO_NODE)
 			continue;
+
 		for (j = 0; j < slit->locality_count; j++) {
-			if (pxm_to_node(j) == NUMA_NO_NODE)
+			to_node = pxm_to_node(j);
+			if (to_node == NUMA_NO_NODE)
 				continue;
-			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
+
+			numa_set_distance(from_node, to_node,
 				slit->entry[slit->locality_count * i + j]);
 		}
 	}
