Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaIEHkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:40:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47164 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbaIEHkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:40:43 -0400
Subject: [PATCH V2 2/2] powernv/cpufreq: Set the pstate of the last
 hotplugged out cpu in policy->cpus to minimum
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: viresh.kumar@linaro.org, rjw@rjwysocki.net
Cc: linux-pm@vger.kernel.org, dirk.j.brandewie@intel.com,
        shreyas@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        patrick.marlier@gmail.com, linuxppc-dev@ozlabs.org,
        dirk.brandewie@gmail.com, svaidy@linux.vnet.ibm.com
Date: Fri, 05 Sep 2014 13:10:33 +0530
Message-ID: <20140905074023.3629.88028.stgit@preeti.in.ibm.com>
In-Reply-To: <20140905073812.3629.29175.stgit@preeti.in.ibm.com>
References: <20140905073812.3629.29175.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090507-9332-0000-0000-000001E9ADD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its possible today that the pstate of a core is held at a high even after the
entire core is hotplugged out if a load had just run on  the hotplugged cpu. This is
fair, since it is assumed that the pstate does not matter to a cpu in a deep idle
state, which is the expected state of a hotplugged core on powerpc. However on powerpc,
the pstate at a socket level is held at the maximum of the pstates of each core. Even
if the pstates of the active cores on that socket is low, the socket pstate is held
high due to the pstate of the hotplugged core in the above mentioned scenario. This
can cost significant amount of power loss for no good.

Besides, since it is a non active core, nothing can be done from the kernel's end
to set the frequency of the core right. Hence make use of the stop_cpu callback
to explicitly set the pstate of the core to a minimum when the last cpu of the
core gets hotplugged out.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 drivers/cpufreq/powernv-cpufreq.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/cpufreq/powernv-cpufreq.c b/drivers/cpufreq/powernv-cpufreq.c
index 379c083..5a628f1 100644
--- a/drivers/cpufreq/powernv-cpufreq.c
+++ b/drivers/cpufreq/powernv-cpufreq.c
@@ -317,6 +317,14 @@ static int powernv_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	return cpufreq_table_validate_and_show(policy, powernv_freqs);
 }
 
+static void powernv_cpufreq_stop_cpu(struct cpufreq_policy *policy)
+{
+	struct powernv_smp_call_data freq_data;
+
+	freq_data.pstate_id = powernv_pstate_info.min;
+	smp_call_function_single(policy->cpu, set_pstate, &freq_data, 1);
+}
+
 static struct cpufreq_driver powernv_cpufreq_driver = {
 	.name		= "powernv-cpufreq",
 	.flags		= CPUFREQ_CONST_LOOPS,
@@ -324,6 +332,7 @@ static struct cpufreq_driver powernv_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= powernv_cpufreq_target_index,
 	.get		= powernv_cpufreq_get,
+	.stop_cpu	= powernv_cpufreq_stop_cpu,
 	.attr		= powernv_cpu_freq_attr,
 };
 

