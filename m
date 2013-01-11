Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab3AKBji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 20:39:38 -0500
Received: from mga14.intel.com ([143.182.124.37]:57165 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277Ab3AKBjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 20:39:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,447,1355126400"; 
   d="scan'208";a="189973479"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Thread-Topic: [PATCH] hardlockup: detect hard lockups without NMIs using
 secondary cpus
Thread-Index: AQHN7tX2GijEmtnaaUikVxcrVBNBW5hDWEWg
Date: Fri, 11 Jan 2013 01:39:33 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A200DD9@SHSMSX101.ccr.corp.intel.com>
References: <1357783059-13923-1-git-send-email-ccross@android.com>
In-Reply-To: <1357783059-13923-1-git-send-email-ccross@android.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Colin Cross [mailto:ccross@android.com]
> Sent: Thursday, January 10, 2013 9:58 AM
> To: linux-kernel@vger.kernel.org
> Cc: Andrew Morton; Don Zickus; Ingo Molnar; Thomas Gleixner; Liu,
> Chuansheng; linux-arm-kernel@lists.infradead.org; Colin Cross
> Subject: [PATCH] hardlockup: detect hard lockups without NMIs using
> secondary cpus
> 
> Emulate NMIs on systems where they are not available by using timer
> interrupts on other cpus.  Each cpu will use its softlockup hrtimer
> to check that the next cpu is processing hrtimer interrupts by
> verifying that a counter is increasing.
> 
> This patch is useful on systems where the hardlockup detector is not
> available due to a lack of NMIs, for example most ARM SoCs.
> Without this patch any cpu stuck with interrupts disabled can
> cause a hardware watchdog reset with no debugging information,
> but with this patch the kernel can detect the lockup and panic,
> which can result in useful debugging info.
> 
> Signed-off-by: Colin Cross <ccross@android.com>
> +static void watchdog_check_hardlockup_other_cpu(void)
> +{
> +	int cpu;
> +	cpumask_t cpus = watchdog_cpus;
> +
> +	/*
> +	 * Test for hardlockups every 3 samples.  The sample period is
> +	 *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
> +	 *  watchdog_thresh (over by 20%).
> +	 */
> +	if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
> +		return;
> +
> +	/* check for a hardlockup on the next cpu */
> +	cpu = cpumask_next(smp_processor_id(), &cpus);
> +	if (cpu >= nr_cpu_ids)
> +		cpu = cpumask_first(&cpus);
> +	if (cpu == smp_processor_id())
> +		return;
> +
> +	smp_rmb();
> +
> +	if (per_cpu(watchdog_nmi_touch, cpu) == true) {
> +		per_cpu(watchdog_nmi_touch, cpu) = false;
> +		return;
> +	}
> +
> +	if (is_hardlockup_other_cpu(cpu)) {
> +		/* only warn once */
One possible case for new hotplug CPU that false hardlockup case.
1/ Assume CPU1, CPU2 are online, CPU3 is being hotplug:
CPU3:                                            CPU2:
watchdog_nmi_enable()
 per_cpu(watchdog_nmi_touch, cpu) = true;
 cpumask_set_cpu(cpu, &watchdog_cpus);
                                                 watchdog_check_hardlockup_other_cpu()
                                                   per_cpu(watchdog_nmi_touch, cpu) = false; == > Here cpu is CPU3

2/ Before CPU3's first hrtimer interrupt coming, CPU2 is been offlined.
  Then CPU1's next CPU is CPU3. But we can not use CPU3's watchdog_nmi_touch to defense
  false CPU3 hardlock more. When CPU1's hrtimer interrupt coming, it is possible report CPU3
  false hard lockup.

Is it the case?


