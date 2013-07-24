Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3GXLNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 07:13:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1183 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab3GXLNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:13:31 -0400
X-IronPort-AV: E=Sophos;i="4.89,734,1367942400"; 
   d="scan'208";a="8006134"
Message-ID: <51EFAD0E.20303@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 18:31:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, bhelgaas@google.com,
        Yinghai Lu <yinghai@kernel.org>,
        Alex Duyck <alexander.h.duyck@intel.com>
Subject: Re: workqueue, pci: INFO: possible recursive locking detected
References: <51E55B7D.2040209@linux.vnet.ibm.com> <51E66CCC.9010600@cn.fujitsu.com> <51E84EDC.5090502@linux.vnet.ibm.com> <51E89ABB.20808@cn.fujitsu.com> <51E8FF76.5030706@linux.vnet.ibm.com> <51ED1D02.80205@cn.fujitsu.com> <20130722213231.GC16776@mtj.dyndns.org> <51EDDB02.20502@cn.fujitsu.com> <20130723143841.GA18458@mtj.dyndns.org>
In-Reply-To: <20130723143841.GA18458@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 18:25:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 18:25:55,
	Serialize complete at 2013/07/24 18:25:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 10:38 PM, Tejun Heo wrote:
> Hey, Lai.
> 
> On Tue, Jul 23, 2013 at 09:23:14AM +0800, Lai Jiangshan wrote:
>> The problem is that the userS may not know their work_on_cpu() nested,
>> especially when work_on_cpu()s are on different subsystems and the call depth
>> is deep enough but the nested work_on_cpu() depends on some conditions.
> 
> Yeah, that's a possibility.  Not sure how much it'd actually matter
> tho given that this is the only instance we have and we've had the
> lockdep annotation for years.
> 
>> I prefer to change the user instead of introducing work_on_cpu_nested(), and
>> I accept to change the user only instead of change work_on_cpu() since there is only
>> one nested-calls case found.
>>
>> But I'm thinking, since nested work_on_cpu() don't have any problem,
>> Why workqueue.c don't offer a more friendly API/behavior?
> 
> If we wanna solve it from workqueue side, let's please do it by
> introduing an internal flush_work() variant which skips the lockdep
> annotation.  I'd really like to avoid using completion here.  It's
> nasty as it depends solely on the fact that completion doesn't have
> lockdep annotation yet.  Let's do it explicitly.
> 
> Thanks.
> 

>From 269bf1a2f47f04e0daf429c2cdf4052b4e8fb309 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 18:21:50 +0800
Subject: [PATCH] workqueue: allow the function of work_on_cpu() can call
 work_on_cpu()

If the @fn call work_on_cpu() again, the lockdep will complain:

> [ INFO: possible recursive locking detected ]
> 3.11.0-rc1-lockdep-fix-a #6 Not tainted
> ---------------------------------------------
> kworker/0:1/142 is trying to acquire lock:
>  ((&wfc.work)){+.+.+.}, at: [<ffffffff81077100>] flush_work+0x0/0xb0
>
> but task is already holding lock:
>  ((&wfc.work)){+.+.+.}, at: [<ffffffff81075dd9>] process_one_work+0x169/0x610
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock((&wfc.work));
>   lock((&wfc.work));
>
>  *** DEADLOCK ***

It is false-positive lockdep report. In this sutiation,
the two "wfc"s of the two work_on_cpu() are different,
they are both on stack. flush_work() can't be deadlock.

To fix this, we need to avoid the lockdep checking in this case,
thus we instroduce a internal __flush_work() which skip the lockdep.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   29 +++++++++++++++++++----------
 1 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..53df707 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2817,6 +2817,19 @@ already_gone:
 	return false;
 }
 
+static bool __flush_work(struct work_struct *work)
+{
+	struct wq_barrier barr;
+
+	if (start_flush_work(work, &barr)) {
+		wait_for_completion(&barr.done);
+		destroy_work_on_stack(&barr.work);
+		return true;
+	} else {
+		return false;
+	}
+}
+
 /**
  * flush_work - wait for a work to finish executing the last queueing instance
  * @work: the work to flush
@@ -2830,18 +2843,10 @@ already_gone:
  */
 bool flush_work(struct work_struct *work)
 {
-	struct wq_barrier barr;
-
 	lock_map_acquire(&work->lockdep_map);
 	lock_map_release(&work->lockdep_map);
 
-	if (start_flush_work(work, &barr)) {
-		wait_for_completion(&barr.done);
-		destroy_work_on_stack(&barr.work);
-		return true;
-	} else {
-		return false;
-	}
+	return __flush_work(work);
 }
 EXPORT_SYMBOL_GPL(flush_work);
 
@@ -4756,7 +4761,11 @@ long work_on_cpu(int cpu, long (*fn)(void *), void *arg)
 
 	INIT_WORK_ONSTACK(&wfc.work, work_for_cpu_fn);
 	schedule_work_on(cpu, &wfc.work);
-	flush_work(&wfc.work);
+	/*
+	 * flushing the work can't lead to deadlock, using __flush_work()
+	 * to avoid the lockdep complaint for nested work_on_cpu()s.
+	 */
+	__flush_work(&wfc.work);
 	return wfc.ret;
 }
 EXPORT_SYMBOL_GPL(work_on_cpu);
-- 
1.7.4.4

