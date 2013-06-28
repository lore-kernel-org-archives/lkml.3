Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3F1Ho0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:44:26 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:64586 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab3F1HoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:44:23 -0400
Date: Fri, 28 Jun 2013 10:44:03 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH] cpu hotplug: rework cpu_hotplug locking (was
 [LOCKDEP] cpufreq: possible circular locking dependency detected)
Message-ID: <20130628074403.GA2201@swordfish>
References: <20130625211544.GA2270@swordfish>
 <CAKohpo=ij+LTB80FtVFQZa_4uh-fceG80GBhGnhbxKio7N-Zuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=ij+LTB80FtVFQZa_4uh-fceG80GBhGnhbxKio7N-Zuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/28/13 10:13), Viresh Kumar wrote:
> On 26 June 2013 02:45, Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> >
> > [   60.277396] ======================================================
> > [   60.277400] [ INFO: possible circular locking dependency detected ]
> > [   60.277407] 3.10.0-rc7-dbg-01385-g241fd04-dirty #1744 Not tainted
> > [   60.277411] -------------------------------------------------------
> > [   60.277417] bash/2225 is trying to acquire lock:
> > [   60.277422]  ((&(&j_cdbs->work)->work)){+.+...}, at: [<ffffffff810621b5>] flush_work+0x5/0x280
> > [   60.277444]
> > but task is already holding lock:
> > [   60.277449]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81042d8b>] cpu_hotplug_begin+0x2b/0x60
> > [   60.277465]
> > which lock already depends on the new lock.
> 
> Hi Sergey,
> 
> Can you try reverting this patch?
> 
> commit 2f7021a815f20f3481c10884fe9735ce2a56db35
> Author: Michael Wang <wangyun@linux.vnet.ibm.com>
> Date:   Wed Jun 5 08:49:37 2013 +0000
> 
>     cpufreq: protect 'policy->cpus' from offlining during __gov_queue_work()
> 

Hello,
Yes, this helps, of course, but at the same time it returns the previous
problem -- preventing cpu_hotplug in some places.


I have a bit different (perhaps naive) RFC patch and would like to hear
comments.



The idead is to brake existing lock dependency chain by not holding
cpu_hotplug lock mutex across the calls. In order to detect active
refcount readers or active writer, refcount now may have the following
values:

-1: active writer -- only one writer may be active, readers are blocked
 0: no readers/writer
>0: active readers -- many readers may be active, writer is blocked

"blocked" reader or writer goes to wait_queue. as soon as writer finishes
(refcount becomes 0), it wakeups all existing processes in a wait_queue.
reader perform wakeup call only when it sees that pending writer is present
(active_writer is not NULL).

cpu_hotplug lock now only required to protect refcount cmp, inc, dec
operations so it can be changed to spinlock.

The patch has survived the initial beating:

echo 0 > /sys/devices/system/cpu/cpu2/online 
echo 0 > /sys/devices/system/cpu/cpu3/online 
echo 1 > /sys/devices/system/cpu/cpu3/online 
echo 1 > /sys/devices/system/cpu/cpu2/online 
echo 0 > /sys/devices/system/cpu/cpu1/online 
echo 0 > /sys/devices/system/cpu/cpu3/online 
echo 1 > /sys/devices/system/cpu/cpu1/online 
echo 1 > /sys/devices/system/cpu/cpu3/online 
echo 0 > /sys/devices/system/cpu/cpu2/online 
echo 0 > /sys/devices/system/cpu/cpu1/online 
echo 0 > /sys/devices/system/cpu/cpu3/online 
echo 1 > /sys/devices/system/cpu/cpu3/online 
echo 1 > /sys/devices/system/cpu/cpu1/online 
echo 0 > /sys/devices/system/cpu/cpu1/online 
echo 1 > /sys/devices/system/cpu/cpu2/online 
echo 1 > /sys/devices/system/cpu/cpu1/online 
echo 0 > /sys/devices/system/cpu/cpu3/online 
echo 1 > /sys/devices/system/cpu/cpu3/online 


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 kernel/cpu.c | 75 ++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 55 insertions(+), 20 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 198a388..7fa7b0f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -50,17 +50,25 @@ static int cpu_hotplug_disabled;
 #ifdef CONFIG_HOTPLUG_CPU
 
 static struct {
-	struct task_struct *active_writer;
-	struct mutex lock; /* Synchronizes accesses to refcount, */
-	/*
-	 * Also blocks the new readers during
-	 * an ongoing cpu hotplug operation.
+	/* Synchronizes accesses to refcount, also blocks the new readers
+	 * during an ongoing cpu hotplug operation.
+	 */
+	spinlock_t lock;
+	/* -1: active cpu hotplug process
+	 *  0: unlocked
+	 * >0: active fercount readers
 	 */
 	int refcount;
+	struct task_struct *active_writer;
+	/* Wait queue for new refcount readers during an ongoing
+	 * cpu hotplug operation.
+	 */
+	wait_queue_head_t wait;
 } cpu_hotplug = {
-	.active_writer = NULL,
-	.lock = __MUTEX_INITIALIZER(cpu_hotplug.lock),
+	.lock = __SPIN_LOCK_INITIALIZER(cpu_hotplug.lock),
 	.refcount = 0,
+	.active_writer = NULL,
+	.wait = __WAIT_QUEUE_HEAD_INITIALIZER(cpu_hotplug.wait),
 };
 
 void get_online_cpus(void)
@@ -68,10 +76,24 @@ void get_online_cpus(void)
 	might_sleep();
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
 
+	for (;;) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		spin_lock(&cpu_hotplug.lock);
+		if (++cpu_hotplug.refcount > 0) {
+			spin_unlock(&cpu_hotplug.lock);
+			break;
+		}
+		/* Ongoing cpu hotplug process */
+		cpu_hotplug.refcount--;
+		add_wait_queue(&cpu_hotplug.wait, &wait);
+		__set_current_state(TASK_UNINTERRUPTIBLE);
+	
+		spin_unlock(&cpu_hotplug.lock);
+		schedule();
+		remove_wait_queue(&cpu_hotplug.wait, &wait);
+	}
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
 
@@ -79,15 +101,15 @@ void put_online_cpus(void)
 {
 	if (cpu_hotplug.active_writer == current)
 		return;
-	mutex_lock(&cpu_hotplug.lock);
+	spin_lock(&cpu_hotplug.lock);
 
-	if (WARN_ON(!cpu_hotplug.refcount))
+	if (WARN_ON(cpu_hotplug.refcount == 0))
 		cpu_hotplug.refcount++; /* try to fix things up */
+	cpu_hotplug.refcount--;
 
-	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
-		wake_up_process(cpu_hotplug.active_writer);
-	mutex_unlock(&cpu_hotplug.lock);
-
+	if (unlikely(cpu_hotplug.active_writer))
+		wake_up(&cpu_hotplug.wait);
+	spin_unlock(&cpu_hotplug.lock);
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
@@ -118,19 +140,32 @@ static void cpu_hotplug_begin(void)
 	cpu_hotplug.active_writer = current;
 
 	for (;;) {
-		mutex_lock(&cpu_hotplug.lock);
-		if (likely(!cpu_hotplug.refcount))
+		DECLARE_WAITQUEUE(wait, current);
+
+		spin_lock(&cpu_hotplug.lock);
+		if (likely(--cpu_hotplug.refcount == -1)) {
+			spin_unlock(&cpu_hotplug.lock);
 			break;
+		}
+		/* Refcount readers present */
+		cpu_hotplug.refcount++;
+		add_wait_queue(&cpu_hotplug.wait, &wait);
 		__set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&cpu_hotplug.lock);
+
+		spin_unlock(&cpu_hotplug.lock);
 		schedule();
+		remove_wait_queue(&cpu_hotplug.wait, &wait);
 	}
 }
 
 static void cpu_hotplug_done(void)
 {
+	spin_lock(&cpu_hotplug.lock);
 	cpu_hotplug.active_writer = NULL;
-	mutex_unlock(&cpu_hotplug.lock);
+	cpu_hotplug.refcount++;
+	spin_unlock(&cpu_hotplug.lock);
+
+	wake_up(&cpu_hotplug.wait);
 }
 
 /*
