Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbaKLB3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:29:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbaKLB3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:29:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tobias Jakobi <liquid.acid@gmx.net>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.17 178/319] intel_pstate: Dont lose sysfs settings during cpu offline
Date: Wed, 12 Nov 2014 10:15:16 +0900
Message-Id: <20141112011022.170303748@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit c034871712730a33e0267095f48b62eae958499c upstream.

The user may have custom settings don't destroy them during suspend.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=80651
Reported-by: Tobias Jakobi <liquid.acid@gmx.net>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -702,7 +702,9 @@ static int intel_pstate_init_cpu(unsigne
 {
 	struct cpudata *cpu;
 
-	all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
+	if (!all_cpu_data[cpunum])
+		all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata),
+					       GFP_KERNEL);
 	if (!all_cpu_data[cpunum])
 		return -ENOMEM;
 
@@ -783,8 +785,6 @@ static void intel_pstate_stop_cpu(struct
 
 	del_timer_sync(&all_cpu_data[cpu_num]->timer);
 	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
-	kfree(all_cpu_data[cpu_num]);
-	all_cpu_data[cpu_num] = NULL;
 }
 
 static int intel_pstate_cpu_init(struct cpufreq_policy *policy)


