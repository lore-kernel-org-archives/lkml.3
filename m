Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab3BFFVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 00:21:20 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:65092 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3BFFVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 00:21:19 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-b9-5111e8496745
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        js1304@gmail.com, Linus Walleij <linus.walleij@linaro.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH RESEND] ARM: sched: correct update_sched_clock()
Date: Wed,  6 Feb 2013 14:21:16 +0900
Message-Id: <1360128076-8555-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want load epoch_cyc and epoch_ns atomically,
we should update epoch_cyc_copy first of all.
This notify reader that updating is in progress.

If we update epoch_cyc first like as current implementation,
there is subtle error case.
Look at the below example.

<Initial Condition>
cyc = 9
ns = 900
cyc_copy = 9

== CASE 1 ==
<CPU A = reader>           <CPU B = updater>
                           write cyc = 10
read cyc = 10
read ns = 900
                           write ns = 1000
                           write cyc_copy = 10
read cyc_copy = 10

output = (10, 900)

== CASE 2 ==
<CPU A = reader>           <CPU B = updater>
read cyc = 9
                           write cyc = 10
                           write ns = 1000
read ns = 1000
read cyc_copy = 9
                           write cyc_copy = 10
output = (9, 1000)

If atomic read is ensured, output should be (9, 900) or (10, 1000).
But, output in example case are not.

So, change updating sequence in order to correct this problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index fc6692e..bd6f56b 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -93,11 +93,11 @@ static void notrace update_sched_clock(void)
 	 * detectable in cyc_to_fixed_sched_clock().
 	 */
 	raw_local_irq_save(flags);
-	cd.epoch_cyc = cyc;
+	cd.epoch_cyc_copy = cyc;
 	smp_wmb();
 	cd.epoch_ns = ns;
 	smp_wmb();
-	cd.epoch_cyc_copy = cyc;
+	cd.epoch_cyc = cyc;
 	raw_local_irq_restore(flags);
 }
 
-- 
1.7.9.5

