Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaDAIH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:07:59 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:54566 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaDAIH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:07:56 -0400
Date: Tue, 1 Apr 2014 10:07:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/mm change for v3.15
Message-ID: <20140401080752.GA22142@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-mm-for-linus

   # HEAD: ba6a328f7dfc95b20df5e0eb33c698187e997190 x86/mm: Avoid duplicated pxm_to_node() calls

A micro-optimization for acpi_numa_slit_init().

 Thanks,

	Ingo

------------------>
Yinghai Lu (1):
      x86/mm: Avoid duplicated pxm_to_node() calls


 arch/x86/mm/srat.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 1953e9c..66338a6 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -52,12 +52,18 @@ void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
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
