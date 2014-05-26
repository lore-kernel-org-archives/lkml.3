Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaEZNfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 09:35:38 -0400
Received: from numidia.opendz.org ([98.142.220.152]:33079 "EHLO
	numidia.opendz.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaEZNfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 09:35:37 -0400
From: Djalal Harouni <tixxdz@opendz.org>
To: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Djalal Harouni <tixxdz@opendz.org>
Subject: [PATCH 6/9] procfs: add pid_seq_private struct to handle /proc/<pid>/{stat|stack}
Date: Mon, 26 May 2014 14:27:27 +0100
Message-Id: <1401110850-3552-7-git-send-email-tixxdz@opendz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is preparation to handle sensitive ONE entries:
/proc/<pid>/stat
/proc/<pid>/stack

These files use sequence iterators and we want to keep that logic, and
their internal handler semantics.

The sequence iterators stock the inode in the seq_file->private field,
so in order to keep the semantic and to make the cached permission
checks available during ->read(), we add the 'pid_seq_private' struct
that contains both the inode and the cached permission. It will be the
one referenced in the seq_file->private.

This way the internal handlers of /proc/<pid>/{stat|stack} wont change.

Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
---
 fs/proc/internal.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index f5c452c..f28e4f01 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -78,6 +78,17 @@ struct proc_inode {
 	struct inode vfs_inode;
 };
 
+/*
+ * Struct used by some /proc/<pid>/$entries that use sequence
+ * iterators.
+ * This struct will be saved in seq_file->private so seq handlers
+ * can access the inode and the cached permission checks of ->open().
+ */
+struct pid_seq_private {
+	int permitted;
+	struct inode *inode;
+};
+
 typedef int (*proc_read_fn_t)(char *page,
 			      struct task_struct *task, int permitted);
 
-- 
1.7.11.7

