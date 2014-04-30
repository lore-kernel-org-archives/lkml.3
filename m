Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaD3BLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:11:03 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:44827 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbaD3BLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:11:00 -0400
From: behanw@converseincode.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, hpa@zytor.com, dwmw2@infradead.org,
        Mark Charlebois <charlebm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: [PATCH] mbcache: LLVMLinux: Remove double calculation from mbcache
Date: Tue, 29 Apr 2014 18:10:39 -0700
Message-Id: <1398820239-1890-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Charlebois <charlebm@gmail.com>

The call to __builtin_log2 presumes there is a
double log2(double x) function defined in the kernel.

The call to hash_log is a call to hash_64 which is
defined in include/linux/hash.h

static __always_inline u64 hash_64(u64 val, unsigned int bits)

That means that __builtin_log2(NR_BG_LOCKS) is converting
NR_BG_LOCKS to a double and returning a double and then that
is converted to an unsigned int.

Using ilog2 is much more appropriate and efficient.

Another side effect of using __builtin_log2 is that is uses
__aeabi_* functions for ARM that require linking with libgcc.a.

Author: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
---
 fs/mbcache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/mbcache.c b/fs/mbcache.c
index bf166e3..2c0752b 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -93,7 +93,7 @@
 
 #define MB_CACHE_WRITER ((unsigned short)~0U >> 1)
 
-#define MB_CACHE_ENTRY_LOCK_BITS	__builtin_log2(NR_BG_LOCKS)
+#define MB_CACHE_ENTRY_LOCK_BITS	ilog2(NR_BG_LOCKS)
 #define	MB_CACHE_ENTRY_LOCK_INDEX(ce)			\
 	(hash_long((unsigned long)ce, MB_CACHE_ENTRY_LOCK_BITS))
 
-- 
1.8.3.2

