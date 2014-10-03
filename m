Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaJCWHE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:07:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbaJCWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:06:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 346/357] cpufreq: update cpufreq_suspended after stopping governors
Date: Fri,  3 Oct 2014 14:32:12 -0700
Message-Id: <20141003212943.845595412@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

commit b1b12babe3b72cfb08b875245e5a5d7c2747c772 upstream.

Commit 8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for intel_pstate")
introduced a bug where the governors wouldn't be stopped anymore for
->target{_index}() drivers during suspend. This happens because
'cpufreq_suspended' is updated before stopping the governors during suspend
and due to this __cpufreq_governor() would return early due to this check:

	/* Don't start any governor operations if we are entering suspend */
	if (cpufreq_suspended)
		return 0;

Fixes: 8e30444e1530 ("cpufreq: fix cpufreq suspend/resume for intel_pstate")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1666,10 +1666,8 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
-	cpufreq_suspended = true;
-
 	if (!has_target())
-		return;
+		goto suspend;
 
 	pr_debug("%s: Suspending Governors\n", __func__);
 
@@ -1682,6 +1680,9 @@ void cpufreq_suspend(void)
 			pr_err("%s: Failed to suspend driver: %p\n", __func__,
 				policy);
 	}
+
+suspend:
+	cpufreq_suspended = true;
 }
 
 /**


