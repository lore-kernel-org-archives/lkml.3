Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaFZMs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 08:48:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45041 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaFZMsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 08:48:54 -0400
Message-ID: <53AC16A3.2060609@linaro.org>
Date: Thu, 26 Jun 2014 13:48:35 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v6 4/4] ARM: Add KGDB/KDB FIQ debugger generic code
References: <1403174303-25456-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org> <1403623097-1153-5-git-send-email-daniel.thompson@linaro.org> <alpine.LFD.2.11.1406241201180.16842@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1406241201180.16842@knanqh.ubzr>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/14 17:22, Nicolas Pitre wrote:
> On Tue, 24 Jun 2014, Daniel Thompson wrote:
> 
>> From: Anton Vorontsov <anton.vorontsov@linaro.org>
>>
>> The FIQ debugger may be used to debug situations when the kernel stuck
>> in uninterruptable sections, e.g. the kernel infinitely loops or
>> deadlocked in an interrupt or with interrupts disabled.
>>
>> By default KGDB FIQ is disabled in runtime, but can be enabled with
>> kgdb_fiq.enable=1 kernel command line option.
>>
>> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Ben Dooks <ben.dooks@codethink.co.uk>
>> Cc: Dave Martin <Dave.Martin@arm.com>
>> ---
>>  arch/arm/Kconfig                 |   2 +
>>  arch/arm/Kconfig.debug           |  18 ++++++
>>  arch/arm/include/asm/kgdb.h      |   7 +++
>>  arch/arm/kernel/Makefile         |   1 +
>>  arch/arm/kernel/kgdb_fiq.c       | 124 +++++++++++++++++++++++++++++++++++++++
>>  arch/arm/kernel/kgdb_fiq_entry.S |  87 +++++++++++++++++++++++++++
>>  6 files changed, 239 insertions(+)
>>  create mode 100644 arch/arm/kernel/kgdb_fiq.c
>>  create mode 100644 arch/arm/kernel/kgdb_fiq_entry.S
> 
> [...]
> 
>> +static long kgdb_fiq_setup_stack(void *info)
>> +{
>> +	struct pt_regs regs;
>> +
>> +	regs.ARM_sp = __get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER) +
>> +			THREAD_START_SP;
>> +	WARN_ON(!regs.ARM_sp);
> 
> Isn't this rather fatal if you can't allocate any stack? Why not using 
> BUG_ON(), or better yet propagate a proper error code back?

Thanks for raising this.

I think we can get rid of the allocation altogether. This stack is *way*
oversized (it only needs to be 12 bytes).


>> +
>> +	set_fiq_regs(&regs);
>> +	return 0;
>> +}
>> +
>> +/**
>> + * kgdb_fiq_enable_nmi - Manage NMI-triggered entry to KGDB
>> + * @on: Flag to either enable or disable an NMI
>> + *
>> + * This function manages NMIs that usually cause KGDB to enter. That is, not
>> + * all NMIs should be enabled or disabled, but only those that issue
>> + * kgdb_handle_exception().
>> + *
>> + * The call counts disable requests, and thus allows to nest disables. But
>> + * trying to enable already enabled NMI is an error.
>> + */
>> +static void kgdb_fiq_enable_nmi(bool on)
>> +{
>> +	static atomic_t cnt;
>> +	int ret;
>> +
>> +	ret = atomic_add_return(on ? 1 : -1, &cnt);
>> +	if (ret > 1 && on) {
>> +		/*
>> +		 * There should be only one instance that calls this function
>> +		 * in "enable, disable" order. All other users must call
>> +		 * disable first, then enable. If not, something is wrong.
>> +		 */
>> +		WARN_ON(1);
>> +		return;
>> +	}
> 
> Minor style suggestion:
> 
> 	/*
> 	 * There should be only one instance that calls this function
> 	 * in "enable, disable" order. All other users must call
> 	 * disable first, then enable. If not, something is wrong.
> 	 */
> 	if (WARN_ON(ret > 1 && on))
> 		return;

Will adopt this style.


> Other than that...
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>

Thanks for review.

