Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaJBKW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:22:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:55703 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJBKWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:22:54 -0400
Date: Thu, 2 Oct 2014 12:22:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, ilya.dryomov@inktank.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 00/11] nested sleeps, fixes and debug infrastructure
Message-ID: <20141002102251.GA6324@worktop.programming.kicks-ass.net>
References: <20140924081845.572814794@infradead.org>
 <1411633803.15810.12.camel@marge.simpson.net>
 <20140925090619.GA5430@worktop>
 <20140925091556.GB5430@worktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925091556.GB5430@worktop>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 11:15:56AM +0200, Peter Zijlstra wrote:
> > > My DL980 hollered itself to death while booting.
> > > 
> > > [   39.587224] do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff811021d0>] kauditd_thread+0x130/0x1e0
> > > [   39.706325] Modules linked in: iTCO_wdt(E) gpio_ich(E) iTCO_vendor_support(E) joydev(E) i7core_edac(E) lpc_ich(E) hid_generic(E) hpwdt(E) mfd_core(E) edac_core(E) bnx2(E) shpchp(E) sr_mod(E) ehci_pci(E) hpilo(E) netxen_nic(E) ipmi_si(E) cdrom(E) pcspkr(E) sg(E) acpi_power_meter(E) ipmi_msghandler(E) button(E) ext4(E) jbd2(E) mbcache(E) crc16(E) usbhid(E) radeon(E) ttm(E) drm_kms_helper(E) drm(E) i2c_algo_bit(E) uhci_hcd(E) ehci_hcd(E) usbcore(E) sd_mod(E) thermal(E) usb_common(E) processor(E) scsi_dh_hp_sw(E) scsi_dh_emc(E) scsi_dh_rdac(E) scsi_dh_alua(E) scsi_dh(E) ata_generic(E) ata_piix(E) libata(E) hpsa(E) cciss(E) scsi_mod(E)
> > > [   40.373599] CPU: 9 PID: 1974 Comm: kauditd Tainted: G            E  3.17.0-default #2
> > > [   40.506928] Hardware name: Hewlett-Packard ProLiant DL980 G7, BIOS P66 07/07/2010
> > > [   40.613753]  0000000000001bd9 ffff88026f3d3d78 ffffffff815b2fc2 ffff88026f3d3db8
> > > [   40.728720]  ffffffff8106613c ffff88026f3d3da8 ffff88026b4fa110 0000000000000000
> > > [   40.816116]  0000000000000038 ffffffff8180ff47 ffff88026f3d3e58 ffff88026f3d3e18
> > > [   40.905088] Call Trace:
> > > [   40.938325]  [<ffffffff815b2fc2>] dump_stack+0x72/0x88
> > > [   41.000143]  [<ffffffff8106613c>] warn_slowpath_common+0x8c/0xc0
> > > [   41.067996]  [<ffffffff81066226>] warn_slowpath_fmt+0x46/0x50
> > > [   41.132669]  [<ffffffff811021d0>] ? kauditd_thread+0x130/0x1e0
> > > [   41.204105]  [<ffffffff811021d0>] ? kauditd_thread+0x130/0x1e0
> > > [   41.270699]  [<ffffffff8108d214>] __might_sleep+0x84/0xa0
> > > [   41.333979]  [<ffffffff8110224b>] kauditd_thread+0x1ab/0x1e0
> > > [   41.398612]  [<ffffffff810940c0>] ? try_to_wake_up+0x210/0x210
> > > [   41.465435]  [<ffffffff811020a0>] ? audit_printk_skb+0x70/0x70
> > > [   41.534628]  [<ffffffff810859db>] kthread+0xeb/0x100
> > > [   41.596562]  [<ffffffff810858f0>] ? kthread_freezable_should_stop+0x80/0x80
> > > [   41.678973]  [<ffffffff815b85bc>] ret_from_fork+0x7c/0xb0
> > > [   41.742073]  [<ffffffff810858f0>] ? kthread_freezable_should_stop+0x80/0x80


---
Subject: audit,wait: Fixup kauditd_thread wait loop

The kauditd_thread wait loop is a bit iffy; it has a number of problems:

 - calls try_to_freeze() before schedule(); you typically want the
   thread to re-evaluate the sleep condition when unfreezing, also
   freeze_task() issues a wakeup.

 - it unconditionally does the {add,remove}_wait_queue(), even when the
   sleep condition is false.

Introduce a new wait_event() variant, wait_event_freezable() that does
all the right things and employ it here.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/wait.h |   25 +++++++++++++++++++++++++
 kernel/audit.c       |   11 +----------
 2 files changed, 26 insertions(+), 10 deletions(-)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -266,6 +266,31 @@ do {									\
 	__wait_event(wq, condition);					\
 } while (0)
 
+#define __wait_event_freezable(wq, condition)				\
+	(void)___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	\
+			    schedule(); try_to_freeze())
+
+/**
+ * wait_event - sleep until a condition gets true or freeze (for kthreads)
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE -- so as not to contribute
+ * to system load) until the @condition evaluates to true. The
+ * @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define wait_event_freezable(wq, condition)				\
+do {									\
+	WARN_ON_ONCE(!(current->flags & PF_KTHREAD));			\
+	might_sleep();							\
+	if (condition)							\
+		break;							\
+	__wait_event_freezable(wq, condition);				\
+} while (0)
+
 #define __wait_event_timeout(wq, condition, timeout)			\
 	___wait_event(wq, ___wait_cond_timeout(condition),		\
 		      TASK_UNINTERRUPTIBLE, 0, timeout,			\
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -499,7 +499,6 @@ static int kauditd_thread(void *dummy)
 	set_freezable();
 	while (!kthread_should_stop()) {
 		struct sk_buff *skb;
-		DECLARE_WAITQUEUE(wait, current);
 
 		flush_hold_queue();
 
@@ -514,16 +513,8 @@ static int kauditd_thread(void *dummy)
 				audit_printk_skb(skb);
 			continue;
 		}
-		set_current_state(TASK_INTERRUPTIBLE);
-		add_wait_queue(&kauditd_wait, &wait);
 
-		if (!skb_queue_len(&audit_skb_queue)) {
-			try_to_freeze();
-			schedule();
-		}
-
-		__set_current_state(TASK_RUNNING);
-		remove_wait_queue(&kauditd_wait, &wait);
+		wait_event_freezable(&kauditd_wait, skb_queue_len(&audit_skb_queue));
 	}
 	return 0;
 }
