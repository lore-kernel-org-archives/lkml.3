Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3IZB1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 21:27:07 -0400
Received: from mx5.zte.com.cn ([63.217.80.70]:39837 "EHLO mx5.zte.com.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380Ab3IZB1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 21:27:05 -0400
X-Greylist: delayed 1002 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Sep 2013 21:27:05 EDT
Subject: [PATCH] futex: Remove the owner check when waking task in
 handle_futex_death
X-KeepSent: CEFEC0A7:CD482CBA-48257BF2:000535D1;
 type=4; name=$KeepSent
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFCEFEC0A7.CD482CBA-ON48257BF2.000535D1-48257BF2.00066AD1@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Thu, 26 Sep 2013 09:09:54 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-09-26 09:09:58
MIME-Version: 1.0
Content-type: text/plain; charset=GB2312
X-MAIL: mse01.zte.com.cn r8Q1A4NV009320
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8Q1RDnc010529


Hi all,

Task processes all its owned robust futex when it is exiting,
to ensure the futexes can be taken by other tasks.

Though this can not work good in sometimes.
Think about this scene£º
1. A robust mutex is shared for two processes, each process has
   multi threads to lock the mutex.
2. One of the threads locks the mutex, and the others are waiting
   and sorted in order of priority.
3. The process to which the mutex owner thread belongs is dying
   without unlocking the mutex£¬and handle_futex_death is invoked
   to wake the first waiter.
4. If the first waiter belongs to the same process£¬it has no chance
   to return to the userspace to lock the mutex, and it won't wake
   the next waiter because it is not the owner of the mutex.
5. The rest waiters of the other process may block forever.

This patch remove the owner check when waking task in handle_futex_death.
If above occured, The dying task can wake the next waiter by processing its list_op_pending.
The waked task could return to userspace and try to lock the mutex again.


Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Reviewed-by: Xie Baoyou <xie.baoyou@zte.com.cn>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>



--- linux/kernel/futex.c	2013-09-25 09:24:34.639634244 +0000
+++ linux/kernel/futex.c	2013-09-25 10:12:17.619673546 +0000
@@ -2541,14 +2541,15 @@ retry:
 		}
 		if (nval != uval)
 			goto retry;
-
-		/*
-		 * Wake robust non-PI futexes here. The wakeup of
-		 * PI futexes happens in exit_pi_state():
-		 */
-		if (!pi && (uval & FUTEX_WAITERS))
-			futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
 	}
+
+	/*
+	 * Wake robust non-PI futexes here. The wakeup of
+	 * PI futexes happens in exit_pi_state():
+	 */
+	if (!pi)
+		futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+
 	return 0;
 }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
