Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751132Ab3HSPhB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 11:37:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8958 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3HSPgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 11:36:21 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=KyxNPXRCR2sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=EQhO4stRxIsA:10 a=VnNF1IyMAAAA:8 a=tNfonIxEJgl1w1g4EeYA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130819153619.148613482@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 11:35:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RT 3/3] swait: Add smp_mb() after setting h->list
References: <20130819153530.409041534@goodmis.org>
Content-Disposition: inline; filename=0003-swait-Add-smp_mb-after-setting-h-list.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

The raw_spin_unlock() is not a full memory barrier. It only keeps
things from leaking past it, but does not prevent leaks from entering
the critical section. That is:

 	p = 1;

 	raw_spin_lock();
 	[...]
 	raw_spin_unlock();

 	y = x

 Can turn into:

  	p = 1;

 	raw_spin_lock();

 	load x

 	store p = 1

 	raw_spin_unlock();

 	y = x

This means that the condition check in __swait_event() (and friends)
can be seen before the h->list is set.

 	raw_spin_lock();

 	load condition;

 	store h->list;

 	raw_spin_unlock();

And the other CPU can see h->list as empty, and this CPU see condition
as not set, and possibly miss the wake up.

To prevent this from happening, add an mb() after setting the h->list.

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/wait-simple.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/wait-simple.c b/kernel/wait-simple.c
index 9725a11..2c85626 100644
--- a/kernel/wait-simple.c
+++ b/kernel/wait-simple.c
@@ -16,6 +16,8 @@
 static inline void __swait_enqueue(struct swait_head *head, struct swaiter *w)
 {
 	list_add(&w->node, &head->list);
+	/* We can't let the condition leak before the setting of head */
+	smp_mb();
 }
 
 /* Removes w from head->list. Must be called with head->lock locked. */
-- 
1.7.10.4


