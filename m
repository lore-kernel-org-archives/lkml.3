Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbaBTOqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:46:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:46071 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbaBTOqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:46:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,512,1389772800"; 
   d="scan'208,223";a="478495514"
Message-ID: <5306150C.4020202@intel.com>
Date: Thu, 20 Feb 2014 22:45:32 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING at kernel/workqueue.c:829 wq_worker_waking_up+0x53/0x70()
References: <20140213124059.GA2908@krava.brq.redhat.com> <20140217171900.GB29173@redhat.com> <20140218224907.GG31892@mtj.dyndns.org> <530602FA.1020103@intel.com> <20140220143102.GA12948@krava.brq.redhat.com>
In-Reply-To: <20140220143102.GA12948@krava.brq.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060508020801010107070209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060508020801010107070209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 02/20/2014 10:31 PM, Jiri Olsa wrote:
> On Thu, Feb 20, 2014 at 09:28:26PM +0800, Lan Tianyu wrote:
>> On 02/19/2014 06:49 AM, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Mon, Feb 17, 2014 at 06:19:00PM +0100, Oleg Nesterov wrote:
>>>> acpi_processor_set_throttling() plays with set_cpus_allowed_ptr(current),
>>>> this is obviously wrong, and the worker is bound.
>>>
>>> Umm... yeah, anything running on workqueues shouldn't be diddling with
>>> cpu affinity.  The function even has /* FIXME: use work_on_cpu() */ in
>>> it.  I suppose it's about time to actually implement that?
>>>
>>> Thanks.
>>>
>>
>> Hi Jiri:
>> 	Could you try this patch which reworks ACPI processor throttling
>> with work_on_cpu()?
>
> hum, I've got difficulties to apply it..
>
> [jolsa@krava2 linux-perf]$ git am /tmp/wq/
> Applying: WARNING at kernel/workqueue.c:829 wq_worker_waking_up+0x53/0x70()
> fatal: corrupt patch at line 8
> Patch failed at 0001 WARNING at kernel/workqueue.c:829 wq_worker_waking_up+0x53/0x70()
>
> jirka
>
Sorry. Please try the attachment again.

-- 
Best Regards
Tianyu Lan

--------------060508020801010107070209
Content-Type: text/x-patch;
 name="0001-ACPI-Processor-Rework-processor-throttling-with-work.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-ACPI-Processor-Rework-processor-throttling-with-work.pa";
 filename*1="tch"

>From 058dc817636186d1e9ccadfa7a2409aaeb1458f4 Mon Sep 17 00:00:00 2001
From: Lan Tianyu <tianyu.lan@intel.com>
Date: Thu, 20 Feb 2014 22:42:41 +0800
Subject: [PATCH] ACPI/Processor: Rework processor throttling with
 work_on_cpu()

---
 drivers/acpi/processor_throttling.c | 54 ++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 28baa05..a21a37d 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -1060,6 +1060,23 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 	return 0;
 }
 
+struct acpi_processor_throttling_arg {
+	struct acpi_processor *pr;
+	int target_state;
+	bool force;
+};
+
+static long acpi_processor_throttling_fn(void *data)
+{
+	struct acpi_processor_throttling_arg *arg = data;
+	struct acpi_processor *pr = arg->pr;
+	struct acpi_processor_throttling *p_throttling = &pr->throttling;
+
+	return p_throttling->acpi_processor_set_throttling(pr,
+			arg->target_state, arg->force);
+}
+
+
 int acpi_processor_set_throttling(struct acpi_processor *pr,
 						int state, bool force)
 {
@@ -1068,6 +1085,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	unsigned int i;
 	struct acpi_processor *match_pr;
 	struct acpi_processor_throttling *p_throttling;
+	struct acpi_processor_throttling_arg arg;
 	struct throttling_tstate t_state;
 	cpumask_var_t online_throttling_cpus;
 
@@ -1083,10 +1101,8 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	if (!alloc_cpumask_var(&saved_mask, GFP_KERNEL))
 		return -ENOMEM;
 
-	if (!alloc_cpumask_var(&online_throttling_cpus, GFP_KERNEL)) {
-		free_cpumask_var(saved_mask);
+	if (!alloc_cpumask_var(&online_throttling_cpus, GFP_KERNEL))
 		return -ENOMEM;
-	}
 
 	if (cpu_is_offline(pr->id)) {
 		/*
@@ -1096,7 +1112,6 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 		return -ENODEV;
 	}
 
-	cpumask_copy(saved_mask, &current->cpus_allowed);
 	t_state.target_state = state;
 	p_throttling = &(pr->throttling);
 	cpumask_and(online_throttling_cpus, cpu_online_mask,
@@ -1118,14 +1133,10 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		/* FIXME: use work_on_cpu() */
-		if (set_cpus_allowed_ptr(current, cpumask_of(pr->id))) {
-			/* Can't migrate to the pr->id CPU. Exit */
-			ret = -ENODEV;
-			goto exit;
-		}
-		ret = p_throttling->acpi_processor_set_throttling(pr,
-						t_state.target_state, force);
+		arg.pr = pr;
+		arg.target_state = state;
+		arg.force = force;
+		ret = work_on_cpu(pr->id, acpi_processor_throttling_fn, &arg);
 	} else {
 		/*
 		 * When the T-state coordination is SW_ALL or HW_ALL,
@@ -1153,13 +1164,12 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 					"on CPU %d\n", i));
 				continue;
 			}
-			t_state.cpu = i;
-			/* FIXME: use work_on_cpu() */
-			if (set_cpus_allowed_ptr(current, cpumask_of(i)))
-				continue;
-			ret = match_pr->throttling.
-				acpi_processor_set_throttling(
-				match_pr, t_state.target_state, force);
+
+			arg.pr = match_pr;
+			arg.target_state = state;
+			arg.force = force;
+			ret = work_on_cpu(pr->id, acpi_processor_throttling_fn,
+				&arg);
 		}
 	}
 	/*
@@ -1173,12 +1183,8 @@ int acpi_processor_set_throttling(struct acpi_processor *pr,
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
 	}
-	/* restore the previous state */
-	/* FIXME: use work_on_cpu() */
-	set_cpus_allowed_ptr(current, saved_mask);
-exit:
+
 	free_cpumask_var(online_throttling_cpus);
-	free_cpumask_var(saved_mask);
 	return ret;
 }
 
-- 
1.8.2.1


--------------060508020801010107070209--
