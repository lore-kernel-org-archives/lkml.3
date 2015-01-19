Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbbASUII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 15:08:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844AbbASUID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 15:08:03 -0500
Subject: [PATCH 1/5] fs: rework getname_kernel to handle up to PATH_MAX
 sized filenames
From: Paul Moore <pmoore@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Mon, 19 Jan 2015 15:08:01 -0500
Message-ID: <20150119200801.29706.41796.stgit@localhost>
In-Reply-To: <20150119200408.29706.24386.stgit@localhost>
References: <20150119200408.29706.24386.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for expanded use in the kernel, make getname_kernel()
more useful by allowing it to handle any legal filename length.

CC: viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Paul Moore <pmoore@redhat.com>
Reviewed-by: Richard Guy Briggs <rgb@redhat.com>
---
 fs/namei.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9eb787e..eeb3b83 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -211,32 +211,38 @@ getname(const char __user * filename)
 	return getname_flags(filename, 0, NULL);
 }
 
-/*
- * The "getname_kernel()" interface doesn't do pathnames longer
- * than EMBEDDED_NAME_MAX. Deal with it - you're a kernel user.
- */
 struct filename *
 getname_kernel(const char * filename)
 {
 	struct filename *result;
-	char *kname;
-	int len;
-
-	len = strlen(filename);
-	if (len >= EMBEDDED_NAME_MAX)
-		return ERR_PTR(-ENAMETOOLONG);
+	int len = strlen(filename) + 1;
 
 	result = __getname();
 	if (unlikely(!result))
 		return ERR_PTR(-ENOMEM);
 
-	kname = (char *)result + sizeof(*result);
-	result->name = kname;
+	if (len <= EMBEDDED_NAME_MAX) {
+		result->name = (char *)(result) + sizeof(*result);
+		result->separate = false;
+	} else if (len <= PATH_MAX) {
+		struct filename *tmp;
+
+		tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+		if (unlikely(!tmp)) {
+			__putname(result);
+			return ERR_PTR(-ENOMEM);
+		}
+		tmp->name = (char *)result;
+		tmp->separate = true;
+		result = tmp;
+	} else {
+		__putname(result);
+		return ERR_PTR(-ENAMETOOLONG);
+	}
+	strlcpy((char *)result->name, filename, len);
 	result->uptr = NULL;
 	result->aname = NULL;
-	result->separate = false;
 
-	strlcpy(kname, filename, EMBEDDED_NAME_MAX);
 	return result;
 }
 

