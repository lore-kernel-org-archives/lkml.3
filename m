Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaAXKVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:21:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1340 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285AbaAXKVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:21:35 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] dcache: fix locking bug in __dentry_path()
Date: Fri, 24 Jan 2014 11:21:26 +0100
Message-Id: <1390558886-4152-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If given buffer size is zero, we forget to rcu_read_unlock()
on error path.

Cc: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 fs/dcache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index cb4a106..24a01fc 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3127,8 +3127,11 @@ restart:
 	end = buf + buflen;
 	len = buflen;
 	prepend(&end, &len, "\0", 1);
-	if (buflen < 1)
+	if (buflen < 1) {
+		if (!(seq & 1))
+			rcu_read_unlock();
 		goto Elong;
+	}
 	/* Get '/' right */
 	retval = end-1;
 	*retval = '/';
-- 
1.8.1.4

