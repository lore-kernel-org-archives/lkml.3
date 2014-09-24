Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaIXQDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:03:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17031 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753261AbaIXQDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:03:35 -0400
From: Josef Bacik <jbacik@fb.com>
To: <rostedt@goodmis.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace-cmd: add helper to read kernel_stack functions
Date: Wed, 24 Sep 2014 12:03:29 -0400
Message-ID: <1411574609-12129-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-24_07:2014-09-24,2014-09-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=3.05312336523755e-09 kscore.compositescore=0
 circleOfTrustscore=22.6900859407804 compositescore=0.997695897463551
 urlsuspect_oldscore=0.997695897463551 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997695897463551 spamscore=0
 recipient_to_sender_domain_totalscore=6 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1409240162
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The way the ftrace kernel_stack event is handled doesn't work right with the
normal event reading stuff in python.  The raw buffer read stuff expects the
size of the event to be non-zero, but in the case of kernel_stack the caller
array is 0 and we are given a size field

	field:int size;	offset:8;	size:4;	signed:1;
	field:unsigned long caller;	offset:16;	size:0;	signed:0;

This screws up python becuase it uses the size field to indicate how much of the
memory buffer is there to read, which in this case is 0.  This makes it
impossible to actually read the caller array from python.  So add a new c
binding to specially read the addr array and go ahead and look up the function
names for the addr and return those strings.  With this I can now pull the
function names for a kernel_stack event from the python library.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 ctracecmd.i | 24 ++++++++++++++++++++++++
 tracecmd.py | 11 +++++++++++
 2 files changed, 35 insertions(+)

diff --git a/ctracecmd.i b/ctracecmd.i
index 3970803..c175254 100644
--- a/ctracecmd.i
+++ b/ctracecmd.i
@@ -49,6 +49,30 @@ void py_pevent_register_event_handler(struct pevent *pevent, int id,
 				      python_callback, pyfunc);
 }
 
+static PyObject *py_field_get_addr_string(struct pevent *pevent,
+					  struct pevent_record *record,
+					  struct format_field *field,
+					  int long_size, int index)
+{
+	void *data = record->data;
+	const char *func = NULL;
+	off_t offset = field->offset + (index * long_size);
+	unsigned long addr;
+
+	if (offset + long_size > record->size) {
+		PyErr_SetString(PyExc_IndexError,
+				"Index is beyond beyond the range");
+		return NULL;
+	}
+
+	addr = pevent_read_number(pevent, data + offset, long_size);
+	func = pevent_find_function(pevent, addr);
+	if (!func)
+		return NULL;
+
+	return PyString_FromStringAndSize(func, strlen(func));
+}
+
 static PyObject *py_field_get_data(struct format_field *f, struct pevent_record *r)
 {
 	if (!strncmp(f->type, "__data_loc ", 11)) {
diff --git a/tracecmd.py b/tracecmd.py
index cdd619b..a43d788 100644
--- a/tracecmd.py
+++ b/tracecmd.py
@@ -117,6 +117,13 @@ class Event(object, DictMixin):
             return None
         return py_field_get_str(f, self._record)
 
+    def addr_field_index(self, name, long_size, index):
+        f = pevent_find_any_field(self._format, name)
+        if f is None:
+            return None
+        return py_field_get_addr_string(self._pevent, self._record, f,
+                                        long_size, index)
+
 class TraceSeq(object):
     def __init__(self, trace_seq):
         self._trace_seq = trace_seq
@@ -192,6 +199,10 @@ class Trace(object):
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

