Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419Ab3CZNxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:53:33 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:63042 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab3CZNxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:53:32 -0400
MIME-Version: 1.0
In-Reply-To: <1364301998.5053.17.camel@laptop>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	<1363955155-18382-4-git-send-email-vincent.guittot@linaro.org>
	<1364301998.5053.17.camel@laptop>
Date: Tue, 26 Mar 2013 14:53:30 +0100
Message-ID: <CAKfTPtAwKXgCW8ausMXiGV8365Lu8CDd4US-OWFLXPpwPYt0qA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/6] sched: pack small tasks
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

On 26 March 2013 13:46, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2013-03-22 at 13:25 +0100, Vincent Guittot wrote:
>> During the creation of sched_domain, we define a pack buddy CPU for
>> each CPU
>> when one is available. We want to pack at all levels where a group of
>> CPU can
>> be power gated independently from others.
>> On a system that can't power gate a group of CPUs independently, the
>> flag is
>> set at all sched_domain level and the buddy is set to -1. This is the
>> default
>> behavior.
>> On a dual clusters / dual cores system which can power gate each core
>> and
>> cluster independently, the buddy configuration will be :
>>
>>       | Cluster 0   | Cluster 1   |
>>       | CPU0 | CPU1 | CPU2 | CPU3 |
>> -----------------------------------
>> buddy | CPU0 | CPU0 | CPU0 | CPU2 |
>
> I suppose this is adequate for the 'small' systems you currently have;
> but given that Samsung is already bragging with its 'octo'-core Exynos
> 5 (4+4 big-little thing) does this solution scale?

The packing is only done at MC and CPU level to minimize the number of
transition.

>
> Isn't this basically related to picking the NO_HZ cpu; if the system
> isn't fully symmetric with its power gates you want the NO_HZ cpu to be
> the 'special' cpu. If it is symmetric we really don't care which core
> is left 'running' and we can even select a new pack cpu from the idle
> cores once the old one is fully utilized.

I agree that on a symmetric system, we don't really care about which
core is selected but we want to use the same one whenever possible to
prevent a ping pong between several cores or groups of cores, which is
power consuming. By forcing a NOHZ cpu, your background activity will
smoothly pack on this CPU and will not be spread on your system.
When a CPU is fully loaded, we don't fall in a low CPU load use case
and the periodic load balance can handle the situation to select a new
target CPU which is close to the buddy CPU

>
> Re-using (or integrating) with NO_HZ has the dual advantage that you'll
> make NO_HZ do the right thing for big-little (you typically want a
> little core to be the one staying 'awake' and once someone makes NO_HZ
> scale this all gets to scale along with it.
>

I think that you have answered to this question in your comment of
patch 5, isn't it?

Vincent
