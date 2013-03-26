Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078Ab3CZPzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:55:39 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:59188 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965025Ab3CZPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:55:35 -0400
MIME-Version: 1.0
In-Reply-To: <1364308932.5053.46.camel@laptop>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	<1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
	<1364302359.5053.21.camel@laptop>
	<CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com>
	<1364308932.5053.46.camel@laptop>
Date: Tue, 26 Mar 2013 16:55:33 +0100
Message-ID: <CAKfTPtDo3dmEZU-R62unQH9j5CxZWJj+Ws5CTBptOzTohkNJMA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        morten.rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 March 2013 15:42, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2013-03-26 at 15:03 +0100, Vincent Guittot wrote:
>> > But ha! here's your NO_HZ link.. but does the above DTRT and ensure
>> > that the ILB is a little core when possible?
>>
>> The loop looks for an idle CPU as close as possible to the buddy CPU
>> and the buddy CPU is the 1st CPU has been chosen. So if your buddy is
>> a little and there is an idle little, the ILB will be this idle
>> little.
>
> Earlier you wrote:
>
>>       | Cluster 0   | Cluster 1   |
>>       | CPU0 | CPU1 | CPU2 | CPU3 |
>> -----------------------------------
>> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
>
> So extrapolating that to a 4+4 big-little you'd get something like:
>
>       |   little  A9  ||   big A15     |
>       | 0 | 1 | 2 | 3 || 4 | 5 | 6 | 7 |
> ------+---+---+---+---++---+---+---+---+
> buddy | 0 | 0 | 0 | 0 || 0 | 4 | 4 | 4 |
>
> Right?

yes

>
> So supposing the current ILB is 6, we'll only check 4, not 0-3, even
> though there might be a perfectly idle cpu in there.

We will check 4,5,7 at MC level in order to pack in the group of A15
(because they are not sharing the same power domain). If none of them
are idle, we will look at CPU level and will check CPUs 0-3.

>
> Also, your scheme fails to pack when cpus 0,4 are filled, even when
> there's idle cores around.

The primary target is to pack the tasks only when we are in a not busy
system so you will have a power improvement without performance
decrease. is_light_task function returns false and  is_buddy_busy
function true before the buddy is fully loaded and the scheduler will
fall back into the default behavior which spreads tasks and races to
idle.

We can extend the buddy CPU and the packing mechanism to fill one CPU
before filling another buddy but it's not always the best choice for
performance and/or power and thus it will imply to have a knob to
select this full packing mode.

>
> If we'd use the ILB as packing cpu, we would simply select a next pack
> target once the old one fills up.

Yes, we will be able to pack the long running tasks and the wake up
will take care of the short tasks

>
