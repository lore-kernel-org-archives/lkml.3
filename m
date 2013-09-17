Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3IQKCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 06:02:24 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53587 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3IQKCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 06:02:19 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] [RFC] m68k: Add System RAM to /proc/iomem
Date: Tue, 17 Sep 2013 12:01:33 +0200
Message-Id: <1379412095-7213-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
References: <1379412095-7213-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've resisted adding System RAM to /proc/iomem because it is the wrong
place for it.  Unfortunately we continue to find tools that rely on this
behaviour (e.g. kdump) so give up and add it in.

As the ST-RAM Pool is now a child of the first System RAM resource, it must
be switched from request_resource() to insert_resource().

Cfr. commit c40dd2f76644016ca7677545fc846ec2470d70a1 ("powerpc: Add System
RAM to /proc/iomem").

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/stram.c     |    2 +-
 arch/m68k/kernel/setup_mm.c |   23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/m68k/atari/stram.c b/arch/m68k/atari/stram.c
index 0810c8d..74eaed4 100644
--- a/arch/m68k/atari/stram.c
+++ b/arch/m68k/atari/stram.c
@@ -102,7 +102,7 @@ void __init atari_stram_reserve_pages(void *start_mem)
 
 	stram_pool.start = (resource_size_t)alloc_bootmem_low_pages(pool_size);
 	stram_pool.end = stram_pool.start + pool_size - 1;
-	request_resource(&iomem_resource, &stram_pool);
+	insert_resource(&iomem_resource, &stram_pool);
 
 	pr_debug("atari_stram pool: size = %lu bytes, resource = %pR\n",
 		 pool_size, &stram_pool);
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index cb7b0c9..55d718a 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -215,6 +215,27 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 #endif
 }
 
+/*
+ * System memory should not be in /proc/iomem but various tools expect it
+ * (e.g. kdump).
+ */
+static int __init add_system_ram_resources(void)
+{
+	int i;
+
+	for (i = 0; i < m68k_num_memory; i++) {
+		struct resource *res;
+		res = alloc_bootmem(sizeof(struct resource));
+		res->name = "System RAM";
+		res->start = m68k_memory[i].addr;
+		res->end = m68k_memory[i].addr + m68k_memory[i].size - 1;
+		res->flags = IORESOURCE_MEM;
+		WARN_ON(request_resource(&iomem_resource, res) < 0);
+	}
+
+	return 0;
+}
+
 void __init setup_arch(char **cmdline_p)
 {
 #ifndef CONFIG_SUN3
@@ -344,6 +365,8 @@ void __init setup_arch(char **cmdline_p)
 
 	paging_init();
 
+	add_system_ram_resources();
+
 #ifndef CONFIG_SUN3
 	for (i = 1; i < m68k_num_memory; i++)
 		free_bootmem_node(NODE_DATA(i), m68k_memory[i].addr,
-- 
1.7.9.5

