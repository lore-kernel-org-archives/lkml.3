Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3EUH7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:59:11 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:40039 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3EUH7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:59:08 -0400
Message-ID: <519B292F.5020603@linux.vnet.ibm.com>
Date: Tue, 21 May 2013 15:58:39 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Viresh Kumar <viresh.kumar@linaro.org>, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, rjw@sisk.pl,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
References: <20130520064727.GD12690@pd.tnic> <5199C990.3020602@linux.vnet.ibm.com> <5199CB59.1020309@linux.vnet.ibm.com> <CAKohponk-FQpHOx407FL63ZCYVgz2C-ScvZQBQFVxddbL+fS=A@mail.gmail.com> <5199CFD0.9030101@linux.vnet.ibm.com> <5199E54D.7030407@linux.vnet.ibm.com> <CAKohponS+tCkZyVpDO9fEMQCfsn5h=N235sj5sBGUkD2qKY=cQ@mail.gmail.com> <5199EBB5.7060209@linux.vnet.ibm.com> <20130520132355.GF12690@pd.tnic> <519ADA03.5060206@linux.vnet.ibm.com> <20130521072140.GA4866@pd.tnic>
In-Reply-To: <20130521072140.GA4866@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052107-5490-0000-0000-0000038123E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 03:21 PM, Borislav Petkov wrote:
> On Tue, May 21, 2013 at 10:20:51AM +0800, Michael Wang wrote:
>> This is not enough to prove that policy->cpus is wrong, the cpu could
>> be online when get from policy->cpus, but offline when checked here,
>> since hotplug is able to happen during the period.
> 
> Strictly speaking you're correct but I don't do any hotplug besides the
> one-time thing which is part of halting the box.

Well, they share the same cpu_down() I suppose...

> 
>> I don't get it...
>>
>> get_online_cpus() is just stop hotplug happen after it was invoked, so
>> unless policy->cpus is really wrong, otherwise all the cpu it masked
>> won't go offline any more.
> 
> Yes, that's my impression too - at the point we do gov_queue_work,
> policy->cpus already contains offline cpus.
> 
>> This protect nothing...before we go here, the cpu could already
>> offline, nothing changed...
> 
> Yes, but I don't want to schedule work on an offlined cpu and that is
> ensured here.

IMHO, the problem seems mostly like the wrong usage of policy->cpus,
it's providing the right info, but just at that time, we don't need
worry about work on offlined cpu if we don't allow cpu disappear.

Your approach could be good respect to performance, but if we could
prove that policy->cpus is correct firstly, than we could fix the
problem without any concern, don't we?

> 
>> If you really want to confirm the policy->cpus was wrong, the way
>> should be apply the fix I suggested, than check online in here.
> 
> Sure, feel free to get a box, enable NO_HZ_FULL and do all the
> experimentations you desire. I surely cannot be the only one who
> triggers this.

I'm fine if the problem get solved, that means your box doesn't show
WARN any more :)

Regards,
Michael Wang

> 

