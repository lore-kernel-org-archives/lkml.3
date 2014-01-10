Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbaAJSs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:48:59 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:45951 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaAJSsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:48:45 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: akpm@linux-foundation.org, manfred@colorfullife.com
Cc: riel@redhat.com, aswin@hp.com, davidlohr@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] ipc: delete seq_max field in struct ipc_ids
Date: Fri, 10 Jan 2014 10:48:25 -0800
Message-Id: <1389379707-20298-6-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
References: <1389379707-20298-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This field is only used to reset the ids seq number if it exceeds the smaller of
INT_MAX/SEQ_MULTIPLIER and USHRT_MAX, and can therefore be moved out of the
structure and into its own macro. Since each ipc_namespace contains a table of
3 pointers to struct ipc_ids we can save space in instruction text:

   text    data     bss     dec     hex filename
  56232    2348      24   58604    e4ec ipc/built-in.o
  56216    2348      24   58588    e4dc ipc/built-in.o-after

Reviewed-by: Jonathan Gonzalez <jgonzalez@linets.cl>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 include/linux/ipc_namespace.h |  1 -
 ipc/util.c                    | 13 ++-----------
 ipc/util.h                    |  1 +
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index f6c82de..e7831d2 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -21,7 +21,6 @@ struct user_namespace;
 struct ipc_ids {
 	int in_use;
 	unsigned short seq;
-	unsigned short seq_max;
 	struct rw_semaphore rwsem;
 	struct idr ipcs_idr;
 	int next_id;
diff --git a/ipc/util.c b/ipc/util.c
index cecb46e..e1b4c6d 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -139,19 +139,10 @@ __initcall(ipc_init);
  */
 void ipc_init_ids(struct ipc_ids *ids)
 {
-	init_rwsem(&ids->rwsem);
-
 	ids->in_use = 0;
 	ids->seq = 0;
 	ids->next_id = -1;
-	{
-		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
-		if (seq_limit > USHRT_MAX)
-			ids->seq_max = USHRT_MAX;
-		 else
-			ids->seq_max = seq_limit;
-	}
-
+	init_rwsem(&ids->rwsem);
 	idr_init(&ids->ipcs_idr);
 }
 
@@ -304,7 +295,7 @@ int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int size)
 
 	if (next_id < 0) {
 		new->seq = ids->seq++;
-		if (ids->seq > ids->seq_max)
+		if (ids->seq > IPCID_SEQ_MAX)
 			ids->seq = 0;
 	} else {
 		new->seq = ipcid_to_seqx(next_id);
diff --git a/ipc/util.h b/ipc/util.h
index d64db3e..9c47d6f 100644
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -100,6 +100,7 @@ void __init ipc_init_proc_interface(const char *path, const char *header,
 
 #define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
 #define ipcid_to_seqx(id) ((id) / SEQ_MULTIPLIER)
+#define IPCID_SEQ_MAX min_t(int, INT_MAX/SEQ_MULTIPLIER, USHRT_MAX)
 
 /* must be called with ids->rwsem acquired for writing */
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
-- 
1.8.1.4

