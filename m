Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934048AbaEGN32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:29:28 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51393 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933025AbaEGN3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:29:23 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Li Zefan <lizefan@huawei.com>
Subject: [PATCH] mm: Postpone the disabling of kmemleak early logging
Date: Wed,  7 May 2014 14:28:35 +0100
Message-Id: <1399469315-29239-1-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8910ae896c8c (kmemleak: change some global variables to int), in
addition to the atomic -> int conversion, moved the kmemleak_early_log
disabling at the beginning of the kmemleak_init() function, before the
full kmemleak tracing is actually enabled. In this small window,
kmem_cache_create() is called by kmemleak which triggers additional
memory allocation that are not traced. This patch restores the original
logic with kmemleak_early_log disabling when kmemleak is fully
functional.

Fixes: 8910ae896c8c (kmemleak: change some global variables to int)
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Li Zefan <lizefan@huawei.com>
---
 mm/kmemleak.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 61a64ed2fbef..33599ba0cd8d 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1809,10 +1809,9 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
-	kmemleak_early_log = 0;
-
 #ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
 	if (!kmemleak_skip_disable) {
+		kmemleak_early_log = 0;
 		kmemleak_disable();
 		return;
 	}
@@ -1830,6 +1829,7 @@ void __init kmemleak_init(void)
 
 	/* the kernel is still in UP mode, so disabling the IRQs is enough */
 	local_irq_save(flags);
+	kmemleak_early_log = 0;
 	if (kmemleak_error) {
 		local_irq_restore(flags);
 		return;
