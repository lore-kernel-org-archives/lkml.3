Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab3CPDcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225Ab3CPDbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:47 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=09nJGDjnI7QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KT4Yw0wyyfoA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=PHo0CsLH493t_rUCqXoA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=hPjdaMEvmhQA:10 a=Zh68SRI7RUMA:10 a=MSl-tDqOz04A:10 a=Dq9v3A9vL-LZP2r7PtUA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316033143.553069781@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>, <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [for-next][PATCH 8/9] tracing: Fix ftrace_dump()
References: <20130316032412.416651612@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-Fix-ftrace_dump.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

ftrace_dump() had a lot of issues. What ftrace_dump() does, is when
ftrace_dump_on_oops is set (via a kernel parameter or sysctl), it
will dump out the ftrace buffers to the console when either a oops,
panic, or a sysrq-z occurs.

This was written a long time ago when ftrace was fragile to recursion.
But it wasn't written well even for that.

There's a possible deadlock that can occur if a ftrace_dump() is happening
and an NMI triggers another dump. This is because it grabs a lock
before checking if the dump ran.

It also totally disables ftrace, and tracing for no good reasons.

As the ring_buffer now checks if it is read via a oops or NMI, where
there's a chance that the buffer gets corrupted, it will disable
itself. No need to have ftrace_dump() do the same.

ftrace_dump() is now cleaned up where it uses an atomic counter to
make sure only one dump happens at a time. A simple atomic_inc_return()
is enough that is needed for both other CPUs and NMIs. No need for
a spinlock, as if one CPU is running the dump, no other CPU needs
to do it too.

The tracing_on variable is turned off and not turned on. The original
code did this, but it wasn't pretty. By just disabling this variable
we get the result of not seeing traces that happen between crashes.

For sysrq-z, it doesn't get turned on, but the user can always write
a '1' to the tracing_on file. If they are using sysrq-z, then they should
know about tracing_on.

The new code is much easier to read and less error prone. No more
deadlock possibility when an NMI triggers here.

Reported-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c          |   62 +++++++++++++++++--------------------=
----
 kernel/trace/trace_selftest.c |    9 +++---
 2 files changed, 31 insertions(+), 40 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8486256..3dc7999 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5997,36 +5997,32 @@ void trace_init_global_iter(struct trace_iterator *=
iter)
 	iter->trace_buffer =3D &global_trace.trace_buffer;
 }
=20
-static void
-__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
+void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
 {
-	static arch_spinlock_t ftrace_dump_lock =3D
-		(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
+	static atomic_t dump_running;
 	unsigned int old_userobj;
-	static int dump_ran;
 	unsigned long flags;
 	int cnt =3D 0, cpu;
=20
-	/* only one dump */
-	local_irq_save(flags);
-	arch_spin_lock(&ftrace_dump_lock);
-	if (dump_ran)
-		goto out;
-
-	dump_ran =3D 1;
+	/* Only allow one dump user at a time. */
+	if (atomic_inc_return(&dump_running) !=3D 1) {
+		atomic_dec(&dump_running);
+		return;
+	}
=20
+	/*
+	 * Always turn off tracing when we dump.
+	 * We don't need to show trace output of what happens
+	 * between multiple crashes.
+	 *
+	 * If the user does a sysrq-z, then they can re-enable
+	 * tracing with echo 1 > tracing_on.
+	 */
 	tracing_off();
=20
-	/* Did function tracer already get disabled? */
-	if (ftrace_is_dead()) {
-		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
-		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
-	}
-
-	if (disable_tracing)
-		ftrace_kill();
+	local_irq_save(flags);
=20
 	/* Simulate the iterator */
 	trace_init_global_iter(&iter);
@@ -6056,6 +6052,12 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump=
_mode oops_dump_mode)
=20
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
=20
+	/* Did function tracer already get disabled? */
+	if (ftrace_is_dead()) {
+		printk("# WARNING: FUNCTION TRACING IS CORRUPTED\n");
+		printk("#          MAY BE MISSING FUNCTION EVENTS\n");
+	}
+
 	/*
 	 * We need to stop all tracing on all CPUS to read the
 	 * the next buffer. This is a bit expensive, but is
@@ -6095,26 +6097,14 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dum=
p_mode oops_dump_mode)
 		printk(KERN_TRACE "---------------------------------\n");
=20
  out_enable:
-	/* Re-enable tracing if requested */
-	if (!disable_tracing) {
-		trace_flags |=3D old_userobj;
+	trace_flags |=3D old_userobj;
=20
-		for_each_tracing_cpu(cpu) {
-			atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
-		}
-		tracing_on();
+	for_each_tracing_cpu(cpu) {
+		atomic_dec(&per_cpu_ptr(iter.trace_buffer->data, cpu)->disabled);
 	}
-
- out:
-	arch_spin_unlock(&ftrace_dump_lock);
+ 	atomic_dec(&dump_running);
 	local_irq_restore(flags);
 }
-
-/* By default: disable tracing after the dump */
-void ftrace_dump(enum ftrace_dump_mode oops_dump_mode)
-{
-	__ftrace_dump(true, oops_dump_mode);
-}
 EXPORT_SYMBOL_GPL(ftrace_dump);
=20
 __init static int tracer_alloc_buffers(void)
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 8672c40..55e2cf6 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -703,8 +703,6 @@ trace_selftest_startup_function(struct tracer *trace, s=
truct trace_array *tr)
 /* Maximum number of functions to trace before diagnosing a hang */
 #define GRAPH_MAX_FUNC_TEST	100000000
=20
-static void
-__ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode);
 static unsigned int graph_hang_thresh;
=20
 /* Wrap the real function entry probe to avoid possible hanging */
@@ -714,8 +712,11 @@ static int trace_graph_entry_watchdog(struct ftrace_gr=
aph_ent *trace)
 	if (unlikely(++graph_hang_thresh > GRAPH_MAX_FUNC_TEST)) {
 		ftrace_graph_stop();
 		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
-		if (ftrace_dump_on_oops)
-			__ftrace_dump(false, DUMP_ALL);
+		if (ftrace_dump_on_oops) {
+			ftrace_dump(DUMP_ALL);
+			/* ftrace_dump() disables tracing */
+			tracing_on();
+		}
 		return 0;
 	}
=20
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+efAAoJEOdOSU1xswtMUnQH/1XlD4ED1ivSPSpP2K3dVSws
pkPpw0jCTjSRB7OC43aw30mETS0URwazf0wvZtnsTPk2ZYuxboo0zzrwrny+GQL4
bfrTiREdB87ZedVOEiX0O4J1/TrVVbrcIyIk/XcOq40+Rlp9LXuOT1uP890hJ9EY
lFL47Plf1KVg+n3ugI+LjVNGi/90YQNZuc6NEl2c7ggAfDl6lRRz9IJqO6M6Uqvc
L0UEjKoCOTb0QDVCbBhZ1PO1qpeByTLF0Aqcay1/QphLUuIywQiBV/B7QOk4aT1j
MuTkF8MCoyyi3rjqVATbqj6BrxW2MZYVEouLFTJNZhZnwHGclaYZ8keqs/E0aec=
=sJED
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
