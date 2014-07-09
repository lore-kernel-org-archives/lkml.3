Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaGILpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:45:06 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63098 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249AbaGILgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:36:31 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-63-53bd29375f5b
From: Andrey Ryabinin <a.ryabinin@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>, Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org,
        Andrey Ryabinin <a.ryabinin@samsung.com>
Subject: [RFC/PATCH RESEND -next 02/21] init: main: initialize kasan's shadow
 area on boot
Date: Wed, 09 Jul 2014 15:29:56 +0400
Message-id: <1404905415-9046-3-git-send-email-a.ryabinin@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xy7rmmnuDDfbOlLLY9usRm8XvvTNZ
	LeasX8Nmcf3bG0aLCQ/b2C1WdjezWWx/9pbJYmXnA1aLTY+vsVr82bWDyeLyrjlsFvfW/Ge1
	uH2Z1+LSgQVMFi37LjBZtH3+x2qxb+V5IGvJRiaLxUduM1u8ezaZ2WLzpqnMFj82PGZ1EPNo
	ae5h89g56y67x4JNpR6bVnWyeWz6NIndo+vtFSaPd+fOsXucmPGbxePJlelMHpuX1Ht8fHqL
	xeP9vqtsHn1bVjF6nFlwhN3j8ya5AP4oLpuU1JzMstQifbsEroyGl9eYC86yV1yc8Zq1gXEG
	WxcjJ4eEgInE9WPvoGwxiQv31gPZXBxCAksZJf6f3gLl9DFJHNj5kh2kik1AT+LfrO1gHSIC
	ChKbe5+xghQxCzSzSbR3fGAFSQgLxEicbzoLVsQioCrR82M6I4jNK+AqMfHPHRaIdQoSy5bP
	BKvnFHCTmDD9GnMXIwfQNleJCSvUJjDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kR
	EktfdzAuPWZ1iFGAg1GJh/fF7j3BQqyJZcWVuYcYJTiYlUR4bUX3BgvxpiRWVqUW5ccXleak
	Fh9iZOLglGpgXH58aWHW0rNrFhbuXRUYsFh5/QS9x4uvzvr8nveG7bJD/3uN7s74vlttemrU
	zJg/xelSFtIzPiumP27XD5hgnpi4oVXMzqai2PfBlBd6p2qO9n7+n7SyRygsjHWDWPDpy5O9
	pTq/s9RMPeY8j/Vo4/WFLqVvnLal+rTuuLXo7imz7S2ftkfymimxFGckGmoxFxUnAgB5O1oj
	gwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes shadow area after it was allocated by arch code.
All low memory marked as accessible except shadow area itself.
Later free_all_bootmem() will release pages to buddy allocator
and these pages will be marked as unaccessible, untill somebody
will allocate them.

Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
---
 init/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index bb1aed9..d06a636 100644
--- a/init/main.c
+++ b/init/main.c
@@ -78,6 +78,7 @@
 #include <linux/context_tracking.h>
 #include <linux/random.h>
 #include <linux/list.h>
+#include <linux/kasan.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -549,7 +550,7 @@ asmlinkage __visible void __init start_kernel(void)
 			   set_init_arg);
 
 	jump_label_init();
-
+	kasan_init_shadow();
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
-- 
1.8.5.5

