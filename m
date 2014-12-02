Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaLBU4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:56:45 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:50386 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365AbaLBU4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:56:43 -0500
Date: Tue, 2 Dec 2014 12:56:36 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202205636.GQ25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <20141201230813.GE25340@linux.vnet.ibm.com>
 <547dec29.c71f8c0a.33d1.11d9@mx.google.com>
 <20141202170407.GK25340@linux.vnet.ibm.com>
 <547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
 <20141202184202.GM25340@linux.vnet.ibm.com>
 <547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
 <20141202191143.GN25340@linux.vnet.ibm.com>
 <547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120220-0017-0000-0000-000006C22719
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 05:24:39PM -0200, Dâniel Fraga wrote:
> On Tue, 2 Dec 2014 11:11:43 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > OK.  I need to know exactly what version of the Linux kernel you are
> > using.  3.18-rc7?  (I am not too worried about exactly which version
> > you are using as long as I know which version it is.)
> 
> 	Ok, I stopped bisecting and went back to 3.17.0 stock kernel.
> I'm testing with 3.17.0 kernel because this one is the first to show
> problems. If you want me to go to 3.18-rc7, just ask I can checkout
> through git.
> 
> 	Ps: my signature will reflect the kernel I'm using now ;)

And I left out a step.  Let's make sure that my preempt_disabled() hack
to CONFIG_TREE_PREEMPT_RCU=y has the same effect as the Kconfig hack
that allowed CONFIG_PREEMPT=y and CONFIG_TREE_PREEMPT_RCU=n.  Could you
please try out the following patch configured with CONFIG_PREEMPT=y
and CONFIG_TREE_PREEMPT_RCU=y?

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index e0d31a345ee6..fff605a9e87f 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -71,7 +71,11 @@ module_param(rcu_expedited, int, 0);
  */
 void __rcu_read_lock(void)
 {
-	current->rcu_read_lock_nesting++;
+	struct task_struct *t = current;
+
+	if (!t->rcu_read_lock_nesting)
+		preempt_disable();
+	t->rcu_read_lock_nesting++;
 	barrier();  /* critical section after entry code. */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
@@ -92,6 +96,7 @@ void __rcu_read_unlock(void)
 	} else {
 		barrier();  /* critical section before exit code. */
 		t->rcu_read_lock_nesting = INT_MIN;
+		preempt_enable();
 		barrier();  /* assign before ->rcu_read_unlock_special load */
 		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special.s)))
 			rcu_read_unlock_special(t);

