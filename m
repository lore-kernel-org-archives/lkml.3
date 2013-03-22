Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422954Ab3CVUg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:36:57 -0400
Received: from mail.ispras.ru ([83.149.199.45]:38649 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422855Ab3CVUgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:36:55 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] SUNRPC/cache: add module_put() on error path in cache_open()
Date: Sat, 23 Mar 2013 00:36:44 +0400
Message-Id: <1363984604-17739-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kmalloc() fails in cache_open(), module cd->owner left locked.
The patch adds module_put(cd->owner) on this path.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 net/sunrpc/cache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 25d58e76..1d3c514 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -986,8 +986,10 @@ static int cache_open(struct inode *inode, struct file *filp,
 	nonseekable_open(inode, filp);
 	if (filp->f_mode & FMODE_READ) {
 		rp = kmalloc(sizeof(*rp), GFP_KERNEL);
-		if (!rp)
+		if (!rp) {
+			module_put(cd->owner);
 			return -ENOMEM;
+		}
 		rp->offset = 0;
 		rp->q.reader = 1;
 		atomic_inc(&cd->readers);
-- 
1.7.9.5

