Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3ITRHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 13:07:43 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:43785 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3ITRHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 13:07:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        linus.walleij@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: check cpufreq driver is valid and cpufreq isn't disabled in cpufreq_get()
Date: Fri, 20 Sep 2013 22:37:31 +0530
Message-Id: <389fbc3c8ad7c339cd2d9572d73c355b7b967823.1379669625.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_get() can be called from external drivers which might not be aware if
cpufreq driver is registered or not. And so we should actually check if cpufreq
driver is registered or not and also if cpufreq is active or disabled, at the
beginning of cpufreq_get().

Otherwise call to lock_policy_rwsem_read() might hit BUG_ON(!policy).

Reported-and-Tested-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

For 3.12.

 drivers/cpufreq/cpufreq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 82ecbe3..db004a8 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1460,6 +1460,9 @@ unsigned int cpufreq_get(unsigned int cpu)
 {
 	unsigned int ret_freq = 0;
 
+	if (cpufreq_disabled() || !cpufreq_driver)
+		return -ENOENT;
+
 	if (!down_read_trylock(&cpufreq_rwsem))
 		return 0;
 
-- 
1.7.12.rc2.18.g61b472e

