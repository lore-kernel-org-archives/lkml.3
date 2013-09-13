Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab3IMLo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 07:44:29 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:38634 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab3IMLo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 07:44:26 -0400
MIME-Version: 1.0
In-Reply-To: <5197493.kSPF7VUWqc@vostro.rjw.lan>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
	<80c4bd8c577e5da0aa63342671773be5cdc26a9a.1378012620.git.viresh.kumar@linaro.org>
	<5225E205.7080008@linux.vnet.ibm.com>
	<5197493.kSPF7VUWqc@vostro.rjw.lan>
Date: Fri, 13 Sep 2013 17:14:26 +0530
Message-ID: <CAKohpom8d89OtJOs-_eCu+RiVA+B0bt7rtgNcJn=D=y95+jdQg@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2013 01:10, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, September 03, 2013 06:50:05 PM Srivatsa S. Bhat wrote:

>> This doesn't solve the problem completely: it prevents the store_*() task
>> from continuing *only* when it concurrently executes the __cpufreq_governor()
>> function along with the CPU offline task. But if the two calls don't overlap,
>> we will still have the possibility where the store_*() task tries to acquire
>> the timer mutex after the CPU offline task has just finished destroying it.
>
> Yeah, I overlooked that.

As a background, I had a IRC chat with Srivatsa on this mail.. (I have marked
this unread as there were other important topics to close)..

And he had some other code in mind and these synchronization problems
aren't there with my patch at all (as per him too)..

Rafael, probably both me and Srivatsa are missing something that you
understood, can you please share what problem you see here with my patch?

And yes, even with Srivatsa's patchset I found a problem:
Two threads, one changing governor from ondemand->conservative and other
one changing min/max freq..

First one will try to STOP governor and other one will try to change
limits of gov.
Suppose 2nd one gets to ->governor() and after this first one stops
the governor.
Now the first one tries to access lock and crashes..

On IRC, Srivatsa agreed about the problem..

So, probably the first thing to do is to get this patch back, i.e.
revert of Srivatsa's
patch:

commit 56d07db274b7b15ca38b60ea4a762d40de093000
Author: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Date:   Sat Sep 7 01:23:55 2013 +0530

    cpufreq: Remove temporary fix for race between CPU hotplug and sysfs-writes


Srivatsa also asked if we can get a big lock around call to ->governor()
which would create recursive locks on a call to EXIT event (as we have seen it
earlier..)..

But he believes he can pull it off and will try this later.. So, for
now we can revert
the above patch :)

--
viresh
