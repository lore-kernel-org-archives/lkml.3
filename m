Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab3CPDcT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 23:32:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22538 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab3CPDbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 23:31:44 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=G2BLRGcs8awA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=1pgACC7SDmEA:10 a=x5kafOpMXDvAhhSY0AEA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=CIqiEw-h3WsMgrlM:21 a=pUsAIZbHjAsfaCYI:21 a=fCu7sSo8eX-ND7X1erkA:9 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130316033142.223257598@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 15 Mar 2013 23:24:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [for-next][PATCH 1/9] ring-buffer: Add ring buffer startup selftest
References: <20130316032412.416651612@goodmis.org>
Content-Disposition: inline; filename=0001-ring-buffer-Add-ring-buffer-startup-selftest.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

When testing my large changes to the ftrace system, there was
a bug that looked like the ring buffer was dropping events.
I wrote up a quick integrity checker of the ring buffer to
see if it was.

Although the bug ended up being something stupid I did in ftrace,
and had nothing to do with the ring buffer, I figured if I spent
the time to write up this test, I might as well include it in the
kernel.

I cleaned it up a bit, as the original version was rather ugly.
Not saying this version is pretty, but it's a beauty queen
compared to what I original wrote.

To enable the start up test, set CONFIG_RING_BUFFER_STARTUP_TEST.

Note, it runs for 10 seconds, so it will slow your boot time
by at least 10 more seconds.

What it does is documented in both the comments and the Kconfig
help.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig       |   23 ++++
 kernel/trace/ring_buffer.c |  319 ++++++++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 342 insertions(+)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index f78eab2..0b5ecf5 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -565,6 +565,29 @@ config RING_BUFFER_BENCHMARK
=20
 	  If unsure, say N.
=20
+config RING_BUFFER_STARTUP_TEST
+       bool "Ring buffer startup self test"
+       depends on RING_BUFFER
+       help
+         Run a simple self test on the ring buffer on boot up. Late in the
+	 kernel boot sequence, the test will start that kicks off
+	 a thread per cpu. Each thread will write various size events
+	 into the ring buffer. Another thread is created to send IPIs
+	 to each of the threads, where the IPI handler will also write
+	 to the ring buffer, to test/stress the nesting ability.
+	 If any anomalies are discovered, a warning will be displayed
+	 and all ring buffers will be disabled.
+
+	 The test runs for 10 seconds. This will slow your boot time
+	 by at least 10 more seconds.
+
+	 At the end of the test, statics and more checks are done.
+	 It will output the stats of each per cpu buffer. What
+	 was written, the sizes, what was read, what was lost, and
+	 other similar details.
+
+	 If unsure, say N
+
 endif # FTRACE
=20
 endif # TRACING_SUPPORT
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index d1c85c5..e5472f7 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -12,10 +12,12 @@
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
+#include <linux/kthread.h>	/* for self test */
 #include <linux/kmemcheck.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/mutex.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/hash.h>
@@ -4634,3 +4636,320 @@ static int rb_cpu_notify(struct notifier_block *sel=
f,
 	return NOTIFY_OK;
 }
 #endif
+
+#ifdef CONFIG_RING_BUFFER_STARTUP_TEST
+/*
+ * This is a basic integrity check of the ring buffer.
+ * Late in the boot cycle this test will run when configured in.
+ * It will kick off a thread per CPU that will go into a loop
+ * writing to the per cpu ring buffer various sizes of data.
+ * Some of the data will be large items, some small.
+ *
+ * Another thread is created that goes into a spin, sending out
+ * IPIs to the other CPUs to also write into the ring buffer.
+ * this is to test the nesting ability of the buffer.
+ *
+ * Basic stats are recorded and reported. If something in the
+ * ring buffer should happen that's not expected, a big warning
+ * is displayed and all ring buffers are disabled.
+ */
+static struct task_struct *rb_threads[NR_CPUS] __initdata;
+
+struct rb_test_data {
+	struct ring_buffer	*buffer;
+	unsigned long		events;
+	unsigned long		bytes_written;
+	unsigned long		bytes_alloc;
+	unsigned long		bytes_dropped;
+	unsigned long		events_nested;
+	unsigned long		bytes_written_nested;
+	unsigned long		bytes_alloc_nested;
+	unsigned long		bytes_dropped_nested;
+	int			min_size_nested;
+	int			max_size_nested;
+	int			max_size;
+	int			min_size;
+	int			cpu;
+	int			cnt;
+};
+
+static struct rb_test_data rb_data[NR_CPUS] __initdata;
+
+/* 1 meg per cpu */
+#define RB_TEST_BUFFER_SIZE	1048576
+
+static char rb_string[] __initdata =3D
+	"abcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()?+\\"
+	"?+|:';\",.<>/?abcdefghijklmnopqrstuvwxyz1234567890"
+	"!@#$%^&*()?+\\?+|:';\",.<>/?abcdefghijklmnopqrstuv";
+
+static bool rb_test_started __initdata;
+
+struct rb_item {
+	int size;
+	char str[];
+};
+
+static __init int rb_write_something(struct rb_test_data *data, bool neste=
d)
+{
+	struct ring_buffer_event *event;
+	struct rb_item *item;
+	bool started;
+	int event_len;
+	int size;
+	int len;
+	int cnt;
+
+	/* Have nested writes different that what is written */
+	cnt =3D data->cnt + (nested ? 27 : 0);
+
+	/* Multiply cnt by ~e, to make some unique increment */
+	size =3D (data->cnt * 68 / 25) % (sizeof(rb_string) - 1);
+
+	len =3D size + sizeof(struct rb_item);
+
+	started =3D rb_test_started;
+	/* read rb_test_started before checking buffer enabled */
+	smp_rmb();
+
+	event =3D ring_buffer_lock_reserve(data->buffer, len);
+	if (!event) {
+		/* Ignore dropped events before test starts. */
+		if (started) {
+			if (nested)
+				data->bytes_dropped +=3D len;
+			else
+				data->bytes_dropped_nested +=3D len;
+		}
+		return len;
+	}
+
+	event_len =3D ring_buffer_event_length(event);
+
+	if (RB_WARN_ON(data->buffer, event_len < len))
+		goto out;
+
+	item =3D ring_buffer_event_data(event);
+	item->size =3D size;
+	memcpy(item->str, rb_string, size);
+
+	if (nested) {
+		data->bytes_alloc_nested +=3D event_len;
+		data->bytes_written_nested +=3D len;
+		data->events_nested++;
+		if (!data->min_size_nested || len < data->min_size_nested)
+			data->min_size_nested =3D len;
+		if (len > data->max_size_nested)
+			data->max_size_nested =3D len;
+	} else {
+		data->bytes_alloc +=3D event_len;
+		data->bytes_written +=3D len;
+		data->events++;
+		if (!data->min_size || len < data->min_size)
+			data->max_size =3D len;
+		if (len > data->max_size)
+			data->max_size =3D len;
+	}
+
+ out:
+	ring_buffer_unlock_commit(data->buffer, event);
+
+	return 0;
+}
+
+static __init int rb_test(void *arg)
+{
+	struct rb_test_data *data =3D arg;
+
+	while (!kthread_should_stop()) {
+		rb_write_something(data, false);
+		data->cnt++;
+
+		set_current_state(TASK_INTERRUPTIBLE);
+		/* Now sleep between a min of 100-300us and a max of 1ms */
+		usleep_range(((data->cnt % 3) + 1) * 100, 1000);
+	}
+
+	return 0;
+}
+
+static __init void rb_ipi(void *ignore)
+{
+	struct rb_test_data *data;
+	int cpu =3D smp_processor_id();
+
+	data =3D &rb_data[cpu];
+	rb_write_something(data, true);
+}
+
+static __init int rb_hammer_test(void *arg)
+{
+	while (!kthread_should_stop()) {
+
+		/* Send an IPI to all cpus to write data! */
+		smp_call_function(rb_ipi, NULL, 1);
+		/* No sleep, but for non preempt, let others run */
+		schedule();
+	}
+
+	return 0;
+}
+
+static __init int test_ringbuffer(void)
+{
+	struct task_struct *rb_hammer;
+	struct ring_buffer *buffer;
+	int cpu;
+	int ret =3D 0;
+
+	pr_info("Running ring buffer tests...\n");
+
+	buffer =3D ring_buffer_alloc(RB_TEST_BUFFER_SIZE, RB_FL_OVERWRITE);
+	if (WARN_ON(!buffer))
+		return 0;
+
+	/* Disable buffer so that threads can't write to it yet */
+	ring_buffer_record_off(buffer);
+
+	for_each_online_cpu(cpu) {
+		rb_data[cpu].buffer =3D buffer;
+		rb_data[cpu].cpu =3D cpu;
+		rb_data[cpu].cnt =3D cpu;
+		rb_threads[cpu] =3D kthread_create(rb_test, &rb_data[cpu],
+						 "rbtester/%d", cpu);
+		if (WARN_ON(!rb_threads[cpu])) {
+			pr_cont("FAILED\n");
+			ret =3D -1;
+			goto out_free;
+		}
+
+		kthread_bind(rb_threads[cpu], cpu);
+ 		wake_up_process(rb_threads[cpu]);
+	}
+
+	/* Now create the rb hammer! */
+	rb_hammer =3D kthread_run(rb_hammer_test, NULL, "rbhammer");
+	if (WARN_ON(!rb_hammer)) {
+		pr_cont("FAILED\n");
+		ret =3D -1;
+		goto out_free;
+	}
+
+	ring_buffer_record_on(buffer);
+	/*
+	 * Show buffer is enabled before setting rb_test_started.
+	 * Yes there's a small race window where events could be
+	 * dropped and the thread wont catch it. But when a ring
+	 * buffer gets enabled, there will always be some kind of
+	 * delay before other CPUs see it. Thus, we don't care about
+	 * those dropped events. We care about events dropped after
+	 * the threads see that the buffer is active.
+	 */
+	smp_wmb();
+	rb_test_started =3D true;
+
+	set_current_state(TASK_INTERRUPTIBLE);
+	/* Just run for 10 seconds */;
+	schedule_timeout(10 * HZ);
+
+	kthread_stop(rb_hammer);
+
+ out_free:
+	for_each_online_cpu(cpu) {
+		if (!rb_threads[cpu])
+			break;
+		kthread_stop(rb_threads[cpu]);
+	}
+	if (ret) {
+		ring_buffer_free(buffer);
+		return ret;
+	}
+
+	/* Report! */
+	pr_info("finished\n");
+	for_each_online_cpu(cpu) {
+		struct ring_buffer_event *event;
+		struct rb_test_data *data =3D &rb_data[cpu];
+		struct rb_item *item;
+		unsigned long total_events;
+		unsigned long total_dropped;
+		unsigned long total_written;
+		unsigned long total_alloc;
+		unsigned long total_read =3D 0;
+		unsigned long total_size =3D 0;
+		unsigned long total_len =3D 0;
+		unsigned long total_lost =3D 0;
+		unsigned long lost;
+		int big_event_size;
+		int small_event_size;
+
+		ret =3D -1;
+
+		total_events =3D data->events + data->events_nested;
+		total_written =3D data->bytes_written + data->bytes_written_nested;
+		total_alloc =3D data->bytes_alloc + data->bytes_alloc_nested;
+		total_dropped =3D data->bytes_dropped + data->bytes_dropped_nested;
+
+		big_event_size =3D data->max_size + data->max_size_nested;
+		small_event_size =3D data->min_size + data->min_size_nested;
+
+		pr_info("CPU %d:\n", cpu);
+		pr_info("              events:    %ld\n", total_events);
+		pr_info("       dropped bytes:    %ld\n", total_dropped);
+		pr_info("       alloced bytes:    %ld\n", total_alloc);
+		pr_info("       written bytes:    %ld\n", total_written);
+		pr_info("       biggest event:    %d\n", big_event_size);
+		pr_info("      smallest event:    %d\n", small_event_size);
+
+		if (RB_WARN_ON(buffer, total_dropped))
+			break;
+
+		ret =3D 0;
+
+		while ((event =3D ring_buffer_consume(buffer, cpu, NULL, &lost))) {
+			total_lost +=3D lost;
+			item =3D ring_buffer_event_data(event);
+			total_len +=3D ring_buffer_event_length(event);
+			total_size +=3D item->size + sizeof(struct rb_item);
+			if (memcmp(&item->str[0], rb_string, item->size) !=3D 0) {
+				pr_info("FAILED!\n");
+				pr_info("buffer had: %.*s\n", item->size, item->str);
+				pr_info("expected:   %.*s\n", item->size, rb_string);
+				RB_WARN_ON(buffer, 1);
+				ret =3D -1;
+				break;
+			}
+			total_read++;
+		}
+		if (ret)
+			break;
+
+		ret =3D -1;
+
+		pr_info("         read events:   %ld\n", total_read);
+		pr_info("         lost events:   %ld\n", total_lost);
+		pr_info("        total events:   %ld\n", total_lost + total_read);
+		pr_info("  recorded len bytes:   %ld\n", total_len);
+		pr_info(" recorded size bytes:   %ld\n", total_size);
+		if (total_lost)
+			pr_info(" With dropped events, record len and size may not match\n"
+				" alloced and written from above\n");
+		if (!total_lost) {
+			if (RB_WARN_ON(buffer, total_len !=3D total_alloc ||
+				       total_size !=3D total_written))
+				break;
+		}
+		if (RB_WARN_ON(buffer, total_lost + total_read !=3D total_events))
+			break;
+
+		ret =3D 0;
+	}
+	if (!ret)
+		pr_info("Ring buffer PASSED!\n");
+
+	ring_buffer_free(buffer);
+	return 0;
+}
+
+late_initcall(test_ringbuffer);
+#endif /* CONFIG_RING_BUFFER_STARTUP_TEST */
--=20
1.7.10.4



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABAgAGBQJRQ+eeAAoJEOdOSU1xswtMXlEIALodF7Tg6yThN9SKehabSmnG
lGv6r3hZQs9zVjY/4BeOwDj+inWdggA3gi5ze8dG4qDgiIfKlrdY34JeKQ9IdCmR
e5YX7+GwYuqpFEIphdKaXq5eJ99KEHER+8mJSlUxp55ok7V3XOQQtOtxRDHkxicK
TuFYOpPOHBYHb7eWp+rJ4RKOPPQEgAk7Z5x7Ke/tYAFirN/MNBSE5xJmvPU54zt1
oaFfa/9MfGwNhO9RUzDKMtwZHEjYf/fqCRARsbaaemHSa3ghMbVh0deYQOA/BkvO
a8Zqp2ppqcWe9g0WwOAkZHRimiIOMXmTVa6cvUEFGgO7RpqlaHbI4xVUOmd3Epc=
=cCZh
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
