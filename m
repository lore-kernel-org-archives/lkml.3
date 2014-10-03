Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760458AbaJCXiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:38:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbaJCWDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 318/357] cpufreq: fix cpufreq suspend/resume for intel_pstate
Date: Fri,  3 Oct 2014 14:31:44 -0700
Message-Id: <20141003212943.022752863@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 8e30444e153008e8eb3e74cbcb7a865bfcfb04a0 upstream.

Cpufreq core introduces cpufreq_suspended flag to let cpufreq sysfs nodes
across S2RAM/S2DISK. But the flag is only set in the cpufreq_suspend()
for cpufreq drivers which have target or target_index callback. This
skips intel_pstate driver. This patch is to set the flag before checking
target or target_index callback.

Fixes: 2f0aea936360 (cpufreq: suspend governors on system suspend/hibernate)
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
[rjw: Subject]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1666,6 +1666,8 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpufreq_suspended = true;
+
 	if (!has_target())
 		return;
 
@@ -1680,8 +1682,6 @@ void cpufreq_suspend(void)
 			pr_err("%s: Failed to suspend driver: %p\n", __func__,
 				policy);
 	}
-
-	cpufreq_suspended = true;
 }
 
 /**
@@ -1697,13 +1697,13 @@ void cpufreq_resume(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpufreq_suspended = false;
+
 	if (!has_target())
 		return;
 
 	pr_debug("%s: Resuming Governors\n", __func__);
 
-	cpufreq_suspended = false;
-
 	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
 		if (cpufreq_driver->resume && cpufreq_driver->resume(policy))
 			pr_err("%s: Failed to resume driver: %p\n", __func__,


