Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaCMRg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 13:36:27 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:60794 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736AbaCMRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 13:36:24 -0400
From: dirk.brandewie@gmail.com
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, rjw@rjwysocki.net, patrick.marlier@gmail.com,
        dirk.brandewie@gmail.com, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 1/2] cpufreq: Add exit_prepare callback to cpufreq_driver interface
Date: Thu, 13 Mar 2014 10:36:07 -0700
Message-Id: <1394732168-12638-2-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

This callback allows the driver to do clean up before the CPU is
completely down and its state cannot be modified.  This is used
by the intel_pstate driver to reduce the requested P state prior to
the core going away.  This is required because the requested P state
of the offline core is used to select the package P state. This
effectively sets the floor package P state to the requested P state on
the offline core.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 Documentation/cpu-freq/cpu-drivers.txt | 8 +++++++-
 drivers/cpufreq/cpufreq.c              | 3 +++
 include/linux/cpufreq.h                | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/Documentation/cpu-freq/cpu-drivers.txt b/Documentation/cpu-freq/cpu-drivers.txt
index 8b1a445..935f274 100644
--- a/Documentation/cpu-freq/cpu-drivers.txt
+++ b/Documentation/cpu-freq/cpu-drivers.txt
@@ -61,7 +61,13 @@ target_index		-	See below on the differences.
 
 And optionally
 
-cpufreq_driver.exit -		A pointer to a per-CPU cleanup function.
+cpufreq_driver.exit -		A pointer to a per-CPU cleanup
+		    		function called during CPU_POST_DEAD
+		    		phase of cpu hotplug process.
+
+cpufreq_driver.exit_prepare -	A pointer to a per-CPU cleanup function 
+			    	called during CPU_DOWN_PREPARE phase of 
+				cpu hotplug process.
 
 cpufreq_driver.resume -		A pointer to a per-CPU resume function
 				which is called with interrupts disabled
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index cf485d9..5c9bbfa 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1338,6 +1338,9 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 		}
 	}
 
+	if (cpufreq_driver->exit_prepare)
+		cpufreq_driver->exit_prepare(policy);
+
 	return 0;
 }
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4d89e0e..5fa94ad 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -224,6 +224,7 @@ struct cpufreq_driver {
 	int	(*bios_limit)	(int cpu, unsigned int *limit);
 
 	int	(*exit)		(struct cpufreq_policy *policy);
+	int	(*exit_prepare)	(struct cpufreq_policy *policy);
 	int	(*suspend)	(struct cpufreq_policy *policy);
 	int	(*resume)	(struct cpufreq_policy *policy);
 	struct freq_attr	**attr;
-- 
1.8.3.1

