Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbaDNQ4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:56:04 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:38300 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbaDNQZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:25:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, Arvind.Chauhan@arm.com,
        linaro-networking@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 11/38] tick-common: fix wrong check in tick_check_replacement()
Date: Mon, 14 Apr 2014 21:53:33 +0530
Message-Id: <1f59048520216e11bcaa50720c005d471372e48f.1397492345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1397492345.git.viresh.kumar@linaro.org>
References: <cover.1397492345.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tick_check_replacement() returns if a replacement of clock_event_device is
possible or not. It does this as the first check:

	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
		return false;

This looks wrong as we are returning false when tick_check_percpu() cpu returned
true. Probably Thomas forgot '!' here in his commit: 03e13cf5e ?

Fix it by placing a '!' before tick_check_percpu().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/time/tick-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 395cbbd..8650026 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -257,7 +257,7 @@ static bool tick_check_preferred(struct clock_event_device *curdev,
 bool tick_check_replacement(struct clock_event_device *curdev,
 			    struct clock_event_device *newdev)
 {
-	if (tick_check_percpu(curdev, newdev, smp_processor_id()))
+	if (!tick_check_percpu(curdev, newdev, smp_processor_id()))
 		return false;
 
 	return tick_check_preferred(curdev, newdev);
-- 
1.7.12.rc2.18.g61b472e

