Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaKPCAI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 21:00:08 -0500
Received: from mail-yh0-f44.google.com ([209.85.213.44]:53022 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaKPCAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 21:00:06 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-pm@vger.kernel.org (open list:CPUIDLE DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC PATCH] cpuidle: Use a lighter barrier in snooze_loop()
Date: Sat, 15 Nov 2014 21:00:07 -0500
Message-Id: <1416103207-18293-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using smp_mb() here so that the bit clear is not reordered is an overkill.

It is more appropriate to use smp_mb__after_atomic() which ensures that the
bit clear is not reordered.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/cpuidle/cpuidle-powernv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
index 7d3a349..b0bfcbe 100644
--- a/drivers/cpuidle/cpuidle-powernv.c
+++ b/drivers/cpuidle/cpuidle-powernv.c
@@ -48,7 +48,8 @@ static int snooze_loop(struct cpuidle_device *dev,
 	HMT_medium();
 	ppc64_runlatch_on();
 	clear_thread_flag(TIF_POLLING_NRFLAG);
-	smp_mb();
+	/* ensure bit clear is not reordered */
+	smp_mb__after_atomic();
 	return index;
 }
 
-- 
1.9.1

