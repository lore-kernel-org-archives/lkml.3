Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaIZSok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:44:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9619 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbaIZSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:44:39 -0400
From: Josef Bacik <jbacik@fb.com>
To: <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: allow python tools to supress warning() and pr_stat()
Date: Fri, 26 Sep 2014 14:44:34 -0400
Message-ID: <1411757074-29117-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-26_07:2014-09-26,2014-09-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409260178
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace-cmd has a lot of built in warning() and pr_stat() output that is noisy
when you are using the python bindings.  This patch provides overrides for these
two functions and the ability for python scripts to optionally turn them off.
With this patch I can silence all of these extraneous print messages from within
my python script.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 ctracecmd.i | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/ctracecmd.i b/ctracecmd.i
index 3b80f01..e91d068 100644
--- a/ctracecmd.i
+++ b/ctracecmd.i
@@ -34,6 +34,36 @@ static int python_callback(struct trace_seq *s,
 			   struct event_format *event,
 			   void *context);
 
+static int skip_output = 0;
+
+static void py_supress_trace_output(void)
+{
+	skip_output = 1;
+}
+
+void pr_stat(const char *fmt, ...)
+{
+        va_list ap;
+
+	if (skip_output)
+		return;
+	va_start(ap, fmt);
+	__vpr_stat(fmt, ap);
+	va_end(ap);
+}
+
+void warning(const char *fmt, ...)
+{
+	va_list ap;
+
+	if (skip_output)
+		return;
+
+	va_start(ap, fmt);
+	__vwarning(fmt, ap);
+	va_end(ap);
+}
+
 PyObject *convert_pevent(unsigned long pevent)
 {
 	void *pev = (void *)pevent;
-- 
1.9.3

