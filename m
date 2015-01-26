Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbbAZPK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:10:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:58362 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754058AbbAZPKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:10:04 -0500
Message-Id: <20150126151001.098069598@goodmis.org>
User-Agent: quilt/0.61-1
Date: Mon, 26 Jan 2015 10:09:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH 14/16 v3] tracing: Automatically mount tracefs on debugfs/tracing
References: <20150126150913.653681560@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0014-tracing-Automatically-mount-tracefs-on-debugfs-traci.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

As tools currently rely on the tracing directory in debugfs, we can not
just created a tracefs infrastructure and expect sysadmins to mount
the new tracefs to have their old tools work.

Instead, the debugfs tracing directory is still created and the tracefs
file system is mounted there when the debugfs filesystem is mounted.

No longer does the tracing infrastructure update the debugfs file system,
but instead interacts with the tracefs file system. But now, it still
appears to the user like nothing changed, except you also have the feature
of mounting just the tracing system without needing all of debugfs!

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index fb577a2a60ea..623791e15966 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -32,6 +32,7 @@
 #include <linux/splice.h>
 #include <linux/kdebug.h>
 #include <linux/string.h>
+#include <linux/mount.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
@@ -5815,10 +5816,34 @@ static __init int register_snapshot_cmd(void)
 static inline __init int register_snapshot_cmd(void) { return 0; }
 #endif /* defined(CONFIG_TRACER_SNAPSHOT) && defined(CONFIG_DYNAMIC_FTRACE) */
 
+static struct vfsmount *trace_automount(void *ingore)
+{
+	struct vfsmount *mnt;
+	struct file_system_type *type;
+
+	/*
+	 * To maintain backward compatibility for tools that mount
+	 * debugfs to get to the tracing facility, tracefs is automatically
+	 * mounted to the debugfs/tracing directory.
+	 */
+	type = get_fs_type("tracefs");
+	if (!type)
+		return NULL;
+	mnt = vfs_kern_mount(type, 0, "tracefs", NULL);
+	put_filesystem(type);
+	if (IS_ERR(mnt))
+		return NULL;
+	mntget(mnt);
+
+	return mnt;
+}
+
 #define TRACE_TOP_DIR_ENTRY		((struct dentry *)1)
 
 struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
 {
+	struct dentry *traced;
+
 	/* Top entry does not have a descriptor */
 	if (tr->dir == TRACE_TOP_DIR_ENTRY)
 		return NULL;
@@ -5831,7 +5856,16 @@ struct dentry *tracing_init_dentry_tr(struct trace_array *tr)
 		return ERR_PTR(-ENODEV);
 
 	if (tr->flags & TRACE_ARRAY_FL_GLOBAL) {
-		tr->dir = debugfs_create_dir("tracing", NULL);
+		/*
+		 * As there may still be users that expect the tracing
+		 * files to exist in debugfs/tracing, we must automount
+		 * the tracefs file system there, so older tools still
+		 * work with the newer kerenl.
+		 */
+		traced = debugfs_create_automount("tracing", NULL,
+						  trace_automount, NULL);
+		if (!traced)
+			return ERR_PTR(-ENOMEM);
 		tr->dir = TRACE_TOP_DIR_ENTRY;
 		return NULL;
 	}
-- 
2.1.4


