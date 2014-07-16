Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaGPUQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:16:15 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34437 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaGPUQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:16:13 -0400
Date: Wed, 16 Jul 2014 13:14:06 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Jeff Layton <jlayton@poochiereds.net>, Aristeu Rozanski <aris@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] simple_xattr: permit 0-size extended attributes
Message-ID: <alpine.LSU.2.11.1407161313210.7782@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a filesystem uses simple_xattr to support user extended attributes,
LTP setxattr01 and xfstests generic/062 fail with "Cannot allocate memory":
simple_xattr_alloc()'s wrap-around test mistakenly excludes values of zero
size.  Fix that off-by-one (but apparently no filesystem needs them yet).

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 fs/xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.16-rc5/fs/xattr.c	2013-02-18 15:58:34.000000000 -0800
+++ linux/fs/xattr.c	2014-07-16 12:47:10.640004412 -0700
@@ -843,7 +843,7 @@ struct simple_xattr *simple_xattr_alloc(
 
 	/* wrap around? */
 	len = sizeof(*new_xattr) + size;
-	if (len <= sizeof(*new_xattr))
+	if (len < sizeof(*new_xattr))
 		return NULL;
 
 	new_xattr = kmalloc(len, GFP_KERNEL);
