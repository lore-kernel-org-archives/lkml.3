Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab3EZGeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 02:34:46 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:51305 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986Ab3EZGeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 02:34:44 -0400
Message-ID: <51A1ACFB.3040600@gmail.com>
Date: Sun, 26 May 2013 14:34:35 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Simon Horman <horms@verge.net.au>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: [PATCH v2 1/7] /dev/oldmem: Remove the interface
References: <51A1AC4A.60506@gmail.com>
In-Reply-To: <51A1AC4A.60506@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

/dev/oldmem provides the interface for us to access the "old memory" in
the dump-capture kernel. Unfortunately, no one actually uses this interface.

And this interface could actually cause some real problems if used on ia64
where the cached/uncached accesses are mixed. See the discussion from
the link: https://lkml.org/lkml/2013/4/12/386.

So Eric suggested that we should remove /dev/oldmem as an unused piece of
code.

Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/char/mem.c |   47 -----------------------------------------------
 1 files changed, 0 insertions(+), 47 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1ccbe94..bbe8ab4 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -21,7 +21,6 @@
 #include <linux/ptrace.h>
 #include <linux/device.h>
 #include <linux/highmem.h>
-#include <linux/crash_dump.h>
 #include <linux/backing-dev.h>
 #include <linux/bootmem.h>
 #include <linux/splice.h>
@@ -357,40 +356,6 @@ static int mmap_kmem(struct file *file, struct vm_area_struct *vma)
 }
 #endif
 
-#ifdef CONFIG_CRASH_DUMP
-/*
- * Read memory corresponding to the old kernel.
- */
-static ssize_t read_oldmem(struct file *file, char __user *buf,
-				size_t count, loff_t *ppos)
-{
-	unsigned long pfn, offset;
-	size_t read = 0, csize;
-	int rc = 0;
-
-	while (count) {
-		pfn = *ppos / PAGE_SIZE;
-		if (pfn > saved_max_pfn)
-			return read;
-
-		offset = (unsigned long)(*ppos % PAGE_SIZE);
-		if (count > PAGE_SIZE - offset)
-			csize = PAGE_SIZE - offset;
-		else
-			csize = count;
-
-		rc = copy_oldmem_page(pfn, buf, csize, offset, 1);
-		if (rc < 0)
-			return rc;
-		buf += csize;
-		*ppos += csize;
-		read += csize;
-		count -= csize;
-	}
-	return read;
-}
-#endif
-
 #ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
@@ -772,7 +737,6 @@ static int open_port(struct inode *inode, struct file *filp)
 #define aio_write_zero	aio_write_null
 #define open_mem	open_port
 #define open_kmem	open_mem
-#define open_oldmem	open_mem
 
 static const struct file_operations mem_fops = {
 	.llseek		= memory_lseek,
@@ -837,14 +801,6 @@ static const struct file_operations full_fops = {
 	.write		= write_full,
 };
 
-#ifdef CONFIG_CRASH_DUMP
-static const struct file_operations oldmem_fops = {
-	.read	= read_oldmem,
-	.open	= open_oldmem,
-	.llseek = default_llseek,
-};
-#endif
-
 static const struct memdev {
 	const char *name;
 	umode_t mode;
@@ -866,9 +822,6 @@ static const struct memdev {
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
 #endif
-#ifdef CONFIG_CRASH_DUMP
-	[12] = { "oldmem", 0, &oldmem_fops, NULL },
-#endif
 };
 
 static int memory_open(struct inode *inode, struct file *filp)
-- 
1.7.1

