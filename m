Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3LUMSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 07:18:22 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52453 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab3LUMSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 07:18:21 -0500
MIME-Version: 1.0
Date: Sat, 21 Dec 2013 17:48:19 +0530
Message-ID: <CAB5gotvTv7Y=rMCvO0b5Jg-fx5rLUro+OfWMD0EoLpuHCsQ8TA@mail.gmail.com>
Subject: [PATCH] skip increamenting nr for TASK_UNINTERRUPTIBLE
From: Vaibhav Shinde <v.bhav.shinde@gmail.com>
To: tj@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

We found below issue in coredump for uninterruptible task -

>From 1c46f0327d98ad593d8913f9f1dad352f8f44304 Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Sat, 21 Dec 2013 17:06:05 +0530
Subject: [PATCH] skip increamenting nr for TASK_UNINTERRUPTIBLE

In coredump case, where thread_1 faults while thread_2 is in
TASK_UNINTERRUPTIBLE state, it cannot handle the SIGKILL.
Thus the process hangs on event.
The coredump routine freezes until the thread state is
uninterruptible.

Solution: Continue for coredump, without waiting for uninterruptible
 thread, as it will get killed as soon as it returns from
 uninterruptible state.
 Therefore do not increament thread count for threads with
 TASK_UNINTERRUPTIBLE.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Signed-off-by: Vaibhav Shinde <v.bhav.shinde@gmail.com>
---
 fs/coredump.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 447b02c..54b0664 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -281,7 +281,8 @@ static int zap_process(struct task_struct *start,
int exit_code)
  if (t != current && t->mm) {
  sigaddset(&t->pending.signal, SIGKILL);
  signal_wake_up(t, 1);
- nr++;
+ if(!(t->state & TASK_UNINTERRUPTIBLE))
+ nr++;
  }
  } while_each_thread(start, t);

-- 
1.7.9.5
