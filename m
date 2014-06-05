Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaFEOiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:38:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48526 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaFEOiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:38:06 -0400
Date: Thu, 5 Jun 2014 07:37:07 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-84c407084137d4e491b07ea5ff8665d19106a5ac@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, tglx@linutronix.de, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        luto@amacapital.net, tglx@linutronix.de, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
In-Reply-To: <c65ce49615d338bae8fb79df5daffab19353c900.1401902905.git.luto@amacapital.net>
References: <c65ce49615d338bae8fb79df5daffab19353c900.1401902905.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] cpuidle: Set polling in poll_idle
Git-Commit-ID: 84c407084137d4e491b07ea5ff8665d19106a5ac
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

Commit-ID:  84c407084137d4e491b07ea5ff8665d19106a5ac
Gitweb:     http://git.kernel.org/tip/84c407084137d4e491b07ea5ff8665d19106a5ac
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 4 Jun 2014 10:31:14 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:09:49 +0200

cpuidle: Set polling in poll_idle

poll_idle is the archetypal polling idle loop; tell the core idle
code about it.

This avoids pointless IPIs when all of the other cpuidle states are
disabled.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: nicolas.pitre@linaro.org
Cc: umgwanakikbuti@gmail.com
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org
Link: http://lkml.kernel.org/r/c65ce49615d338bae8fb79df5daffab19353c900.1401902905.git.luto@amacapital.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/cpuidle/driver.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 136d6a2..9634f20 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -187,8 +187,11 @@ static int poll_idle(struct cpuidle_device *dev,
 
 	t1 = ktime_get();
 	local_irq_enable();
-	while (!need_resched())
-		cpu_relax();
+	if (!current_set_polling_and_test()) {
+		while (!need_resched())
+			cpu_relax();
+	}
+	current_clr_polling();
 
 	t2 = ktime_get();
 	diff = ktime_to_us(ktime_sub(t2, t1));
