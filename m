Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933Ab3DOCNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:13:36 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:42502 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab3DOCNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:13:35 -0400
From: kpark3469@gmail.com
To: rostedt@goodmis.org
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org,
        kpark3469@gmail.com, mathieu.desnoyers@efficios.com
Subject: [PATCH v3] tracepoints: prevents null probe from being added
Date: Mon, 15 Apr 2013 11:13:15 +0900
Message-Id: <1365991995-19445-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahara <keun-o.park@windriver.com>

Somehow tracepoint_entry_add_probe function allows a null probe function.
And, this may lead to unexpected result since the number of probe
functions in an entry can be counted by checking whether probe is null
or not in for-loop.
This patch prevents the null probe from being added.
In tracepoint_entry_remove_probe function, checking probe parameter
within for-loop is moved out for code efficiency leaving the null probe
feature which removes all probe functions in the entry.

Signed-off-by: Sahara <keun-o.park@windriver.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 kernel/tracepoint.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 0c05a45..29f2654 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -112,7 +112,8 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
 	int nr_probes = 0;
 	struct tracepoint_func *old, *new;
 
-	WARN_ON(!probe);
+	if (WARN_ON(!probe))
+		return ERR_PTR(-EINVAL);
 
 	debug_print_probes(entry);
 	old = entry->funcs;
@@ -152,13 +153,18 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
 
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >= 0) probes */
-	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
-		if (!probe ||
-		    (old[nr_probes].func == probe &&
-		     old[nr_probes].data == data))
-			nr_del++;
+	if (probe) {
+		for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
+			if (old[nr_probes].func == probe &&
+			     old[nr_probes].data == data)
+				nr_del++;
+		}
 	}
 
+	/*
+	 * If probe is NULL, then nr_probes = nr_del = 0, and then the
+	 * entire entry will be removed.
+	 */
 	if (nr_probes - nr_del == 0) {
 		/* N -> 0, (N > 1) */
 		entry->funcs = NULL;
@@ -173,8 +179,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
 		if (new == NULL)
 			return ERR_PTR(-ENOMEM);
 		for (i = 0; old[i].func; i++)
-			if (probe &&
-			    (old[i].func != probe || old[i].data != data))
+			if (old[i].func != probe || old[i].data != data)
 				new[j++] = old[i];
 		new[nr_probes - nr_del].func = NULL;
 		entry->refcount = nr_probes - nr_del;
-- 
1.7.1

