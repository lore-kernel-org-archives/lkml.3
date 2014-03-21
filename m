Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbaCUAEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965028AbaCUAES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Plattner <aplattner@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.13 088/149] cpufreq: use cpufreq_cpu_get() to avoid cpufreq_get() race conditions
Date: Thu, 20 Mar 2014 17:04:11 -0700
Message-Id: <20140321000440.007851096@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

commit 999976e0f6233322a878b0b7148c810544d6c8a8 upstream.

If a module calls cpufreq_get while cpufreq is initializing, it's
possible for it to be called after cpufreq_driver is set but before
cpufreq_cpu_data is written during subsys_interface_register.  This
happens because cpufreq_get doesn't take the cpufreq_driver_lock
around its use of cpufreq_cpu_data.

Fix this by using cpufreq_cpu_get(cpu) to look up the policy rather
than reading it out of cpufreq_cpu_data directly.  cpufreq_cpu_get()
takes the appropriate locks to prevent this race from happening.

Since it's possible for policy to be NULL if the caller passes in an
invalid CPU number or calls the function before cpufreq is initialized,
delete the BUG_ON(!policy) and simply return 0.  Don't try to return
-ENOENT because that's negative and the function returns an unsigned
integer.

References: https://bbs.archlinux.org/viewtopic.php?id=177934
Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1447,23 +1447,16 @@ static unsigned int __cpufreq_get(unsign
  */
 unsigned int cpufreq_get(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	unsigned int ret_freq = 0;
 
-	if (cpufreq_disabled() || !cpufreq_driver)
-		return -ENOENT;
+	if (policy) {
+		down_read(&policy->rwsem);
+		ret_freq = __cpufreq_get(cpu);
+		up_read(&policy->rwsem);
 
-	BUG_ON(!policy);
-
-	if (!down_read_trylock(&cpufreq_rwsem))
-		return 0;
-
-	down_read(&policy->rwsem);
-
-	ret_freq = __cpufreq_get(cpu);
-
-	up_read(&policy->rwsem);
-	up_read(&cpufreq_rwsem);
+		cpufreq_cpu_put(policy);
+	}
 
 	return ret_freq;
 }


