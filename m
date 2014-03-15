Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaCOBLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 21:11:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40090 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209AbaCOBLu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 21:11:50 -0400
Message-ID: <5323A8B9.4030700@ti.com>
Date: Fri, 14 Mar 2014 20:11:21 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Suman Anna <s-anna@ti.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh@kernel.org>, Tero Kristo <t-kristo@ti.com>,
        Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 4/5] clocksource: omap-timer: Introduce clocksource driver
 for OMAP SoCs
References: <1394742919-32163-1-git-send-email-joelf@ti.com> <1394742919-32163-5-git-send-email-joelf@ti.com> <53239B1F.705@ti.com>
In-Reply-To: <53239B1F.705@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2014 07:13 PM, Suman Anna wrote:
> Hi Joel,
> 
> On 03/13/2014 03:35 PM, Joel Fernandes wrote:
>> We introduce functions to initialize clocksource and clockevent, use
>> CLOCKSOURCE_OF_DECLARE to declare the clocksource, and handle the
>> clocksource
>> selection on a per-SoC basis (Currently only AM335x is supported).
>> Powering up
>> of the timer will be done with the help of the mach-omap layer function
>> that's
>> introduced earlier in the series.
>>
>> We make a local copy of dmtimer API for use by clocksource, the original
>> dmtimer API in plat-omap is kept as-is till the migration of all SoCs is
>> completed after which it can't be deleted.
>>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>   drivers/clocksource/Makefile     |    1 +
>>   drivers/clocksource/omap-timer.c | 1157
>> ++++++++++++++++++++++++++++++++++++++
>>   drivers/clocksource/omap-timer.h |  422 ++++++++++++++
>>   3 files changed, 1580 insertions(+)
>>   create mode 100644 drivers/clocksource/omap-timer.c
>>   create mode 100644 drivers/clocksource/omap-timer.h
>>
>> diff --git a/drivers/clocksource/Makefile b/drivers/clocksource/Makefile
>> index c7ca50a..2ffe698 100644
>> --- a/drivers/clocksource/Makefile
>> +++ b/drivers/clocksource/Makefile
>> @@ -37,3 +37,4 @@ obj-$(CONFIG_ARM_ARCH_TIMER)        += arm_arch_timer.o
>>   obj-$(CONFIG_ARM_GLOBAL_TIMER)        += arm_global_timer.o
>>   obj-$(CONFIG_CLKSRC_METAG_GENERIC)    += metag_generic.o
>>   obj-$(CONFIG_ARCH_HAS_TICK_BROADCAST)    += dummy_timer.o
>> +obj-y                    += omap-timer.o
>> diff --git a/drivers/clocksource/omap-timer.c
>> b/drivers/clocksource/omap-timer.c
>> new file mode 100644
>> index 0000000..91593d8
>> --- /dev/null
>> +++ b/drivers/clocksource/omap-timer.c
>> @@ -0,0 +1,1157 @@
>> +/*
>> + * drivers/clocksource/omap-timer.c
>> + *
>> + * OMAP Dual-Mode Timers
>> + *
>> + * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com/
>> + * Joel Fernandes <joelf@ti.com>
>> + * Tarun Kanti DebBarma <tarun.kanti@ti.com>
>> + * Thara Gopinath <thara@ti.com>
>> + *
>> + * dmtimer adaptation to platform_driver.
>> + *
>> + * Copyright (C) 2005 Nokia Corporation
>> + * OMAP2 support by Juha Yrjola
>> + * API improvements and OMAP2 clock framework support by Timo Teras
>> + *
>> + * Copyright (C) 2014 Texas Instruments
>> + * Added OMAP4 support - Santosh Shilimkar <santosh.shilimkar@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the
>> + * Free Software Foundation; either version 2 of the License, or (at your
>> + * option) any later version.
>> + *
>> + * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED
>> + * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN
>> + * NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
>> + * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
>> + * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
>> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
>> + * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>> + *
>> + * You should have received a copy of the  GNU General Public License along
>> + * with this program; if not, write  to the Free Software Foundation, Inc.,
>> + * 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +#include <linux/init.h>
>> +#include <linux/time.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/err.h>
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +#include <linux/irq.h>
>> +#include <linux/clocksource.h>
>> +#include <linux/clockchips.h>
>> +#include <linux/slab.h>
>> +#include <linux/sched_clock.h>
>> +
>> +#include <linux/clk.h>
>> +#include <linux/module.h>
>> +#include <linux/io.h>
>> +#include <linux/device.h>
>> +#include <linux/err.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/of.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_address.h>
>> +
>> +#include <linux/of_device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/platform_data/dmtimer-omap.h>
>> +#include "omap-timer.h"
>> +/*
>> + *  TODO: OMAP1 support removed due to need for header mach/hardware.h
>> + *        OMAP2 support may be broken due to lack of cpu_is stuff, see
>> omap_dm_timer_get_errata
>> + */
>> +
>> +/**
>> + * omap_dm_timer_get_errata - get errata flags for a timer
>> + *
>> + * Get the timer errata flags that are specific to the OMAP device being
>> used.
>> + */
>> +static u32 __init omap_dm_timer_get_errata(void)
>> +{
>> +    /* ifdef'd out due to lack of availaibility of soc.h */
>> +#if 0
>> +    if (cpu_is_omap24xx())
>> +        return 0;
> 
> You should be able to fix this using some compatible checks.

Thanks. I'll use of_device_is_compatible to check for that.

-Joel

