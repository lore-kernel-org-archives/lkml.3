Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924AbaAYO0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:26:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52570 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaAYO0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:26:05 -0500
Date: Sat, 25 Jan 2014 06:25:38 -0800
From: tip-bot for Toshi Kani <tipbot@zytor.com>
Message-ID: <tip-a85eba8814631d0d48361c8b9a7ee0984e80c03c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, toshi.kani@hp.com, akpm@linux-foundation.org,
        tglx@linutronix.de, rientjes@google.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] arch/x86/mm/srat:
  Skip NUMA_NO_NODE while parsing SLIT
Git-Commit-ID: a85eba8814631d0d48361c8b9a7ee0984e80c03c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:25:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a85eba8814631d0d48361c8b9a7ee0984e80c03c
Gitweb:     http://git.kernel.org/tip/a85eba8814631d0d48361c8b9a7ee0984e80c03c
Author:     Toshi Kani <toshi.kani@hp.com>
AuthorDate: Tue, 21 Jan 2014 14:33:15 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 09:13:35 +0100

arch/x86/mm/srat: Skip NUMA_NO_NODE while parsing SLIT

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
---
 arch/x86/mm/srat.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 266ca91..5ecf651 100644
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
