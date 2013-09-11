Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab3IKPij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:38:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab3IKPih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:38:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] CacheFiles: Fix memory leak in cachefiles_check_auxdata
 error paths
To: milosz@adfin.com
From: David Howells <dhowells@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org, Hongyi Jia <jiayisuse@gmail.com>,
        Josh Boyer <jwboyer@fedoraproject.org>
Date: Wed, 11 Sep 2013 16:38:32 +0100
Message-ID: <20130911153832.19151.65721.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

In cachefiles_check_auxdata(), we allocate auxbuf but fail to free it if we get
determine there's an error or that the data is stale.

Further, assigning the output of vfs_getxattr() to auxbuf->len gives problems
with checking for errors as auxbuf->len is a u16.  We don't actually need to
set auxbuf->len, so keep the length in a variable for now.  We shouldn't need
to check the upper limit of the buffer as an overflow there should be
indicated by -ERANGE.

Whilst we're at it, fscache_check_aux() returns an enum value, not an int, so
assign it to an appropriately typed variable rather than to ret.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Hongyi Jia <jiayisuse@gmail.com>
cc: Milosz Tanski <milosz@adfin.com>
---

 fs/cachefiles/xattr.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/cachefiles/xattr.c b/fs/cachefiles/xattr.c
index 34c88b8..12b0eef 100644
--- a/fs/cachefiles/xattr.c
+++ b/fs/cachefiles/xattr.c
@@ -162,8 +162,9 @@ int cachefiles_update_object_xattr(struct cachefiles_object *object,
 int cachefiles_check_auxdata(struct cachefiles_object *object)
 {
 	struct cachefiles_xattr *auxbuf;
+	enum fscache_checkaux validity;
 	struct dentry *dentry = object->dentry;
-	unsigned int dlen;
+	ssize_t xlen;
 	int ret;
 
 	ASSERT(dentry);
@@ -174,22 +175,22 @@ int cachefiles_check_auxdata(struct cachefiles_object *object)
 	if (!auxbuf)
 		return -ENOMEM;
 
-	auxbuf->len = vfs_getxattr(dentry, cachefiles_xattr_cache,
-				   &auxbuf->type, 512 + 1);
-	if (auxbuf->len < 1)
-		return -ESTALE;
-
-	if (auxbuf->type != object->fscache.cookie->def->type)
-		return -ESTALE;
+	xlen = vfs_getxattr(dentry, cachefiles_xattr_cache,
+			    &auxbuf->type, 512 + 1);
+	ret = -ESTALE;
+	if (xlen < 1 ||
+	    auxbuf->type != object->fscache.cookie->def->type)
+		goto error;
 
-	dlen = auxbuf->len - 1;
-	ret = fscache_check_aux(&object->fscache, &auxbuf->data, dlen);
+	xlen--;
+	validity = fscache_check_aux(&object->fscache, &auxbuf->data, xlen);
+	if (validity != FSCACHE_CHECKAUX_OKAY)
+		goto error;
 
+	ret = 0;
+error:
 	kfree(auxbuf);
-	if (ret != FSCACHE_CHECKAUX_OKAY)
-		return -ESTALE;
-
-	return 0;
+	return ret;
 }
 
 /*

