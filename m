Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbbAZXaD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:30:03 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:54942 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbbAZX34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:29:56 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>
Subject: [RFC PATCH 1/7] mm: Change __get_vm_area_node() to use fls_long()
Date: Mon, 26 Jan 2015 16:13:23 -0700
Message-Id: <1422314009-31667-2-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
References: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__get_vm_area_node() takes unsigned long size, which is a 64-bit
value on a 64-bit kernel.  However, fls(size) simply ignores the
upper 32-bit.  Change to use fls_long() to handle the size properly.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 mm/vmalloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 39c3388..830a4be 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -29,6 +29,7 @@
 #include <linux/atomic.h>
 #include <linux/compiler.h>
 #include <linux/llist.h>
+#include <linux/bitops.h>
 
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
@@ -1314,7 +1315,8 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 
 	BUG_ON(in_interrupt());
 	if (flags & VM_IOREMAP)
-		align = 1ul << clamp(fls(size), PAGE_SHIFT, IOREMAP_MAX_ORDER);
+		align = 1ul << clamp((int)fls_long(size),
+				     PAGE_SHIFT, IOREMAP_MAX_ORDER);
 
 	size = PAGE_ALIGN(size);
 	if (unlikely(!size))
