Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935517Ab3DPDDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 23:03:22 -0400
Received: from mx5.zte.com.cn ([63.217.80.70]:55545 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935212Ab3DPDDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 23:03:21 -0400
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] futex: bugfix for robust futex deadlock when waking only one thread
 in handle_futex_death
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5.4 March 27, 2005
Message-ID: <OF9EFE848A.BEC7D34A-ON48257B4F.00105687-48257B4F.0010C79B@zte.com.cn>
From: zhang.yi20@zte.com.cn
Date: Tue, 16 Apr 2013 11:02:46 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-16 11:02:45,
	Serialize complete at 2013-04-16 11:02:45
Content-Type: text/plain; charset="GB2312"
X-MAIL: mse01.zte.com.cn r3G330Gx083078
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r3G33PBk000317

From: Zhang Yi <zhang.yi20@zte.com.cn>

Hello,

The function handle_futex_death just wakes one thread, which may be not 
enough when the owner process is dead. Think about this scene£º
1. A robust futex is shared for two processes, each process has multi 
threads try to get the lock. 
2. One of the threads gets the lock, and the others are waiting and sorted 

in order of priority.
3. The process to which the lock owner thread belongs is dying£¬and 
handle_futex_death is called to wake the first waiter 
4. When the first waiter belongs to the same process£¬it has no chance to 
return to the userspace to get the lock and will not call 
handle_futex_death any 
more£¬and then the rest threads of the other process will never be waked, 
and 
will block forever.

This patch wakes all the waiters when lock owner is in group-exit, letting 

all the waiters return to userspace and try to get the lock again.


Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>


--- orig/linux-3.9-rc7/kernel/futex.c   2013-04-15 00:45:16.000000000 
+0000
+++ new/linux-3.9-rc7/kernel/futex.c    2013-04-16 10:17:46.264597000 
+0000
@@ -2545,8 +2545,11 @@ retry:
                 * Wake robust non-PI futexes here. The wakeup of
                 * PI futexes happens in exit_pi_state():
                 */
-               if (!pi && (uval & FUTEX_WAITERS))
-                       futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+               if (!pi && (uval & FUTEX_WAITERS)) {
+                       int nr = signal_group_exit(current->signal)
+                                           ? INT_MAX : 1;
+                       futex_wake(uaddr, 1, nr, FUTEX_BITSET_MATCH_ANY);
+               }
        }
        return 0;
 }

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
