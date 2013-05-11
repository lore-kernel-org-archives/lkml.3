Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757224Ab3EKANm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 20:13:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab3EKANI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 20:13:08 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Qwu-QPM6EgMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=EDewqSO6fdEA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VnNF1IyMAAAA:8 a=Gk8ZaLLF0g0qgiRPsewA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=YIqJApWulCMb9HnN75IA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130511001306.512249145@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 10 May 2013 20:12:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tom Zanussi <tom.zanussi@intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: [PATCH 17/18] tracing/kprobes: Support ftrace_event_file base multibuffer
References: <20130511001206.477862307@goodmis.org>
Content-Disposition: inline; filename=0017-tracing-kprobes-Support-ftrace_event_file-base-multi.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Support multi-buffer on kprobe-based dynamic events by
using ftrace_event_file.

Link: http://lkml.kernel.org/r/20130509054449.30398.88343.stgit@mhiramat-M0=
-7522

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tom Zanussi <tom.zanussi@intel.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_kprobe.c |  250 ++++++++++++++++++++++++++++++++++++---=
----
 1 file changed, 214 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 9ca44fc..fee865d 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -27,7 +27,6 @@
 /**
  * Kprobe event core functions
  */
-
 struct trace_probe {
 	struct list_head	list;
 	struct kretprobe	rp;	/* Use rp.kp for kprobe use */
@@ -36,6 +35,7 @@ struct trace_probe {
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_class	class;
 	struct ftrace_event_call	call;
+	struct ftrace_event_file	**files;
 	ssize_t			size;		/* trace entry size */
 	unsigned int		nr_args;
 	struct probe_arg	args[];
@@ -183,12 +183,57 @@ static struct trace_probe *find_trace_probe(const cha=
r *event,
 	return NULL;
 }
=20
-/* Enable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
-static int enable_trace_probe(struct trace_probe *tp, int flag)
+static int trace_probe_nr_files(struct trace_probe *tp)
+{
+	struct ftrace_event_file **file =3D tp->files;
+	int ret =3D 0;
+
+	if (file)
+		while (*(file++))
+			ret++;
+
+	return ret;
+}
+
+static DEFINE_MUTEX(probe_enable_lock);
+
+/*
+ * Enable trace_probe
+ * if the file is NULL, enable "perf" handler, or enable "trace" handler.
+ */
+static int
+enable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
 	int ret =3D 0;
=20
-	tp->flags |=3D flag;
+	mutex_lock(&probe_enable_lock);
+
+	if (file) {
+		struct ftrace_event_file **new, **old =3D tp->files;
+		int n =3D trace_probe_nr_files(tp);
+
+		/* 1 is for new one and 1 is for stopper */
+		new =3D kzalloc((n + 2) * sizeof(struct ftrace_event_file *),
+			      GFP_KERNEL);
+		if (!new) {
+			ret =3D -ENOMEM;
+			goto out_unlock;
+		}
+		memcpy(new, old, n * sizeof(struct ftrace_event_file *));
+		new[n] =3D file;
+		/* The last one keeps a NULL */
+
+		rcu_assign_pointer(tp->files, new);
+		tp->flags |=3D TP_FLAG_TRACE;
+
+		if (old) {
+			/* Make sure the probe is done with old files */
+			synchronize_sched();
+			kfree(old);
+		}
+	} else
+		tp->flags |=3D TP_FLAG_PROFILE;
+
 	if (trace_probe_is_enabled(tp) && trace_probe_is_registered(tp) &&
 	    !trace_probe_has_gone(tp)) {
 		if (trace_probe_is_return(tp))
@@ -197,19 +242,83 @@ static int enable_trace_probe(struct trace_probe *tp,=
 int flag)
 			ret =3D enable_kprobe(&tp->rp.kp);
 	}
=20
+ out_unlock:
+	mutex_unlock(&probe_enable_lock);
+
 	return ret;
 }
=20
-/* Disable trace_probe - @flag must be TP_FLAG_TRACE or TP_FLAG_PROFILE */
-static void disable_trace_probe(struct trace_probe *tp, int flag)
+static int
+trace_probe_file_index(struct trace_probe *tp, struct ftrace_event_file *f=
ile)
+{
+	int i;
+
+	if (tp->files) {
+		for (i =3D 0; tp->files[i]; i++)
+			if (tp->files[i] =3D=3D file)
+				return i;
+	}
+
+	return -1;
+}
+
+/*
+ * Disable trace_probe
+ * if the file is NULL, disable "perf" handler, or disable "trace" handler.
+ */
+static int
+disable_trace_probe(struct trace_probe *tp, struct ftrace_event_file *file)
 {
-	tp->flags &=3D ~flag;
+	int ret =3D 0;
+
+	mutex_lock(&probe_enable_lock);
+
+	if (file) {
+		struct ftrace_event_file **new, **old =3D tp->files;
+		int n =3D trace_probe_nr_files(tp);
+		int i, j;
+
+		if (n =3D=3D 0 || trace_probe_file_index(tp, file) < 0) {
+			ret =3D -EINVAL;
+			goto out_unlock;
+		}
+
+		if (n =3D=3D 1) {	/* Remove the last file */
+			tp->flags &=3D ~TP_FLAG_TRACE;
+			new =3D NULL;
+		} else {
+			new =3D kzalloc(n * sizeof(struct ftrace_event_file *),
+				      GFP_KERNEL);
+			if (!new) {
+				ret =3D -ENOMEM;
+				goto out_unlock;
+			}
+
+			/* This copy & check loop copies the NULL stopper too */
+			for (i =3D 0, j =3D 0; j < n && i < n + 1; i++)
+				if (old[i] !=3D file)
+					new[j++] =3D old[i];
+		}
+
+		rcu_assign_pointer(tp->files, new);
+
+		/* Make sure the probe is done with old files */
+		synchronize_sched();
+		kfree(old);
+	} else
+		tp->flags &=3D ~TP_FLAG_PROFILE;
+
 	if (!trace_probe_is_enabled(tp) && trace_probe_is_registered(tp)) {
 		if (trace_probe_is_return(tp))
 			disable_kretprobe(&tp->rp);
 		else
 			disable_kprobe(&tp->rp.kp);
 	}
+
+ out_unlock:
+	mutex_unlock(&probe_enable_lock);
+
+	return ret;
 }
=20
 /* Internal register function - just handle k*probes and flags */
@@ -724,7 +833,8 @@ static __kprobes void store_trace_args(int ent_size, st=
ruct trace_probe *tp,
=20
 /* Kprobe handler */
 static __kprobes void
-kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
+__kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs,
+		    struct ftrace_event_file *ftrace_file)
 {
 	struct kprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -733,14 +843,17 @@ kprobe_trace_func(struct trace_probe *tp, struct pt_r=
egs *regs)
 	unsigned long irq_flags;
 	struct ftrace_event_call *call =3D &tp->call;
=20
+	WARN_ON(call !=3D ftrace_file->event_call);
+
 	local_save_flags(irq_flags);
 	pc =3D preempt_count();
=20
 	dsize =3D __get_data_size(tp, regs);
 	size =3D sizeof(*entry) + tp->size + dsize;
=20
-	event =3D trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, irq_flags, pc);
+	event =3D trace_event_buffer_lock_reserve(&buffer, ftrace_file,
+						call->event.type,
+						size, irq_flags, pc);
 	if (!event)
 		return;
=20
@@ -753,10 +866,23 @@ kprobe_trace_func(struct trace_probe *tp, struct pt_r=
egs *regs)
 						irq_flags, pc, regs);
 }
=20
+static __kprobes void
+kprobe_trace_func(struct trace_probe *tp, struct pt_regs *regs)
+{
+	struct ftrace_event_file **file =3D tp->files;
+
+	/* Note: preempt is already disabled around the kprobe handler */
+	while (*file) {
+		__kprobe_trace_func(tp, regs, *file);
+		file++;
+	}
+}
+
 /* Kretprobe handler */
 static __kprobes void
-kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
-		     struct pt_regs *regs)
+__kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *=
ri,
+		       struct pt_regs *regs,
+		       struct ftrace_event_file *ftrace_file)
 {
 	struct kretprobe_trace_entry_head *entry;
 	struct ring_buffer_event *event;
@@ -765,14 +891,17 @@ kretprobe_trace_func(struct trace_probe *tp, struct k=
retprobe_instance *ri,
 	unsigned long irq_flags;
 	struct ftrace_event_call *call =3D &tp->call;
=20
+	WARN_ON(call !=3D ftrace_file->event_call);
+
 	local_save_flags(irq_flags);
 	pc =3D preempt_count();
=20
 	dsize =3D __get_data_size(tp, regs);
 	size =3D sizeof(*entry) + tp->size + dsize;
=20
-	event =3D trace_current_buffer_lock_reserve(&buffer, call->event.type,
-						  size, irq_flags, pc);
+	event =3D trace_event_buffer_lock_reserve(&buffer, ftrace_file,
+						call->event.type,
+						size, irq_flags, pc);
 	if (!event)
 		return;
=20
@@ -786,6 +915,19 @@ kretprobe_trace_func(struct trace_probe *tp, struct kr=
etprobe_instance *ri,
 						irq_flags, pc, regs);
 }
=20
+static __kprobes void
+kretprobe_trace_func(struct trace_probe *tp, struct kretprobe_instance *ri,
+		     struct pt_regs *regs)
+{
+	struct ftrace_event_file **file =3D tp->files;
+
+	/* Note: preempt is already disabled around the kprobe handler */
+	while (*file) {
+		__kretprobe_trace_func(tp, ri, regs, *file);
+		file++;
+	}
+}
+
 /* Event entry printers */
 enum print_line_t
 print_kprobe_event(struct trace_iterator *iter, int flags,
@@ -1041,20 +1183,19 @@ int kprobe_register(struct ftrace_event_call *event,
 		    enum trace_reg type, void *data)
 {
 	struct trace_probe *tp =3D (struct trace_probe *)event->data;
+	struct ftrace_event_file *file =3D data;
=20
 	switch (type) {
 	case TRACE_REG_REGISTER:
-		return enable_trace_probe(tp, TP_FLAG_TRACE);
+		return enable_trace_probe(tp, file);
 	case TRACE_REG_UNREGISTER:
-		disable_trace_probe(tp, TP_FLAG_TRACE);
-		return 0;
+		return disable_trace_probe(tp, file);
=20
 #ifdef CONFIG_PERF_EVENTS
 	case TRACE_REG_PERF_REGISTER:
-		return enable_trace_probe(tp, TP_FLAG_PROFILE);
+		return enable_trace_probe(tp, NULL);
 	case TRACE_REG_PERF_UNREGISTER:
-		disable_trace_probe(tp, TP_FLAG_PROFILE);
-		return 0;
+		return disable_trace_probe(tp, NULL);
 	case TRACE_REG_PERF_OPEN:
 	case TRACE_REG_PERF_CLOSE:
 	case TRACE_REG_PERF_ADD:
@@ -1190,11 +1331,24 @@ static __used int kprobe_trace_selftest_target(int =
a1, int a2, int a3,
 	return a1 + a2 + a3 + a4 + a5 + a6;
 }
=20
+static struct ftrace_event_file *
+find_trace_probe_file(struct trace_probe *tp, struct trace_array *tr)
+{
+	struct ftrace_event_file *file;
+
+	list_for_each_entry(file, &tr->events, list)
+		if (file->event_call =3D=3D &tp->call)
+			return file;
+
+	return NULL;
+}
+
 static __init int kprobe_trace_self_tests_init(void)
 {
 	int ret, warn =3D 0;
 	int (*target)(int, int, int, int, int, int);
 	struct trace_probe *tp;
+	struct ftrace_event_file *file;
=20
 	target =3D kprobe_trace_selftest_target;
=20
@@ -1204,31 +1358,43 @@ static __init int kprobe_trace_self_tests_init(void)
 				  "$stack $stack0 +0($stack)",
 				  create_trace_probe);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on probing function entry.\n");
+		pr_warn("error on probing function entry.\n");
 		warn++;
 	} else {
 		/* Enable trace point */
 		tp =3D find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp =3D=3D NULL)) {
-			pr_warning("error on getting new probe.\n");
+			pr_warn("error on getting new probe.\n");
 			warn++;
-		} else
-			enable_trace_probe(tp, TP_FLAG_TRACE);
+		} else {
+			file =3D find_trace_probe_file(tp, top_trace_array());
+			if (WARN_ON_ONCE(file =3D=3D NULL)) {
+				pr_warn("error on getting probe file.\n");
+				warn++;
+			} else
+				enable_trace_probe(tp, file);
+		}
 	}
=20
 	ret =3D traceprobe_command("r:testprobe2 kprobe_trace_selftest_target "
 				  "$retval", create_trace_probe);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on probing function return.\n");
+		pr_warn("error on probing function return.\n");
 		warn++;
 	} else {
 		/* Enable trace point */
 		tp =3D find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp =3D=3D NULL)) {
-			pr_warning("error on getting new probe.\n");
+			pr_warn("error on getting 2nd new probe.\n");
 			warn++;
-		} else
-			enable_trace_probe(tp, TP_FLAG_TRACE);
+		} else {
+			file =3D find_trace_probe_file(tp, top_trace_array());
+			if (WARN_ON_ONCE(file =3D=3D NULL)) {
+				pr_warn("error on getting probe file.\n");
+				warn++;
+			} else
+				enable_trace_probe(tp, file);
+		}
 	}
=20
 	if (warn)
@@ -1239,27 +1405,39 @@ static __init int kprobe_trace_self_tests_init(void)
 	/* Disable trace points before removing it */
 	tp =3D find_trace_probe("testprobe", KPROBE_EVENT_SYSTEM);
 	if (WARN_ON_ONCE(tp =3D=3D NULL)) {
-		pr_warning("error on getting test probe.\n");
+		pr_warn("error on getting test probe.\n");
 		warn++;
-	} else
-		disable_trace_probe(tp, TP_FLAG_TRACE);
+	} else {
+		file =3D find_trace_probe_file(tp, top_trace_array());
+		if (WARN_ON_ONCE(file =3D=3D NULL)) {
+			pr_warn("error on getting probe file.\n");
+			warn++;
+		} else
+			disable_trace_probe(tp, file);
+	}
=20
 	tp =3D find_trace_probe("testprobe2", KPROBE_EVENT_SYSTEM);
 	if (WARN_ON_ONCE(tp =3D=3D NULL)) {
-		pr_warning("error on getting 2nd test probe.\n");
+		pr_warn("error on getting 2nd test probe.\n");
 		warn++;
-	} else
-		disable_trace_probe(tp, TP_FLAG_TRACE);
+	} else {
+		file =3D find_trace_probe_file(tp, top_trace_array());
+		if (WARN_ON_ONCE(file =3D=3D NULL)) {
+			pr_warn("error on getting probe file.\n");
+			warn++;
+		} else
+			disable_trace_probe(tp, file);
+	}
=20
 	ret =3D traceprobe_command("-:testprobe", create_trace_probe);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on deleting a probe.\n");
+		pr_warn("error on deleting a probe.\n");
 		warn++;
 	}
=20
 	ret =3D traceprobe_command("-:testprobe2", create_trace_probe);
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on deleting a probe.\n");
+		pr_warn("error on deleting a probe.\n");
 		warn++;
 	}
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRjY0SAAoJEOdOSU1xswtMNvcIALldMdRjGY6FUY3X038Pitjb
pLVipnF1pCT3uhzjMuWBdtpVS2SZ1p40TrzqtoiBvf8hsDDiSM5r6MRj6eb7YUcq
MwHB4DW/24GjVJwseZMHuOiLUgQ0uTEz2tOwxRGqz7Z4tB6YxGu8pXBaISXiK297
2Lzrr3BNKEyIfYGgGSYA2A/pptj4PVk97Lp2JZvuGzNnwmbksAlxM5xtMrDGCEBX
dA/WOxSLb8h6qgSH5O1++n5mQ3szLOV4FKtG4wvPzfPh+ELB+wuosfCyo32KuGe6
8Kw4sCugOEMEdWXcb6pdre8MvgTGHkd1UwoGdb+Zb+Wq/kQPReJ6CI/2aDZ27/I=
=+uY+
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
