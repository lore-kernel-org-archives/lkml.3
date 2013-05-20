Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3ETHMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 03:12:13 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:64584 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576Ab3ETHMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 03:12:09 -0400
MIME-Version: 1.0
In-Reply-To: <5199CB59.1020309@linux.vnet.ibm.com>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz>
	<20130509125040.GF27333@pd.tnic>
	<20130509125859.GG27333@pd.tnic>
	<20130515184528.GO4442@linux.vnet.ibm.com>
	<20130515224358.GF11783@pd.tnic>
	<20130515235512.GT4442@linux.vnet.ibm.com>
	<20130517135641.GF23035@pd.tnic>
	<51999591.8030401@linux.vnet.ibm.com>
	<20130520045023.GA12690@pd.tnic>
	<5199C169.7060504@linux.vnet.ibm.com>
	<20130520064727.GD12690@pd.tnic>
	<5199C990.3020602@linux.vnet.ibm.com>
	<5199CB59.1020309@linux.vnet.ibm.com>
Date: Mon, 20 May 2013 12:42:08 +0530
Message-ID: <CAKohponk-FQpHOx407FL63ZCYVgz2C-ScvZQBQFVxddbL+fS=A@mail.gmail.com>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, rjw@sisk.pl,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

I haven't followed this mail chain earlier and saw this mail only as I am
added in cc now. I probably have answers to few questions here:

On 20 May 2013 12:36, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> On 05/20/2013 02:58 PM, Michael Wang wrote:
>> On 05/20/2013 02:47 PM, Borislav Petkov wrote:
>>> On Mon, May 20, 2013 at 02:23:37PM +0800, Michael Wang wrote:
>>>> On 05/20/2013 12:50 PM, Borislav Petkov wrote:
>>>> So there are two questions here:
>>>> 1. Is gov_queue_work() want to queue the work on offline cpu?

No. We are only working with online cpus now in cpufreq core and governors.

>> Besides, the cpu gov_queue_work() is using 'policy->cpus' which seems to
>> be updated during UP DOWN notify, I think they are supposed to be online.
>>
>> But we need expert in cpufreq to confirm all these...

I confirm this. policy->cpus only contains online cpus.. and
policy->related_cpus
always contain online+offline cpus.

> And I guess this may help to reduce the chance to trigger WARN:
>
> diff --git a/drivers/cpufreq/cpufreq_governor.c
> b/drivers/cpufreq/cpufreq_governor.c
> index 443442d..0f96013 100644
> --- a/drivers/cpufreq/cpufreq_governor.c
> +++ b/drivers/cpufreq/cpufreq_governor.c
> @@ -180,7 +180,7 @@ void gov_queue_work(struct dbs_data *dbs_data,
> struct cpufreq_policy *policy,
>         if (!all_cpus) {
>                 __gov_queue_work(smp_processor_id(), dbs_data, delay);
>         } else {
> -               for_each_cpu(i, policy->cpus)
> +               for_each_cpu_and(i, policy->cpus, cpu_online_mask)
>                         __gov_queue_work(i, dbs_data, delay);
>         }
>  }

Not required at all... policy->cpus is guaranteed to have only online cpus.
