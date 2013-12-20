Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3LTStR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:49:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:19658 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3LTSsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:48:22 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-a2-52b490f5f120
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, lenb@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com
Subject: [PATCH v2 7/9] intel_idle: remove superfluous dev->state_count
 initialization
Date: Fri, 20 Dec 2013 19:47:29 +0100
Message-id: <1387565251-7051-8-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
References: <1387565251-7051-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsVy+t9jQd2vE7YEGaz8KWixccZ6Vot5n2Ut
	zja9YbfY+fAtm8XlXXPYLD73HmG0mHF+H5PF7+//WC3OnL7E6sDpsWlVJ5vHnWt72DzOz1jI
	6LHlajuLR9+WVYwenzfJBbBFcdmkpOZklqUW6dslcGVMfHuRveAWb8XMtZ8ZGxhXcncxcnJI
	CJhInJ24mAXCFpO4cG89WxcjF4eQwHRGiX/TrjFDOF1MEifnH2QDqWITsJKY2L6KEcQWERCV
	uLx7AgtIEbPAY0aJ2U1TmEESwgIREtcfXgWzWQRUJf7f3Qhm8wq4S7R2tzNDrFOU6H42AWwo
	p4CHxOxXy5lAbCGgmhNdv5knMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcdM+k
	dzCuarA4xCjAwajEwysRuSVIiDWxrLgy9xCjBAezkgjvzTagEG9KYmVValF+fFFpTmrxIUZp
	DhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBsaIgxURab+TnlxRnXGBlfXlzqSXOWY3V3g+
	3Poz0chwkejrpiqDc3MT173tyP+wI8+dLVyO6da83Wv8Iy7ME1A9sCliykcdgXOsB79ovIr5
	EcPZE39vm1nE0wWGnWe5QxrtHjPXReRmPP3pLeNaFDj9Wb29x+Gpq4zPRP2cHxts2rfX47mR
	OosSS3FGoqEWc1FxIgAuNgYWNgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

intel_idle driver sets dev->state_count to drv->state_count so
the default dev->state_count initialization in cpuidle_enable_device()
(called from cpuidle_register_device()) can be used instead.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/idle/intel_idle.c | 29 -----------------------------
 1 file changed, 29 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 38da3fb..524d07b 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -639,39 +639,10 @@ static int __init intel_idle_cpuidle_driver_init(void)
  */
 static int intel_idle_cpu_init(int cpu)
 {
-	int cstate;
 	struct cpuidle_device *dev;
 
 	dev = per_cpu_ptr(intel_idle_cpuidle_devices, cpu);
 
-	dev->state_count = 1;
-
-	for (cstate = 0; cstate < CPUIDLE_STATE_MAX; ++cstate) {
-		int num_substates, mwait_hint, mwait_cstate, mwait_substate;
-
-		if (cpuidle_state_table[cstate].enter == NULL)
-			break;
-
-		if (cstate + 1 > max_cstate) {
-			printk(PREFIX "max_cstate %d reached\n", max_cstate);
-			break;
-		}
-
-		mwait_hint = flg2MWAIT(cpuidle_state_table[cstate].flags);
-		mwait_cstate = MWAIT_HINT2CSTATE(mwait_hint);
-		mwait_substate = MWAIT_HINT2SUBSTATE(mwait_hint);
-
-		/* does the state exist in CPUID.MWAIT? */
-		num_substates = (mwait_substates >> ((mwait_cstate + 1) * 4))
-					& MWAIT_SUBSTATE_MASK;
-
-		/* if sub-state in table is not enumerated by CPUID */
-		if ((mwait_substate + 1) > num_substates)
-			continue;
-
-		dev->state_count += 1;
-	}
-
 	dev->cpu = cpu;
 
 	if (cpuidle_register_device(dev)) {
-- 
1.8.2.3

