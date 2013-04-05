Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3DELIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:08:06 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:33878 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333Ab3DELIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:08:05 -0400
MIME-Version: 1.0
In-Reply-To: <1364308932.5053.46.camel@laptop>
References: <1363955155-18382-1-git-send-email-vincent.guittot@linaro.org>
	<1363955155-18382-6-git-send-email-vincent.guittot@linaro.org>
	<1364302359.5053.21.camel@laptop>
	<CAKfTPtD=_oS5gJeynUG=ft-Y1zEdxZEMhUPH9hSXx+H2pi4xgA@mail.gmail.com>
	<1364308932.5053.46.camel@laptop>
Date: Fri, 5 Apr 2013 13:08:02 +0200
Message-ID: <CAKfTPtArtgkH5MU_xFAKjLDS-i32g2qQMdvyW=LLkG84tH8Hhg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 5/6] sched: pack the idle load balance
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Turner <pjt@google.com>, Santosh <santosh.shilimkar@ti.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

After some toughts about your comments,I can update the buddy cpu
during ILB or periofdic LB to a new idle core and extend the packing
mechanism  Does this additional mechanism sound better for you ?

Vincent

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
>
> So supposing the current ILB is 6, we'll only check 4, not 0-3, even
> though there might be a perfectly idle cpu in there.
>
> Also, your scheme fails to pack when cpus 0,4 are filled, even when
> there's idle cores around.
>
> If we'd use the ILB as packing cpu, we would simply select a next pack
> target once the old one fills up.
>
