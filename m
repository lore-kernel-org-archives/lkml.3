Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbaCDLd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:33:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034AbaCDLdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:33:52 -0500
Date: Tue, 4 Mar 2014 03:33:41 -0800
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-38edbb0b913d73713c23dcc742669f7e78b52aa7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org>
References: <9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timer:
  Make sure TIMER_FLAG_MASK bits are free in allocated base
Git-Commit-ID: 38edbb0b913d73713c23dcc742669f7e78b52aa7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38edbb0b913d73713c23dcc742669f7e78b52aa7
Gitweb:     http://git.kernel.org/tip/38edbb0b913d73713c23dcc742669f7e78b52aa7
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Fri, 28 Feb 2014 14:15:22 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 4 Mar 2014 12:30:29 +0100

timer: Make sure TIMER_FLAG_MASK bits are free in allocated base

Currently we are using two lowest bit of base for internal purpose and
so they both should be zero in the allocated address. The code was
doing the right thing before this patch came in: commit c5f66e99b
(timer: Implement TIMER_IRQSAFE)

Tejun probably forgot to update this piece of code which checks if the
lowest 'n' bits are zero or not and so wasn't updated according to the
new flag. Lets use TIMER_FLAG_MASK in the calculations here.

[ tglx: Massaged changelog ]

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: fweisbec@gmail.com
Cc: tj@kernel.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/9144e10d7e854a0aa8a673332adec356d81a923c.1393576981.git.viresh.kumar@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 31824ef..949d74e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1555,9 +1555,8 @@ static int init_timers_cpu(int cpu)
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
