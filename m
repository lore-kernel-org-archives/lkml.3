Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3HAVUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 17:20:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51122 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab3HAVUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 17:20:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>, cpufreq@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: Avoid double kobject_put() for the same kobject in error code path
Date: Thu, 01 Aug 2013 23:31:05 +0200
Message-ID: <2204970.DYsqYi7YjZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The only case triggering a jump to the err_out_unregister label in
__cpufreq_add_dev() is when cpufreq_add_dev_interface() fails.
However, if cpufreq_add_dev_interface() fails, it calls kobject_put()
for the policy kobject in its error code path and since that causes
the kobject's refcount to become 0, the additional kobject_put() for
the same kobject under err_out_unregister and the
wait_for_completion() following it are pointless, so drop them.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpufreq/cpufreq.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-pm/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/cpufreq.c
+++ linux-pm/drivers/cpufreq/cpufreq.c
@@ -1109,9 +1109,6 @@ err_out_unregister:
 	}
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
-	kobject_put(&policy->kobj);
-	wait_for_completion(&policy->kobj_unregister);
-
 err_set_policy_cpu:
 	per_cpu(cpufreq_policy_cpu, cpu) = -1;
 	cpufreq_policy_free(policy);

