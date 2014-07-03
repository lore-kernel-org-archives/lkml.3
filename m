Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbaGCJSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:18:42 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:50964 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaGCJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:18:40 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: DNAME_INLINE_LEN versus CONFIG_GENERIC_LOCKBREAK
Organization: D03
Date: Thu, 03 Jul 2014 11:18:35 +0200
Message-ID: <8761je94wk.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In dcache.h, DNAME_INLINE_LEN is carefully chosen so that sizeof(struct
dentry) is a (specific) multiple of 64 bytes. Obviously this breaks when
certain debug options are chosen (DEBUG_LOCK_ALLOC and DEBUG_SPINLOCK),
but also, AFAICT, on architectures with CONFIG_GENERIC_LOCKBREAK.

I'm not sure it matters, but if it does, I'd suggest putting a
BUILD_BUG_ON somewhere, protected by suitable #ifdefs, so that the code
documents the assumptions that went into the particular choice of
DNAME_INLINE_LEN (this would also help catch changes to some of the
structures embedded in struct dentry which would violate those
assumptions). 

Rasmus


Something like this, which correctly fails for me on x86_64 when I
transplant CONFIG_GENERIC_LOCKBREAK to its Kconfig.

diff --git a/fs/dcache.c b/fs/dcache.c
index 06f6585..aa72a86 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1433,6 +1433,14 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	struct dentry *dentry;
 	char *dname;
 
+#if !defined(CONFIG_DEBUG_LOCK_ALLOC) && !defined(CONFIG_DEBUG_SPINLOCK)
+# ifdef CONFIG_64BIT
+	BUILD_BUG_ON(sizeof(struct dentry) != 192);
+# else
+	BUILD_BUG_ON(sizeof(struct dentry) != 128);
+# endif
+#endif
+
 	dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
 	if (!dentry)
 		return NULL;
