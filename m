Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab3DZJq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:46:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759624Ab3DZJpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:45:54 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 7/8] GFS2: Add origin indicator to glock demote tracing
Date: Fri, 26 Apr 2013 10:19:00 +0100
Message-Id: <1366967941-7184-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
References: <1366967941-7184-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the origin indicator to the trace point for glock
demotion, so that it is possible to see where demote requests
have come from.

Note that requests generated from the demote_rq sysfs interface
will show as remote, since they are intended to replicate
exactly the effect of a demote reuqest from a remote node. It
is still possible to tell these apart by looking at the process
which initiated the demote request.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 77d7927..3b9e178 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -926,7 +926,7 @@ static void handle_callback(struct gfs2_glock *gl, unsigned int state,
 	}
 	if (gl->gl_ops->go_callback)
 		gl->gl_ops->go_callback(gl, remote);
-	trace_gfs2_demote_rq(gl);
+	trace_gfs2_demote_rq(gl, remote);
 }
 
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
diff --git a/fs/gfs2/trace_gfs2.h b/fs/gfs2/trace_gfs2.h
index 2ee13e8..20c007d 100644
--- a/fs/gfs2/trace_gfs2.h
+++ b/fs/gfs2/trace_gfs2.h
@@ -159,9 +159,9 @@ TRACE_EVENT(gfs2_glock_put,
 /* Callback (local or remote) requesting lock demotion */
 TRACE_EVENT(gfs2_demote_rq,
 
-	TP_PROTO(const struct gfs2_glock *gl),
+	TP_PROTO(const struct gfs2_glock *gl, bool remote),
 
-	TP_ARGS(gl),
+	TP_ARGS(gl, remote),
 
 	TP_STRUCT__entry(
 		__field(        dev_t,  dev                     )
@@ -170,6 +170,7 @@ TRACE_EVENT(gfs2_demote_rq,
 		__field(	u8,	cur_state		)
 		__field(	u8,	dmt_state		)
 		__field(	unsigned long,	flags		)
+		__field(	bool,	remote			)
 	),
 
 	TP_fast_assign(
@@ -179,14 +180,16 @@ TRACE_EVENT(gfs2_demote_rq,
 		__entry->cur_state	= glock_trace_state(gl->gl_state);
 		__entry->dmt_state	= glock_trace_state(gl->gl_demote_state);
 		__entry->flags		= gl->gl_flags  | (gl->gl_object ? (1UL<<GLF_OBJECT) : 0);
+		__entry->remote		= remote;
 	),
 
-	TP_printk("%u,%u glock %d:%lld demote %s to %s flags:%s",
+	TP_printk("%u,%u glock %d:%lld demote %s to %s flags:%s %s",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
 		  (unsigned long long)__entry->glnum,
                   glock_trace_name(__entry->cur_state),
                   glock_trace_name(__entry->dmt_state),
-		  show_glock_flags(__entry->flags))
+		  show_glock_flags(__entry->flags),
+		  __entry->remote ? "remote" : "local")
 
 );
 
-- 
1.7.4

