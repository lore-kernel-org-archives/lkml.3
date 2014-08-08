Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbaHHTA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 15:00:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaHHTAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 15:00:20 -0400
Date: Fri, 8 Aug 2014 20:57:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/5] proc: introduce pid_entry_name()
Message-ID: <20140808185759.GA791@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808185732.GA760@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, this is ugly. I think we should simply export struct pid_entry,
or make is_tgid_pid_entry/pid_entry_name "struct inode *". Or something
else. Lets discuss this later.

See the next patch which explains why.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c     |    7 +++++++
 fs/proc/internal.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 368f6fe..81d372c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2992,6 +2992,13 @@ bool is_tgid_pid_entry(const struct pid_entry *p)
 	BUG();
 }
 
+// THIS IS UGLY, JUST TO DISCUSS RFC
+const char *pid_entry_name(const struct pid_entry *p)
+{
+	is_tgid_pid_entry(p);	// trigger BUG_ON() if not valid
+	return p->name;
+}
+
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
 {
 	return proc_pident_readdir(file, ctx,
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 46500af..c162db2 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -150,6 +150,7 @@ out:
 extern const struct file_operations proc_tid_children_operations;
 
 extern bool is_tgid_pid_entry(const struct pid_entry *p);
+extern const char *pid_entry_name(const struct pid_entry *p);
 
 extern int proc_pid_stat(struct seq_file *, struct pid_namespace *,
 			 struct pid *, struct task_struct *);
-- 
1.5.5.1

