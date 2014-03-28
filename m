Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaC1FUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 01:20:45 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48948 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaC1FUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 01:20:41 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rob@landley.net, olof@lixom.net, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org
Subject: [PATCH 1/2] PM / Domains: Add pd_ignore_unused to keep power domains enabled
Date: Fri, 28 Mar 2014 10:50:21 +0530
Message-Id: <1395984022-8284-2-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395984022-8284-1-git-send-email-tushar.behera@linaro.org>
References: <1395984022-8284-1-git-send-email-tushar.behera@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep all power-domains already enabled by bootloader on, even if no
driver has claimed them. This is useful for debug and development, but
should not be needed on a platform with proper driver support.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-pm@vger.kernel.org
---
 Documentation/kernel-parameters.txt |    7 +++++++
 drivers/base/power/domain.c         |   13 +++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50a001a..96bb532 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2557,6 +2557,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	pcmv=		[HW,PCMCIA] BadgePAD 4
 
+	pd_ignore_unused
+			[PM]
+			Keep all power-domains already enabled by bootloader on,
+			even if no driver has claimed them. This is useful
+			for debug and development, but should not be
+			needed on a platform with proper driver support.
+
 	pd.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 6f54962..ae098a2 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -705,6 +705,14 @@ static int pm_genpd_runtime_resume(struct device *dev)
 	return 0;
 }
 
+static bool pd_ignore_unused;
+static int __init pd_ignore_unused_setup(char *__unused)
+{
+	pd_ignore_unused = true;
+	return 1;
+}
+__setup("pd_ignore_unused", pd_ignore_unused_setup);
+
 /**
  * pm_genpd_poweroff_unused - Power off all PM domains with no devices in use.
  */
@@ -712,6 +720,11 @@ void pm_genpd_poweroff_unused(void)
 {
 	struct generic_pm_domain *genpd;
 
+	if (pd_ignore_unused) {
+		pr_warn("genpd: Not disabling unused power domains\n");
+		return;
+	}
+
 	mutex_lock(&gpd_list_lock);
 
 	list_for_each_entry(genpd, &gpd_list, gpd_list_node)
-- 
1.7.9.5

