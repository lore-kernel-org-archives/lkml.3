Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab3LUJzm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 04:55:42 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48691 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab3LUJzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 04:55:40 -0500
MIME-Version: 1.0
Date: Sat, 21 Dec 2013 15:25:39 +0530
Message-ID: <CAJ8eaTzkKtwM2Xvw_GYRrefUVJg0uzaqFNPJcNc_ffSayQiDUA@mail.gmail.com>
Subject: [PATCH] secure unlock_task_sighand() call
From: naveen yadav <yad.naveen@gmail.com>
To: tj@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,


When check code , we found below issue in zap_thread function().


>From 57bf616d0e20086d73122373baf799c675f4e3d5 Mon Sep 17 00:00:00 2001
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Date: Sat, 21 Dec 2013 14:45:48 +0530
Subject: [PATCH] secure unlock_task_sighand() call

Since the return value was not checked for lock_task_sighand(),
there was a chance that spin_unlock_irqrestore being called
from unlock_task_sighand gets called wihout actually acquire
the lock, which inturn can lead to kernel crash.

Signed-off-by: Ajeet Yadav <ajeet.yadav.77@gmail.com>
Signed-off-by: Vaibhav Shinde <v.bhav.shinde@gmail.com>

---
 fs/coredump.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 6d8b4cd..447b02c 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -357,9 +357,10 @@ static inline int zap_threads(struct task_struct
*tsk, struct mm_struct *mm,
                do {
                        if (p->mm) {
                                if (unlikely(p->mm == mm)) {
-                                       lock_task_sighand(p, &flags);
-                                       nr += zap_process(p, exit_code);
-                                       unlock_task_sighand(p, &flags);
+                                       if (lock_task_sighand(p, &flags) {
+                                               nr += zap_process(p, exit_code);
+                                               unlock_task_sighand(p, &flags);
+                                       }
                                }
                                break;
                        }
--
1.7.9.5
