Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165Ab3KTFee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 00:34:34 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:47362 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3KTFe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 00:34:29 -0500
MIME-Version: 1.0
In-Reply-To: <5289A80B.7080808@linaro.org>
References: <0e476d16e0ae4b001f5dd4f9ac191f899095928a.1384510171.git.viresh.kumar@linaro.org>
	<5974906.WAPp3f3eVY@vostro.rjw.lan>
	<CAKohpo=PoAaYgLNEVkkTC6tzAH=5hKw4VWTsrjt2jQnr7+6Q_w@mail.gmail.com>
	<5229929.5JRiWnF6CT@vostro.rjw.lan>
	<5289A80B.7080808@linaro.org>
Date: Wed, 20 Nov 2013 11:04:28 +0530
Message-ID: <CAKohpon5L21yXg=GAuSLSgkr_66iRSn_uUWKZ1FhwD3zuQNb_A@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: suspend/resume governors with PM notifiers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Nishanth Menon <nm@ti.com>,
        jinchoi@broadcom.com, Sebastian Capella <sebastian.capella@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2013 11:09, viresh kumar <viresh.kumar@linaro.org> wrote:
> On 18 November 2013 03:07, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Sunday, November 17, 2013 10:27:43 PM Viresh Kumar wrote:
>
>>> Okay.. Even these notifiers would be fine for me. To make things more clear
>>> before I start implementing them:
>>> - What about implementing syscore's suspend_prepare and post_suspend?
>>
>> I'm not sure how useful that would be.  When would you like to execute those
>> things?
>
> Maybe after freezing userspace. So I was actually looking to move the existing
> code I wrote in PM notifiers to those..
>
> Because in our usecase, we just want to know when suspend has started or
> resume has finished. And so we really don't need a per cpu callback.
>
> And so I felt probably it would be better to implement those instead of
> cpu_subsys callbacks.
>
>>> - Or you want to extend only CPU subsystems notifiers? What notifiers exactly?
>>> And at which places we want to issue them from?
>>
>> Why do we need to use notifiers?  What about PM callbacks?
>
> Yeah, we don't need notifiers but callbacks.
>
>>> Okay, so you were asking about extending following list: CPU_ONLINE,
>>> CPU_UP_PREPARE, CPU_UP_CANCELED, CPU_DOWN_PREPARE, etc.. to
>>> include suspend/resume ones as well?
>>
>> No.  Bus types (among other things) may provide suspend/resume callbacks for
>> handling devices.  We have a bus type for CPUs, which is called cpu_subsys
>> and currently doesn't define any PM callbacks, although it could do that in
>> principle.  Have you investigated that possibility?
>
> I did it now and got really confused. :)
>
> This is what my understanding is:
> - bus can register PM hooks, like suspend/resume/prepare, etc..
> - devices under that bus would register themselves to that bus and eventually
> can get their _driver's_ callbacks called via bus hooks.. For example and I2C
> controller driver's callbacks will get called via i2c core bus..
>
> - In case of cpu subsystem, even if cpu_subsys adds those hooks in
> drivers/base/cpu.c, then those hooks will get called for each cpu. CPU's don't
> have a driver and so the only callbacks called are the ones of cpu_subsys.
> - How will we bind/use them with cpufreq?
>
> Our sole requirement here is to get notify cpufreq core that system
> suspend/resume/hibernation/restore has started/finished. How will that get
> fulfilled with cpu_subsys callbacks?
>
>>> Logically speaking, all existing ones does look correct as they are more or
>>> less cpu related. But suspend/resume doesn't look any similar, Atleast to me.
>>>
>>> Suspend/resume are system's state rather than CPU's.. We aren't suspending
>>> or resuming CPUs, we are shutting them off.. So I thought maybe syscore ops
>>> is a better place (which is already used by cpufreq)..
>>
>> cpufreq uses syscore_ops for the boot CPU only and that admittedly is a hack.
>
> Why do you call it a hack?
>
>> syscore_ops is specifically for things that have to be suspended with only one
>> CPU online and with interrupts off.  I'm not sure how that applies to cpufreq.
>
> Currently syscore_ops only implements suspend/resume/shutdown callbacks and
> those precisely happen the way you mentioned. i.e. after removing all non-boot
> CPUs and disabling interrupts (And before bringing back all CPUs and enabling
> interrupts on resume side).. So, yes we have limitation currently..
>
> Honestly speaking I have looked at syscore ops for the first time now, when we
> got to this problem.. I couldn't find much information about it anywhere,
> leaving the commit itself: 40dc16
>
> And by that, this is the definition of this framework: "PM / Core: Introduce
> struct syscore_ops for core subsystems PM"
>
> I can see that you mentioned the limitations like single cpu and disabled
> interrupts even in the log, but I think we can enhance this framework a little bit.
>
> Also I can see that there are many users of this framework which aren't core
> frameworks but simply drivers. I don't think that was the intention behind this
> framework, but that's how others went to use it.
>
> So, this framework exists to service core frameworks for their requirements
> about PM stages. Currently that is only limited to late suspend and early resume
> but I feel there is space for more..
>
> For example, our current problem.. A core framework wants to prepare before
> suspend starts and after everything has resumed. Obviously that would violate
> one of the basic rules with which this was designed, but still this feature lies
> in scope of syscore. And so we can keep the limitations as is for
> suspend/resume/shutdown but not for prepare and resume_late.
>
> And I really feel even if we would be able to use cpu callbacks for
> suspend/resume, that would be a real *Hack*, because our framework doesn't want
> to get a callback for each of its devices (i.e. cpu) but a single callback at
> certain instances.. And syscore suits very well to this scenario..

Hi Rafael,

I need few more suggestions from you on this :)
