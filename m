Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbaD2QgK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:36:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51466 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761AbaD2QgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:36:08 -0400
Date: Tue, 29 Apr 2014 09:36:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Richard Weinberger <richard@nod.at>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
Message-ID: <20140429163604.GH8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <535AC91A.1070504@infradead.org>
 <535ACB0E.4070600@infradead.org>
 <20140427062650.GW4496@linux.vnet.ibm.com>
 <20140428135540.GA14661@linux.vnet.ibm.com>
 <535E8D14.7080405@infradead.org>
 <535E8E17.2050600@nod.at>
 <20140428200640.GG4430@linux.vnet.ibm.com>
 <535EBAE6.3080907@infradead.org>
 <20140428211535.GK4430@linux.vnet.ibm.com>
 <535F95FC.1020909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535F95FC.1020909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042916-3532-0000-0000-00000163ADDF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 08:07:24AM -0400, Rik van Riel wrote:
> On 04/28/2014 05:15 PM, Paul E. McKenney wrote:
> > On Mon, Apr 28, 2014 at 01:32:38PM -0700, Randy Dunlap wrote:
> >> On 04/28/14 13:06, Paul E. McKenney wrote:
> 
> >>> Please see below for a patch against next-20140428 that makes this build
> >>> for me.  This is derived from Rik's patch, my patch, and is consistent with
> >>> Arnd's patch.
> >>>
> >>> 							Thanx, Paul
> >>
> >> Thnx, works for me.  Finally.
> > 
> > Good!
> > 
> > Rik, how would you like to proceed with this?
> 
> I guess this fix should go into -mm?

Andrew dropped the original patch, so a consolidated patch is needed.
I believe that something like the following is what we ended up with.
Does this look right to you?

							Thanx, Paul

------------------------------------------------------------------------

sysrq,rcu: suppress RCU stall warnings while sysrq runs

Some sysrq handlers can run for a long time, because they dump a lot
of data onto a serial console. Having RCU stall warnings pop up in
the middle of them only makes the problem worse.

This patch temporarily disables RCU stall warnings while a sysrq
request is handled.

Signed-off-by: Rik van Riel <riel@redhat.com>
[ paulmck: Fix build bugs for obscure config options. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Joern Engel <joern@logfs.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Madper Xie <cxie@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index fc67a89..38d5f9a 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -46,6 +46,7 @@
 #include <linux/jiffies.h>
 #include <linux/syscalls.h>
 #include <linux/of.h>
+#include <linux/rcupdate.h>
 
 #include <asm/ptrace.h>
 #include <asm/irq_regs.h>
@@ -511,6 +512,7 @@ void __handle_sysrq(int key, bool check_mask)
 	int orig_log_level;
 	int i;
 
+	rcu_sysrq_start();
 	rcu_read_lock();
 	/*
 	 * Raise the apparent loglevel to maximum so that the sysrq header
@@ -554,6 +556,7 @@ void __handle_sysrq(int key, bool check_mask)
 		console_loglevel = orig_log_level;
 	}
 	rcu_read_unlock();
+	rcu_sysrq_end();
 }
 
 void handle_sysrq(int key)
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 00a7fd6..f3a672c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -227,6 +227,17 @@ void rcu_idle_enter(void);
 void rcu_idle_exit(void);
 void rcu_irq_enter(void);
 void rcu_irq_exit(void);
+#ifdef CONFIG_RCU_STALL_COMMON
+void rcu_sysrq_start(void);
+void rcu_sysrq_end(void);
+#else /* #ifdef CONFIG_RCU_STALL_COMMON */
+static inline void rcu_sysrq_start(void)
+{
+}
+static inline void rcu_sysrq_end(void)
+{
+}
+#endif /* #else #ifdef CONFIG_RCU_STALL_COMMON */
 
 #ifdef CONFIG_RCU_USER_QS
 void rcu_user_enter(void);
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 4c0a9b0..d22309c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -320,6 +320,18 @@ int rcu_jiffies_till_stall_check(void)
 	return till_stall_check * HZ + RCU_STALL_DELAY_DELTA;
 }
 
+void rcu_sysrq_start(void)
+{
+	if (!rcu_cpu_stall_suppress)
+		rcu_cpu_stall_suppress = 2;
+}
+
+void rcu_sysrq_end(void)
+{
+	if (rcu_cpu_stall_suppress == 2)
+		rcu_cpu_stall_suppress = 0;
+}
+
 static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 {
 	rcu_cpu_stall_suppress = 1;

