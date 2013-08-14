Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859Ab3HNNdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:33:02 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52238 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759891Ab3HNNcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:32:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        John Crispin <blogic@openwrt.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-cris-kernel@axis.com,
        linux-sh@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, Shawn Guo <shawn.guo@linaro.org>,
        spear-devel@list.st.com, Stephen Warren <swarren@nvidia.com>,
        Steven Miao <realmz6@gmail.com>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 01/37] cpufreq: call cpufreq_driver->get() after calling ->init()
Date: Wed, 14 Aug 2013 19:01:50 +0530
Message-Id: <2345f33fd6215a0754a71b4dc1ca02f8ff874211.1376486713.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Almost all drivers set policy->cur with current cpu frequency in their ->init()
part. This can be done for all of them at core level and so they wouldn't need
to do it.

This patch adds supporting code in cpufreq core for calling get() after we have
called init() for a policy.

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: John Crispin <blogic@openwrt.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-cris-kernel@axis.com
Cc: linux-sh@vger.kernel.org
Cc: Mikael Starvik <starvik@axis.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: spear-devel@list.st.com
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Steven Miao <realmz6@gmail.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 4d37306..a7a1d3e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1038,6 +1038,14 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 		goto err_set_policy_cpu;
 	}
 
+	if (cpufreq_driver->get) {
+		policy->cur = cpufreq_driver->get(policy->cpu);
+		if (!policy->cur) {
+			pr_err("%s: ->get() failed\n", __func__);
+			goto err_get_freq;
+		}
+	}
+
 	/* related cpus should atleast have policy->cpus */
 	cpumask_or(policy->related_cpus, policy->related_cpus, policy->cpus);
 
@@ -1097,6 +1105,9 @@ err_out_unregister:
 	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+err_get_freq:
+	if (cpufreq_driver->exit)
+		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
 	per_cpu(cpufreq_policy_cpu, cpu) = -1;
 	cpufreq_policy_free(policy);
-- 
1.7.12.rc2.18.g61b472e

