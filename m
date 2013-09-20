Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab3ITNSH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590Ab3ITNSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:18:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/2] CacheFiles: Don't try to dump the index key if the
 cookie has been cleared
To: torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        linux-kernel@vger.kernel.org
Date: Fri, 20 Sep 2013 14:18:00 +0100
Message-ID: <20130920131800.24001.38851.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130920131752.24001.87500.stgit@warthog.procyon.org.uk>
References: <20130920131752.24001.87500.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't try to dump the index key that distinguishes an object if netfs data in
the cookie the object refers to has been cleared (ie. the cookie has passed
most of the way through __fscache_relinquish_cookie()).

Since the netfs holds the index key, we can't get at it once the ->def and
->netfs_data pointers have been cleared - and a NULL pointer exception will
ensue, usually just after a:

	CacheFiles: Error: Unexpected object collision

error is reported.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 25badd1..f4a08d7 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -56,7 +56,7 @@ void __cachefiles_printk_object(struct cachefiles_object *object,
 		       object->fscache.cookie->parent,
 		       object->fscache.cookie->netfs_data,
 		       object->fscache.cookie->flags);
-		if (keybuf)
+		if (keybuf && cookie->def)
 			keylen = cookie->def->get_key(cookie->netfs_data, keybuf,
 						      CACHEFILES_KEYBUF_SIZE);
 		else

