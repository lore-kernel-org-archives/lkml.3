Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbbAII2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:28:13 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18971 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbbAII2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:28:11 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-96-54af9119cbc2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] PM / OPP: Assert RCU lock in exported functions
Date: Fri, 09 Jan 2015 09:27:57 +0100
Message-id: <1420792078-14132-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xq7qSE9eHGBy+q2/RvHg9m8XrF4YW
	s6bsZbK4vGsOm8Xn3iOMFndPHWWzOHP6EqsDu8fiPS+ZPPbPXcPuseVqO4tH35ZVjB4rVn9n
	9/i8SS6ALYrLJiU1J7MstUjfLoEr48y1DSwFy7gqnvT+YWpgvMHRxcjJISFgIjFv7RtWCFtM
	4sK99WxdjFwcQgJLGSW6bnxlA0kICfQxSXxv4Qex2QSMJTYvXwJWJCJwjVHiwfMHzCAJZgFD
	iZ/v/rCD2MICLhLHezuB4hwcLAKqEo0vvUDCvALuEh9a9zJBLJOTOHlsMusERu4FjAyrGEVT
	S5MLipPSc430ihNzi0vz0vWS83M3MUKC5esOxqXHrA4xCnAwKvHwbpBbHyLEmlhWXJl7iFGC
	g1lJhFfWEijEm5JYWZValB9fVJqTWnyIkYmDU6qBMWNzQsoskbv95Q1/2uQ2BQf/WHlgU8K8
	C59vJ5iLOfwUWDxxRs+3XbNkWaxC99pHLs4NeVzAXv5x9SzuU4+KtnxpMJg78R3X3LD/6j5m
	Sj/XWzYter6h7Emp09Urb/8f/PeNaeOny9/TTAXb9ryesS6qsv2grQoH66Sg2/aqwW+YObdq
	WohdTVFiKc5INNRiLipOBABUA31R9AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lockdep asserts for holding the RCU lock when calling
dev_pm_opp_get_freq() and dev_pm_opp_get_voltage() to aid in detecting
RCU misuses.

These are called often after dev_pm_opp_find_freq_ceil/exact() which
already asserts for RCU lock. However one could make an error by
releasing lock too early - just after dev_pm_opp_find_freq_ceil().

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/base/power/opp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 106c69359306..842d31e24eee 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -169,6 +169,8 @@ unsigned long dev_pm_opp_get_voltage(struct dev_pm_opp *opp)
 	struct dev_pm_opp *tmp_opp;
 	unsigned long v = 0;
 
+	opp_rcu_lockdep_assert();
+
 	tmp_opp = rcu_dereference(opp);
 	if (unlikely(IS_ERR_OR_NULL(tmp_opp)) || !tmp_opp->available)
 		pr_err("%s: Invalid parameters\n", __func__);
@@ -199,6 +201,8 @@ unsigned long dev_pm_opp_get_freq(struct dev_pm_opp *opp)
 	struct dev_pm_opp *tmp_opp;
 	unsigned long f = 0;
 
+	opp_rcu_lockdep_assert();
+
 	tmp_opp = rcu_dereference(opp);
 	if (unlikely(IS_ERR_OR_NULL(tmp_opp)) || !tmp_opp->available)
 		pr_err("%s: Invalid parameters\n", __func__);
-- 
1.9.1

