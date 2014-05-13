Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbaEMU2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 16:28:31 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:49080 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaEMU1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 16:27:48 -0400
From: Davidlohr Bueso <davidlohr@hp.com>
To: manfred@colorfullife.com, akpm@linux-foundation.org
Cc: davidlohr@hp.com, aswin@hp.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ipc,msg: move some msgq ns code around
Date: Tue, 13 May 2014 13:27:34 -0700
Message-Id: <1400012857-11733-3-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing big and no logical changes, just get rid of some
redundant function declarations. Move msg_[init/exit]_ns
down the end of the file.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 ipc/msg.c | 132 ++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 63 insertions(+), 69 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 5a8489b..6d33e30 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -70,75 +70,6 @@ struct msg_sender {
 
 #define msg_ids(ns)	((ns)->ids[IPC_MSG_IDS])
 
-static void freeque(struct ipc_namespace *, struct kern_ipc_perm *);
-static int newque(struct ipc_namespace *, struct ipc_params *);
-#ifdef CONFIG_PROC_FS
-static int sysvipc_msg_proc_show(struct seq_file *s, void *it);
-#endif
-
-/*
- * Scale msgmni with the available lowmem size: the memory dedicated to msg
- * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
- * Also take into account the number of nsproxies created so far.
- * This should be done staying within the (MSGMNI , IPCMNI/nr_ipc_ns) range.
- */
-void recompute_msgmni(struct ipc_namespace *ns)
-{
-	struct sysinfo i;
-	unsigned long allowed;
-	int nb_ns;
-
-	si_meminfo(&i);
-	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
-		/ MSGMNB;
-	nb_ns = atomic_read(&nr_ipc_ns);
-	allowed /= nb_ns;
-
-	if (allowed < MSGMNI) {
-		ns->msg_ctlmni = MSGMNI;
-		return;
-	}
-
-	if (allowed > IPCMNI / nb_ns) {
-		ns->msg_ctlmni = IPCMNI / nb_ns;
-		return;
-	}
-
-	ns->msg_ctlmni = allowed;
-}
-
-void msg_init_ns(struct ipc_namespace *ns)
-{
-	ns->msg_ctlmax = MSGMAX;
-	ns->msg_ctlmnb = MSGMNB;
-
-	recompute_msgmni(ns);
-
-	atomic_set(&ns->msg_bytes, 0);
-	atomic_set(&ns->msg_hdrs, 0);
-	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
-}
-
-#ifdef CONFIG_IPC_NS
-void msg_exit_ns(struct ipc_namespace *ns)
-{
-	free_ipcs(ns, &msg_ids(ns), freeque);
-	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
-}
-#endif
-
-void __init msg_init(void)
-{
-	msg_init_ns(&init_ipc_ns);
-
-	printk(KERN_INFO "msgmni has been set to %d\n",
-		init_ipc_ns.msg_ctlmni);
-
-	ipc_init_proc_interface("sysvipc/msg",
-				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
-				IPC_MSG_IDS, sysvipc_msg_proc_show);
-}
-
 static inline struct msg_queue *msq_obtain_object(struct ipc_namespace *ns, int id)
 {
 	struct kern_ipc_perm *ipcp = ipc_obtain_object(&msg_ids(ns), id);
@@ -1054,6 +985,57 @@ SYSCALL_DEFINE5(msgrcv, int, msqid, struct msgbuf __user *, msgp, size_t, msgsz,
 	return do_msgrcv(msqid, msgp, msgsz, msgtyp, msgflg, do_msg_fill);
 }
 
+/*
+ * Scale msgmni with the available lowmem size: the memory dedicated to msg
+ * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
+ * Also take into account the number of nsproxies created so far.
+ * This should be done staying within the (MSGMNI , IPCMNI/nr_ipc_ns) range.
+ */
+void recompute_msgmni(struct ipc_namespace *ns)
+{
+	struct sysinfo i;
+	unsigned long allowed;
+	int nb_ns;
+
+	si_meminfo(&i);
+	allowed = (((i.totalram - i.totalhigh) / MSG_MEM_SCALE) * i.mem_unit)
+		/ MSGMNB;
+	nb_ns = atomic_read(&nr_ipc_ns);
+	allowed /= nb_ns;
+
+	if (allowed < MSGMNI) {
+		ns->msg_ctlmni = MSGMNI;
+		return;
+	}
+
+	if (allowed > IPCMNI / nb_ns) {
+		ns->msg_ctlmni = IPCMNI / nb_ns;
+		return;
+	}
+
+	ns->msg_ctlmni = allowed;
+}
+
+void msg_init_ns(struct ipc_namespace *ns)
+{
+	ns->msg_ctlmax = MSGMAX;
+	ns->msg_ctlmnb = MSGMNB;
+
+	recompute_msgmni(ns);
+
+	atomic_set(&ns->msg_bytes, 0);
+	atomic_set(&ns->msg_hdrs, 0);
+	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
+}
+
+#ifdef CONFIG_IPC_NS
+void msg_exit_ns(struct ipc_namespace *ns)
+{
+	free_ipcs(ns, &msg_ids(ns), freeque);
+	idr_destroy(&ns->ids[IPC_MSG_IDS].ipcs_idr);
+}
+#endif
+
 #ifdef CONFIG_PROC_FS
 static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 {
@@ -1078,3 +1060,15 @@ static int sysvipc_msg_proc_show(struct seq_file *s, void *it)
 			msq->q_ctime);
 }
 #endif
+
+void __init msg_init(void)
+{
+	msg_init_ns(&init_ipc_ns);
+
+	printk(KERN_INFO "msgmni has been set to %d\n",
+		init_ipc_ns.msg_ctlmni);
+
+	ipc_init_proc_interface("sysvipc/msg",
+				"       key      msqid perms      cbytes       qnum lspid lrpid   uid   gid  cuid  cgid      stime      rtime      ctime\n",
+				IPC_MSG_IDS, sysvipc_msg_proc_show);
+}
-- 
1.8.1.4

