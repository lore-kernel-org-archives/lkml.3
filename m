Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaJVALC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 20:11:02 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39656 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaJVAKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 20:10:54 -0400
Message-ID: <5446F60C.4010500@codeaurora.org>
Date: Tue, 21 Oct 2014 17:10:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: josh@joshtriplett.org, =?windows-1252?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: .exit.text section in vmlinux ?
References: <201410212319.20340.PeterHuewe@gmx.de> <20141021233518.GA15840@cloud> <5446F2C0.10309@codeaurora.org>
In-Reply-To: <5446F2C0.10309@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 04:56 PM, Stephen Boyd wrote:
> On 10/21/2014 04:35 PM, josh@joshtriplett.org wrote:
>> --->8---
>> From 1646d051a4a4c18b9a6163fceabcafa20628c728 Mon Sep 17 00:00:00 2001
>> From: Josh Triplett <josh@joshtriplett.org>
>> Date: Tue, 21 Oct 2014 16:14:19 -0700
>> Subject: [PATCH] linux/init.h: Always omit __exit code and data for in-kernel
>>  compilation
>>
>> __exit code and data only exists for module removal; when compiling such
>> code in the kernel, omit the __exit functions to save space.  For x86
>> defconfig this saves about 9k, and significantly more in the compiled
>> binary size.
> Does it boot? Usually we can't get rid of the exit section because we
> have some table pointing at it somewhere for bug tables, alternatives,
> etc. See this comment in arch/x86/kernel/vmlinux.lds.S for example:
>
>         /*
>          * .exit.text is discard at runtime, not link time, to deal with
>          *  references from .altinstructions and .eh_frame
>          */
>         .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
>                 EXIT_TEXT
>         }
>
>         .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
>                 EXIT_DATA
>         }
>
>

Furthermore, on ARM we discard the exit text and exit data in the linker
script if we're not using the generic bug tables or patching spinlocks
for uniprocessor hardware (see arch/arm/kernel/vmlinux.lds.S). Maybe
something similar can be done for x86?

#if (defined(CONFIG_SMP_ON_UP) && !defined(CONFIG_DEBUG_SPINLOCK)) || \
        defined(CONFIG_GENERIC_BUG)
#define ARM_EXIT_KEEP(x)        x
#define ARM_EXIT_DISCARD(x)
#else
#define ARM_EXIT_KEEP(x)
#define ARM_EXIT_DISCARD(x)     x
#endif 


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

