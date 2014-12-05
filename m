Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaLELS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 06:18:29 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:52172 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbaLELS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 06:18:26 -0500
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, dahi@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com, mst@redhat.com,
        tglx@linutronix.de, David.Laight@ACULAB.COM, peterz@infradead.org,
        hughd@google.com, hocko@suse.cz
Subject: [PATCH v1 5/5] uaccess: CONFIG_DEBUG_PAGEFAULT_COUNT to debug pagefault_count
Date: Fri,  5 Dec 2014 12:18:09 +0100
Message-Id: <1417778289-51567-6-git-send-email-dahi@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
References: <1417778289-51567-1-git-send-email-dahi@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120511-0021-0000-0000-000002080311
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
index 4e35a5d..529e9d4 100644
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

