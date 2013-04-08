Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab3DHH6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:58:13 -0400
Received: from mx5.zte.com.cn ([63.217.80.70]:55303 "EHLO zte.com.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752526Ab3DHH6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:58:13 -0400
To: linux-kernel@vger.kernel.org
Cc: Zhang Yi <zhang.yi20@zte.com.cn>, Ma Chenggong <ma.chenggong@zte.com.cn>,
        Liu Dong <liu.dong3@zte.com.cn>, Cui Yunfeng <cui.yunfeng@zte.com.cn>,
        Lu Zhongjun <lu.zhongjun@zte.com.cn>,
        Jiang Biao <jiang.biao2@zte.com.cn>
Subject: [PATCH] futex: bugfix for robust futex deadlock when waking only one thread
 in handle_futex_death
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFC7A3D444.3EF36F3E-ON48257B47.002BA6AB-48257B47.002BC310@zte.com.cn>
From: jiang.biao2@zte.com.cn
Date: Mon, 8 Apr 2013 15:57:38 +0800
X-MIMETrack: Serialize by Router on notes_smtp/zte_ltd(Release 8.5.3FP1 HF212|May 23, 2012) at
 2013-04-08 15:57:45,
	Serialize complete at 2013-04-08 15:57:45
Content-Type: text/plain; charset="GB2312"
X-MAIL: mse02.zte.com.cn r387vigX031582
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r387wFTO023706

From: Zhang Yi <zhang.yi20@zte.com.cn>

The function handle_futex_death just wakes one thread, which may be not 
enough 
when the owner process is dead. Think about this scene£º
1. A robust futex is shared for two processes, each process has multi 
threads 
try to get the lock. 
2. One of the threads gets the lock, and the others are waiting and sorted 
in 
order of priority.
3. The process to which the lock owner thread belongs is dying£¬and 
handle_futex_death is called to wake the first waiter 
4. When the first waiter belongs to the same process£¬it has no chance to 
return 
to the userspace to get the lock and will not call handle_futex_death any 
more£¬
and then the rest threads of the other process will never be waked, and 
will block 
forever.

This patch wakes all the waiters when lock owner is in group-exit, letting 
all 
the waiters return to userspace and try to get the lock again.

Signed-off-by: Zhang Yi <zhang.yi20@zte.com.cn>
Tested-by: Ma Chenggong <ma.chenggong@zte.com.cn>
Reviewed-by: Liu Dong <liu.dong3@zte.com.cn>
Reviewed-by: Cui Yunfeng <cui.yunfeng@zte.com.cn>
Reviewed-by: Lu Zhongjun <lu.zhongjun@zte.com.cn>
Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>

--- orig/linux-3.9-rc5/kernel/futex.c   2013-03-31 22:12:43.000000000 
+0000
+++ new/linux-3.9-rc5/kernel/futex.c    2013-04-03 12:33:27.735392000 
+0000
@@ -2545,8 +2545,10 @@ retry:
                 * Wake robust non-PI futexes here. The wakeup of
                 * PI futexes happens in exit_pi_state():
                 */
-               if (!pi && (uval & FUTEX_WAITERS))
-                       futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
+               if (!pi && (uval & FUTEX_WAITERS)){
+                       int wake_nr = signal_group_exit(current->signal) ? 
INT_MAX : 1;
+                       futex_wake(uaddr, 1, wake_nr, 
FUTEX_BITSET_MATCH_ANY);
+               }
        }
        return 0;
 }
--------------------------------------------------------
ZTE Information Security Notice: The information contained in this mail (and any attachment transmitted herewith) is privileged and confidential and is intended for the exclusive use of the addressee(s).  If you are not an intended recipient, any disclosure, reproduction, distribution or other dissemination or use of the information contained is strictly prohibited.  If you have received this mail in error, please delete it and notify us immediately.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
