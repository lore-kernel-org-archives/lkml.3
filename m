Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328AbaGDWQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:16:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030233AbaGDWQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Plattner <aplattner@nvidia.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.15 55/66] cpufreq: unlock when failing cpufreq_update_policy()
Date: Fri,  4 Jul 2014 15:14:54 -0700
Message-Id: <20140704221425.319308546@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Plattner <aplattner@nvidia.com>

commit fefa8ff810c5ab4c4206aed9d159c4d6fe8d4f1c upstream.

Commit bd0fa9bb455d introduced a failure path to cpufreq_update_policy() if
cpufreq_driver->get(cpu) returns NULL.  However, it jumps to the 'no_policy'
label, which exits without unlocking any of the locks the function acquired
earlier.  This causes later calls into cpufreq to hang.

Fix this by creating a new 'unlock' label and jumping to that instead.

Fixes: bd0fa9bb455d ("cpufreq: Return error if ->get() failed in cpufreq_update_policy()")
Link: https://devtalk.nvidia.com/default/topic/751903/kernel-3-15-and-nv-drivers-337-340-failed-to-initialize-the-nvidia-kernel-module-gtx-550-ti-/
Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2166,10 +2166,8 @@ int cpufreq_update_policy(unsigned int c
 	struct cpufreq_policy new_policy;
 	int ret;
 
-	if (!policy) {
-		ret = -ENODEV;
-		goto no_policy;
-	}
+	if (!policy)
+		return -ENODEV;
 
 	down_write(&policy->rwsem);
 
@@ -2188,7 +2186,7 @@ int cpufreq_update_policy(unsigned int c
 		new_policy.cur = cpufreq_driver->get(cpu);
 		if (WARN_ON(!new_policy.cur)) {
 			ret = -EIO;
-			goto no_policy;
+			goto unlock;
 		}
 
 		if (!policy->cur) {
@@ -2203,10 +2201,10 @@ int cpufreq_update_policy(unsigned int c
 
 	ret = cpufreq_set_policy(policy, &new_policy);
 
+unlock:
 	up_write(&policy->rwsem);
 
 	cpufreq_cpu_put(policy);
-no_policy:
 	return ret;
 }
 EXPORT_SYMBOL(cpufreq_update_policy);


