Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3IJOTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 10:19:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab3IJOTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 10:19:35 -0400
Date: Tue, 10 Sep 2013 10:19:33 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] CacheFiles: Fix memory leak in cachefiles_check_auxdata
 error paths
Message-ID: <20130910141932.GA30716@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We kmalloc auxbuf but fail to kfree it if we get errors in various places.
Rework the error paths to avoid the resource leak.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 fs/cachefiles/xattr.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 34c88b8..f929ab6 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -176,20 +176,28 @@ int cachefiles_check_auxdata(struct cachefiles_object *object)
 
 	auxbuf->len = vfs_getxattr(dentry, cachefiles_xattr_cache,
 				   &auxbuf->type, 512 + 1);
-	if (auxbuf->len < 1)
-		return -ESTALE;
+	if (auxbuf->len < 1) {
+		ret = -ESTALE;
+		goto error;
+	}
 
-	if (auxbuf->type != object->fscache.cookie->def->type)
-		return -ESTALE;
+	if (auxbuf->type != object->fscache.cookie->def->type) {
+		ret = -ESTALE;
+		goto error;
+	}
 
 	dlen = auxbuf->len - 1;
 	ret = fscache_check_aux(&object->fscache, &auxbuf->data, dlen);
 
-	kfree(auxbuf);
-	if (ret != FSCACHE_CHECKAUX_OKAY)
-		return -ESTALE;
+	if (ret != FSCACHE_CHECKAUX_OKAY) {
+		ret = -ESTALE;
+		goto error;
+	}
 
-	return 0;
+	ret = 0;
+error:
+	kfree(auxbuf);
+	return ret;
 }
 
 /*
-- 
1.8.3.1

