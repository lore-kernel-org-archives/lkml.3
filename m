Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3AXUPT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:15:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34394 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3AXUNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:13:40 -0500
Date: Thu, 24 Jan 2013 12:13:17 -0800
From: tip-bot for Davidlohr Bueso <davidlohr.bueso@hp.com>
Message-ID: <tip-479a99a8e510c8839e0d3d3de8391f8bc61b9760@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davidlohr.bueso@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davidlohr.bueso@hp.com, tglx@linutronix.de
In-Reply-To: <1357690721.1890.15.camel@buesod1.americas.hpqcorp.net>
References: <1357690721.1890.15.camel@buesod1.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/srat:
  Simplify memory affinity init error handling
Git-Commit-ID: 479a99a8e510c8839e0d3d3de8391f8bc61b9760
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:13:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  479a99a8e510c8839e0d3d3de8391f8bc61b9760
Gitweb:     http://git.kernel.org/tip/479a99a8e510c8839e0d3d3de8391f8bc61b9760
Author:     Davidlohr Bueso <davidlohr.bueso@hp.com>
AuthorDate: Tue, 8 Jan 2013 16:18:41 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 14:20:00 +0100

x86/srat: Simplify memory affinity init error handling

The acpi_numa_memory_affinity_init() function can fail in
several scenarios, use a single point of error return.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Link: http://lkml.kernel.org/r/1357690721.1890.15.camel@buesod1.americas.hpqcorp.net
[ Cleaned up the label naming a bit. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/srat.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 4ddf497..cdd0da9 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -149,39 +149,40 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	int node, pxm;
 
 	if (srat_disabled())
-		return -1;
-	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
-		bad_srat();
-		return -1;
-	}
+		goto out_err;
+	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity))
+		goto out_err_bad_srat;
 	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
-		return -1;
-
+		goto out_err;
 	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
-		return -1;
+		goto out_err;
+
 	start = ma->base_address;
 	end = start + ma->length;
 	pxm = ma->proximity_domain;
 	if (acpi_srat_revision <= 1)
 		pxm &= 0xff;
+
 	node = setup_node(pxm);
 	if (node < 0) {
 		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-		bad_srat();
-		return -1;
+		goto out_err_bad_srat;
 	}
 
-	if (numa_add_memblk(node, start, end) < 0) {
-		bad_srat();
-		return -1;
-	}
+	if (numa_add_memblk(node, start, end) < 0)
+		goto out_err_bad_srat;
 
 	node_set(node, numa_nodes_parsed);
 
 	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
 	       node, pxm,
 	       (unsigned long long) start, (unsigned long long) end - 1);
+
 	return 0;
+out_err_bad_srat:
+	bad_srat();
+out_err:
+	return -1;
 }
 
 void __init acpi_numa_arch_fixup(void) {}
