Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104Ab3JIJG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:06:56 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:48587 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab3JIJGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:06:55 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Radu Caragea <sinaelgl@gmail.com>, Michel Lespinasse <walken@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 1/2] mmap: arch_get_unmapped_area(): use proper mmap base for bottom up direction
Date: Wed,  9 Oct 2013 11:06:42 +0200
Message-Id: <1381309603-19570-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100909-5024-0000-0000-00000774F5DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is more or less the generic variant of 41aacc1eea "x86 get_unmapped_area:
Access mmap_legacy_base through mm_struct member".

So effectively architectures which use an own arch_pick_mmap_layout()
implementation but call the generic arch_get_unmapped_area() now can also
randomize their mmap_base.

All architectures which have an own arch_pick_mmap_layout() and call
the generic arch_get_unmapped_area() (arm64, s390, tile) currently set
mmap_base to TASK_UNMAPPED_BASE. This is also true for the generic
arch_pick_mmap_layout() function. So this change is a no-op currently.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 9d54851..fa206ab 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1872,7 +1872,7 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 
 	info.flags = 0;
 	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
+	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = 0;
 	return vm_unmapped_area(&info);
-- 
1.8.3.4

