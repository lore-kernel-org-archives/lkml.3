Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3CNHg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:36:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45392 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab3CNHgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:36:24 -0400
Message-ID: <51417E58.5050501@ti.com>
Date: Thu, 14 Mar 2013 13:08:00 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Deacon <Will.Deacon@arm.com>
CC: Lokesh Vutla <lokeshvutla@ti.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if system
 supports 'has_ossr'
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com> <51406BA7.8010306@arm.com> <51407120.7030709@ti.com>
In-Reply-To: <51407120.7030709@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On Wednesday 13 March 2013 05:59 PM, Lokesh Vutla wrote:
> Hi Dietmar,
> On Wednesday 13 March 2013 05:35 PM, Dietmar Eggemann wrote:
>> On 13/03/13 06:52, Lokesh Vutla wrote:
>>> Commit {9a6eb31 ARM: hw_breakpoint: Debug powerdown support for
>>> self-hosted
>>> debug} introduces debug powerdown support for self-hosted debug.
>>> While merging the patch 'has_ossr' check was removed which
>>> was needed for hardwares which doesn't support self-hosted debug.
>>> Pandaboard (A9) is one such hardware and Dietmar's orginial
>>> patch did mention this issue.
>>> Without that check on Panda with CPUIDLE enabled, a flood of
>>> below messages thrown.
>>>
>>> [ 3.597930] hw-breakpoint: CPU 0 failed to disable vector catch
>>> [ 3.597991] hw-breakpoint: CPU 1 failed to disable vector catch
>>>
>>
>> Hi Lokesh,
>>
>> I confirm that this has_ossr condition has to go back into the
>> pm_init(void) call. I just verified it again on my Panda board and I get
>> the same issue like you without it.
>>
>> I guess what was happening is that Will asked me if this check is really
>> necessary and I said No without re-testing on my Panda board as an V7
>> debug architecture example where OSSR is not implemented. Since then I
>> only tested in on V7.1 debug architectures where OSSR is mandatory.
>> Sorry about this and thanks for catching this.
> Thanks for confirming..:)
> 
Can you please queue this one for 3.9-rc2+ ? Without this patch
CPUIDLE is unusable on OMAP4 devices because of those flood
of warning messages.

I was also wondering whether we should just warn once rather
than continuous warnings in the notifier. Patch is end of the
email.

Regards,
Santosh

>From b8db63f786719aef835f1ef4e20f3b3406b99b62 Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Thu, 14 Mar 2013 13:03:25 +0530
Subject: [PATCH] ARM: hw_breakpoints: Use warn_once to avoid message flood on
 unsupported ossr machines

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/kernel/hw_breakpoint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index 96093b7..5dc1aa6 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -966,7 +966,7 @@ static void reset_ctrl_regs(void *unused)
 	}
 
 	if (err) {
-		pr_warning("CPU %d debug is powered down!\n", cpu);
+		pr_warn_once("CPU %d debug is powered down!\n", cpu);
 		cpumask_or(&debug_err_mask, &debug_err_mask, cpumask_of(cpu));
 		return;
 	}
@@ -987,7 +987,7 @@ clear_vcr:
 	isb();
 
 	if (cpumask_intersects(&debug_err_mask, cpumask_of(cpu))) {
-		pr_warning("CPU %d failed to disable vector catch\n", cpu);
+		pr_warn_once("CPU %d failed to disable vector catch\n", cpu);
 		return;
 	}
 
@@ -1007,7 +1007,7 @@ clear_vcr:
 	}
 
 	if (cpumask_intersects(&debug_err_mask, cpumask_of(cpu))) {
-		pr_warning("CPU %d failed to clear debug register pairs\n", cpu);
+		pr_warn_once("CPU %d failed to clear debug register pairs\n", cpu);
 		return;
 	}
 
-- 
1.7.9.5

