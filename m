Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab3CTDSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 23:18:50 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49983 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967Ab3CTDSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 23:18:40 -0400
From: kpark3469@gmail.com
To: rostedt@goodmis.org
Cc: keun-o.park@windriver.com, linux-kernel@vger.kernel.org,
        kpark3469@gmail.com
Subject: [PATCH] tracepoints: prevents null probe from being added
Date: Wed, 20 Mar 2013 12:18:17 +0900
Message-Id: <1363749497-12176-1-git-send-email-kpark3469@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahara <keun-o.park@windriver.com>

Somehow tracepoint_entry_add/remove_probe functions allow a null probe
function. Especially on getting a null probe in remove function, it seems
to be used to remove all probe functions in the entry.
But, the code is not handled as expected. Since the tracepoint_entry
maintains funcs array's last func as NULL in order to mark it as the end
of the array. Also NULL func is used in for-loop to check out the end of
the loop. So if there's NULL func in the entry's funcs, the for-loop
will be abruptly ended in the middle of operation.
Also checking out if probe is null in for-loop is not efficient.

Signed-off-by: Sahara <keun-o.park@windriver.com>
---
 kernel/tracepoint.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 0c05a45..30f427e 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -112,7 +112,10 @@ tracepoint_entry_add_probe(struct tracepoint_entry *entry,
 	int nr_probes = 0;
 	struct tracepoint_func *old, *new;
 
-	WARN_ON(!probe);
+	if (unlikely(!probe)) {
+		WARN_ON(!probe);
+		return ERR_PTR(-EINVAL);
+	}
 
 	debug_print_probes(entry);
 	old = entry->funcs;
@@ -147,15 +150,19 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
 
 	old = entry->funcs;
 
+	if (unlikely(!probe)) {
+		WARN_ON(!probe);
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (!old)
 		return ERR_PTR(-ENOENT);
 
 	debug_print_probes(entry);
 	/* (N -> M), (N > 1, M >= 0) probes */
 	for (nr_probes = 0; old[nr_probes].func; nr_probes++) {
-		if (!probe ||
-		    (old[nr_probes].func == probe &&
-		     old[nr_probes].data == data))
+		if (old[nr_probes].func == probe &&
+		     old[nr_probes].data == data)
 			nr_del++;
 	}
 
@@ -173,8 +180,7 @@ tracepoint_entry_remove_probe(struct tracepoint_entry *entry,
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

