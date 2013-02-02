Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878Ab3BBOUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732Ab3BBOUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:20:00 -0500
X-Authority-Analysis: v=2.0 cv=NqdTgrhJ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=DKdvwoj9DwIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=-UIDKKBU7A0A:10 a=yPCof4ZbAAAA:8 a=3nbZYyFuAAAA:8 a=618GDtwajSH4qNQB-wgA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=7DSvI1NPTFQA:10 a=EvKJbDF4Ut8A:10 a=CdbX1FLNkxFrj8GaMj8A:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141956.729663102@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 11/11] tracing: Init current_trace to nop_trace and remove NULL checks
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-Init-current_trace-to-nop_trace-and-remove-N.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

On early boot up, when the ftrace ring buffer is initialized, the
static variable current_trace is initialized to &nop_trace.
Before this initialization, current_trace is NULL and will never
become NULL again. It is always reassigned to a ftrace tracer.

Several places check if current_trace is NULL before it uses
it, and this check is frivolous, because at the point in time
when the checks are made the only way current_trace could be
NULL is if ftrace failed its allocations at boot up, and the
paths to these locations would probably not be possible.

By initializing current_trace to &nop_trace where it is declared,
current_trace will never be NULL, and we can remove all these
checks of current_trace being NULL which never needed to be
checked in the first place.

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 70dce64..5d520b7 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -249,7 +249,7 @@ static unsigned long		trace_buf_size =3D TRACE_BUF_SIZE=
_DEFAULT;
 static struct tracer		*trace_types __read_mostly;
=20
 /* current_trace points to the tracer that is currently active */
-static struct tracer		*current_trace __read_mostly;
+static struct tracer		*current_trace __read_mostly =3D &nop_trace;
=20
 /*
  * trace_types_lock is used to protect the trace_types list.
@@ -2100,8 +2100,7 @@ print_trace_header(struct seq_file *m, struct trace_i=
terator *iter)
 	unsigned long total;
 	const char *name =3D "preemption";
=20
-	if (type)
-		name =3D type->name;
+	name =3D type->name;
=20
 	get_total_entries(tr, &total, &entries);
=20
@@ -2477,13 +2476,12 @@ __tracing_open(struct inode *inode, struct file *fi=
le, bool snapshot)
 	if (!iter->trace)
 		goto fail;
=20
-	if (current_trace)
-		*iter->trace =3D *current_trace;
+	*iter->trace =3D *current_trace;
=20
 	if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
 		goto fail;
=20
-	if ((current_trace && current_trace->print_max) || snapshot)
+	if (current_trace->print_max || snapshot)
 		iter->tr =3D &max_tr;
 	else
 		iter->tr =3D &global_trace;
@@ -3037,10 +3035,7 @@ tracing_set_trace_read(struct file *filp, char __use=
r *ubuf,
 	int r;
=20
 	mutex_lock(&trace_types_lock);
-	if (current_trace)
-		r =3D sprintf(buf, "%s\n", current_trace->name);
-	else
-		r =3D sprintf(buf, "\n");
+	r =3D sprintf(buf, "%s\n", current_trace->name);
 	mutex_unlock(&trace_types_lock);
=20
 	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
@@ -3231,10 +3226,10 @@ static int tracing_set_tracer(const char *buf)
 		goto out;
=20
 	trace_branch_disable();
-	if (current_trace && current_trace->reset)
+	if (current_trace->reset)
 		current_trace->reset(tr);
=20
-	had_max_tr =3D current_trace && current_trace->allocated_snapshot;
+	had_max_tr =3D current_trace->allocated_snapshot;
 	current_trace =3D &nop_trace;
=20
 	if (had_max_tr && !t->use_max_tr) {
@@ -3373,8 +3368,7 @@ static int tracing_open_pipe(struct inode *inode, str=
uct file *filp)
 		ret =3D -ENOMEM;
 		goto fail;
 	}
-	if (current_trace)
-		*iter->trace =3D *current_trace;
+	*iter->trace =3D *current_trace;
=20
 	if (!alloc_cpumask_var(&iter->started, GFP_KERNEL)) {
 		ret =3D -ENOMEM;
@@ -3525,7 +3519,7 @@ tracing_read_pipe(struct file *filp, char __user *ubu=
f,
=20
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(current_trace && iter->trace->name !=3D current_trace->name))
+	if (unlikely(iter->trace->name !=3D current_trace->name))
 		*iter->trace =3D *current_trace;
 	mutex_unlock(&trace_types_lock);
=20
@@ -3691,7 +3685,7 @@ static ssize_t tracing_splice_read_pipe(struct file *=
filp,
=20
 	/* copy the tracer to avoid using a global lock all around */
 	mutex_lock(&trace_types_lock);
-	if (unlikely(current_trace && iter->trace->name !=3D current_trace->name))
+	if (unlikely(iter->trace->name !=3D current_trace->name))
 		*iter->trace =3D *current_trace;
 	mutex_unlock(&trace_types_lock);
=20
@@ -4115,7 +4109,7 @@ tracing_snapshot_write(struct file *filp, const char =
__user *ubuf, size_t cnt,
=20
 	mutex_lock(&trace_types_lock);
=20
-	if (current_trace && current_trace->use_max_tr) {
+	if (current_trace->use_max_tr) {
 		ret =3D -EBUSY;
 		goto out;
 	}
@@ -5299,7 +5293,7 @@ __init static int tracer_alloc_buffers(void)
 	init_irq_work(&trace_work_wakeup, trace_wake_up);
=20
 	register_tracer(&nop_trace);
-	current_trace =3D &nop_trace;
+
 	/* All seems OK, enable tracing */
 	tracing_disabled =3D 0;
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCMAAoJEOdOSU1xswtMEmcH/2FmXqhwExixshL8B5C0PMuH
qeVExk5dNjhvIH3e+VDeMLJqZup48hx2NxO7ol3U0Ax5wFq+XQzpPngnaUSZF6rh
qOZkejqoPbeUZOmv1SKYcyiEhOlO6aXFR597HbM0FnuIGxIxNsaQ/F5ZnJ4EGio+
/qjIdgdCERxMoeB6mPPcvmyWGBOvGT9sUZvhOcB4Lz7xRpFjVv3TmWlBoX2EL1O6
LEKgUZWWStMAz6sqjL6PdanxsFcTYLBslOb33ZHk8VaBWKeaTmiuGUfF2QknY6n7
Vl/1VPFlH8KffANnQeEF8yNeIjTzQxSQArFLiXMZo6/ORnnl1NNHDgAvFsVkT94=
=KW1l
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
