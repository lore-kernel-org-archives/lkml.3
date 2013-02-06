Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab3BFMkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:40:35 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:49170 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3BFMkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:40:32 -0500
MIME-Version: 1.0
Date: Wed, 6 Feb 2013 20:40:32 +0800
Message-ID: <CAJd=RBBp1-Q_xDzyUsLLJkh1BWb_X13JAOGxpOjt5Q48_7Q=Ng@mail.gmail.com>
Subject: [PATCH 3/3] stop_machine: wake up stopper thread lazily
From: Hillf Danton <dhillf@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ring no bell if the stopper thread is busy in handling enqueued works.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/stop_machine.c	Wed Feb  6 20:05:44 2013
+++ b/kernel/stop_machine.c	Wed Feb  6 20:06:56 2013
@@ -72,8 +72,10 @@ static void cpu_stop_queue_work(struct c
 	spin_lock_irqsave(&stopper->lock, flags);

 	if (stopper->enabled) {
+		int wakeup = list_empty(&stopper->works);
 		list_add_tail(&work->list, &stopper->works);
-		wake_up_process(stopper->thread);
+		if (wakeup)
+			wake_up_process(stopper->thread);
 	} else
 		cpu_stop_signal_done(work->done, false, 0);

--
