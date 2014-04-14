Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaDNQxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:53:49 -0400
Received: from smtprelay0210.hostedemail.com ([216.40.44.210]:56931 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755494AbaDNQxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:53:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:152:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1605:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2691:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4605:5007:7514:7652:7903:8660:8957:9592:10004:10394:10400:10848:11026:11232:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12740:13148:13230:13894:14093:14097:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: juice15_3b84eb881d142
X-Filterd-Recvd-Size: 4583
Message-ID: <1397494407.2962.2.camel@joe-AO722>
Subject: Re: [PATCH 1/1] kernel/rcu/tree.c: remove duplicate extern
 definition
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com
Cc: Pranith Kumar <pranith@gatech.edu>, LKML <linux-kernel@vger.kernel.org>
Date: Mon, 14 Apr 2014 09:53:27 -0700
In-Reply-To: <20140414163207.GG4496@linux.vnet.ibm.com>
References: <CAJhHMCBVQTpDecjd5sVhCWJk++K_Rne0DfHRoF7aSd7SRYp1WA@mail.gmail.com>
	 <20140414160743.GF4496@linux.vnet.ibm.com>
	 <CAJhHMCB5_A8xRHAnpQuTTcc4KhXEiS5Uo+oZEih=cci9H+H79w@mail.gmail.com>
	 <20140414163207.GG4496@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 09:32 -0700, Paul E. McKenney wrote:
> On Mon, Apr 14, 2014 at 12:19:31PM -0400, Pranith Kumar wrote:
> > Hi Paul,
> > 
> > On Mon, Apr 14, 2014 at 12:07 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Sun, Apr 13, 2014 at 05:53:53PM -0400, Pranith Kumar wrote:
> > >> remove duplicate definition of extern resched_cpu
> > >>
> > >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
> > >
> > > Hello, Pranith,
> > >
> > > When I apply this patch I get the following:
> > >
> > > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c: In function ‘rcu_implicit_dynticks_qs’:
> > > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:895:3: error: implicit declaration of function ‘resched_cpu’ [-Werror=implicit-function-declaration]
> > > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c: At top level:
> > > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:1009:13: warning: conflicting types for ‘resched_cpu’ [enabled by default]
> > > /home/paulmck/public_git/linux-rcu/kernel/rcu/tree.c:895:3: note: previous implicit declaration of ‘resched_cpu’ was here
> > >
> > > This failed in under number of different Kconfig setups, the .config file
> > > for one of them is attached.
> > >
> > > So this declaration really is needed.  Just out of curiosity, what led
> > > you to believe that it could be removed?
> > >
> > 
> > That is strange. The patch removes a duplicate declaration of
> > resched_cpu (on lines 768, 954) of the file kernel/rcu/tree.c of the
> > latest git.
> > 
> > The patch compiles fine here with the latest tip of the git tree.
> > 
> >   CC      kernel/rcu/tree.o
> > 
> > Can you please check if your tree.c has two declarations for resched_cpu?
> 
> Ah, your patch didn't apply, so I hand-applied it, and removed the first
> declaration rather than the second one.  Trying it again.

Perhaps this might be better than using the extern.

This also would allow the resched_cpu call to become
static inline as it's very small.

---
 kernel/rcu/tree.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e30..7f2c8c2 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -60,6 +60,13 @@
 #include "tree.h"
 #include "rcu.h"
 
+/*
+ * This include of sched.h (for resched_cpu) really isn't for public
+ * consumption, but RCU is special in that context switches can allow
+ * the state machine to make progress.
+ */
+#include "../sched/sched.h"
+
 MODULE_ALIAS("rcutree");
 #ifdef MODULE_PARAM_PREFIX
 #undef MODULE_PARAM_PREFIX
@@ -762,12 +769,6 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp,
 }
 
 /*
- * This function really isn't for public consumption, but RCU is special in
- * that context switches can allow the state machine to make progress.
- */
-extern void resched_cpu(int cpu);
-
-/*
  * Return true if the specified CPU has passed through a quiescent
  * state by virtue of being in or having passed through an dynticks
  * idle state since the last call to dyntick_save_progress_counter()
@@ -947,12 +948,6 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	force_quiescent_state(rsp);  /* Kick them all. */
 }
 
-/*
- * This function really isn't for public consumption, but RCU is special in
- * that context switches can allow the state machine to make progress.
- */
-extern void resched_cpu(int cpu);
-
 static void print_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;


