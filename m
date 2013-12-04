Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab3LDVOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:14:11 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:46903 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3LDVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:14:09 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, mingo@kernel.org, hpa@zytor.com,
        tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH] mm, x86: Skip NUMA_NO_NODE while parsing SLIT
Date: Wed,  4 Dec 2013 14:09:08 -0700
Message-Id: <1386191348-4696-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ACPI SLIT table has an I/O locality (i.e. a locality unique
to an I/O device), numa_set_distance() emits the warning message
below.

 NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10

acpi_numa_slit_init() calls numa_set_distance() with pxm_to_node(),
which assumes that all localities have been parsed with SRAT previously.
SRAT does not list I/O localities, where as SLIT lists all localities
including I/Os.  Hence, pxm_to_node() returns NUMA_NO_NODE (-1) for
an I/O locality.  I/O localities are not supported and are ignored
today, but emitting such warning message leads unnecessary confusion.

Change acpi_numa_slit_init() to avoid calling numa_set_distance()
with NUMA_NO_NODE.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 arch/x86/mm/srat.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 266ca91..29a2ced 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -47,10 +47,16 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
 {
 	int i, j;
 
-	for (i = 0; i < slit->locality_count; i++)
-		for (j = 0; j < slit->locality_count; j++)
+	for (i = 0; i < slit->locality_count; i++) {
+		if (pxm_to_node(i) == NUMA_NO_NODE)
+			continue;
+		for (j = 0; j < slit->locality_count; j++) {
+			if (pxm_to_node(j) == NUMA_NO_NODE)
+				continue;
 			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
 				slit->entry[slit->locality_count * i + j]);
+		}
+	}
 }
 
 /* Callback for Proximity Domain -> x2APIC mapping */
