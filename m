Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228AbaHZSHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:07:13 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:15199 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752744AbaHZSHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:07:08 -0400
Message-ID: <53FCCCC7.9070801@arm.com>
Date: Tue, 26 Aug 2014 19:07:03 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux@openrisc.net" <linux@openrisc.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "shawn.guo@freescale.com" <shawn.guo@freescale.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "tony@atomide.com" <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "jonas@southpole.se" <jonas@southpole.se>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "shc_work@mail.ru" <shc_work@mail.ru>,
        "baohua@kernel.org" <baohua@kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "khilman@linaro.org" <khilman@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "larry.bassel@linaro.org" <larry.bassel@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>,
        "stefan.kristiansson@saunalahti.fi" 
	<stefan.kristiansson@saunalahti.fi>,
        "vkale@apm.com" <vkale@apm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        Vladimir Murzin <Vladimir.Murzin@arm.com>
Subject: Re: [PATCH v2 01/26] genirq: add irq_domain-aware core IRQ handler
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com> <1409047421-27649-2-git-send-email-marc.zyngier@arm.com> <53FCC714.3090206@codeaurora.org>
In-Reply-To: <53FCC714.3090206@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/14 18:42, Stephen Boyd wrote:
> On 08/26/14 03:03, Marc Zyngier wrote:
>> Calling irq_find_mapping from outside a irq_{enter,exit} section is
>> unsafe and produces ugly messages if CONFIG_PROVE_RCU is enabled:
>> If coming from the idle state, the rcu_read_lock call in irq_find_mapping
>> will generate an unpleasant warning:
>>
>> <quote>
>> ===============================
>> [ INFO: suspicious RCU usage. ]
>> 3.16.0-rc1+ #135 Not tainted
>> -------------------------------
>> include/linux/rcupdate.h:871 rcu_read_lock() used illegally while idle!
>>
>> other info that might help us debug this:
>>
>> RCU used illegally from idle CPU!
>> rcu_scheduler_active = 1, debug_locks = 0
>> RCU used illegally from extended quiescent state!
>> 1 lock held by swapper/0/0:
>>  #0:  (rcu_read_lock){......}, at: [<ffffffc00010206c>]
>> irq_find_mapping+0x4c/0x198
> 
> Do you have the whole stacktrace? I don't see where this is called
> outside of irq_enter() from within the idle loop, but maybe I missed
> something.
> 

Hi Stephen,

Digging into my email, one of the traces looked like this:

stack backtrace:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.16.0-rc1+ #135
Call trace:
[<ffffffc0000882cc>] dump_backtrace+0x0/0x12c
[<ffffffc000088408>] show_stack+0x10/0x1c
[<ffffffc0004ee5f0>] dump_stack+0x74/0xc4
[<ffffffc0000edfbc>] lockdep_rcu_suspicious+0xe8/0x124
[<ffffffc00010218c>] irq_find_mapping+0x16c/0x198
[<ffffffc00008130c>] gic_handle_irq+0x38/0xcc

Most drivers call irq_find_mapping outside of irq_enter()/irq_exit(), as
this is in handle_IRQ().

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
