Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbaFAAYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 20:24:37 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44772 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbaFAAYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 20:24:36 -0400
From: Real Name <enjoymindful@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: richard@nod.at, linux-kernel@vger.kernel.org,
        Real Name <enjoymindful@gmail.com>
Subject: [PATCH] delete unnecessary bootmem struct page array
Date: Sun,  1 Jun 2014 08:24:06 +0800
Message-Id: <1401582246-30025-1-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) uml kernel bootmem managed through bootmem_data->node_bootmem_map,
not struct page array, so it is unnecessary.

2) the struct page array allocate has been pointer by a *loacl* pointer
struct page *map in init_maps function. The array can't be access after
the init_maps exit. As a result, there is about 1% of total memory leak.
---
 arch/um/kernel/um_arch.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 016adf0..d4c98d1 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -348,12 +348,6 @@ int __init linux_main(int argc, char **argv)
 	start_vm = VMALLOC_START;
 
 	setup_physmem(uml_physmem, uml_reserved, physmem_size, highmem);
-	if (init_maps(physmem_size, iomem_size, highmem)) {
-		printf("Failed to allocate mem_map for %Lu bytes of physical "
-		       "memory and %Lu bytes of highmem\n", physmem_size,
-		       highmem);
-		exit(1);
-	}
 
 	virtmem_size = physmem_size;
 	stack = (unsigned long) argv;
-- 
1.8.3.1

