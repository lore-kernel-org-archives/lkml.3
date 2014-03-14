Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaCNPKt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 11:10:49 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:46130 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaCNPKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 11:10:47 -0400
Message-ID: <53231BF4.2000308@intel.com>
Date: Fri, 14 Mar 2014 08:10:44 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
CC: dirk.j.brandewie@intel.com, Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, patrick.marlier@gmail.com
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com> <CAOh2x==at2PtHRpa=-_V6O5Z9aSog4r9BDb7ixJgBZk_+vfPtg@mail.gmail.com>
In-Reply-To: <CAOh2x==at2PtHRpa=-_V6O5Z9aSog4r9BDb7ixJgBZk_+vfPtg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 09:59 PM, Viresh Kumar wrote:
> On Thu, Mar 13, 2014 at 11:06 PM,  <dirk.brandewie@gmail.com> wrote:
>> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
>>
>> Some drivers (intel_pstate) need to modify state on a core before it
>> is completely offline.  The ->exit() callback is executed during the
>> CPU_POST_DEAD phase of the cpu offline process which is too late to
>> change the state of the core.
>>
>> Patch 1 adds an optional callback function to the cpufreq_driver
>> interface which is called by the core during the CPU_DOWN_PREPARE
>> phase of cpu offline in __cpufreq_remove_dev_prepare().
>>
>> Patch 2 changes intel_pstate to use the ->exit_prepare callback to do
>> its cleanup during cpu offline.
>
> Copying stuff from other mail thread here so that we can discuss on a
> single mail chain.
>
> On 14 March 2014 03:09, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>> On Thursday, March 13, 2014 12:56:02 PM Viresh Kumar wrote:
>>> On 13 March 2014 08:07, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>>>> On Wednesday, March 12, 2014 02:27:07 PM Dirk Brandewie wrote:
>>>
>>>>>> I see two possibilities:
>>>>>>    1. Move the exit() callback to __cpufreq_remove_dev_prepare().  I don't
>>>>>>       have a good understanding of what carnage this would cause in the core
>>>>>>       or other scaling drivers.
>>>>>>
>>>>>>    2. Add another callback to the cpufreq_driver interface that would be call
>>>>>>       from __cpufreq_remove_dev_prepare() if the callback was set.
>>>>
>>>> I prefer 2, the reason being that it pretty much is guaranteed not to break
>>>> anything.  For the record, I'm not a fan of adding new cpufreq driver callbacks,
>>>> but in this particular case it seems we can't really do anything better.
>>>
>>> I haven't thought a lot about which one of these two looks better, probably
>>> Rafael might be correct. But I can see another way out here as this is very
>>> much driver specific. Why can't we do a register_hotcpu_notifier() from
>>> pstate driver alone?
>>
>> Why would that be better than adding a new callback?
>
> Because its becoming more and more confusing. Probably we got the problem
> right but have wrong solutions for it.
>
> But having considered this issue in detail now, I have more inputs. All Dirk and
> Patrick wanted is to set core to min P-state before it gets offlined. We already
> have some infrastructure in core which is called this today:
> cpufreq_generic_suspend(). We can rework on that to get a more ideal solution
> for both the problems.

Are you proposing adding cpufreq_generic_suspend() to the core I can not find
it in the mainline code.

>
> Over that I don't think Dirk's solution is going to work if we twist
> the systems a bit.

Could you explain what "twist the systems a bit" means?

>For example, Dirk probably wanted to set P-STATE of every core to MIN
> when it goes down. But his solution probably doesn't do that right now.
>

No, I wanted to set the core that was being off-lined to min P state.

> As exit() is called only when the policy expires or all the CPUs of that policy
> are down. Suppose only one CPU out of 4 goes down from a policy, then
> pstate driver would never know that happened. And that core wouldn't go
> to min state.

My patch does not change the semantics of exit() or when it is called.  For
intel_pstate their is one cpu per policy so I moved all the cleanup to
exit_prepare() if there were work I needed to do at CPU_POST_DEAD I would have
continued to export the *optional* exit callback.

The callback name exit_prepare() was probably unfortunate and might be causing
some confusion.  I will be changing the name per Rafael's feedback.
>
> I think we have two solutions here:
> - If its just about setting core a particular freq when it goes down, I think it
> looks a generic enough problem and so better fix core for that. Probably with
> help of flags field/suspend-freq (maybe renamed) and without calling drivers
> exit() at all..

ATM the only thing that needs to be done in this case is to allow intel_pstate
to set the P state on the core when it is going done.  My solution from the
cores point of view is more generic, it allows any driver that needs to do work
during CPU_DOWN_PREPARE to do it without adding any new logic to the core.

>
> - If this is highly driver specific (which doesn't look like if all we
> have to do is setting freq to MIN),

That is why intel_pstate is the *only* driver using exit_prepare().  If
other drivers need to do work during this phase of the cpu hotplug process
then they can export the callback otherwise it has no affect on existing
or future scaling drivers.

> then better have something like
> register_hotcpu_notifier() with priority set to -1, so that it gets called after
> cpufreq.

intel_pstate or any scaling driver having its own hotcpu_notifier makes possible
for the core and the driver to disagree on the state of the driver.  Having
the driver take hotplug notifications from two directions is a bad idea IMHO.

>
> --
> viresh
>

