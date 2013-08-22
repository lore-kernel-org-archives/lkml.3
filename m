Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518Ab3HVVuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:50:13 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:54974 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab3HVVuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:50:10 -0400
X-IronPort-AV: E=Sophos;i="4.89,936,1367971200"; 
   d="scan'208";a="44538407"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>, Paul Bolle <pebolle@tiscali.nl>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: [PATCH] Documentation/trace: Correcting and extending tracepoint documentation
Date: Thu, 22 Aug 2013 22:49:31 +0100
Message-ID: <1377208171-9004-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sample missed the moving of the header files into the events subdirectory.
I've also extended it based on the existing headers, and mentioned the tiny
but important role of CREATE_TRACE_POINTS.

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
---
 Documentation/trace/tracepoints.txt |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/trace/tracepoints.txt b/Documentation/trace/tracepoints.txt
index da49437..e8e3c4b 100644
--- a/Documentation/trace/tracepoints.txt
+++ b/Documentation/trace/tracepoints.txt
@@ -40,7 +40,13 @@ Two elements are required for tracepoints :
 
 In order to use tracepoints, you should include linux/tracepoint.h.
 
-In include/trace/subsys.h :
+In include/trace/events/subsys.h :
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM subsys
+
+#if !defined(_TRACE_SUBSYS_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_SUBSYS_H
 
 #include <linux/tracepoint.h>
 
@@ -48,10 +54,16 @@ DECLARE_TRACE(subsys_eventname,
 	TP_PROTO(int firstarg, struct task_struct *p),
 	TP_ARGS(firstarg, p));
 
+#endif /* _TRACE_SUBSYS_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
+
 In subsys/file.c (where the tracing statement must be added) :
 
-#include <trace/subsys.h>
+#include <trace/events/subsys.h>
 
+#define CREATE_TRACE_POINTS
 DEFINE_TRACE(subsys_eventname);
 
 void somefct(void)
@@ -72,6 +84,9 @@ Where :
 - TP_ARGS(firstarg, p) are the parameters names, same as found in the
   prototype.
 
+- if you use the header in multiple source files, #define CREATE_TRACE_POINTS
+  should appear only in one source file
+
 Connecting a function (probe) to a tracepoint is done by providing a
 probe (function to call) for the specific tracepoint through
 register_trace_subsys_eventname().  Removing a probe is done through
-- 
1.7.9.5

