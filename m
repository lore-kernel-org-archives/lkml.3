Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162374Ab3DESQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:16:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56900 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162339Ab3DESQ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:16:57 -0400
Message-ID: <1365185813.25942.12.camel@hornet>
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
        Robert Richter <robert.richter@amd.com>,
        Richard Cochran <richardcochran@gmail.com>
Date: Fri, 05 Apr 2013 19:16:53 +0100
In-Reply-To: <1365092963.26858.107.camel@hornet>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>
	 <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>
	 <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>
	 <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	 <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>
	 <5159D221.70304@linaro.org> <1364889256.16858.1.camel@laptop>
	 <515B0502.8070408@linaro.org> <1365009558.26858.19.camel@hornet>
	 <515C66FE.7030501@linaro.org> <1365010502.26858.32.camel@hornet>
	 <515C6C01.9070905@linaro.org> <1365092963.26858.107.camel@hornet>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 05 Apr 2013 18:16:53.0648 (UTC) FILETIME=[BFFE3900:01CE3229]
X-MC-Unique: 113040519165502301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 17:29 +0100, Pawel Moll wrote:
> > Maybe can we extend the dynamic posix clock code to work on more then 
> > just the chardev? 
> 
> The idea I'm following now is to make the dynamic clock framework even
> more generic, so there could be a clock associated with an arbitrary
> struct file * (the perf syscall is getting one with
> anon_inode_getfile()). I don't know how to get this done yet, but I'll
> give it a try and report.

Ok, so how about the code below? Disclaimer: this is just a proposal.
I'm not sure how welcomed would be an extra field in struct file, but
this makes the clocks ultimately flexible - one can "attach" the clock
to any arbitrary struct file. Alternatively we could mark a "clocked"
file with a special flag in f_mode and have some kind of lookup.

Also, I can't stop thinking that the posix-clock.c shouldn't actually do
anything about the character device... The PTP core (as the model of
using character device seems to me just one of possible choices) could
do this on its own and have simple open/release attaching/detaching the
clock. This would remove a lot of "generic dev" code in the
posix-clock.c and all the optional cdev methods in struct posix_clock.
It's just a thought, though...

And a couple of questions to Richard... Isn't the kref_put() in
posix_clock_unregister() a bug? I'm not 100% but it looks like a simple
register->unregister sequence was making the ref count == -1, so the
delete_clock() won't be called. And was there any particular reason that
the ops in struct posix_clock are *not* a pointer? This makes static
clock declaration a bit cumbersome (I'm not a C language lawyer, but gcc
doesn't let me do simply .ops = other_static_struct_with_ops).

Regards

Pawel

8<-------------------------------------------
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2c28271..4090500 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -804,6 +804,9 @@ struct file {
 #ifdef CONFIG_DEBUG_WRITECOUNT
 	unsigned long f_mnt_write_state;
 #endif
+
+	/* for clock_gettime(FD_TO_CLOCKID(fd)) and friends */
+	struct posix_clock	*posix_clock;
 };
 
 struct file_handle {
diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index 34c4498..85df2c5 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -123,6 +123,10 @@ struct posix_clock {
 	void (*release)(struct posix_clock *clk);
 };
 
+void posix_clock_init(struct posix_clock *clk);
+void posix_clock_attach(struct posix_clock *clk, struct file *fp);
+void posix_clock_detach(struct file *fp);
+
 /**
  * posix_clock_register() - register a new clock
  * @clk:   Pointer to the clock. Caller must provide 'ops' and 'release'
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0cd865..0b70ad1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -34,6 +34,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
 #include <linux/perf_event.h>
+#include <linux/posix-clock.h>
 #include <linux/ftrace_event.h>
 #include <linux/hw_breakpoint.h>
 #include <linux/mm_types.h>
@@ -627,6 +628,25 @@ perf_cgroup_mark_enabled(struct perf_event *event,
 }
 #endif
 
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
+static struct posix_clock perf_posix_clock = {
+	.ops = (struct posix_clock_operations) {
+		.clock_getres = perf_posix_clock_getres,
+		.clock_gettime = perf_posix_clock_gettime,
+	},
+};
+
 void perf_pmu_disable(struct pmu *pmu)
 {
 	int *count = this_cpu_ptr(pmu->pmu_disable_count);
@@ -2992,6 +3012,7 @@ static void put_event(struct perf_event *event)
 
 static int perf_release(struct inode *inode, struct file *file)
 {
+	posix_clock_detach(file);
 	put_event(file->private_data);
 	return 0;
 }
@@ -6671,6 +6692,7 @@ SYSCALL_DEFINE5(perf_event_open,
 	 * perf_group_detach().
 	 */
 	fdput(group);
+	posix_clock_attach(&perf_posix_clock, event_file);
 	fd_install(event_fd, event_file);
 	return event_fd;
 
@@ -7416,6 +7438,8 @@ void __init perf_event_init(void)
 	 */
 	BUILD_BUG_ON((offsetof(struct perf_event_mmap_page, data_head))
 		     != 1024);
+
+	posix_clock_init(&perf_posix_clock);
 }
 
 static int __init perf_event_sysfs_init(void)
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index ce033c7..525fa44 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -25,14 +25,44 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 
-static void delete_clock(struct kref *kref);
+void posix_clock_init(struct posix_clock *clk)
+{
+	kref_init(&clk->kref);
+	init_rwsem(&clk->rwsem);
+}
+EXPORT_SYMBOL_GPL(posix_clock_init);
+
+void posix_clock_attach(struct posix_clock *clk, struct file *fp)
+{
+	kref_get(&clk->kref);
+	fp->posix_clock = clk;
+}
+EXPORT_SYMBOL_GPL(posix_clock_attach);
+
+static void delete_clock(struct kref *kref)
+{
+	struct posix_clock *clk = container_of(kref, struct posix_clock, kref);
+
+	if (clk->release)
+		clk->release(clk);
+}
+
+void posix_clock_detach(struct file *fp)
+{
+	kref_put(&fp->posix_clock->kref, delete_clock);
+	fp->posix_clock = NULL;
+}
+EXPORT_SYMBOL_GPL(posix_clock_detach);
 
 /*
  * Returns NULL if the posix_clock instance attached to 'fp' is old and stale.
  */
 static struct posix_clock *get_posix_clock(struct file *fp)
 {
-	struct posix_clock *clk = fp->private_data;
+	struct posix_clock *clk = fp->posix_clock;
+
+	if (!clk)
+		return NULL;
 
 	down_read(&clk->rwsem);
 
@@ -167,10 +197,8 @@ static int posix_clock_open(struct inode *inode, struct file *fp)
 	else
 		err = 0;
 
-	if (!err) {
-		kref_get(&clk->kref);
-		fp->private_data = clk;
-	}
+	if (!err)
+		posix_clock_attach(clk, fp);
 out:
 	up_read(&clk->rwsem);
 	return err;
@@ -178,15 +206,13 @@ out:
 
 static int posix_clock_release(struct inode *inode, struct file *fp)
 {
-	struct posix_clock *clk = fp->private_data;
+	struct posix_clock *clk = fp->posix_clock;
 	int err = 0;
 
 	if (clk->ops.release)
 		err = clk->ops.release(clk);
 
-	kref_put(&clk->kref, delete_clock);
-
-	fp->private_data = NULL;
+	posix_clock_detach(fp);
 
 	return err;
 }
@@ -210,8 +236,7 @@ int posix_clock_register(struct posix_clock *clk, dev_t devid)
 {
 	int err;
 
-	kref_init(&clk->kref);
-	init_rwsem(&clk->rwsem);
+	posix_clock_init(clk);
 
 	cdev_init(&clk->cdev, &posix_clock_file_operations);
 	clk->cdev.owner = clk->ops.owner;
@@ -221,14 +246,6 @@ int posix_clock_register(struct posix_clock *clk, dev_t devid)
 }
 EXPORT_SYMBOL_GPL(posix_clock_register);
 
-static void delete_clock(struct kref *kref)
-{
-	struct posix_clock *clk = container_of(kref, struct posix_clock, kref);
-
-	if (clk->release)
-		clk->release(clk);
-}
-
 void posix_clock_unregister(struct posix_clock *clk)
 {
 	cdev_del(&clk->cdev);
@@ -249,22 +266,19 @@ struct posix_clock_desc {
 static int get_clock_desc(const clockid_t id, struct posix_clock_desc *cd)
 {
 	struct file *fp = fget(CLOCKID_TO_FD(id));
-	int err = -EINVAL;
 
 	if (!fp)
-		return err;
-
-	if (fp->f_op->open != posix_clock_open || !fp->private_data)
-		goto out;
+		return -EINVAL;
 
 	cd->fp = fp;
 	cd->clk = get_posix_clock(fp);
 
-	err = cd->clk ? 0 : -ENODEV;
-out:
-	if (err)
+	if (!cd->clk) {
 		fput(fp);
-	return err;
+		return -ENODEV;
+	}
+
+	return 0;
 }
 
 static void put_clock_desc(struct posix_clock_desc *cd)




