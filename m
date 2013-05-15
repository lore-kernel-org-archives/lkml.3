Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab3EOTm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:42:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2696 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab3EOTm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:42:26 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=aQGj5Ba5i8kA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=qh-1NM5LFg4A:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=2fjvpvJnXocZroCHupAA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=XOmH3qukYmWbKTYhgcwA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130515194224.190650921@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 15 May 2013 15:39:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/4] tracing/kprobes: Use rcu_dereference_raw for tp->files
References: <20130515193922.094868872@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-kprobes-Use-rcu_dereference_raw-for-tp-files.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Use rcu_dereference_raw() for accessing tp->files. Because the
write-side uses rcu_assign_pointer() for memory barrier,
the read-side also has to use rcu_dereference_raw() with
read memory barrier.

Link: http://lkml.kernel.org/r/20130513115834.6545.17022.stgit@mhiramat-M0-=
7522

Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |   47 ++++++++++++++++++++++++++++++++++-----=
----
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 636d45f..0a3d8d5 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -185,9 +185,14 @@ static struct trace_probe *find_trace_probe(const char=
 *event,
=20
 static int trace_probe_nr_files(struct trace_probe *tp)
 {
-	struct ftrace_event_file **file =3D tp->files;
+	struct ftrace_event_file **file;
 	int ret =3D 0;
=20
+	/*
+	 * Since all tp->files updater is protected by probe_enable_lock,
+	 * we don't need to lock an rcu_read_lock.
+	 */
+	file =3D rcu_dereference_raw(tp->files);
 	if (file)
 		while (*(file++))
 			ret++;
@@ -209,9 +214,10 @@ enable_trace_probe(struct trace_probe *tp, struct ftra=
ce_event_file *file)
 	mutex_lock(&probe_enable_lock);
=20
 	if (file) {
-		struct ftrace_event_file **new, **old =3D tp->files;
+		struct ftrace_event_file **new, **old;
 		int n =3D trace_probe_nr_files(tp);
=20
+		old =3D rcu_dereference_raw(tp->files);
 		/* 1 is for new one and 1 is for stopper */
 		new =3D kzalloc((n + 2) * sizeof(struct ftrace_event_file *),
 			      GFP_KERNEL);
@@ -251,11 +257,17 @@ enable_trace_probe(struct trace_probe *tp, struct ftr=
ace_event_file *file)
 static int
 trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *f=
ile)
 {
+	struct ftrace_event_file **files;
 	int i;
=20
-	if (tp->files) {
-		for (i =3D 0; tp->files[i]; i++)
-			if (tp->files[i] =3D=3D file)
+	/*
+	 * Since all tp->files updater is protected by probe_enable_lock,
+	 * we don't need to lock an rcu_read_lock.
+	 */
+	files =3D rcu_dereference_raw(tp->files);
+	if (files) {
+		for (i =3D 0; files[i]; i++)
+			if (files[i] =3D=3D file)
 				return i;
 	}
=20
@@ -274,10 +286,11 @@ disable_trace_probe(struct trace_probe *tp, struct ft=
race_event_file *file)
 	mutex_lock(&probe_enable_lock);
=20
 	if (file) {
-		struct ftrace_event_file **new, **old =3D tp->files;
+		struct ftrace_event_file **new, **old;
 		int n =3D trace_probe_nr_files(tp);
 		int i, j;
=20
+		old =3D rcu_dereference_raw(tp->files);
 		if (n =3D=3D 0 || trace_probe_file_index(tp, file) < 0) {
 			ret =3D -EINVAL;
 			goto out_unlock;
@@ -872,9 +885,16 @@ __kprobe_trace_func(struct trace_probe *tp, struct pt_=
regs *regs,
 static __kprobes void
 kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
 {
-	struct ftrace_event_file **file =3D tp->files;
+	/*
+	 * Note: preempt is already disabled around the kprobe handler.
+	 * However, we still need an smp_read_barrier_depends() corresponding
+	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
+	 */
+	struct ftrace_event_file **file =3D rcu_dereference_raw(tp->files);
+
+	if (unlikely(!file))
+		return;
=20
-	/* Note: preempt is already disabled around the kprobe handler */
 	while (*file) {
 		__kprobe_trace_func(tp, regs, *file);
 		file++;
@@ -925,9 +945,16 @@ static __kprobes void
 kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
 		     struct pt_regs *regs)
 {
-	struct ftrace_event_file **file =3D tp->files;
+	/*
+	 * Note: preempt is already disabled around the kprobe handler.
+	 * However, we still need an smp_read_barrier_depends() corresponding
+	 * to smp_wmb() in rcu_assign_pointer() to access the pointer.
+	 */
+	struct ftrace_event_file **file =3D rcu_dereference_raw(tp->files);
+
+	if (unlikely(!file))
+		return;
=20
-	/* Note: preempt is already disabled around the kprobe handler */
 	while (*file) {
 		__kretprobe_trace_func(tp, ri, regs, *file);
 		file++;
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRk+UgAAoJEOdOSU1xswtMhRYH/1gVLmLQ+BrzRoMHJ+MemGQS
PI0wyvNFt5NUSqMlgVSN3dWsUdEhUoe4tnIwirxATBA3k2VloTr/OnaAjCuwVnYp
DJcRsiqEPS5/qzBa3q5MOjCCmxYUdLZXA0WC+97YOa0VBDZzbmtkJDrrStixcCkF
Mhao3LeQXOLDSXbwg8bXKkkFWMpUfqOdVk/1Ewd3L/4+LW+ekIAjOE/TQkIPc4iz
NK899E7O3JCFQ7E3hPIzW3EPrXVhVFZQi8JWdigFdIS267H6PPL7lpEf6oSAD/dE
a3ID0lLitY/lzR7yLnWwf3V5xO5hok86/bdFa8/4cdzFV69OEq01d2NklTaMJ6o=
=smax
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
