Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab3AUVem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:34:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:22690 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab3AUVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:34:41 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] x86, mm: Skip unknown PXM early in SLIT parsing
Date: Mon, 21 Jan 2013 13:33:57 -0800
Message-Id: <1358804037-29244-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems one bios could support 2 sockets and 4 sockets,
and SLIT is the same, aka 4x4.

For 2 sockets configuration, SRAT will only have PXM0 and PXM2.

So we will get warning:
NUMA: Warning: node ids are out of bound, from=0 to=-1 distance=15

Need to skip PXM1 and PXM2 as there is no responding node,
To avoid uncorrect warning.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
 
---
 arch/x86/mm/srat.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/srat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat.c
+++ linux-2.6/arch/x86/mm/srat.c
@@ -46,11 +46,22 @@ static __init inline int srat_disabled(v
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
 	int i, j;
+	int from_node, to_node;
 
-	for (i = 0; i < slit->locality_count; i++)
-		for (j = 0; j < slit->locality_count; j++)
-			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
+	for (i = 0; i < slit->locality_count; i++) {
+		from_node = pxm_to_node(i);
+		if (from_node < 0)
+			continue; /* skip unknown PXM */
+
+		for (j = 0; j < slit->locality_count; j++) {
+			to_node = pxm_to_node(j);
+			if (to_node < 0)
+				continue; /* skip unknown PXM */
+
+			numa_set_distance(from_node, to_node,
 				slit->entry[slit->locality_count * i + j]);
+		}
+	}
 }
 
 /* Callback for Proximity Domain -> x2APIC mapping */
