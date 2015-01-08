Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbbAHQur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:50:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571AbbAHQup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:50:45 -0500
Subject: [RFC PATCH 3/5] audit: enable filename recording via
 getname_kernel()
From: Paul Moore <pmoore@redhat.com>
To: linux-audit@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 08 Jan 2015 11:50:43 -0500
Message-ID: <20150108165043.11316.28694.stgit@localhost>
In-Reply-To: <20150108164514.11316.85331.stgit@localhost>
References: <20150108164514.11316.85331.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable recording of filenames in getname_kernel() and remove the
kludgy workaround in __audit_inode() now that we have proper filename
logging for kernel users.

Signed-off-by: Paul Moore <pmoore@redhat.com>
---
 fs/namei.c       |    1 +
 kernel/auditsc.c |   40 +++-------------------------------------
 2 files changed, 4 insertions(+), 37 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c3d21b7..1c0d4c7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -242,6 +242,7 @@ getname_kernel(const char * filename)
 	strlcpy((char *)result->name, filename, len);
 	result->uptr = NULL;
 	result->aname = NULL;
+	audit_getname(result);
 
 	return result;
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 793e9e9..c967ffc 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1882,44 +1882,10 @@ out_alloc:
 	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
 	if (!n)
 		return;
-	/* unfortunately, while we may have a path name to record with the
-	 * inode, we can't always rely on the string lasting until the end of
-	 * the syscall so we need to create our own copy, it may fail due to
-	 * memory allocation issues, but we do our best */
-	if (name) {
-		/* we can't use getname_kernel() due to size limits */
-		size_t len = strlen(name->name) + 1;
-		struct filename *new = __getname();
-
-		if (unlikely(!new))
-			goto out;
+	if (name)
+		/* no need to set ->name_put as the original will cleanup */
+		n->name = name;
 
-		if (len <= (PATH_MAX - sizeof(*new))) {
-			new->name = (char *)(new) + sizeof(*new);
-			new->separate = false;
-		} else if (len <= PATH_MAX) {
-			/* this looks odd, but is due to final_putname() */
-			struct filename *new2;
-
-			new2 = kmalloc(sizeof(*new2), GFP_KERNEL);
-			if (unlikely(!new2)) {
-				__putname(new);
-				goto out;
-			}
-			new2->name = (char *)new;
-			new2->separate = true;
-			new = new2;
-		} else {
-			/* we should never get here, but let's be safe */
-			__putname(new);
-			goto out;
-		}
-		strlcpy((char *)new->name, name->name, len);
-		new->uptr = NULL;
-		new->aname = n;
-		n->name = new;
-		n->name_put = true;
-	}
 out:
 	if (parent) {
 		n->name_len = n->name ? parent_len(n->name->name) : AUDIT_NAME_FULL;

