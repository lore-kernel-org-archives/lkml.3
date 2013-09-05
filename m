Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762635Ab3IEAyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 20:54:55 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43676 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab3IEAyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 20:54:53 -0400
Message-ID: <5227D65A.7040200@codeaurora.org>
Date: Wed, 04 Sep 2013 17:54:50 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <1706734.hVYFTCa5rJ@vostro.rjw.lan> <5227C729.5040803@codeaurora.org> <16630296.tCCMEKstkO@vostro.rjw.lan>
In-Reply-To: <16630296.tCCMEKstkO@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/13 17:26, Rafael J. Wysocki wrote:
> On Wednesday, September 04, 2013 04:50:01 PM Stephen Boyd wrote:
>> On 09/04/13 16:55, Rafael J. Wysocki wrote:
>>> Well, I'm not sure when Viresh is going to be back.
>>>
>>> Srivatsa, can you please resend this patch with a proper changelog?
>>>
>> I haven't had a chance to try this out yet, but I was just thinking
>> about this patch. How is it going to work? If one task opens the file
>> and another task is taking down the CPU wouldn't we deadlock in the
>> CPU_DOWN notifier waiting for the kobject to be released? Task 1 will
>> grab the kobject reference and sleep on the hotplug mutex and task 2
>> will put the kobject and wait for the completion, but it won't happen.
>> At least I think that's what would happen.
> Do you mean the completion in sysfs_deactivate()?  Yes, we can deadlock
> there.

I mean the complete in cpufreq_sysfs_release(). I don't think that will
ever be called because the kobject is held by the task calling store()
which is waiting on the hotplug lock to be released.

>
> Well, I guess the Srivatsa's patch may be salvaged by making it do a "trylock"
> version of get_online_cpus(), but then I wonder if there's no better way.

I think the real solution is to remove the kobject first if the CPU
going down is the last user of that policy. Once the completion is done
we can stop the governor and clean up state. For the case where there
are still CPUs using the policy why can't we cancel that CPU's work and
do nothing else? Even in the case where we have to move the cpufreq
directory do we need to do a STOP/START/LIMITS sequence? I hope we can
get away with just moving the directory and canceling that CPUs work then.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

