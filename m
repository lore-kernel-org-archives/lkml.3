Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3A3D5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:57:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab3A3D5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:57:41 -0500
Date: Tue, 29 Jan 2013 19:57:28 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-38fa4175e60d98fb1c9815fb14f8057576dade73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-35-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-35-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] mm: Add alloc_bootmem_low_pages_nopanic()
Git-Commit-ID: 38fa4175e60d98fb1c9815fb14f8057576dade73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 19:57:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38fa4175e60d98fb1c9815fb14f8057576dade73
Gitweb:     http://git.kernel.org/tip/38fa4175e60d98fb1c9815fb14f8057576dade73
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:15 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 19:32:59 -0800

mm: Add alloc_bootmem_low_pages_nopanic()

We don't need to panic in some case, like for swiotlb preallocating.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-35-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/bootmem.h | 5 +++++
 mm/bootmem.c            | 8 ++++++++
 mm/nobootmem.c          | 8 ++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 3f778c2..3cd16ba 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -99,6 +99,9 @@ void *___alloc_bootmem_node_nopanic(pg_data_t *pgdat,
 extern void *__alloc_bootmem_low(unsigned long size,
 				 unsigned long align,
 				 unsigned long goal);
+void *__alloc_bootmem_low_nopanic(unsigned long size,
+				 unsigned long align,
+				 unsigned long goal);
 extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 				      unsigned long size,
 				      unsigned long align,
@@ -132,6 +135,8 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 
 #define alloc_bootmem_low(x) \
 	__alloc_bootmem_low(x, SMP_CACHE_BYTES, 0)
+#define alloc_bootmem_low_pages_nopanic(x) \
+	__alloc_bootmem_low_nopanic(x, PAGE_SIZE, 0)
 #define alloc_bootmem_low_pages(x) \
 	__alloc_bootmem_low(x, PAGE_SIZE, 0)
 #define alloc_bootmem_low_pages_node(pgdat, x) \
diff --git a/mm/bootmem.c b/mm/bootmem.c
index b93376c..2b0bcb0 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -833,6 +833,14 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
 }
 
+void * __init __alloc_bootmem_low_nopanic(unsigned long size,
+					  unsigned long align,
+					  unsigned long goal)
+{
+	return ___alloc_bootmem_nopanic(size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
+}
+
 /**
  * __alloc_bootmem_low_node - allocate low boot memory from a specific node
  * @pgdat: node to allocate from
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 03d152a..5e07d36 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -391,6 +391,14 @@ void * __init __alloc_bootmem_low(unsigned long size, unsigned long align,
 	return ___alloc_bootmem(size, align, goal, ARCH_LOW_ADDRESS_LIMIT);
 }
 
+void * __init __alloc_bootmem_low_nopanic(unsigned long size,
+					  unsigned long align,
+					  unsigned long goal)
+{
+	return ___alloc_bootmem_nopanic(size, align, goal,
+					ARCH_LOW_ADDRESS_LIMIT);
+}
+
 /**
  * __alloc_bootmem_low_node - allocate low boot memory from a specific node
  * @pgdat: node to allocate from
