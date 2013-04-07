Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab3DGKSD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 06:18:03 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:60160 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933115Ab3DGKSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 06:18:01 -0400
Message-ID: <1365329658.27045.6.camel@beeld>
Subject: [PATCH] auditsc: Use kzalloc instead of kmalloc+memset.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 07 Apr 2013 16:14:18 +0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  In function audit_alloc_context(), use kzalloc, instead of kmalloc+memset. Patch also renames audit_zero_context() to 
audit_set_context(), to represent it's inner workings properly.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index a371f85..f5b6dc5 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1034,10 +1034,9 @@ static inline void audit_free_aux(struct audit_context *context)
 	}
 }
 
-static inline void audit_zero_context(struct audit_context *context,
+static inline void audit_set_context(struct audit_context *context,
 				      enum audit_state state)
 {
-	memset(context, 0, sizeof(*context));
 	context->state      = state;
 	context->prio = state == AUDIT_RECORD_CONTEXT ? ~0ULL : 0;
 }
@@ -1046,9 +1045,10 @@ static inline struct audit_context *audit_alloc_context(enum audit_state state)
 {
 	struct audit_context *context;
 
-	if (!(context = kmalloc(sizeof(*context), GFP_KERNEL)))
+	context = kzalloc(sizeof(*context), GFP_KERNEL);
+	if (!context)
 		return NULL;
-	audit_zero_context(context, state);
+	audit_set_context(context, state);
 	INIT_LIST_HEAD(&context->killed_trees);
 	INIT_LIST_HEAD(&context->names_list);
 	return context;


