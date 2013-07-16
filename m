Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933724Ab3GPTC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 15:02:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab3GPTC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 15:02:27 -0400
Date: Tue, 16 Jul 2013 20:57:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/4] tracing: Change remove_event_from_tracers() to
	clear d_subdirs->i_private
Message-ID: <20130716185720.GA21189@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130716185658.GA21167@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparation to make the next patches more understandable.

The caller of trace_remove_event_call() is going to free call/files,
this means that every opened id/filter/enable/format file will use
the already freed memory via filp->private_data / inode->i_private.

Change remove_event_from_tracers() to clear ->i_private for every
child. This fixes nothing and even makes the crash more possible,
but this allows to fix the problem later.

Note: this doesn't affect instance_rmdir() paths. It has the similar
problems and they will be fixed separately.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/trace/trace_events.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 9d2b499..cbd1a57 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1534,6 +1534,14 @@ static void remove_subsystem(struct ftrace_subsystem_dir *dir)
 	}
 }
 
+static void invalidate_event_file(struct dentry *dir)
+{
+	struct dentry *child;
+	/* ->i_mutex is not needed, nodody can create/remove a file */
+	list_for_each_entry(child, &dir->d_subdirs, d_u.d_child)
+		child->d_inode->i_private = NULL;
+}
+
 static void remove_event_from_tracers(struct ftrace_event_call *call)
 {
 	struct ftrace_event_file *file;
@@ -1545,6 +1553,7 @@ static void remove_event_from_tracers(struct ftrace_event_call *call)
 			continue;
 
 		list_del(&file->list);
+		invalidate_event_file(file->dir);
 		debugfs_remove_recursive(file->dir);
 		remove_subsystem(file->system);
 		kmem_cache_free(file_cachep, file);
-- 
1.5.5.1

