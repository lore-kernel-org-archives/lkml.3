Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbbATPZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:25:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbbATPZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:25:48 -0500
Date: Tue, 20 Jan 2015 10:25:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: Zhang Zhen <zhenzhang.zhang@huawei.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        morgan.wang@huawei.com, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: RCU CPU stall console spews  leads to soft lockup disabled is
 reasonable ?
Message-ID: <20150120152531.GR116159@redhat.com>
References: <54BCBB33.6060608@huawei.com>
 <20150119084200.GE9719@linux.vnet.ibm.com>
 <54BCC89D.9040702@huawei.com>
 <20150119140612.GI116159@redhat.com>
 <54BDC6DF.6000602@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BDC6DF.6000602@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 11:09:19AM +0800, Zhang Zhen wrote:
> 
> > Of course back then, touch_nmi_watchdog touched all cpus.  So a problem
> > like this was masked.  I believe this upstream commit 62572e29bc53, solved
> > the problem.
> 
> Thanks for your suggestion.
> 
> Commit 62572e29bc53 changed the semantics of touch_nmi_watchdog and make it
> only touch local cpu not every one.
> But watchdog_nmi_touch = true only guarantee no hard lockup check on this cpu.
> 
> Commit 62572e29bc53 didn't changed the semantics of touch_softlockup_watchdog.

Ah, yes.  I reviewed the commit to quickly yesterday.  I thought
touch_softlockup_watchdog was called on every cpu and that commit changed
it to the local cpu.  But that was incorrect.

> > 
> > You can apply that commit and see if you if you get both RCU stall
> > messages _and_ softlockup messages.  I believe that is what you were
> > expecting, correct?
> > 
> Correct, i expect i can get  both RCU stall messages _and_ softlockup messages.
> I applied that commit, and i only got RCU stall messages.

Hmm, I believe the act of printing to the console calls touch_nmi_watchdog
which calls touch_softlockup_watchdog.  I think that is the problem there.

This may not cause other problems but what happens if you comment out the
'touch_softlockup_watchdog' from the touch_nmi_watchdog function like
below (based on latest upstream cb59670870)?

The idea is that console printing for that cpu won't reset the softlockup
detector.  Again other bad things might happen and this patch may not be a
good final solution, but it can help give me a clue about what is going
on.

Cheers,
Don

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 70bf118..833c015 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -209,7 +209,7 @@ void touch_nmi_watchdog(void)
 	 * going off.
 	 */
 	raw_cpu_write(watchdog_nmi_touch, true);
-	touch_softlockup_watchdog();
+	//touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
