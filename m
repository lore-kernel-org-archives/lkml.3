Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508AbaDHU5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:57:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56598 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaDHU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:57:14 -0400
Date: Tue, 8 Apr 2014 13:57:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd V2
Message-Id: <20140408135712.c761d7b01bd451be5fc41c00@linux-foundation.org>
In-Reply-To: <20131108200620.GC14606@localhost.localdomain>
References: <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org>
	<00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
	<20131017122344.39d55db97c3923131bdf2831@linux-foundation.org>
	<0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com>
	<20131107225049.GC28130@localhost.localdomain>
	<0000014238407a1c-34e7bdbc-45c0-48de-a8a3-94a99f276044-000000@email.amazonses.com>
	<20131108163112.GA12853@localhost.localdomain>
	<0000014238ad0fb9-aa252280-8e44-48ac-a096-e6dee26e09ea-000000@email.amazonses.com>
	<20131108191235.GB12853@localhost.localdomain>
	<000001423945fde3-f846f403-58b9-4acd-a2b8-43b62991ce02-000000@email.amazonses.com>
	<20131108200620.GC14606@localhost.localdomain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013 21:06:22 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Nov 08, 2013 at 07:52:37PM +0000, Christoph Lameter wrote:
> > On Fri, 8 Nov 2013, Frederic Weisbecker wrote:
> > 
> > > I understand, but why not solving that from the workqueue affinity? We want to
> > > solve the issue of unbound workqueues in CPU isolation anyway.
> > 
> > Sure if you can solve that with an unbound work queue then this patch is
> > not needed. Do you have a patch that addresses this issue in your
> > patchset?
> 
> No. Sorry.
> 

Several months have passed and nothgin has happened.  Any thoughts on
what we should do with Christoph's patch?


From: Christoph Lameter <cl@linux.com>
Subject: kmod: run usermodehelpers only on cpus allowed for kthreadd V2

usermodehelper() threads can currently run on all processors.  This is an
issue for low latency cores.  Spawnig a new thread causes cpu holdoffs in
the range of hundreds of microseconds to a few milliseconds.  Not good for
cores on which processes run that need to react as fast as possible.

kthreadd threads can be restricted using taskset to a limited set of
processors.  Then the kernel thread pool will not fork processes on those
anymore thereby protecting those processors from additional latencies.

Make usermodehelper() threads obey the limitations that kthreadd is
restricted to.  Kthreadd is not the parent of usermodehelper threads so we
need to explicitly get the allowed processors for kthreadd.

Before this patch there is no way to limit the cpus that usermodehelper
can run on since the affinity is set when the thread is spawned to all
processors.

[akpm@linux-foundation.org: set_cpus_allowed() doesn't exist when CONFIG_CPUMASK_OFFSTACK=y]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kthread.h |    1 +
 kernel/kmod.c           |   11 +++++++++--
 kernel/kthread.c        |    9 +++++++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff -puN include/linux/kthread.h~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2 include/linux/kthread.h
--- a/include/linux/kthread.h~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2
+++ a/include/linux/kthread.h
@@ -51,6 +51,7 @@ void kthread_parkme(void);
 int kthreadd(void *unused);
 extern struct task_struct *kthreadd_task;
 extern int tsk_fork_get_node(struct task_struct *tsk);
+void set_kthreadd_affinity(void);
 
 /*
  * Simple work processor based on kthread.
diff -puN kernel/kmod.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2 kernel/kmod.c
--- a/kernel/kmod.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2
+++ a/kernel/kmod.c
@@ -40,6 +40,7 @@
 #include <linux/ptrace.h>
 #include <linux/async.h>
 #include <asm/uaccess.h>
+#include <linux/kthread.h>
 
 #include <trace/events/module.h>
 
@@ -209,8 +210,14 @@ static int ____call_usermodehelper(void
 	flush_signal_handlers(current, 1);
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* We can run anywhere, unlike our parent keventd(). */
-	set_cpus_allowed_ptr(current, cpu_all_mask);
+	/*
+	 * Kthreadd can be restricted to a set of processors if the user wants
+	 * to protect other processors from OS latencies. If that has happened
+	 * then we do not want to disturb the other processors here either so we
+	 * start the usermode helper threads only on the processors allowed for
+	 * kthreadd.
+	 */
+	set_kthreadd_affinity();
 
 	/*
 	 * Our parent is keventd, which runs with elevated scheduling priority.
diff -puN kernel/kthread.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2 kernel/kthread.c
--- a/kernel/kthread.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2
+++ a/kernel/kthread.c
@@ -136,6 +136,15 @@ void *kthread_data(struct task_struct *t
 	return to_kthread(task)->data;
 }
 
+/*
+ * Set the affinity of the calling task to be the same
+ * as the kthreadd affinities.
+ */
+void set_kthreadd_affinity(void)
+{
+	set_cpus_allowed_ptr(current, &kthreadd_task->cpus_allowed);
+}
+
 /**
  * probe_kthread_data - speculative version of kthread_data()
  * @task: possible kthread task in question
_

