Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaB1Ipt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:45:49 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:39319 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbaB1Ipk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:45:40 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, tj@kernel.org, peterz@infradead.org,
        mingo@kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] timer: Make sure TIMER_FLAG_MASK bits are free in allocated base
Date: Fri, 28 Feb 2014 14:15:22 +0530
Message-Id: <9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org>
References: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org>
In-Reply-To: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org>
References: <c439f5b6bbc2047e1662f4d523350531425bcf9d.1393576981.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we are using two lowest bit of base for internal purpose and so they
both should be zero in the allocated address. The code was doing the right thing
before this patch came in:

commit c5f66e99b7cb091e3d51ae8e8156892e8feb7fa3
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Aug 8 11:10:28 2012 -0700

    timer: Implement TIMER_IRQSAFE

Tejun probably forgot to update this piece of code which checks if the lowest
'n' bits are zero or not and so wasn't updated according to the new flag. Lets
use TIMER_FLAG_MASK in the calculations here, so that this code wouldn't require
a change later on with another flag in.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/timer.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index e8e7839..d52a8ff 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1548,9 +1548,8 @@ static int init_timers_cpu(int cpu)
 			if (!base)
 				return -ENOMEM;
 
-			/* Make sure that tvec_base is 2 byte aligned */
-			if (tbase_get_deferrable(base)) {
-				WARN_ON(1);
+			/* Make sure tvec_base has TIMER_FLAG_MASK bits free */
+			if (WARN_ON(base != tbase_get_base(base))) {
 				kfree(base);
 				return -ENOMEM;
 			}
-- 
1.7.12.rc2.18.g61b472e

