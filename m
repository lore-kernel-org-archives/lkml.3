Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbaCDK2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:28:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9794 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697AbaCDK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:28:04 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-c7-5315aaad161d
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        thomas.ab@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC v3 2/5] cpufreq:LAB:cpufreq_governor Adjust
 cpufreq_governor.[h|c] to support LAB
Date: Tue, 04 Mar 2014 11:27:29 +0100
Message-id: <1393928852-22725-3-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t9jAd21q0SDDb6fVLXYOGM9q8XTph/s
	Fp1nnzBbvHnEbfHm4WZGi02Pr7FaXN41h83ic+8RRosZ5/cxWdxuXMFmceb0JVaL9TNes1hs
	nrCRzaJjGaPFxq8eDvweO2fdZfe4c20Pm8fmJfUe66a9ZfbYcrWdxaNvyypGj8+b5ALYo7hs
	UlJzMstSi/TtErgydr+9zFgwia9i6e0O1gbGM9xdjJwcEgImEsd2nWeDsMUkLtxbD2RzcQgJ
	LGKU6LlylREkISTQxSRxe2Y0iM0moCfx+e5TJhBbRCBU4ujUr+wgDcwCZ1gk3r7YzQqSEBZI
	lPj49iKYzSKgKvGg6SzYIF4BN4l5dw8xQWxTlOh+NgFsM6eAu8TxFc3MEJtbGSUu77zBNIGR
	dwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4KB9Jr2DcVWDxSFGAQ5GJR5ehykiwUKs
	iWXFlbmHGCU4mJVEeBUXigYL8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKanZpa
	kFoEk2Xi4JRqYJxlO+k+x/flqbN1r3HfLZi+uu+lc+SDiwxCT7hlc1f8vH3s8Yl7HVJznPcd
	lr6uHF2668Z5vwfzMyb4qv3T7rxprfGW4XMP950fX7su++U2OGg12OYYWV5/qLux+Nr+W7pV
	xnM/puu/Nwiq+fD40WGNo8wNC4uCf1sHHbswo8ZNviQlqeJvZKcSS3FGoqEWc1FxIgDA9uJa
	VgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor adjustments were needed to support LAB operation in the
cpufreq_governor.[h|c] files.

Most notably, code for proper estimation of the idle time for each CPU is
added here.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/cpufreq_governor.c |    7 +++++++
 drivers/cpufreq/cpufreq_governor.h |    2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index ba43991..99fc3e8 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -98,6 +98,13 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 
 		load = 100 * (wall_time - idle_time) / wall_time;
 
+		if (dbs_data->cdata->governor == GOV_LAB) {
+			struct od_cpu_dbs_info_s *od_dbs_info =
+				dbs_data->cdata->get_cpu_dbs_info_s(j);
+
+			od_dbs_info->idle_time = (100 * idle_time) / wall_time;
+		}
+
 		if (load > max_load)
 			max_load = load;
 	}
diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 34b1cf2..82a519f 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -152,6 +152,7 @@ struct od_cpu_dbs_info_s {
 	unsigned int freq_lo_jiffies;
 	unsigned int freq_hi_jiffies;
 	unsigned int rate_mult;
+	unsigned int idle_time;
 	unsigned int sample_type:1;
 };
 
@@ -187,6 +188,7 @@ struct common_dbs_data {
 	/* Common across governors */
 	#define GOV_ONDEMAND		0
 	#define GOV_CONSERVATIVE	1
+	#define GOV_LAB                 2
 	int governor;
 	struct attribute_group *attr_group_gov_sys; /* one governor - system */
 	struct attribute_group *attr_group_gov_pol; /* one governor - policy */
-- 
1.7.10.4

