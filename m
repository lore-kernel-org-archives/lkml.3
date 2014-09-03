Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaICJCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:02:24 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:64493 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaICJCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:02:20 -0400
Message-ID: <5406D91A.9090209@linaro.org>
Date: Wed, 03 Sep 2014 10:02:18 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Russell King <linux@arm.linux.org.uk>, linaro-kernel@lists.linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>, patches@linaro.org,
        kgdb-bugreport@lists.sourceforge.net, Nicolas Pitre <nico@linaro.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Fabio Estevam <festevam@gmail.com>, Colin Cross <ccross@android.com>,
        kernel-team@android.com, Dave Martin <Dave.Martin@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v11 00/19] arm: KGDB NMI/FIQ support
References: <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1409662853-29313-1-git-send-email-daniel.thompson@linaro.org> <alpine.DEB.2.10.1409030032010.3333@nanos>
In-Reply-To: <alpine.DEB.2.10.1409030032010.3333@nanos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 00:02, Thomas Gleixner wrote:
> On Tue, 2 Sep 2014, Daniel Thompson wrote:
> 
>> This patchset makes it possible to use kgdb's NMI infrastructure on ARM
>> platforms.
>>
>> The patches are seperated into three distinct groups:
>>
>> 1. arm specific changes; these provide multi-platform support for FIQ
>>    (including raising an IPI using FIQ to ensure effective SMP support)
>>    and extend ARM KGDB support to use the features provided.
>>
>> 2. irqchip changes; updates to the gic and vic drivers to provide
>>    support for routing certain interrupt sources to FIQ.
>>
>> 3. serial changes; driver support to allow the UART interrupt to be
>>    routed to FIQ. The already mainlined kgdb NMI infrastructure (mostly
>>    found in drivers/tty/serial/kgdb_nmi.c) will re-route the kgdb
>>    console UART's interrupt signal from IRQ to FIQ. Naturally the UART
>>    will no longer function normally and will instead be managed by kgdb
>>    using the polled I/O functions. Any character delivered to the UART
>>    causes the kgdb handler function to be called.
> 
> To be honest, what you are doing is just ass backwards.
> 
> The use case you are looking for is the most irrelevant of all. Just
> because KGDB is on some managerial "must have items" checklist does
> not make it useful.

The FIQ based interactive debugger use case is fairly common on Android,
especially for Nexus devices (they have an out-of-tree debugger similar
to kdb for this).

I think it finds favour there because during the development phases
where the console is unplugged to allow developers to go walkabout live
with a prototype phone. The interactive debugger is used for
post-morteming when something breaks. At this stage of development are
reluctant to expose/consume hardware resources (JTAG pins, RAM, FLASH)
for JTAG or kexec/kdump post-mortems.


> The only relevant use cases of FIQs are the same as those of NMIs on
> x86:
> 
>   - Watchdog to detect stuck cpus and issue stack traces

Russell put together a quick 'n dirty version of the NMI stack trace
code based on a subset of my patchset. Based on his feedback, later
revisions of my patchset are structured to simplify adding this code.


Daniel.


>   - Performace monitoring
> 
> KGDB falls into place once you solved the above.
>
> That said for the general approach, I'll have a look at the irq
> related patches in a minute.
> 
> Thanks,
> 
> 	tglx


