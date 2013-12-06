Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3LFN4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:56:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44011 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab3LFNBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:01:43 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 099/272] ipc, msg: forbid negative values for "msg{max,mnb,mni}"
Date: Fri,  6 Dec 2013 12:56:28 +0000
Message-Id: <1386334761-25517-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 9bf76ca325d5e9208eb343f7bd4cc666f703ed30 upstream.

Negative message lengths make no sense -- so don't do negative queue
lenghts or identifier counts. Prevent them from getting negative.

Also change the underlying data types to be unsigned to avoid hairy
surprises with sign extensions in cases where those variables get
evaluated in unsigned expressions with bigger data types, e.g size_t.

In case a user still wants to have "unlimited" sizes she could just use
INT_MAX instead.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ipc_namespace.h |  6 +++---
 ipc/ipc_sysctl.c              | 20 ++++++++++++--------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
index 19c19a5..f6c82de 100644
--- a/include/linux/ipc_namespace.h
+++ b/include/linux/ipc_namespace.h
@@ -34,9 +34,9 @@ struct ipc_namespace {
 	int		sem_ctls[4];
 	int		used_sems;
 
-	int		msg_ctlmax;
-	int		msg_ctlmnb;
-	int		msg_ctlmni;
+	unsigned int	msg_ctlmax;
+	unsigned int	msg_ctlmnb;
+	unsigned int	msg_ctlmni;
 	atomic_t	msg_bytes;
 	atomic_t	msg_hdrs;
 	int		auto_msgmni;
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 130dfec..b0e99de 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -62,7 +62,7 @@ static int proc_ipc_dointvec_minmax_orphans(ctl_table *table, int write,
 	return err;
 }
 
-static int proc_ipc_callback_dointvec(ctl_table *table, int write,
+static int proc_ipc_callback_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -72,7 +72,7 @@ static int proc_ipc_callback_dointvec(ctl_table *table, int write,
 	memcpy(&ipc_table, table, sizeof(ipc_table));
 	ipc_table.data = get_ipc(table);
 
-	rc = proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
+	rc = proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 
 	if (write && !rc && lenp_bef == *lenp)
 		/*
@@ -152,15 +152,13 @@ static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
 #define proc_ipc_dointvec	   NULL
 #define proc_ipc_dointvec_minmax   NULL
 #define proc_ipc_dointvec_minmax_orphans   NULL
-#define proc_ipc_callback_dointvec NULL
+#define proc_ipc_callback_dointvec_minmax  NULL
 #define proc_ipcauto_dointvec_minmax NULL
 #endif
 
 static int zero;
 static int one = 1;
-#ifdef CONFIG_CHECKPOINT_RESTORE
 static int int_max = INT_MAX;
-#endif
 
 static struct ctl_table ipc_kern_table[] = {
 	{
@@ -198,21 +196,27 @@ static struct ctl_table ipc_kern_table[] = {
 		.data		= &init_ipc_ns.msg_ctlmax,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
 		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec,
+		.proc_handler	= proc_ipc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &int_max,
 	},
 	{
 		.procname	= "msgmni",
 		.data		= &init_ipc_ns.msg_ctlmni,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
-		.proc_handler	= proc_ipc_callback_dointvec,
+		.proc_handler	= proc_ipc_callback_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &int_max,
 	},
 	{
 		.procname	=  "msgmnb",
 		.data		= &init_ipc_ns.msg_ctlmnb,
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
 		.mode		= 0644,
-		.proc_handler	= proc_ipc_dointvec,
+		.proc_handler	= proc_ipc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &int_max,
 	},
 	{
 		.procname	= "sem",
-- 
1.8.3.2

