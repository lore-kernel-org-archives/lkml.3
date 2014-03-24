Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaCXGsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:48:32 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62815 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbaCXGs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:48:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        svaidy@linux.vnet.ibm.com, l.majewski@samsung.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: set value of CPUFREQ_BOOST_FREQ to 0xABABABAB
Date: Mon, 24 Mar 2014 12:18:14 +0530
Message-Id: <78187ea173460c871eef31432ec2a80ec657fe30.1395643393.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ideally, .driver_data field of struct cpufreq_frequency_table must not be used
by core at all. But during a recent change if its value is same as
CPUFREQ_BOOST_FREQ macro, then it is treated specially by core.

The value of this macro was set to ~2 earlier, i.e. 0xFFFFFFFD. In case some
driver is using this field for its own data and sets this field to -3, then with
two's complement that value will also become 0xFFFFFFFD.

To fix this issue, lets change value of this flag to a very uncommon value which
shouldn't be used by any driver unless they want to use BOOST feature.

Along with this update comments to make this more clear.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---

Gautham/Vaidy: I hope this fixes the problem we discussed for your patchset.

 include/linux/cpufreq.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index c48e595..9f25d9d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -455,12 +455,18 @@ extern struct cpufreq_governor cpufreq_gov_conservative;
  *                     FREQUENCY TABLE HELPERS                       *
  *********************************************************************/
 
+/* Special Values of .frequency field */
 #define CPUFREQ_ENTRY_INVALID ~0
 #define CPUFREQ_TABLE_END     ~1
-#define CPUFREQ_BOOST_FREQ    ~2
+/* Special Values of .driver_data field */
+#define CPUFREQ_BOOST_FREQ    0xABABABAB
 
 struct cpufreq_frequency_table {
-	unsigned int	driver_data; /* driver specific data, not used by core */
+	/*
+	 * driver specific data, not used by core unless it is set to
+	 * CPUFREQ_BOOST_FREQ.
+	 */
+	unsigned int	driver_data;
 	unsigned int	frequency; /* kHz - doesn't need to be in ascending
 				    * order */
 };
-- 
1.7.12.rc2.18.g61b472e

