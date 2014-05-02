Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaEBNlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:41:51 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52186 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751983AbaEBNlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:41:49 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6/6] mm: Postpone the disabling of kmemleak early logging
Date: Fri,  2 May 2014 14:41:10 +0100
Message-Id: <1399038070-1540-7-git-send-email-catalin.marinas@arm.com>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
References: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kmemleak_early_log is disabled at the beginning of the
kmemleak_init() function, before the full kmemleak tracing is actually
enabled. In this small window, kmem_cache_create() is called by kmemleak
which triggers additional memory allocation that are not traced. This
patch moves the kmemleak_early_log disabling further down and at the
same time with full kmemleak enabling.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/kmemleak.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 61a64ed2fbef..0cd6aabd45a0 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1809,8 +1809,6 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
-	kmemleak_early_log = 0;
-
 #ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
 	if (!kmemleak_skip_disable) {
 		kmemleak_disable();
@@ -1833,8 +1831,9 @@ void __init kmemleak_init(void)
 	if (kmemleak_error) {
 		local_irq_restore(flags);
 		return;
-	} else
-		kmemleak_enabled = 1;
+	}
+	kmemleak_early_log = 0;
+	kmemleak_enabled = 1;
 	local_irq_restore(flags);
 
 	/*
