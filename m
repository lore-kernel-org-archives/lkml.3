Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaIYRoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 13:44:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7443 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753141AbaIYRoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:44:03 -0400
From: Josef Bacik <jbacik@fb.com>
To: <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: add helper to read *_stack ftrace events
Date: Thu, 25 Sep 2014 13:43:57 -0400
Message-ID: <1411667037-27105-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-25_07:2014-09-25,2014-09-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409250184
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user_stack and kernel_stack events are special in that they are dynamic
arrays but aren't labeled as __data_loc like other dynamic arrays.  This isn't a
big deal since they look the same, they have a "caller" field which is an array
of unsigned longs.  This patch adds a helper to the python bindings to read
these arrays in, lookup the function and append them to a python list.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
NOTE:  This patch replaces the one I sent yesterday

trace-cmd: add helper to read kernel_stack functions

This is cleaner and gives us a nice list of the functions and works for both
kernel_stack and user_stack events.

 ctracecmd.i | 37 +++++++++++++++++++++++++++++++++++++
 tracecmd.py |  8 ++++++++
 2 files changed, 45 insertions(+)

diff --git a/ctracecmd.i b/ctracecmd.i
index 3970803..3b80f01 100644
--- a/ctracecmd.i
+++ b/ctracecmd.i
@@ -49,6 +49,43 @@ void py_pevent_register_event_handler(struct pevent *pevent, int id,
 				      python_callback, pyfunc);
 }
 
+static PyObject *py_field_get_stack(struct pevent *pevent,
+				    struct pevent_record *record,
+				    struct event_format *event,
+				    int long_size)
+{
+	PyObject *list;
+	struct format_field *field;
+	void *data = record->data;
+	const char *func = NULL;
+	unsigned long addr;
+
+	field = pevent_find_any_field(event, "caller");
+	if (!field) {
+		PyErr_SetString(PyExc_TypeError,
+				"Event doesn't have caller field");
+		return NULL;
+	}
+
+	list = PyList_New(0);
+
+	for (data += field->offset; data < record->data + record->size;
+	     data += long_size) {
+		addr = pevent_read_number(event->pevent, data, long_size);
+
+		if ((long_size == 8 && addr == (unsigned long long)-1) ||
+		    ((int)addr == -1))
+			break;
+		func = pevent_find_function(event->pevent, addr);
+		if (PyList_Append(list, PyString_FromString(func))) {
+			Py_DECREF(list);
+			return NULL;
+		}
+	}
+
+	return list;
+}
+
 static PyObject *py_field_get_data(struct format_field *f, struct pevent_record *r)
 {
 	if (!strncmp(f->type, "__data_loc ", 11)) {
diff --git a/tracecmd.py b/tracecmd.py
index cdd619b..358185b 100644
--- a/tracecmd.py
+++ b/tracecmd.py
@@ -117,6 +117,10 @@ class Event(object, DictMixin):
             return None
         return py_field_get_str(f, self._record)
 
+    def stack_field(self, long_size):
+        return py_field_get_stack(self._pevent, self._record, self._format,
+                                  long_size)
+
 class TraceSeq(object):
     def __init__(self, trace_seq):
         self._trace_seq = trace_seq
@@ -192,6 +196,10 @@ class Trace(object):
     def cpus(self):
         return tracecmd_cpus(self._handle)
 
+    @cached_property
+    def long_size(self):
+        return tracecmd_long_size(self._handle)
+
     def read_event(self, cpu):
         rec = tracecmd_read_data(self._handle, cpu)
         if rec:
-- 
1.9.3

