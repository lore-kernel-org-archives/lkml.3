Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682AbaLJOXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:23:52 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:44809 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757628AbaLJOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:23:46 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM, peterz@infradead.org,
        hughd@google.com, hocko@suse.cz
Subject: [PATCH v2 5/5] uaccess: CONFIG_DEBUG_PAGEFAULT_COUNT to debug pagefault_count
Date: Wed, 10 Dec 2014 15:23:34 +0100
Message-Id: <1418221414-60110-6-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121014-0005-0000-0000-000002685C2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces CONFIG_DEBUG_PAGEFAULT_COUNT, to detect over-/underflows
in the pagefault_count resulting from a wrong usage of pagefault_enable() and
pagefault_disable().

Signed-off-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
---
 include/linux/uaccess.h |  8 +++++++-
 lib/Kconfig.debug       |  9 +++++++++
 mm/maccess.c            | 11 +++++++++++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 1dfc678..6ffb90b 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -20,11 +20,17 @@ static __always_inline void pagefault_count_inc(void)
 	(*pagefault_count_ptr())++;
 }
 
-static __always_inline void pagefault_count_dec(void)
+static __always_inline void __pagefault_count_dec(void)
 {
 	(*pagefault_count_ptr())--;
 }
 
+#ifdef CONFIG_DEBUG_PAGEFAULT_COUNT
+extern void pagefault_count_dec(void);
+#else
+#define pagefault_count_dec() __pagefault_count_dec()
+#endif
+
 /*
  * These routines enable/disable the pagefault handler. If disabled, it will
  * not take any locks and go straight to the fixup table.
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d780351..9dea6e0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -860,6 +860,15 @@ config DEBUG_PREEMPT
 	  if kernel code uses it in a preemption-unsafe way. Also, the kernel
 	  will detect preemption count underflows.
 
+config DEBUG_PAGEFAULT_COUNT
+	bool "Debug pagefault_disable / pagefault_enable"
+	depends on DEBUG_KERNEL
+	default n
+	help
+	  If you say Y here then the kernel will detect pagefault count
+	  over-/underflows and therefore non-matching pagefault_enable() and
+	  pagefault_disable() calls.
+
 menu "Lock Debugging (spinlocks, mutexes, etc...)"
 
 config DEBUG_RT_MUTEXES
diff --git a/mm/maccess.c b/mm/maccess.c
index d53adf9..4b72aa1 100644
--- a/mm/maccess.c
+++ b/mm/maccess.c
@@ -5,6 +5,17 @@
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 
+#ifdef CONFIG_DEBUG_PAGEFAULT_COUNT
+void pagefault_count_dec(void)
+{
+	__pagefault_count_dec();
+
+	/* underflow / previous overflow ? */
+	WARN_ON(pagefault_count() < 0);
+}
+EXPORT_SYMBOL(pagefault_count_dec);
+#endif
+
 /**
  * probe_kernel_read(): safely attempt to read from a location
  * @dst: pointer to the buffer that shall take the data
-- 
1.8.5.5

