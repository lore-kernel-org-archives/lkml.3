Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404AbaDBOTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:19:52 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:58384 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbaDBOTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:19:47 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-ed-533c1c80c5f6
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: stable@vger.kernel.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Xiaoguang Chen <chenxg@marvell.com>, Stephen Boyd <sboyd@codeaurora.org>,
        rjw@rjwysocki.net, Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 2/2] cpufreq: Fix timer/workqueue corruption due to double
 queueing
Date: Wed, 02 Apr 2014 16:19:38 +0200
Message-id: <1396448378-22487-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1396448378-22487-1-git-send-email-k.kozlowski@samsung.com>
References: <1396448378-22487-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e/4Zd0GGZtggztXjS2OTV/CavG06Qe7
	xeVdc9gsPvceYbR4vOItu8WZ05dYLX6c6WaxWLDxEaPFxq8eDpwel/t6mTwW73nJ5HHn2h42
	j8kLLzJ7bLnazuLxeZNcAFsUl01Kak5mWWqRvl0CV0bz08nMBS0qFe++3WVqYNwv28XIySEh
	YCJx+f1ONghbTOLCvfVANheHkMBSRokFzQsZIZw+JolTK+awg1SxCRhLbF6+BKxDRCBX4nPH
	emaQImaBvYwSJ3ovMYMkhAVCJU7N7mUFsVkEVCWuzdnGAmLzCrhLTLy7ASjOAbROQWLOJBuQ
	MKeAh8S+TefAWoWASl6tfMk2gZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQkPuy
	g3HxMatDjAIcjEo8vBZSNsFCrIllxZW5hxglOJiVRHgnfbIOFuJNSaysSi3Kjy8qzUktPsTI
	xMEp1cCYUGgQH7kga86aHfXxjb8cjz1/2PTayzr3y9GbtWJ+33+/ePh12f3bN9gfyVYc674o
	c3NBT42Mg/+0s5JRtk0VTf4qL4zP5UiEzD3YsVPr+C3Thp8mvzcJ55r/2lV1wbqlRGNZaVNt
	YaNjxooTm2LmHlfILjh4lGPfD70KpQ03PmxPOvbuqK27EktxRqKhFnNRcSIA/XB5PxcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

When a CPU is hot removed we'll cancel all the delayed work items
via gov_cancel_work(). Normally this will just cancels a delayed
timer on each CPU that the policy is managing and the work won't
run, but if the work is already running the workqueue code will
wait for the work to finish before continuing to prevent the
work items from re-queuing themselves like they normally do. This
scheme will work most of the time, except for the case where the
work function determines that it should adjust the delay for all
other CPUs that the policy is managing. If this scenario occurs,
the canceling CPU will cancel its own work but queue up the other
CPUs works to run. For example:

 CPU0                                        CPU1
 ----                                        ----
 cpu_down()
  ...
  __cpufreq_remove_dev()
   cpufreq_governor_dbs()
    case CPUFREQ_GOV_STOP:
     gov_cancel_work(dbs_data, policy);
      cpu0 work is canceled
       timer is canceled
       cpu1 work is canceled                    <work runs>
       <waits for cpu1>                         od_dbs_timer()
                                                 gov_queue_work(*, *, true);
 						  cpu0 work queued
 						  cpu1 work queued
						  cpu2 work queued
						  ...
       cpu1 work is canceled
       cpu2 work is canceled
       ...

At the end of the GOV_STOP case cpu0 still has a work queued to
run although the code is expecting all of the works to be
canceled. __cpufreq_remove_dev() will then proceed to
re-initialize all the other CPUs works except for the CPU that is
going down. The CPUFREQ_GOV_START case in cpufreq_governor_dbs()
will trample over the queued work and debugobjects will spit out
a warning:

WARNING: at lib/debugobjects.c:260 debug_print_object+0x94/0xbc()
ODEBUG: init active (active state 0) object type: timer_list hint: delayed_work_timer_fn+0x0/0x10
Modules linked in:
CPU: 0 PID: 1491 Comm: sh Tainted: G        W    3.10.0 #19
[<c010c178>] (unwind_backtrace+0x0/0x11c) from [<c0109dec>] (show_stack+0x10/0x14)
[<c0109dec>] (show_stack+0x10/0x14) from [<c01904cc>] (warn_slowpath_common+0x4c/0x6c)
[<c01904cc>] (warn_slowpath_common+0x4c/0x6c) from [<c019056c>] (warn_slowpath_fmt+0x2c/0x3c)
[<c019056c>] (warn_slowpath_fmt+0x2c/0x3c) from [<c0388a7c>] (debug_print_object+0x94/0xbc)
[<c0388a7c>] (debug_print_object+0x94/0xbc) from [<c0388e34>] (__debug_object_init+0x2d0/0x340)
[<c0388e34>] (__debug_object_init+0x2d0/0x340) from [<c019e3b0>] (init_timer_key+0x14/0xb0)
[<c019e3b0>] (init_timer_key+0x14/0xb0) from [<c0635f78>] (cpufreq_governor_dbs+0x3e8/0x5f8)
[<c0635f78>] (cpufreq_governor_dbs+0x3e8/0x5f8) from [<c06325a0>] (__cpufreq_governor+0xdc/0x1a4)
[<c06325a0>] (__cpufreq_governor+0xdc/0x1a4) from [<c0633704>] (__cpufreq_remove_dev.isra.10+0x3b4/0x434)
[<c0633704>] (__cpufreq_remove_dev.isra.10+0x3b4/0x434) from [<c08989f4>] (cpufreq_cpu_callback+0x60/0x80)
[<c08989f4>] (cpufreq_cpu_callback+0x60/0x80) from [<c08a43c0>] (notifier_call_chain+0x38/0x68)
[<c08a43c0>] (notifier_call_chain+0x38/0x68) from [<c01938e0>] (__cpu_notify+0x28/0x40)
[<c01938e0>] (__cpu_notify+0x28/0x40) from [<c0892ad4>] (_cpu_down+0x7c/0x2c0)
[<c0892ad4>] (_cpu_down+0x7c/0x2c0) from [<c0892d3c>] (cpu_down+0x24/0x40)
[<c0892d3c>] (cpu_down+0x24/0x40) from [<c0893ea8>] (store_online+0x2c/0x74)
[<c0893ea8>] (store_online+0x2c/0x74) from [<c04519d8>] (dev_attr_store+0x18/0x24)
[<c04519d8>] (dev_attr_store+0x18/0x24) from [<c02a69d4>] (sysfs_write_file+0x100/0x148)
[<c02a69d4>] (sysfs_write_file+0x100/0x148) from [<c0255c18>] (vfs_write+0xcc/0x174)
[<c0255c18>] (vfs_write+0xcc/0x174) from [<c0255f70>] (SyS_write+0x38/0x64)
[<c0255f70>] (SyS_write+0x38/0x64) from [<c0106120>] (ret_fast_syscall+0x0/0x30)

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/cpufreq/cpufreq_governor.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 87427360c77f..bce2cd216423 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -119,6 +119,9 @@ void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 {
 	int i;
 
+	if (!policy->governor_enabled)
+		return;
+
 	if (!all_cpus) {
 		__gov_queue_work(smp_processor_id(), dbs_data, delay);
 	} else {
-- 
1.7.9.5

