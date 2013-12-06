Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758585Ab3LFUNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:13:31 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:42858 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab3LFUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:13:28 -0500
X-IronPort-AV: E=Sophos;i="4.93,842,1378882800"; 
   d="scan'208";a="371094"
Message-ID: <52A22FD6.8070105@broadcom.com>
Date: Fri, 6 Dec 2013 12:13:10 -0800
From: Sherman Yin <syin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: timer: catching new timers in migrated tvec_base
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm looking for feedback regarding explicitly invalidating the 
list_heads in tvec_base.tv1 .. tv5 after a migration, for example by 
doing a list_del(head) at the end of migrate_timer_list().  This is not 
meant to fix any bugs, but to help catch attempts to add timers to the 
migrated tvec_base.  Bugs like this could be difficult to catch without 
this change (example below).

If I understand correctly, after migration of timers from one cpu (the 
one being shut down, say cpu1) to another (say cpu0), no one should be 
adding any timers to the tvec_base of cpu1.  When cpu1 later comes back 
up, new timers can be added only after init_timers_cpu(1).

If a buggy driver tries to add a timer to cpu1 after it has shut down, 
eg with add_timer_on(1), there is no indication that this is an invalid 
operation (no BUG_ON, no return code).  The following is what happened 
in my case:

1. cpu1 shuts down, all timers migrated to cpu0
2. driverA adds a timerX to cpu1's tvec_base.tv1[n] (bug)
3. cpu1 returns, all lists in tvec_base.tv1 re-initialized without 
checking if the lists are indeed empty.
4. timerX is now "orphaned"; its entry->next and entry->prev points to 
cpu1's tvec_base.tv1[n], but tvec_base.tv1[n] is an empty list.
5. driverB adds a timerY to cpu1's tvec_base.tv[n] and becomes the only 
entry in that list.
6. driverA removes timerX, which eventually calls __list_del on 
timerX.entry.
7. Since timerX.entry points to cpu1's tvec_base.tv1[n], 
tvec_base.tv1[n] will now become an empty list, and timerY is now 
"orphaned".
8. timerY never fires

This bug was difficult to catch because it will only happen if timerX 
and timerY are both added to the same slot tv1[n].  The likelihood may 
be low so the bug might be very difficult to reproduce.

By invalidating the list_heads in tv[1..5] right after migration, we can 
catch this bug at step 2.  A patch might look like:
------------------------
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1585,6 +1585,14 @@ static void migrate_timer_list(struct tvec_base 
*new_base, struct list_head *hea
  		timer_set_base(timer, new_base);
  		internal_add_timer(new_base, timer);
  	}
+
+	/*
+	 * After existing timers are migrated, new timers should never be added
+	 * to this list until after the next init_timers_cpu().  Deleting
+	 * list_head here will not affect timer behavior but will help catch
+	 * anyone trying to add to this list when they shouldn't.
+	 */
+	list_del(head);
  }

  static void __cpuinit migrate_timers(int cpu)
------------------------

Is there anything I missed or failed to consider here?

Thanks,
Sherman
