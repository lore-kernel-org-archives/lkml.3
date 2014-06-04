Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaFDRb3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:31:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61887 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaFDRbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:31:23 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Peter Zijlstra <peterz@infradead.org>, umgwanakikbuti@gmail.com
Cc: mingo@kernel.org, tglx@linutronix.de, nicolas.pitre@linaro.org,
        daniel.lezcano@linaro.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 1/5] cpuidle: Set polling in poll_idle
Date: Wed,  4 Jun 2014 10:31:14 -0700
Message-Id: <c65ce49615d338bae8fb79df5daffab19353c900.1401902905.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401902905.git.luto@amacapital.net>
References: <cover.1401902905.git.luto@amacapital.net>
In-Reply-To: <cover.1401902905.git.luto@amacapital.net>
References: <cover.1401902905.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

poll_idle is the archetypal polling idle loop; tell the core idle
code about it.

This avoids pointless IPIs when all of the other cpuidle states are
disabled.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
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
-- 
1.9.3

