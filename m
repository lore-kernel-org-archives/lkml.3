Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab3LBVOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:14:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3LBTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 042/173] ipc, msg: forbid negative values for "msg{max,mnb,mni}"
Date: Mon,  2 Dec 2013 11:10:25 -0800
Message-Id: <20131202191147.502624518@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/ipc_namespace.h |    6 +++---
 ipc/ipc_sysctl.c              |   20 ++++++++++++--------
 2 files changed, 15 insertions(+), 11 deletions(-)

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
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -62,7 +62,7 @@ static int proc_ipc_dointvec_minmax_orph
 	return err;
 }
 
-static int proc_ipc_callback_dointvec(ctl_table *table, int write,
+static int proc_ipc_callback_dointvec_minmax(ctl_table *table, int write,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table ipc_table;
@@ -72,7 +72,7 @@ static int proc_ipc_callback_dointvec(ct
 	memcpy(&ipc_table, table, sizeof(ipc_table));
 	ipc_table.data = get_ipc(table);
 
-	rc = proc_dointvec(&ipc_table, write, buffer, lenp, ppos);
+	rc = proc_dointvec_minmax(&ipc_table, write, buffer, lenp, ppos);
 
 	if (write && !rc && lenp_bef == *lenp)
 		/*
@@ -152,15 +152,13 @@ static int proc_ipcauto_dointvec_minmax(
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
@@ -198,21 +196,27 @@ static struct ctl_table ipc_kern_table[]
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


