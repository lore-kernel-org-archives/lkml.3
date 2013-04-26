Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525Ab3DZNQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:16:36 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:57352 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab3DZNQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:16:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130426123002.GA13464@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
	<1366910611-20048-4-git-send-email-vincent.guittot@linaro.org>
	<20130426123002.GA13464@dyad.programming.kicks-ass.net>
Date: Fri, 26 Apr 2013 15:16:33 +0200
Message-ID: <CAKfTPtBTs17yc_Ff9Es2m6kmvsqidwFjAxYbR0sMJSFBeGGA6A@mail.gmail.com>
Subject: Re: [PATCH 03/14] sched: pack small tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Lukasz Majewski <l.majewski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2013 14:30, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Apr 25, 2013 at 07:23:19PM +0200, Vincent Guittot wrote:
>> During the creation of sched_domain, we define a pack buddy CPU for each CPU
>> when one is available. We want to pack at all levels where a group of CPUs can
>> be power gated independently from others.
>> On a system that can't power gate a group of CPUs independently, the flag is
>> set at all sched_domain level and the buddy is set to -1. This is the default
>> behavior.
>>
>> On a dual clusters / dual cores system which can power gate each core and
>> cluster independently, the buddy configuration will be :
>>
>>       | Cluster 0   | Cluster 1   |
>>       | CPU0 | CPU1 | CPU2 | CPU3 |
>> -----------------------------------
>> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
>>
>> If the cores in a cluster can't be power gated independently, the buddy
>> configuration becomes:
>>
>>       | Cluster 0   | Cluster 1   |
>>       | CPU0 | CPU1 | CPU2 | CPU3 |
>> -----------------------------------
>> buddy | CPU0 | CPU1 | CPU0 | CPU0 |
>>
>> Small tasks tend to slip out of the periodic load balance so the best place
>> to choose to migrate them is during their wake up. The decision is in O(1) as
>> we only check again one buddy CPU
>
>
> So I really don't get the point of this buddy stuff, even for light load non
> performance impact stuff you want to do.
>
> The moment you judge cpu0 busy you'll bail, even though its perfectly doable
> (and desirable afaict) to continue stacking light tasks on cpu1 instead of
> waking up cpu2/3.
>
> So what's wrong with keeping a single light-wake target cpu selection and
> updating it appropriately?

I have tried to follow the same kind of tasks migration as during load
balance: 1 CPU in a power domain group migrates tasks with other
groups.

>
> Also where/how does the nohz balance cpu criteria not match the light-wake
> target criteria?

The nohz balance cpu is an idle cpu but it doesn't mean that it's the
target cpu which will be sometime busy with the light tasks.
