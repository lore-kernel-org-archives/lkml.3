Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab3JCQeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 12:34:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39671 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab3JCQeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 12:34:15 -0400
Date: Thu, 3 Oct 2013 09:34:11 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH] fs: make sure we do not read beyond allocation
Message-ID: <20131003163411.GA17101@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dentry_string_cmp (via__d_lookup_rcu), when CONFIG_DCACHE_WORD_ACCESS
is set, word-width memory reads are performed. However, the string
allocation size may not be a multiple of the word size. To avoid reading
past the end of such an allocation, we must allocate in multiples of
the word size.

Found by the Kernel Address Sanitizer project:
https://code.google.com/p/address-sanitizer/wiki/AddressSanitizerForKernel

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/dcache.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4100030..23665e2 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1570,7 +1570,11 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	 */
 	dentry->d_iname[DNAME_INLINE_LEN-1] = 0;
 	if (name->len > DNAME_INLINE_LEN-1) {
-		dname = kmalloc(name->len + 1, GFP_KERNEL);
+		size_t alloc_size = name->len + 1;
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+		alloc_size = round_up(alloc_size, sizeof(unsigned long));
+#endif
+		dname = kmalloc(alloc_size, GFP_KERNEL);
 		if (!dname) {
 			kmem_cache_free(dentry_cache, dentry); 
 			return NULL;
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
