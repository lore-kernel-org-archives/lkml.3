Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3DLRMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831Ab3DLRMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:12:47 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] audit: fix build break when AUDIT_DEBUG == 2
Date: Fri, 12 Apr 2013 13:12:46 -0400
Message-Id: <1365786766-7029-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like this one has been around since 5195d8e21:

    kernel/auditsc.c: In function ‘audit_free_names’:
    kernel/auditsc.c:998: error: ‘i’ undeclared (first use in this function)

...and this warning:

    kernel/auditsc.c: In function ‘audit_putname’:
    kernel/auditsc.c:2045: warning: ‘i’ may be used uninitialized in this function

Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 kernel/auditsc.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a371f85..4083b69 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -987,6 +987,8 @@ static inline void audit_free_names(struct audit_context *context)
 
 #if AUDIT_DEBUG == 2
 	if (context->put_count + context->ino_count != context->name_count) {
+		int i = 0;
+
 		printk(KERN_ERR "%s:%d(:%d): major=%d in_syscall=%d"
 		       " name_count=%d put_count=%d"
 		       " ino_count=%d [NOT freeing]\n",
@@ -995,7 +997,7 @@ static inline void audit_free_names(struct audit_context *context)
 		       context->name_count, context->put_count,
 		       context->ino_count);
 		list_for_each_entry(n, &context->names_list, list) {
-			printk(KERN_ERR "names[%d] = %p = %s\n", i,
+			printk(KERN_ERR "names[%d] = %p = %s\n", i++,
 			       n->name, n->name->name ?: "(null)");
 		}
 		dump_stack();
@@ -2040,10 +2042,10 @@ void audit_putname(struct filename *name)
 		       __FILE__, __LINE__, context->serial, name);
 		if (context->name_count) {
 			struct audit_names *n;
-			int i;
+			int i = 0;
 
 			list_for_each_entry(n, &context->names_list, list)
-				printk(KERN_ERR "name[%d] = %p = %s\n", i,
+				printk(KERN_ERR "name[%d] = %p = %s\n", i++,
 				       n->name, n->name->name ?: "(null)");
 			}
 #endif
-- 
1.7.1

