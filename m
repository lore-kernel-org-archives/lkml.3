Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbaDBUWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:22:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42843 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758905AbaDBUN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Toshi Kani <toshi.kani@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 08/40] arch/x86/mm/srat: Skip NUMA_NO_NODE while parsing SLIT
Date: Wed,  2 Apr 2014 22:12:54 +0200
Message-Id: <c81b7d0b30c471ede72d57e567ff26a79d45f1f2.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Toshi Kani <toshi.kani@hp.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit a85eba8814631d0d48361c8b9a7ee0984e80c03c upstream.

When ACPI SLIT table has an I/O locality (i.e. a locality
unique to an I/O device), numa_set_distance() emits this warning
message:

 NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10

acpi_numa_slit_init() calls numa_set_distance() with
pxm_to_node(), which assumes that all localities have been
parsed with SRAT previously.  SRAT does not list I/O localities,
where as SLIT lists all localities including I/Os.  Hence,
pxm_to_node() returns NUMA_NO_NODE (-1) for an I/O locality.

I/O localities are not supported and are ignored today, but emitting
such warning message leads to unnecessary confusion.

Change acpi_numa_slit_init() to avoid calling
numa_set_distance() with NUMA_NO_NODE.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/n/tip-dSvpjjvp8aMzs1ybkftxohlh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/mm/srat.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 266ca912f62e..5ecf65117e6f 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -42,15 +42,25 @@ static __init inline int srat_disabled(void)
 	return acpi_numa < 0;
 }
 
-/* Callback for SLIT parsing */
+/*
+ * Callback for SLIT parsing.  pxm_to_node() returns NUMA_NO_NODE for
+ * I/O localities since SRAT does not list them.  I/O localities are
+ * not supported at this point.
+ */
 void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
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
-- 
1.9.1

