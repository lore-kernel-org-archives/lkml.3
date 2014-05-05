Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357AbaEEMnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:43:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40969 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932155AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 10/50] __dentry_path() fixes
Date: Mon,  5 May 2014 14:42:52 +0200
Message-Id: <aeaf64c5a760c88e7af7b316536980d41bf312cf.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f6500801522c61782d4990fa1ad96154cb397cd4 upstream.

* we need to save the starting point for restarts
* reject pathologically short buffers outright

Spotted-by: Denys Vlasenko <dvlasenk@redhat.com>
Spotted-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/dcache.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 008f524e195a..8ef74f3d8fe5 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3122,19 +3122,22 @@ char *simple_dname(struct dentry *dentry, char *buffer, int buflen)
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
1.9.2

