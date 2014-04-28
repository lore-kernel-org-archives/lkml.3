Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaD1TIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:08:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42033 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaD1TIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:08:13 -0400
Message-ID: <535E8DC2.4010504@ti.com>
Date: Mon, 28 Apr 2014 12:20:02 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Dave Martin <Dave.Martin@arm.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: OMAP5: Switch to THUMB mode if needed on secondary
 CPU
References: <1398191506-3741-1-git-send-email-joelf@ti.com> <20140428164348.GA14354@e103592.cambridge.arm.com>
In-Reply-To: <20140428164348.GA14354@e103592.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 11:43 AM, Dave Martin wrote:
> On Tue, Apr 22, 2014 at 01:31:46PM -0500, Joel Fernandes wrote:
>> On my DRA7 system, when the kernel is built in THUMB mode, the secondary CPU
>> (Cortex A15) fails to come up causing SMP boot on second CPU to timeout. This
>> seems to be because the CPU is in ARM mode once the ROM hands over control to
>> the kernel.  Switch to THUMB mode if required once the kernel is control of
>> secondary CPU. On OMAP4 on the other hand, it appears to be in THUMB mode on
>> entry so this is not required and SMP boot works as is.
>>
>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Nishanth Menon <nm@ti.com>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: Joel Fernandes <joelf@ti.com>
>> ---
>>  arch/arm/mach-omap2/omap-headsmp.S |    8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap-headsmp.S b/arch/arm/mach-omap2/omap-headsmp.S
>> index 75e9295..1809dce 100644
>> --- a/arch/arm/mach-omap2/omap-headsmp.S
>> +++ b/arch/arm/mach-omap2/omap-headsmp.S
>> @@ -1,7 +1,7 @@
>>  /*
>>   * Secondary CPU startup routine source file.
>>   *
>> - * Copyright (C) 2009 Texas Instruments, Inc.
>> + * Copyright (C) 2014 Texas Instruments, Inc.
>>   *
>>   * Author:
>>   *      Santosh Shilimkar <santosh.shilimkar@ti.com>
>> @@ -28,9 +28,13 @@
>>   * code.  This routine also provides a holding flag into which
>>   * secondary core is held until we're ready for it to initialise.
>>   * The primary core will update this flag using a hardware
>> -+ * register AuxCoreBoot0.
>> + * register AuxCoreBoot0.
>>   */
>>  ENTRY(omap5_secondary_startup)
> 
> Are you sure this problem is not caused by the missing ENDPROC() for
> omap5_secondary_startup?
> 
> You have END() instead (which may have been accidental).
> 
> Without ENDPROC(), the symbol is not marked as a function and so
> the Thumb bit won't be set when taking a pointer -- so the kernel
> is actually telling the firmware to enter in ARM state.
> 
> 
> Try changing END() to ENDPROC() without this patch, and see if it
> makes a difference.
> 
> If it still doesn't work, then the firmware either doesn't support
> entering in ARM, or is buggy.

Thanks for the suggestion. I'm guessing what you mean is with ENDPROC,
interworking code uses bx instead of bl to set thumb mode.

But ROM/firmware doesn't have access to symbol table, how would it know
the type of the symbol to be ARM or THUMB before it branches?

regards,
 -Joel



