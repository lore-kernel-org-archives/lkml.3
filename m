Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3KHFYI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 00:24:08 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8988 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750986Ab3KHFYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 00:24:04 -0500
From: Xiaoguang Chen <chenxg@marvell.com>
To: <rjw@rjwysocki.net>, <viresh.kumar@linaro.org>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <chenxg@marvell.com>, <chenxg.marvell@gmail.com>
Subject: [PATCH 1/2] cpufreq: conservative: fix requested_freq reduction issue
Date: Fri, 8 Nov 2013 13:23:51 +0800
Message-ID: <1383888232-27049-1-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-11-07_08:2013-11-08,2013-11-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1311070277
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When decreasing frequency, requested_freq may be less than
freq_target, So requested_freq minus freq_target may be negative,
But reqested_freq's unit is unsigned int, then the negative result
will be one larger integer which may be even higher than
requested_freq.

This patch is to fix such issue. when result becomes negative,
set requested_freq as the min value of policy.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_conservative.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index f62d822..218460f 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -80,13 +80,18 @@ static void cs_check_cpu(int cpu, unsigned int load)
 
 	/* Check for frequency decrease */
 	if (load < cs_tuners->down_threshold) {
+		unsigned int freq_target;
 		/*
 		 * if we cannot reduce the frequency anymore, break out early
 		 */
 		if (policy->cur == policy->min)
 			return;
 
-		dbs_info->requested_freq -= get_freq_target(cs_tuners, policy);
+		freq_target = get_freq_target(cs_tuners, policy);
+		if (dbs_info->requested_freq > freq_target)
+			dbs_info->requested_freq -= freq_target;
+		else
+			dbs_info->requested_freq = policy->min;
 
 		__cpufreq_driver_target(policy, dbs_info->requested_freq,
 				CPUFREQ_RELATION_L);
-- 
1.8.0

