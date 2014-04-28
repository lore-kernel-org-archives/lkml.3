Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbaD1Nzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 09:55:54 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57562 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbaD1Nzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 09:55:50 -0400
Date: Mon, 28 Apr 2014 06:55:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-next@vger.kernel.org, umgwanakikbuti@gmail.com
Subject: Re: mmotm 2014-04-24-13-07 uploaded
Message-ID: <20140428135540.GA14661@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com>
 <535992DD.3060808@infradead.org>
 <20140425100459.7824f676@annuminas.surriel.com>
 <535AC91A.1070504@infradead.org>
 <535ACB0E.4070600@infradead.org>
 <20140427062650.GW4496@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140427062650.GW4496@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042813-9332-0000-0000-000000A0CAF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 11:26:50PM -0700, Paul E. McKenney wrote:
> On Fri, Apr 25, 2014 at 01:52:30PM -0700, Randy Dunlap wrote:
> > On 04/25/14 13:44, Randy Dunlap wrote:
> > > On 04/25/14 07:04, Rik van Riel wrote:
> > >> On Thu, 24 Apr 2014 15:40:29 -0700
> > >> Randy Dunlap <rdunlap@infradead.org> wrote:
> > >>
> > >>
> > >>> uml on x86_64 defconfig:
> > >>>
> > >>> drivers/built-in.o: In function `__handle_sysrq':
> > >>> drivers/tty/sysrq.c:514: undefined reference to `rcu_sysrq_start'
> > >>> drivers/tty/sysrq.c:558: undefined reference to `rcu_sysrq_end'
> > >>
> > >> Randy, does the patch below fix it?
> > 
> > CONFIG_TINY_RCU=y
> > 
> > tiny.c does not provide these functions...  Paul...
> > 
> > > Hm, no, it does not.  I'll look into it.
> > > 
> > >> Mike, this patch should also address your concerns.
> > >>
> > >> Andrew, this can be a -fix patch for the sysctl-rcu patch,
> > >> assuming it fixes things :)
> > >>
> > >> Signed-off-by: Rik van Riel <riel@redhat.com
> > >> ---
> > >>  drivers/tty/sysrq.c | 1 +
> > >>  kernel/rcu/update.c | 3 ++-
> > >>  2 files changed, 3 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
> > >> index dd53af9..0867433 100644
> > >> --- a/drivers/tty/sysrq.c
> > >> +++ b/drivers/tty/sysrq.c
> > >> @@ -46,6 +46,7 @@
> > >>  #include <linux/jiffies.h>
> > >>  #include <linux/syscalls.h>
> > >>  #include <linux/of.h>
> > >> +#include <linux/rcupdate.h>
> > >>  
> > >>  #include <asm/ptrace.h>
> > >>  #include <asm/irq_regs.h>
> > >> diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
> > >> index 2ac3289..d22309c 100644
> > >> --- a/kernel/rcu/update.c
> > >> +++ b/kernel/rcu/update.c
> > >> @@ -322,7 +322,8 @@ int rcu_jiffies_till_stall_check(void)
> > >>  
> > >>  void rcu_sysrq_start(void)
> > >>  {
> > >> -	rcu_cpu_stall_suppress = 2;
> > >> +	if (!rcu_cpu_stall_suppress)
> > >> +		rcu_cpu_stall_suppress = 2;
> > >>  }
> > >>  
> > >>  void rcu_sysrq_end(void)
> 
> You would think that I would have learned by now that RCU requires a bit
> more care...  Anyway, patch containing only the APIs that -should- work
> is below.  Currently testing it on the usual set of configs.

Right...  Adding a "static inline" would help, wouldn't it?  Updated
patch below.

							Thanx, Paul

------------------------------------------------------------------------

rcu: Provide API to suppress stall warnings while sysrc runs

Some sysrq handlers can run for a long time, because they dump a lot
of data onto a serial console. Having RCU stall warnings pop up in
the middle of them only makes the problem worse.

This commit provides rcu_sysrq_start() and rcu_sysrq_end() APIs to
temporarily suppress RCU CPU stall warnings while a sysrq request is
handled.

Signed-off-by: Rik van Riel <riel@redhat.com>
[ paulmck: Fix TINY_RCU build error. ]
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a6f2664a1b77..ca6fe55913b7 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -248,6 +248,18 @@ void rcu_idle_exit(void);
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
+
 #ifdef CONFIG_RCU_USER_QS
 void rcu_user_enter(void);
 void rcu_user_exit(void);
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index ed7a0d72562c..a2aeb4df0f60 100644
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

