Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3JRHJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:09:51 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:53080 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3JRHJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:09:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/atari: Call paging_init() before nf_init()
Date: Fri, 18 Oct 2013 09:09:44 +0200
Message-Id: <1382080184-19115-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nf_init() uses virt_to_phys(), which depends on m68k_memoffset being set and
module_fixup() having been called, but this is only done in paging_init().
Hence call paging_init() before nf_init().

This went unnoticed, as virt_to_phys() is a no-op on Atari, unless you start
fiddling with the memory blocks in the bootinfo manually.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/kernel/setup_mm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 99cfe0577ad0..5b8ec4d5f8e8 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -348,12 +348,12 @@ void __init setup_arch(char **cmdline_p)
 		panic("No configuration setup");
 	}
 
+	paging_init();
+
 #ifdef CONFIG_NATFEAT
 	nf_init();
 #endif
 
-	paging_init();
-
 #ifndef CONFIG_SUN3
 	for (i = 1; i < m68k_num_memory; i++)
 		free_bootmem_node(NODE_DATA(i), m68k_memory[i].addr,
-- 
1.7.9.5

