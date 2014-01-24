Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaAXMSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:18:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaAXMSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:18:03 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] dcache: error out on failures to store terminating NUL
Date: Fri, 24 Jan 2014 13:17:46 +0100
Message-Id: <1390565866-30868-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of routines wasn't checking that the initial call
to prepend "\0" to result buffer doesn't fail.

Coredump code was seeing d_path() with zero-sized buffer
to erroneously return bogus data (non-error pointer
pointing before buffer start).

Users report that this change fixes it.

Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 fs/dcache.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 24a01fc..93f651b 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2974,7 +2974,9 @@ char *__d_path(const struct path *path,
 	char *res = buf + buflen;
 	int error;
 
-	prepend(&res, &buflen, "\0", 1);
+	error = prepend(&res, &buflen, "\0", 1);
+	if (error)
+		return ERR_PTR(error);
 	error = prepend_path(path, root, &res, &buflen);
 
 	if (error < 0)
@@ -2991,7 +2993,9 @@ char *d_absolute_path(const struct path *path,
 	char *res = buf + buflen;
 	int error;
 
-	prepend(&res, &buflen, "\0", 1);
+	error = prepend(&res, &buflen, "\0", 1);
+	if (error)
+		return ERR_PTR(error);
 	error = prepend_path(path, &root, &res, &buflen);
 
 	if (error > 1)
@@ -3008,7 +3012,11 @@ static int path_with_deleted(const struct path *path,
 			     const struct path *root,
 			     char **buf, int *buflen)
 {
-	prepend(buf, buflen, "\0", 1);
+	int error;
+
+	error = prepend(buf, buflen, "\0", 1);
+	if (error)
+		return error;
 	if (d_unlinked(path->dentry)) {
 		int error = prepend(buf, buflen, " (deleted)", 10);
 		if (error)
@@ -3126,12 +3134,12 @@ static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 restart:
 	end = buf + buflen;
 	len = buflen;
-	prepend(&end, &len, "\0", 1);
 	if (buflen < 1) {
 		if (!(seq & 1))
 			rcu_read_unlock();
 		goto Elong;
 	}
+	prepend(&end, &len, "\0", 1);
 	/* Get '/' right */
 	retval = end-1;
 	*retval = '/';
@@ -3235,8 +3243,9 @@ SYSCALL_DEFINE2(getcwd, char __user *, buf, unsigned long, size)
 		char *cwd = page + PATH_MAX;
 		int buflen = PATH_MAX;
 
-		prepend(&cwd, &buflen, "\0", 1);
-		error = prepend_path(&pwd, &root, &cwd, &buflen);
+		error = prepend(&cwd, &buflen, "\0", 1);
+		if (!error)
+			error = prepend_path(&pwd, &root, &cwd, &buflen);
 		rcu_read_unlock();
 
 		if (error < 0)
-- 
1.8.1.4

