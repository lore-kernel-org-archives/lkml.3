Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab3EZC6Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 22:58:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:55981 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497Ab3EZC6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 22:58:20 -0400
From: Stephen Mell <sub.atomic.fusion@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: proc: add nsfd mount option to allow mounting for pid namespaces other than the current
Date: Sun, 26 May 2013 03:00:05 +0000
Message-ID: <1823955.4fAi8iUinf@pegasus>
User-Agent: KMail/4.9.5 (Linux/3.9.3; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Mell <sub.atomic.fusion@gmail.com>

Currently, there is no userspace method to mount proc for a pid namespace other than the current one. In light of the new namespace filedescriptors, this patch adds a mount option to use the namespace represented by the specified filedescriptor instead of the current pid namespace. This patch depends on "proc: move proc mount options out of pid_namespace".

Signed-off-by: Stephen Mell <sub.atomic.fusion@gmail.com>
---
 fs/proc/root.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 5a2b6ff..6a9a46d 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -39,10 +39,11 @@ static int proc_set_super(struct super_block *sb, void *data)
 }
 
 enum {
-	Opt_gid, Opt_hidepid, Opt_err,
+	Opt_nsfd, Opt_gid, Opt_hidepid, Opt_err,
 };
 
 static const match_table_t tokens = {
+	{Opt_nsfd, "nsfd=%u"},
 	{Opt_hidepid, "hidepid=%u"},
 	{Opt_gid, "gid=%u"},
 	{Opt_err, NULL},
@@ -53,6 +54,8 @@ static int proc_parse_options(char *options, struct proc_sb_info *fsi)
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	int option;
+	struct proc_ns *ei;
+	struct file *file;
 
 	if (!options)
 		return 1;
@@ -65,6 +68,24 @@ static int proc_parse_options(char *options, struct proc_sb_info *fsi)
 		args[0].to = args[0].from = NULL;
 		token = match_token(p, tokens, args);
 		switch (token) {
+		case Opt_nsfd:
+			if (match_int(&args[0], &option))
+				return 0;
+			file = proc_ns_fget(option);
+			if (IS_ERR(file)) {
+				pr_err("proc: nsfd value must refer to a pid namespace.\n");
+				return 0;
+			}
+			ei = get_proc_ns(file_inode(file));
+			if (!(ei->ns_ops->type & CLONE_NEWPID)) {
+				pr_err("proc: nsfd value must refer to a pid namespace.\n");
+				return 0;
+			}
+			if (fsi->ns)
+				put_pid_ns(fsi->ns);
+			fsi->ns = ei->ns;
+			get_pid_ns(fsi->ns);
+			break;
 		case Opt_gid:
 			if (match_int(&args[0], &option))
 				return 0;

