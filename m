Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab3FCGv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:51:56 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:34751 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3FCGvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:51:48 -0400
MIME-Version: 1.0
In-Reply-To: <3146671.7pOpkCChrO@vostro.rjw.lan>
References: <51A7BFA6.3070800@semaphore.gr>
	<51A8D0C2.1080801@semaphore.gr>
	<CAKohpokmn-Rf-1w2aQHMMMkMbJqxokWXm5ye3DNuc-yzzk=7pQ@mail.gmail.com>
	<3146671.7pOpkCChrO@vostro.rjw.lan>
Date: Mon, 3 Jun 2013 12:21:47 +0530
Message-ID: <CAKohpokGDFvtaBMKxLTJCkx_WN+HN4eZ7LZ2upBLsXAsmcq7kA@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: ondemand: Change the calculation of target frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Stratos Karafotis <stratosk@semaphore.gr>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 June 2013 01:07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday, June 01, 2013 08:26:47 PM Viresh Kumar wrote:

>> Even removal of __cpufreq_driver_getavg() should be done in a separate
>> patch, so that it can be reverted easily if required later.
>
> Why would you want to revert it separately?

We might not need to revert all the changes that Stratos is doing.
Only a revert of getavg() and its users + a small fix in governor would
be enough. Stratos patch isn't only about removing getavg() but how
ondemand works and so breaking stuff might be more useful.

>> >> "Proportional to load" means C * load, so why is "policy->max / 100" *the* right C?
>> >
>> > I think, finally(?) I see your point. The right C should be "policy->cpuinfo.max_freq / 100".
>>
>> Why are you changing it to cpuinfo.max_freq?? This is fixed once a driver is
>> initialized.. but user may request a lower max freq for a governor or policy.
>> Which is actually reflected in policy->max I believe.
>
> Which doesn't matter.  The formula should provide the same results regardless
> of the user settings except that the selected frequency should be capped by
> policy->max (instead of being proportional to it).  I think using
> cpuinfo.max_freq here is correct.

I am confused now about what to use.. This is how I read it:

Assumption: CPU supports following freq range.. 500 MHz, 600 MHz, 700 MHz,
800 MHz, 900 MHz, 1 GHz

cpuinfo.max_freq = 1 GHz
policy->max is set to 600 MHz

Case 1: Use policy->max:

We need load to be over 500/600 (i.e. .834) to move to 600 MHz.

Case 2: Use cpuinfo.max_freq..

We need load to be over 500/1000 (i.e. .5) to move to 600 MHz.

So, obviously the calculations aren't the same..

Now, this is how I understood these two different variables:
- cpuinfo.max_freq:

>> Over that why keeping following check is useful anymore?
>>
>> if (load_freq > od_tuners->up_threshold)
>>     goto max.
>>
>> As, if load is over 95, then even policy->max * 95 / 100 will even give almost
>> the same freq.
>
> Yes, in the majority of cases.
>
> Thanks,
> Rafael
>
>
> --
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
