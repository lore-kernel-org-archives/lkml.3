Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3IQLx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:53:26 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37921 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab3IQLxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:53:25 -0400
Message-ID: <523841BF.3070806@linux.vnet.ibm.com>
Date: Tue, 17 Sep 2013 17:19:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <80c4bd8c577e5da0aa63342671773be5cdc26a9a.1378012620.git.viresh.kumar@linaro.org> <5225E205.7080008@linux.vnet.ibm.com>	<5197493.kSPF7VUWqc@vostro.rjw.lan> <CAKohpom8d89OtJOs-_eCu+RiVA+B0bt7rtgNcJn=D=y95+jdQg@mail.gmail.com>
In-Reply-To: <CAKohpom8d89OtJOs-_eCu+RiVA+B0bt7rtgNcJn=D=y95+jdQg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091711-5816-0000-0000-000009F14225
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 05:14 PM, Viresh Kumar wrote:
> On 4 September 2013 01:10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> On Tuesday, September 03, 2013 06:50:05 PM Srivatsa S. Bhat wrote:
> 
>>> This doesn't solve the problem completely: it prevents the store_*() task
>>> from continuing *only* when it concurrently executes the __cpufreq_governor()
>>> function along with the CPU offline task. But if the two calls don't overlap,
>>> we will still have the possibility where the store_*() task tries to acquire
>>> the timer mutex after the CPU offline task has just finished destroying it.
>>
>> Yeah, I overlooked that.
> 
> As a background, I had a IRC chat with Srivatsa on this mail.. (I have marked
> this unread as there were other important topics to close)..
> 
> And he had some other code in mind and these synchronization problems
> aren't there with my patch at all (as per him too)..
> 
> Rafael, probably both me and Srivatsa are missing something that you
> understood, can you please share what problem you see here with my patch?
> 
> And yes, even with Srivatsa's patchset I found a problem:
> Two threads, one changing governor from ondemand->conservative and other
> one changing min/max freq..
> 
> First one will try to STOP governor and other one will try to change
> limits of gov.
> Suppose 2nd one gets to ->governor() and after this first one stops
> the governor.
> Now the first one tries to access lock and crashes..
> 
> On IRC, Srivatsa agreed about the problem..
> 

Actually, we had another round of discussions and decided that there is no
problem here. The reason is, the top-level store() routine takes the rwsem of
that policy for write; so only one store() can go at a time. So the race between
changing the governor and changing the min/max freq won't happen because only
one of them can execute at a given time. In fact, by extension, *any* two store()s
in cpufreq shouldn't race with one another.

So the conclusion is that the mainline code is fine in this aspect. Nothing
needs to be reverted.

That said, there are still certain low-priority/less-visible synchronization
issues to be fixed in cpufreq, and we'll take them up later, once the dust is
settled.

Regards,
Srivatsa S. Bhat

