Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab3CPDcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3CPDbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:45 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=dFYlJhJYAWQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=34mVwQnwHT0A:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=LSKYr4QK8mN5tH2s6a8A:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=jeBq3FmKZ4MA:10 a=lWNHMShOs62LvWcJxtkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316033143.356607943@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 7/9] tracing: Rename trace_event_mutex to trace_event_sem
References: <20130316032412.416651612@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-Rename-trace_event_mutex-to-trace_event_sem.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

trace_event_mutex is an rw semaphore now, not a mutex, change the name.

Link: http://lkml.kernel.org/r/513D843B.40109@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
[ Forward ported to my new code ]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |   22 +++++++++++-----------
 kernel/trace/trace_output.c |   16 ++++++++--------
 kernel/trace/trace_output.h |    2 +-
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index a71cdc3..53582e9 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1584,7 +1584,7 @@ int trace_add_event_call(struct ftrace_event_call *ca=
ll)
 }
=20
 /*
- * Must be called under locking both of event_mutex and trace_event_mutex.
+ * Must be called under locking both of event_mutex and trace_event_sem.
  */
 static void __trace_remove_event_call(struct ftrace_event_call *call)
 {
@@ -1597,9 +1597,9 @@ static void __trace_remove_event_call(struct ftrace_e=
vent_call *call)
 void trace_remove_event_call(struct ftrace_event_call *call)
 {
 	mutex_lock(&event_mutex);
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	__trace_remove_event_call(call);
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
 	mutex_unlock(&event_mutex);
 }
=20
@@ -1707,7 +1707,7 @@ static void trace_module_remove_events(struct module =
*mod)
 	struct ftrace_event_call *call, *p;
 	bool clear_trace =3D false;
=20
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	list_for_each_entry_safe(call, p, &ftrace_events, list) {
 		if (call->mod =3D=3D mod) {
 			if (call->flags & TRACE_EVENT_FL_WAS_ENABLED)
@@ -1725,7 +1725,7 @@ static void trace_module_remove_events(struct module =
*mod)
 		list_del(&file_ops->list);
 		kfree(file_ops);
 	}
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
=20
 	/*
 	 * It is safest to reset the ring buffer if the module being unloaded
@@ -2262,9 +2262,9 @@ int event_trace_add_tracer(struct dentry *parent, str=
uct trace_array *tr)
 	if (ret)
 		goto out_unlock;
=20
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	__trace_add_event_dirs(tr);
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
=20
  out_unlock:
 	mutex_unlock(&event_mutex);
@@ -2287,9 +2287,9 @@ early_event_add_tracer(struct dentry *parent, struct =
trace_array *tr)
 	if (ret)
 		goto out_unlock;
=20
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	__trace_early_add_event_dirs(tr);
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
=20
  out_unlock:
 	mutex_unlock(&event_mutex);
@@ -2304,10 +2304,10 @@ int event_trace_del_tracer(struct trace_array *tr)
=20
 	mutex_lock(&event_mutex);
=20
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	__trace_remove_event_dirs(tr);
 	debugfs_remove_recursive(tr->event_dir);
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
=20
 	tr->event_dir =3D NULL;
=20
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 19f48e7..f475b2a 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -14,7 +14,7 @@
 /* must be a power of 2 */
 #define EVENT_HASHSIZE	128
=20
-DECLARE_RWSEM(trace_event_mutex);
+DECLARE_RWSEM(trace_event_sem);
=20
 static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
=20
@@ -826,12 +826,12 @@ static int trace_search_list(struct list_head **list)
=20
 void trace_event_read_lock(void)
 {
-	down_read(&trace_event_mutex);
+	down_read(&trace_event_sem);
 }
=20
 void trace_event_read_unlock(void)
 {
-	up_read(&trace_event_mutex);
+	up_read(&trace_event_sem);
 }
=20
 /**
@@ -854,7 +854,7 @@ int register_ftrace_event(struct trace_event *event)
 	unsigned key;
 	int ret =3D 0;
=20
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
=20
 	if (WARN_ON(!event))
 		goto out;
@@ -909,14 +909,14 @@ int register_ftrace_event(struct trace_event *event)
=20
 	ret =3D event->type;
  out:
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
=20
 	return ret;
 }
 EXPORT_SYMBOL_GPL(register_ftrace_event);
=20
 /*
- * Used by module code with the trace_event_mutex held for write.
+ * Used by module code with the trace_event_sem held for write.
  */
 int __unregister_ftrace_event(struct trace_event *event)
 {
@@ -931,9 +931,9 @@ int __unregister_ftrace_event(struct trace_event *event)
  */
 int unregister_ftrace_event(struct trace_event *event)
 {
-	down_write(&trace_event_mutex);
+	down_write(&trace_event_sem);
 	__unregister_ftrace_event(event);
-	up_write(&trace_event_mutex);
+	up_write(&trace_event_sem);
=20
 	return 0;
 }
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
index af77870..127a9d8 100644
--- a/kernel/trace/trace_output.h
+++ b/kernel/trace/trace_output.h
@@ -33,7 +33,7 @@ trace_print_lat_fmt(struct trace_seq *s, struct trace_ent=
ry *entry);
=20
 /* used by module unregistering */
 extern int __unregister_ftrace_event(struct trace_event *event);
-extern struct rw_semaphore trace_event_mutex;
+extern struct rw_semaphore trace_event_sem;
=20
 #define MAX_MEMHEX_BYTES	8
 #define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+efAAoJEOdOSU1xswtMFWoH/RE23Vvg8YWzrDONJAyJZQ2p
KKZ/Qeq5GPtY7Xxm+LhU2aGipnSzaVEMsb1dF7Gj9FL/zeSHQ0c+rVMu5v/4P4+I
Vhu0pbUsUujWCFKroZiePaHv8hm51XOcrPNbyRcXazT5tb21ptyCkjXGqVcXuKnf
vgfHNd1lc7qp/PVqt230samJ1oavwBSKZCARI8pWKPwoFQbYeADtJYgkFBGsKZBH
BPPZFvCQ0CmIM6TMM29AbFPHJqlDVFluPPL/7mSHM8Lv6w+g+LiVFTl0PdUmAO5e
1BhsjFN/oa2nZJZ1i84sbCDd7X/AFfuvhYxOO9mQ72Y5r65sC5znfqLotdmJykY=
=qyYT
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
