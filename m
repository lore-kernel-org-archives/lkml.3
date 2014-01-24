Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbaAXOFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 09:05:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752445AbaAXOFH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 09:05:07 -0500
From: Denys Vlasenko <dvlasenk@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] dcache: error out if the name buffer is too short
Date: Fri, 24 Jan 2014 15:04:59 +0100
Message-Id: <1390572299-3074-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change makes __dentry_path() and d_path()
immediately return ENAMETOOLONG if buflen < 2.

Cc: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
---
 fs/dcache.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index cb4a106..2fba276 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3055,6 +3055,9 @@ char *d_path(const struct path *path, char *buf, int buflen)
 	struct path root;
 	int error;
 
+	if (buflen < 2)
+		return ERR_PTR(-ENAMETOOLONG);
+
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
 	 * these filesystems dentries are never used for lookup purposes, and
@@ -3122,13 +3125,14 @@ static char *__dentry_path(struct dentry *dentry, char *buf, int buflen)
 	int len, seq = 0;
 	int error = 0;
 
+	if (buflen < 2)
+		goto Elong;
+
 	rcu_read_lock();
 restart:
 	end = buf + buflen;
 	len = buflen;
 	prepend(&end, &len, "\0", 1);
-	if (buflen < 1)
-		goto Elong;
 	/* Get '/' right */
 	retval = end-1;
 	*retval = '/';
-- 
1.8.1.4

