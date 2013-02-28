Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393Ab3B1PQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:16:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42052 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3B1Or1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:47:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 040/139] ARM: 7643/1: sched: correct update_sched_clock()
Date: Thu, 28 Feb 2013 14:43:10 +0000
Message-Id: <1362062689-2567-41-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joonsoo Kim <js1304@gmail.com>

commit 7c4e9ced424be4d36df6a3e3825763e97ee97607 upstream.

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
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/kernel/sched_clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
index 27d186a..6bbf936 100644
--- a/arch/arm/kernel/sched_clock.c
+++ b/arch/arm/kernel/sched_clock.c
@@ -84,11 +84,11 @@ static void notrace update_sched_clock(void)
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
1.8.1.2

