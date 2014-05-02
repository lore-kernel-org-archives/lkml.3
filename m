Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaEBQZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:25:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaEBPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Mikulas Patocka <mpatocka@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 003/151] __dentry_path() fixes
Date: Fri,  2 May 2014 08:36:31 -0700
Message-Id: <1399045139-4531-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit f6500801522c61782d4990fa1ad96154cb397cd4 upstream.

* we need to save the starting point for restarts
* reject pathologically short buffers outright

Spotted-by: Denys Vlasenko <dvlasenk@redhat.com>
Spotted-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/dcache.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index f7ad6d7..ca02c13 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3116,19 +3116,22 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
 /*
  * Write full pathname from the root of the filesystem into the buffer.
  */
-static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
+static char *__dentry_path(struct dentry *d, char *buf, int buflen)
 {
+	struct dentry *dentry;
 	char *end, *retval;
 	int len, seq = 0;
 	int error = 0;
 
+	if (buflen < 2)
+		goto Elong;
+
 	rcu_read_lock();
 restart:
+	dentry = d;
 	end = buf + buflen;
 	len = buflen;
 	prepend(&end, &len, "\0", 1);
-	if (buflen < 1)
-		goto Elong;
 	/* Get '/' right */
 	retval = end-1;
 	*retval = '/';
-- 
1.9.1

