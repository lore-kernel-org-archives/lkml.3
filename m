Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762759Ab3DCRTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:19:25 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54906 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762298Ab3DCRTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:19:23 -0400
Message-ID: <1365009558.26858.19.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Date: Wed, 03 Apr 2013 18:19:18 +0100
In-Reply-To: <515B0502.8070408@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>
	 <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>
	 <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>
	 <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	 <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>
	 <5159D221.70304@linaro.org> <1364889256.16858.1.camel@laptop>
	 <515B0502.8070408@linaro.org>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 03 Apr 2013 17:19:18.0183 (UTC) FILETIME=[5F8C9B70:01CE308F]
X-MC-Unique: 113040318191908501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 17:19 +0100, John Stultz wrote:
> But if we're going to have to do 
> this via a clockid, I'm going to want it to be done via a dynamic posix 
> clockid, so its clear its tightly tied with perf and not considered a 
> generic interface (and I can clearly point folks having problems to the 
> perf maintainers ;).

Ok, so how about the code below?

There are two distinct parts of the "solution":

1. The dynamic posix clock, as you suggested. Then one can get the perf
timestamp by doing:

	clock_fd = open("/dev/perf-clock", O_RDONLY);
	clock_gettime(FD_TO_CLOCKID(clock_fd), &ts) 

2. A sort-of-hack in the get_posix_clock() function making it possible
to do the same using the perf event file descriptor, eg.:

	fd = sys_perf_event_open(&attr, -1, 0, -1, 0);
	clock_gettime(FD_TO_CLOCKID(fd), &ts) 

Any (either strong or not) opinions?

Pawel

8<--------------
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index e47ee46..b2127e3 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -52,6 +52,7 @@ struct perf_guest_info_callbacks {
 #include <linux/atomic.h>
 #include <linux/sysfs.h>
 #include <linux/perf_regs.h>
+#include <linux/posix-clock.h>
 #include <asm/local.h>
 
 struct perf_callchain_entry {
@@ -845,4 +846,6 @@ _name##_show(struct device *dev,					\
 									\
 static struct device_attribute format_attr_##_name = __ATTR_RO(_name)
 
+struct posix_clock *perf_get_posix_clock(struct file *fp);
+
 #endif /* _LINUX_PERF_EVENT_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..534cb43 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7446,6 +7446,49 @@ unlock:
 }
 device_initcall(perf_event_sysfs_init);
 
+static int perf_posix_clock_getres(struct posix_clock *pc, struct timespec *tp)
+{
+	*tp = ns_to_timespec(TICK_NSEC);
+	return 0;
+}
+
+static int perf_posix_clock_gettime(struct posix_clock *pc, struct timespec *tp)
+{
+	*tp = ns_to_timespec(perf_clock());
+	return 0;
+}
+
+static const struct posix_clock_operations perf_posix_clock_ops = {
+	.clock_getres = perf_posix_clock_getres,
+	.clock_gettime = perf_posix_clock_gettime,
+};
+
+static struct posix_clock perf_posix_clock;
+
+struct posix_clock *perf_get_posix_clock(struct file *fp)
+{
+	if (!fp || fp->f_op != &perf_fops)
+		return NULL;
+
+	down_read(&perf_posix_clock.rwsem);
+
+	return &perf_posix_clock;
+}
+
+static int __init perf_posix_clock_init(void)
+{
+	dev_t devt;
+	int ret;
+
+	ret = alloc_chrdev_region(&devt, 0, 1, "perf-clock");
+	if (ret)
+		return ret;
+
+	perf_posix_clock.ops = perf_posix_clock_ops;
+	return posix_clock_register(&perf_posix_clock, devt);
+}
+device_initcall(perf_posix_clock_init);
+
 #ifdef CONFIG_CGROUP_PERF
 static struct cgroup_subsys_state *perf_cgroup_css_alloc(struct cgroup *cont)
 {
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index ce033c7..e2a40a5 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/export.h>
 #include <linux/file.h>
+#include <linux/perf_event.h>
 #include <linux/posix-clock.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
@@ -249,16 +250,21 @@ struct posix_clock_desc {
 static int get_clock_desc(const clockid_t id, struct posix_clock_desc *cd)
 {
 	struct file *fp = fget(CLOCKID_TO_FD(id));
+	struct posix_clock *perf_clk = NULL;
 	int err = -EINVAL;
 
 	if (!fp)
 		return err;
 
-	if (fp->f_op->open != posix_clock_open || !fp->private_data)
+#if defined(CONFIG_PERF_EVENTS)
+	perf_clk = perf_get_posix_clock(fp);
+#endif
+	if ((fp->f_op->open != posix_clock_open || !fp->private_data) &&
+			!perf_clk)
 		goto out;
 
 	cd->fp = fp;
-	cd->clk = get_posix_clock(fp);
+	cd->clk = perf_clk ? perf_clk : get_posix_clock(fp);
 
 	err = cd->clk ? 0 : -ENODEV;
 out:



