Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3KCLhS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 06:37:18 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52920 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3KCLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 06:36:47 -0500
From: Mathias Krause <minipli@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Pax Team <pageexec@freemail.hu>,
        Brad Spengler <spender@grsecurity.net>, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCHv2 2/2] ipc, msg: forbid negative values for "msg{max,mnb,mni}"
Date: Sun,  3 Nov 2013 12:36:28 +0100
Message-Id: <1383478588-7011-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1383478588-7011-1-git-send-email-minipli@googlemail.com>
References: <CA+55aFxeGaZjWM37e4p1tAhjwocpv0_iU0jTYUfaAFagvCBxmQ@mail.gmail.com>
 <1383478588-7011-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Negative message lengths make no sense -- so don't do negative queue
lenghts or identifier counts. Prevent them from getting negative.

Also change the underlying data types to be unsigned to avoid harry
surprises with sign extensions in cases where those variables get
evaluated in unsigned expressions with bigger data types, e.g size_t.

In case a user still wants to have "unlimited" sizes she could just use
INT_MAX instead.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
v2:
 - handle msgmnb and msgmni, too
 - make the underlying variables unsigned, as per Linus

 include/linux/ipc_namespace.h |    6 +++---
 ipc/ipc_sysctl.c              |   20 ++++++++++++--------
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
1.7.10.4

