Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761108Ab3LIORL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 09:17:11 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57267 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760929Ab3LIORI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 09:17:08 -0500
Message-ID: <52A5D0E0.7050201@linaro.org>
Date: Mon, 09 Dec 2013 15:17:04 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Shi <alex.shi@linaro.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        preeti@linux.vnet.ibm.com, "len.brown@intel.com" <len.brown@intel.com>
Subject: Re: questions of cpuidle
References: <52A5C846.30308@linaro.org>
In-Reply-To: <52A5C846.30308@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 02:40 PM, Alex Shi wrote:
>
> Sorry for a idiot of cpuidle.
>
> I just find few cpu set TIMER_STOP on cpuidle, like omap4 and big.Little
> driver. Does that mean other ARM cpu or x86 cpu can get the timer
> interrupt in cpuidle?
>
> If the timer stopped during cpuidle, does that means at least one cpu
> cann't get into deep c-state since system need a cpu to wake up other
> deep c-state cpu? Or sth I missed?
>
> If the cpu stopped the interrupt during deep c-state and without
> monitor/mwait support, which kind of ipi can wake the cpu? I mean like a
> x86 cpu, APIC stopped in c3 mode, but actually ipi send via apic bus. So
> I don't know which ipi work?

Hi Alex,

there are several timers on the system, the local and the external. On 
ARM we find the local timers twd. Depending on the depth of the idle 
state, they can be shutdown.

All the cpus can go to a deep idle state because the timer expiration 
will be delegated to a timer which does not belong to the power domain 
of the idle state.

The idle state contains the flag TIMER_STOP when the idle state power 
downs the local timer.

The cpuidle common framework checks this flag when entering the idle 
state and calls clock_events_notify(ENTER/EXIT). That tells the time 
framework to switch to another timer on the system in replacement of the 
local one.

The external timer will be programmed to the next event and will store 
the cpu which is concerned by this expiration. This timer is called the 
broadcast timer.

When the broadcast timer expires there are two cases:

* if the timer has the CLOCK_EVT_FEAT_DYNIRQ set, when the time 
framework switched to this timer as described above, it also set the irq 
affinity to the cpu. So no IPI happens because the interrupt occurs 
directly to the targeted cpu

* if the timer has *no* CLOCK_EVT_FEAT_DYNIRQ set, then the interrupt 
will occur to any cpus belonging to the cpumask (usually cpu0), and if 
the timer must expires for another cpu then an IPI is emitted to the 
cpu. The IPI is the IPI_TIMER.

Concerning the wake up of the cpu: the cpu disabled the irq and goes to 
sleep, it is up to the firmware to wake up the cpu when an interrupt 
occurs. It will exits its sleep state, call clock_events_notify(EXIT), 
by this way re-switching to the local timer, and then re-enabling the 
local interrupt which leads to the interrupt handler.

There are some more informations in the wiki page [1].

   -- Daniel

[1] https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/WakeUpSources

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

