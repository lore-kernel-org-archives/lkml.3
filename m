Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab3BBOUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:20:24 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16662 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727Ab3BBOT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:19:59 -0500
X-Authority-Analysis: v=2.0 cv=bJmU0YCZ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6dcEgwZeM6UA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=25dGYeLXSLcA:10 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=SniNfmaUgOzkzmjKdF4A:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=3AdyjRya9Di08edi3tAA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130202141956.305830206@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sat, 02 Feb 2013 09:18:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Sharp <dhsharp@google.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [PATCH 09/11] tracing: Make a snapshot feature available from userspace
References: <20130202141842.189550803@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-Make-a-snapshot-feature-available-from-users.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>

Ftrace has a snapshot feature available from kernel space and
latency tracers (e.g. irqsoff) are using it. This patch enables
user applictions to take a snapshot via debugfs.

Add "snapshot" debugfs file in "tracing" directory.

  snapshot:
    This is used to take a snapshot and to read the output of the
    snapshot.

     # echo 1 > snapshot

    This will allocate the spare buffer for snapshot (if it is
    not allocated), and take a snapshot.

     # cat snapshot

    This will show contents of the snapshot.

     # echo 0 > snapshot

    This will free the snapshot if it is allocated.

    Any other positive values will clear the snapshot contents if
    the snapshot is allocated, or return EINVAL if it is not allocated.

Link: http://lkml.kernel.org/r/20121226025300.3252.86850.stgit@liselsia

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
[
   Fixed irqsoff selftest and also a conflict with a change
   that fixes the update_max_tr.
]
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    3 +
 kernel/trace/Kconfig         |   10 +++
 kernel/trace/trace.c         |  166 +++++++++++++++++++++++++++++++++++---=
----
 kernel/trace/trace.h         |    1 +
 4 files changed, 154 insertions(+), 26 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 6f8d0b7..13a54d0 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -83,6 +83,9 @@ struct trace_iterator {
 	long			idx;
=20
 	cpumask_var_t		started;
+
+	/* it's true when current open file is snapshot */
+	bool			snapshot;
 };
=20
 enum trace_iter_flags {
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index cdc9d28..3656756 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -253,6 +253,16 @@ config FTRACE_SYSCALLS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
=20
+config TRACER_SNAPSHOT
+	bool "Create a snapshot trace buffer"
+	select TRACER_MAX_TRACE
+	help
+	  Allow tracing users to take snapshot of the current buffer using the
+	  ftrace interface, e.g.:
+
+	      echo 1 > /sys/kernel/debug/tracing/snapshot
+	      cat snapshot
+
 config TRACE_BRANCH_PROFILING
 	bool
 	select GENERIC_TRACER
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2c72466..70dce64 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -710,12 +710,11 @@ update_max_tr(struct trace_array *tr, struct task_str=
uct *tsk, int cpu)
=20
 	WARN_ON_ONCE(!irqs_disabled());
=20
-	/* If we disabled the tracer, stop now */
-	if (current_trace =3D=3D &nop_trace)
-		return;
-
-	if (WARN_ON_ONCE(!current_trace->use_max_tr))
+	if (!current_trace->allocated_snapshot) {
+		/* Only the nop tracer should hit this when disabling */
+		WARN_ON_ONCE(current_trace !=3D &nop_trace);
 		return;
+	}
=20
 	arch_spin_lock(&ftrace_max_lock);
=20
@@ -743,10 +742,8 @@ update_max_tr_single(struct trace_array *tr, struct ta=
sk_struct *tsk, int cpu)
 		return;
=20
 	WARN_ON_ONCE(!irqs_disabled());
-	if (!current_trace->use_max_tr) {
-		WARN_ON_ONCE(1);
+	if (WARN_ON_ONCE(!current_trace->allocated_snapshot))
 		return;
-	}
=20
 	arch_spin_lock(&ftrace_max_lock);
=20
@@ -866,10 +863,13 @@ int register_tracer(struct tracer *type)
=20
 		current_trace =3D type;
=20
-		/* If we expanded the buffers, make sure the max is expanded too */
-		if (ring_buffer_expanded && type->use_max_tr)
-			ring_buffer_resize(max_tr.buffer, trace_buf_size,
-						RING_BUFFER_ALL_CPUS);
+		if (type->use_max_tr) {
+			/* If we expanded the buffers, make sure the max is expanded too */
+			if (ring_buffer_expanded)
+				ring_buffer_resize(max_tr.buffer, trace_buf_size,
+						   RING_BUFFER_ALL_CPUS);
+			type->allocated_snapshot =3D true;
+		}
=20
 		/* the test is responsible for initializing and enabling */
 		pr_info("Testing tracer %s: ", type->name);
@@ -885,10 +885,14 @@ int register_tracer(struct tracer *type)
 		/* Only reset on passing, to avoid touching corrupted buffers */
 		tracing_reset_online_cpus(tr);
=20
-		/* Shrink the max buffer again */
-		if (ring_buffer_expanded && type->use_max_tr)
-			ring_buffer_resize(max_tr.buffer, 1,
-						RING_BUFFER_ALL_CPUS);
+		if (type->use_max_tr) {
+			type->allocated_snapshot =3D false;
+
+			/* Shrink the max buffer again */
+			if (ring_buffer_expanded)
+				ring_buffer_resize(max_tr.buffer, 1,
+						   RING_BUFFER_ALL_CPUS);
+		}
=20
 		printk(KERN_CONT "PASSED\n");
 	}
@@ -1964,7 +1968,11 @@ static void *s_start(struct seq_file *m, loff_t *pos)
 		*iter->trace =3D *current_trace;
 	mutex_unlock(&trace_types_lock);
=20
-	atomic_inc(&trace_record_cmdline_disabled);
+	if (iter->snapshot && iter->trace->use_max_tr)
+		return ERR_PTR(-EBUSY);
+
+	if (!iter->snapshot)
+		atomic_inc(&trace_record_cmdline_disabled);
=20
 	if (*pos !=3D iter->pos) {
 		iter->ent =3D NULL;
@@ -2003,7 +2011,11 @@ static void s_stop(struct seq_file *m, void *p)
 {
 	struct trace_iterator *iter =3D m->private;
=20
-	atomic_dec(&trace_record_cmdline_disabled);
+	if (iter->snapshot && iter->trace->use_max_tr)
+		return;
+
+	if (!iter->snapshot)
+		atomic_dec(&trace_record_cmdline_disabled);
 	trace_access_unlock(iter->cpu_file);
 	trace_event_read_unlock();
 }
@@ -2438,7 +2450,7 @@ static const struct seq_operations tracer_seq_ops =3D=
 {
 };
=20
 static struct trace_iterator *
-__tracing_open(struct inode *inode, struct file *file)
+__tracing_open(struct inode *inode, struct file *file, bool snapshot)
 {
 	long cpu_file =3D (long) inode->i_private;
 	struct trace_iterator *iter;
@@ -2471,10 +2483,11 @@ __tracing_open(struct inode *inode, struct file *fi=
le)
 	if (!zalloc_cpumask_var(&iter->started, GFP_KERNEL))
 		goto fail;
=20
-	if (current_trace && current_trace->print_max)
+	if ((current_trace && current_trace->print_max) || snapshot)
 		iter->tr =3D &max_tr;
 	else
 		iter->tr =3D &global_trace;
+	iter->snapshot =3D snapshot;
 	iter->pos =3D -1;
 	mutex_init(&iter->mutex);
 	iter->cpu_file =3D cpu_file;
@@ -2491,8 +2504,9 @@ __tracing_open(struct inode *inode, struct file *file)
 	if (trace_clocks[trace_clock_id].in_ns)
 		iter->iter_flags |=3D TRACE_FILE_TIME_IN_NS;
=20
-	/* stop the trace while dumping */
-	tracing_stop();
+	/* stop the trace while dumping if we are not opening "snapshot" */
+	if (!iter->snapshot)
+		tracing_stop();
=20
 	if (iter->cpu_file =3D=3D TRACE_PIPE_ALL_CPU) {
 		for_each_tracing_cpu(cpu) {
@@ -2555,8 +2569,9 @@ static int tracing_release(struct inode *inode, struc=
t file *file)
 	if (iter->trace && iter->trace->close)
 		iter->trace->close(iter);
=20
-	/* reenable tracing if it was previously enabled */
-	tracing_start();
+	if (!iter->snapshot)
+		/* reenable tracing if it was previously enabled */
+		tracing_start();
 	mutex_unlock(&trace_types_lock);
=20
 	mutex_destroy(&iter->mutex);
@@ -2584,7 +2599,7 @@ static int tracing_open(struct inode *inode, struct f=
ile *file)
 	}
=20
 	if (file->f_mode & FMODE_READ) {
-		iter =3D __tracing_open(inode, file);
+		iter =3D __tracing_open(inode, file, false);
 		if (IS_ERR(iter))
 			ret =3D PTR_ERR(iter);
 		else if (trace_flags & TRACE_ITER_LATENCY_FMT)
@@ -3219,7 +3234,7 @@ static int tracing_set_tracer(const char *buf)
 	if (current_trace && current_trace->reset)
 		current_trace->reset(tr);
=20
-	had_max_tr =3D current_trace && current_trace->use_max_tr;
+	had_max_tr =3D current_trace && current_trace->allocated_snapshot;
 	current_trace =3D &nop_trace;
=20
 	if (had_max_tr && !t->use_max_tr) {
@@ -3238,6 +3253,8 @@ static int tracing_set_tracer(const char *buf)
 		 */
 		ring_buffer_resize(max_tr.buffer, 1, RING_BUFFER_ALL_CPUS);
 		set_buffer_entries(&max_tr, 1);
+		tracing_reset_online_cpus(&max_tr);
+		current_trace->allocated_snapshot =3D false;
 	}
 	destroy_trace_option_files(topts);
=20
@@ -3248,6 +3265,7 @@ static int tracing_set_tracer(const char *buf)
 						   RING_BUFFER_ALL_CPUS);
 		if (ret < 0)
 			goto out;
+		t->allocated_snapshot =3D true;
 	}
=20
 	if (t->init) {
@@ -4066,6 +4084,87 @@ static int tracing_clock_open(struct inode *inode, s=
truct file *file)
 	return single_open(file, tracing_clock_show, NULL);
 }
=20
+#ifdef CONFIG_TRACER_SNAPSHOT
+static int tracing_snapshot_open(struct inode *inode, struct file *file)
+{
+	struct trace_iterator *iter;
+	int ret =3D 0;
+
+	if (file->f_mode & FMODE_READ) {
+		iter =3D __tracing_open(inode, file, true);
+		if (IS_ERR(iter))
+			ret =3D PTR_ERR(iter);
+	}
+	return ret;
+}
+
+static ssize_t
+tracing_snapshot_write(struct file *filp, const char __user *ubuf, size_t =
cnt,
+		       loff_t *ppos)
+{
+	unsigned long val;
+	int ret;
+
+	ret =3D tracing_update_buffers();
+	if (ret < 0)
+		return ret;
+
+	ret =3D kstrtoul_from_user(ubuf, cnt, 10, &val);
+	if (ret)
+		return ret;
+
+	mutex_lock(&trace_types_lock);
+
+	if (current_trace && current_trace->use_max_tr) {
+		ret =3D -EBUSY;
+		goto out;
+	}
+
+	switch (val) {
+	case 0:
+		if (current_trace->allocated_snapshot) {
+			/* free spare buffer */
+			ring_buffer_resize(max_tr.buffer, 1,
+					   RING_BUFFER_ALL_CPUS);
+			set_buffer_entries(&max_tr, 1);
+			tracing_reset_online_cpus(&max_tr);
+			current_trace->allocated_snapshot =3D false;
+		}
+		break;
+	case 1:
+		if (!current_trace->allocated_snapshot) {
+			/* allocate spare buffer */
+			ret =3D resize_buffer_duplicate_size(&max_tr,
+					&global_trace, RING_BUFFER_ALL_CPUS);
+			if (ret < 0)
+				break;
+			current_trace->allocated_snapshot =3D true;
+		}
+
+		local_irq_disable();
+		/* Now, we're going to swap */
+		update_max_tr(&global_trace, current, smp_processor_id());
+		local_irq_enable();
+		break;
+	default:
+		if (current_trace->allocated_snapshot)
+			tracing_reset_online_cpus(&max_tr);
+		else
+			ret =3D -EINVAL;
+		break;
+	}
+
+	if (ret >=3D 0) {
+		*ppos +=3D cnt;
+		ret =3D cnt;
+	}
+out:
+	mutex_unlock(&trace_types_lock);
+	return ret;
+}
+#endif /* CONFIG_TRACER_SNAPSHOT */
+
+
 static const struct file_operations tracing_max_lat_fops =3D {
 	.open		=3D tracing_open_generic,
 	.read		=3D tracing_max_lat_read,
@@ -4122,6 +4221,16 @@ static const struct file_operations trace_clock_fops=
 =3D {
 	.write		=3D tracing_clock_write,
 };
=20
+#ifdef CONFIG_TRACER_SNAPSHOT
+static const struct file_operations snapshot_fops =3D {
+	.open		=3D tracing_snapshot_open,
+	.read		=3D seq_read,
+	.write		=3D tracing_snapshot_write,
+	.llseek		=3D tracing_seek,
+	.release	=3D tracing_release,
+};
+#endif /* CONFIG_TRACER_SNAPSHOT */
+
 struct ftrace_buffer_info {
 	struct trace_array	*tr;
 	void			*spare;
@@ -4921,6 +5030,11 @@ static __init int tracer_init_debugfs(void)
 			&ftrace_update_tot_cnt, &tracing_dyn_info_fops);
 #endif
=20
+#ifdef CONFIG_TRACER_SNAPSHOT
+	trace_create_file("snapshot", 0644, d_tracer,
+			  (void *) TRACE_PIPE_ALL_CPU, &snapshot_fops);
+#endif
+
 	create_trace_options_dir();
=20
 	for_each_tracing_cpu(cpu)
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 04a2c7a..57d7e53 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -287,6 +287,7 @@ struct tracer {
 	struct tracer_flags	*flags;
 	bool			print_max;
 	bool			use_max_tr;
+	bool			allocated_snapshot;
 };
=20
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRDSCMAAoJEOdOSU1xswtMHLsH/1IjB+dX4s+qIlfjdi45XwOD
Hq6J0JhnVBI3Qo2JTOCX2t7nhvGHDB9K9g7vvPjAhs4C7EJ/8iOPE0hICiB+xv/h
CDRBet7cUyMqqh7dFWkY1FVB1w3mrqQDkhTrvrLMPj5UlqRQ2RugLAvlOLS0upiS
4fwyouPRFJrOjHgEtkz3zGBghq4MJIzvs+IE0Kauq061RM7KmgHfvqkz4encHaeq
uLqJvHiADDsEPxEEGbHINI9Uv1cKbq72irzMsd17SsP8vYrTBhJhuOq8pGj105ns
SQf2Ckp20xA0Dm3ttM0G6yVT4MuCuoP64qMjycrvvhUq1V1vJDPFtX9wxvz37i8=
=9FG2
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
