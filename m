Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaLaPos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:44:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaLaPor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:44:47 -0500
Subject: [PATCH] audit: create private file name copies when auditing inodes
From: Paul Moore <pmoore@redhat.com>
To: linux-audit@redhat.com
Cc: toralf.foerster@gmx.de, linux-kernel@vger.kernel.org
Date: Wed, 31 Dec 2014 10:44:38 -0500
Message-ID: <20141231154438.11821.29823.stgit@localhost>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, while commit 4a928436 ("audit: correctly record file
names with different path name types") fixed a problem where we were
not recording filenames, it created a new problem by attempting to use
these file names after they had been freed.  This patch resolves the
issue by creating a copy of the filename which the audit subsystem
frees after it is done with the string.

At some point it would be nice to resolve this issue with refcounts,
or something similar, instead of having to allocate/copy strings, but
that is almost surely beyond the scope of a -rcX patch so we'll defer
that for later.  On the plus side, only audit users should be impacted
by the string copying.

Reported-by: Toralf Foerster <toralf.foerster@gmx.de>
Signed-off-by: Paul Moore <pmoore@redhat.com>
---
 kernel/auditsc.c |   49 ++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 287b3d3..793e9e9 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -72,6 +72,8 @@
 #include <linux/fs_struct.h>
 #include <linux/compat.h>
 #include <linux/ctype.h>
+#include <linux/string.h>
+#include <uapi/linux/limits.h>
 
 #include "audit.h"
 
@@ -1861,8 +1863,7 @@ void __audit_inode(struct filename *name, const struct dentry *dentry,
 	}
 
 	list_for_each_entry_reverse(n, &context->names_list, list) {
-		/* does the name pointer match? */
-		if (!n->name || n->name->name != name->name)
+		if (!n->name || strcmp(n->name->name, name->name))
 			continue;
 
 		/* match the correct record type */
@@ -1881,14 +1882,44 @@ out_alloc:
 	n = audit_alloc_name(context, AUDIT_TYPE_UNKNOWN);
 	if (!n)
 		return;
-	if (name)
-		/* since name is not NULL we know there is already a matching
-		 * name record, see audit_getname(), so there must be a type
-		 * mismatch; reuse the string path since the original name
-		 * record will keep the string valid until we free it in
-		 * audit_free_names() */
-		n->name = name;
+	/* unfortunately, while we may have a path name to record with the
+	 * inode, we can't always rely on the string lasting until the end of
+	 * the syscall so we need to create our own copy, it may fail due to
+	 * memory allocation issues, but we do our best */
+	if (name) {
+		/* we can't use getname_kernel() due to size limits */
+		size_t len = strlen(name->name) + 1;
+		struct filename *new = __getname();
+
+		if (unlikely(!new))
+			goto out;
+
+		if (len <= (PATH_MAX - sizeof(*new))) {
+			new->name = (char *)(new) + sizeof(*new);
+			new->separate = false;
+		} else if (len <= PATH_MAX) {
+			/* this looks odd, but is due to final_putname() */
+			struct filename *new2;
 
+			new2 = kmalloc(sizeof(*new2), GFP_KERNEL);
+			if (unlikely(!new2)) {
+				__putname(new);
+				goto out;
+			}
+			new2->name = (char *)new;
+			new2->separate = true;
+			new = new2;
+		} else {
+			/* we should never get here, but let's be safe */
+			__putname(new);
+			goto out;
+		}
+		strlcpy((char *)new->name, name->name, len);
+		new->uptr = NULL;
+		new->aname = n;
+		n->name = new;
+		n->name_put = true;
+	}
 out:
 	if (parent) {
 		n->name_len = n->name ? parent_len(n->name->name) : AUDIT_NAME_FULL;

