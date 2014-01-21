Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaAUH0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 02:26:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:1986 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaAUH0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 02:26:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,695,1384329600"; 
   d="scan'208";a="468199079"
From: "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>
Subject: RE: [PATCH] cpufreq: Align all CPUs to the same frequency if using
 shared clock
Thread-Topic: [PATCH] cpufreq: Align all CPUs to the same frequency if using
 shared clock
Thread-Index: AQHPFnLkmoIEnd0u3UmWxfIRHgMuSJqOuuow
Date: Tue, 21 Jan 2014 07:26:28 +0000
Message-ID: <630F9443351D2B4BB7EC6BAE6B6B08342549C5DC@SHSMSX104.ccr.corp.intel.com>
References: <1390273543-18032-1-git-send-email-zhuangzhi.li@intel.com>
 <CAKohponL_R8M40BJa3X+++1yDtw5KRvk88w8kVfA+_D+poK08A@mail.gmail.com>
In-Reply-To: <CAKohponL_R8M40BJa3X+++1yDtw5KRvk88w8kVfA+_D+poK08A@mail.gmail.com>
Accept-Language: en-US
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

Thanks for reviewing.

Sorry for make you misunderstanding, on our x86 platform, we want all the CPUs share one policy by setting CPUFREQ_SHARED_TYPE_ALL, not share one HW clock line.
If the CPUs work at different frequency at init stage, then while the CPUs registering, no policy to align all the CPUs to the same frequency, this caused some conflicts with current CPUs P-state.

For example:
CPU0: P0
CPU1: P14
CPU2: P14
CPU3: P14
During all the CPUs registering, kernel considers all the CPUs work at P0 state because of sharing CPU0 policy, but the other three CPUs really work at P14 state,
all CPUs frequency only wait to be aligned until CPU0 state changed by governor based on shared policy. 

Best Regards

Li zhuangzhi
Android System Integration Shanghai
Tel: +86 (0)21 6116 4323


-----Original Message-----
From: Viresh Kumar [mailto:viresh.kumar@linaro.org] 
Sent: Tuesday, January 21, 2014 2:35 PM
To: Li, Zhuangzhi
Cc: Rafael J. Wysocki; cpufreq@vger.kernel.org; linux-pm@vger.kernel.org; Linux Kernel Mailing List; Liu, Chuansheng
Subject: Re: [PATCH] cpufreq: Align all CPUs to the same frequency if using shared clock

On 21 January 2014 08:35, lizhuangzhi <zhuangzhi.li@intel.com> wrote:
> Some SMP systems want to make all the possible CPUs share the clock, 
> if the CPUs init frequencies aren't the same, we need to align all the 
> CPUs to the same frequency while CPUs registing to avoid mismatched 
> CPU's P-states.
>
> Signed-off-by: lizhuangzhi <zhuangzhi.li@intel.com>
> ---
>  drivers/cpufreq/cpufreq.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c 
> index 8d19f7c..d00abb5 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -991,6 +991,8 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
>          * CPU because it is in the same boat. */
>         policy = cpufreq_cpu_get(cpu);
>         if (unlikely(policy)) {
> +               /* according present policy to align all the cpus frequencies */
> +               cpufreq_driver->target(policy, policy->cur, 
> + CPUFREQ_RELATION_H);

I don't really understand why is this required? CPUs sharing clocks means that CPUs runs on the same clock line and so all of them must be running on same frequency. So, why do we need to call this routine? policy->cur must be the current freq here for CPU in question.

--
viresh
