Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667AbbAVFAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:00:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbbAVFAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:00:06 -0500
Subject: [PATCH v2 1/5] fs: rework getname_kernel to handle up to PATH_MAX
 sized filenames
From: Paul Moore <pmoore@redhat.com>
To: linux-fsdevel@vger.kernel.org, linux-audit@redhat.com
Cc: rgb@redhat.com, sd@queasysnail.net, linux-kernel@vger.kernel.org,
        linux@roeck-us.net, viro@zeniv.linux.org.uk
Date: Wed, 21 Jan 2015 23:59:56 -0500
Message-ID: <20150122045956.1347.11508.stgit@localhost>
In-Reply-To: <20150122045303.1347.98054.stgit@localhost>
References: <20150122045303.1347.98054.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for expanded use in the kernel, make getname_kernel()
more useful by allowing it to handle any legal filename length.

Thanks to Guenter Roeck for his suggestion to substitute memcpy() for
strlcpy().

CC: linux@roeck-us.net
CC: viro@zeniv.linux.org.uk
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Paul Moore <pmoore@redhat.com>
---
 fs/namei.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 9eb787e..63eaaf6 100644
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
+	memcpy((char *)result->name, filename, len);
 	result->uptr = NULL;
 	result->aname = NULL;
-	result->separate = false;
 
-	strlcpy(kname, filename, EMBEDDED_NAME_MAX);
 	return result;
 }
 

