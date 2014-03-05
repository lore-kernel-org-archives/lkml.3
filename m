Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbaCEVzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 16:55:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaCEVzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 16:55:47 -0500
Message-ID: <53179D06.2050707@redhat.com>
Date: Wed, 05 Mar 2014 16:54:14 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Mateusz Guzik <mguzik@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC PATCH] hrtimer: remove deadlock due to waiting on IPI in
 softirq context
References: <20140305162526.7d2ef1ab@cuia.bos.redhat.com> <alpine.DEB.2.02.1403052239390.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403052239390.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 04:51 PM, Thomas Gleixner wrote:
> On Wed, 5 Mar 2014, Rik van Riel wrote:
>> There appears to be a deadlock in the hrtimer code. Specifically,
>> clock_was_set() calls an IPI with wait=1, from softirq context.
>
> This should not be called from softirq context.
>
>> Waiting for IPIs to complete in irq context can lead to a deadlock,
>> because the current code (that was interrupted) might be holding some
>> kind of lock, that another CPU is waiting for with spin_lock_irq or
>> similar.
>>
>> In other words, the current CPU may need to release a resource, before
>> the IPI can be handled by one of the destination CPUs.
>>
>> To my untrained eye, it does not look like this patch introduces a
>> new bug to the timer code, but that is hard to ascertain with the
>> timer code. so I am posting this as an RFC for the timer gods to hurt
>> their brains on :)
>>
>> This bug was introduced by 54cdfdb4 in early 2007 (the original
>> hrtimer code patch).
>
> Right and we had some issues with that until we moved the calls to
> clock_was_set() out of lock held regions.

Ahh indeed, the bug got fixed already :)

> The only call which happens from interrupt context is in
> update_wall_time(). And that one definitely holds no locks which are
> relevant.
>
> On which kernel are you observing the issue?

This was RHEL6, and I saw that the immediate function
was still the same upstream.

I forgot to check that clock_was_set() is now called
in a different way. My bad.
