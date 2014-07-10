Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaGJVXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:23:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14370 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbaGJVXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:23:02 -0400
From: Josef Bacik <jbacik@fb.com>
To: <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>
Subject: [PATCH 2/2] trace-cmd: make libtracecmd a little more library friendly
Date: Thu, 10 Jul 2014 17:22:47 -0400
Message-ID: <1405027367-26570-3-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405027367-26570-1-git-send-email-jbacik@fb.com>
References: <1405027367-26570-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-10_07:2014-07-10,2014-07-10,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.39887054664933e-10 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407100241
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You get a lot of debug output if you link directly against libtracecmd if you
don't provide your own pr_stat() function because we default to something that
actually prints stuff out.  Fix this by making pr_stat() do nothing by default.
This also changes the printf() for the version number to a pr_stat().  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 parse-utils.c     | 6 ------
 plugin_function.c | 1 +
 trace-cmd-local.h | 1 +
 trace-cmd.c       | 1 +
 trace-cmd.h       | 2 --
 trace-input.c     | 2 +-
 trace-local.h     | 1 +
 trace-recorder.c  | 1 +
 trace-util.c      | 1 +
 9 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/parse-utils.c b/parse-utils.c
index f023a13..c5b0487 100644
--- a/parse-utils.c
+++ b/parse-utils.c
@@ -87,16 +87,10 @@ void __pr_stat(const char *fmt, ...)
 
 void __weak vpr_stat(const char *fmt, va_list ap)
 {
-	__vpr_stat(fmt, ap);
 }
 
 void __weak pr_stat(const char *fmt, ...)
 {
-	va_list ap;
-
-	va_start(ap, fmt);
-	__vpr_stat(fmt, ap);
-	va_end(ap);
 }
 
 void __weak *malloc_or_die(unsigned int size)
diff --git a/plugin_function.c b/plugin_function.c
index 0defd11..9ae4cf1 100644
--- a/plugin_function.c
+++ b/plugin_function.c
@@ -22,6 +22,7 @@
 #include <string.h>
 
 #include "trace-cmd.h"
+#include "event-utils.h"
 
 static struct func_stack {
 	int size;
diff --git a/trace-cmd-local.h b/trace-cmd-local.h
index 6f502c5..06809dd 100644
--- a/trace-cmd-local.h
+++ b/trace-cmd-local.h
@@ -23,6 +23,7 @@
 /* Local for trace-input.c and trace-output.c */
 
 #include "trace-cmd.h"
+#include "event-utils.h"
 
 static ssize_t __do_write(int fd, void *data, size_t size)
 {
diff --git a/trace-cmd.c b/trace-cmd.c
index ebf9c7a..1b776de 100644
--- a/trace-cmd.c
+++ b/trace-cmd.c
@@ -23,6 +23,7 @@
 #include <unistd.h>
 #include <dirent.h>
 #include <errno.h>
+#include <stdlib.h>
 
 #include "trace-local.h"
 
diff --git a/trace-cmd.h b/trace-cmd.h
index 92b4ff2..37d2fa8 100644
--- a/trace-cmd.h
+++ b/trace-cmd.h
@@ -20,8 +20,6 @@
 #ifndef _TRACE_CMD_H
 #define _TRACE_CMD_H
 
-#include <stdlib.h>
-#include "event-utils.h"
 #include "event-parse.h"
 
 #define TRACECMD_ERR_MSK	((unsigned long)(-1) & ~((1UL << 14) - 1))
diff --git a/trace-input.c b/trace-input.c
index 8118b22..090ee59 100644
--- a/trace-input.c
+++ b/trace-input.c
@@ -2237,7 +2237,7 @@ struct tracecmd_input *tracecmd_alloc_fd(int fd)
 	version = read_string(handle);
 	if (!version)
 		goto failed_read;
-	printf("version = %s\n", version);
+	pr_stat("version = %s\n", version);
 	free(version);
 
 	if (do_read_check(handle, buf, 1))
diff --git a/trace-local.h b/trace-local.h
index 3c82c2f..d187005 100644
--- a/trace-local.h
+++ b/trace-local.h
@@ -21,6 +21,7 @@
 #define __TRACE_LOCAL_H
 
 #include "trace-cmd.h"
+#include "event-utils.h"
 
 /* fix stupid glib guint64 typecasts and printf formats */
 typedef unsigned long long u64;
diff --git a/trace-recorder.c b/trace-recorder.c
index 247bb2d..e922f26 100644
--- a/trace-recorder.c
+++ b/trace-recorder.c
@@ -34,6 +34,7 @@
 #include <errno.h>
 
 #include "trace-cmd.h"
+#include "event-utils.h"
 
 struct tracecmd_recorder {
 	int		fd;
diff --git a/trace-util.c b/trace-util.c
index 208f150..e1f8230 100644
--- a/trace-util.c
+++ b/trace-util.c
@@ -32,6 +32,7 @@
 #include <sys/stat.h>
 
 #include "trace-cmd.h"
+#include "event-utils.h"
 
 #define LOCAL_PLUGIN_DIR ".trace-cmd/plugins"
 #define DEBUGFS_PATH "/sys/kernel/debug"
-- 
1.8.3.1

