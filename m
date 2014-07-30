Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaG3Uzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:55:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63923 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750909AbaG3UzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:55:12 -0400
From: Josef Bacik <jbacik@fb.com>
To: <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: make sure we have a pending pid in trace-hist
Date: Wed, 30 Jul 2014 16:54:45 -0400
Message-ID: <1406753685-10590-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-30_07:2014-07-30,2014-07-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=22.6900859407804
 compositescore=0.997695897463551 urlsuspect_oldscore=0.997695897463551
 suspectscore=2 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407300243
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a trace.dat file where we lost some events and so we didn't have the
corresponding event to go with the stack trace.  This made trace-cmd hist
segfault because it unconditionally pushes the pending_pid's function onto the
stack trace.  In this case pending_pid < 0, which means we didn't have a pending
stack trace, so we got garbage in the call chain and hilarity ensued.  Fix this
by only pushing the pending call chain if there actually is one, and also don't
reset the current call chain if there isn't actually one there either.  This
fixed my segfault.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 Makefile      |  9 +++++----
 trace-cmd.c   |  3 +++
 trace-hist.c  | 14 +++++++++-----
 trace-local.h |  2 ++
 trace-usage.c |  5 +++++
 5 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/Makefile b/Makefile
index cbe0eb9..0a46125 100644
--- a/Makefile
+++ b/Makefile
@@ -81,7 +81,7 @@ ifndef NO_PYTHON
 PYTHON		:= ctracecmd.so
 PYTHON_GUI	:= ctracecmd.so ctracecmdgui.so
 
-PYTHON_VERS ?= python
+PYTHON_VERS ?= python-2.7
 
 # Can build python?
 ifeq ($(shell sh -c "pkg-config --cflags $(PYTHON_VERS) > /dev/null 2>&1 && echo y"), y)
@@ -164,6 +164,7 @@ LIBS = -L. -ltracecmd -ldl
 LIB_FILE = libtracecmd.a
 
 PACKAGES= gtk+-2.0 libxml-2.0 gthread-2.0
+NOGUI_PACKAGES= glib-2.0
 
 ifndef BUILDGUI
  BUILDGUI = 0
@@ -194,8 +195,8 @@ N 		= @/bin/true ||
 CONFIG_FLAGS	+= $(HELP_DIR_SQ)
 else
 
-CONFIG_INCLUDES = 
-CONFIG_LIBS	=
+CONFIG_INCLUDES = $(shell pkg-config --cflags $(NOGUI_PACKAGES))
+CONFIG_LIBS	= $(shell pkg-config --libs $(NOGUI_PACKAGES))
 CONFIG_FLAGS	=
 
 VERSION		= $(TC_VERSION)
@@ -307,7 +308,7 @@ $(obj)/%.o: $(src)/%.c
 TRACE_GUI_OBJS = trace-filter.o trace-compat.o trace-hash.o trace-dialog.o \
 		trace-xml.o
 TRACE_CMD_OBJS = trace-cmd.o trace-record.o trace-read.o trace-split.o trace-listen.o \
-	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o
+	 trace-stack.o trace-hist.o trace-mem.o trace-snapshot.o trace-latency.o
 TRACE_VIEW_OBJS = trace-view.o trace-view-store.o
 TRACE_GRAPH_OBJS = trace-graph.o trace-plot.o trace-plot-cpu.o trace-plot-task.o
 TRACE_VIEW_MAIN_OBJS = trace-view-main.o $(TRACE_VIEW_OBJS) $(TRACE_GUI_OBJS)
diff --git a/trace-cmd.c b/trace-cmd.c
index ebf9c7a..a8ecad6 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -432,6 +432,9 @@ int main (int argc, char **argv)
 	} else if (strcmp(argv[1], "stack") == 0) {
 		trace_stack(argc, argv);
 		exit(0);
+	} else if (strcmp(argv[1], "latency") == 0) {
+		trace_latency(argc, argv);
+		exit(0);
 	} else if (strcmp(argv[1], "check-events") == 0) {
 		char *tracing;
 		int ret;
diff --git a/trace-hist.c b/trace-hist.c
index 73820de..574549e 100644
--- a/trace-hist.c
+++ b/trace-hist.c
@@ -453,9 +453,11 @@ process_kernel_stack(struct pevent *pevent, struct pevent_record *record)
 		}
 	} else {
 		/* function stack trace? */
-		copy_stack_to_pending(current_pid);
-		free(ips);
-		reset_stack();
+		if (current_pid >= 0) {
+			copy_stack_to_pending(current_pid);
+			free(ips);
+			reset_stack();
+		}
 	}
 
 	current_pid = pid;
@@ -482,8 +484,10 @@ process_kernel_stack(struct pevent *pevent, struct pevent_record *record)
 			push_stack_func(func);
 	}
 
-	push_stack_func(pending_ips[pending_ips_idx - 1]);
-	reset_pending_stack();
+	if (pending_pid >= 0) {
+		push_stack_func(pending_ips[pending_ips_idx - 1]);
+		reset_pending_stack();
+	}
 	save_call_chain(current_pid, ips, ips_idx, 1);
 	if (do_restore)
 		restore_stack(current_pid);
diff --git a/trace-local.h b/trace-local.h
index 3c82c2f..1d6d69b 100644
--- a/trace-local.h
+++ b/trace-local.h
@@ -57,6 +57,8 @@ void trace_snapshot(int argc, char **argv);
 
 void trace_mem(int argc, char **argv);
 
+void trace_latency(int argc, char **argv);
+
 /* --- instance manipulation --- */
 
 struct func_list {
diff --git a/trace-usage.c b/trace-usage.c
index 0dec87e..ef73551 100644
--- a/trace-usage.c
+++ b/trace-usage.c
@@ -231,6 +231,11 @@ static struct usage_help usage_help[] = {
 		"          -N do not load any plugins\n"
 	},
 	{
+		"latency",
+		"parse latency events",
+		""
+	},
+	{
 		NULL, NULL, NULL
 	}
 };
-- 
2.0.0

