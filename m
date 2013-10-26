Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab3JZCdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 22:33:24 -0400
Received: from fifo99.com ([67.223.236.141]:60921 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244Ab3JZCdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 22:33:23 -0400
From: Daniel Walker <dwalker@fifo99.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fs: libfs: remove calls to simple_strtoll
Date: Fri, 25 Oct 2013 19:33:11 -0700
Message-Id: <1382754793-8827-1-git-send-email-dwalker@fifo99.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@fifo99.com>
---
 fs/libfs.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 8c50184..0467f6e 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -845,10 +845,13 @@ ssize_t simple_attr_write(struct file *file, const char __user *buf,
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	val = simple_strtoll(attr->set_buf, NULL, 0);
-	ret = attr->set(attr->data, val);
-	if (ret == 0)
-		ret = len; /* on success, claim we got the whole input */
+	ret = kstrtoll(attr->set_buf, 0, &val);
+	if (ret == 0) {
+		ret = attr->set(attr->data, val);
+		if (ret == 0)
+			/* on success, claim we got the whole input */
+			ret = len;
+	}
 out:
 	mutex_unlock(&attr->mutex);
 	return ret;
-- 
1.8.3.2

