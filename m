Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbaJUX4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 19:56:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39076 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaJUX4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 19:56:49 -0400
Message-ID: <5446F2C0.10309@codeaurora.org>
Date: Tue, 21 Oct 2014 16:56:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: josh@joshtriplett.org, =?windows-1252?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: .exit.text section in vmlinux ?
References: <201410212319.20340.PeterHuewe@gmx.de> <20141021233518.GA15840@cloud>
In-Reply-To: <20141021233518.GA15840@cloud>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 04:35 PM, josh@joshtriplett.org wrote:
> On Tue, Oct 21, 2014 at 11:19:01PM +0200, Peter Hüwe wrote:
>> as far as I remember everything marked with __exit or __exit_data will only be 
>> used/called when unloading a module, and gets moved to the .exit.text or 
>> .exit.data sections.
>>
>> Why are these sections present in the vmlinux/vmlinux.bin/bzImage and not 
>> dropped by the linker or at least objdump? 
>> This code will never be called for everything compiled in - in an allyesconfig 
>> build these sections account for ~80kb of code.
>>
>> Is there something I'm missing here, or can we add "--remove-section 
>> .exit.data --remove-section .exit.text" to the OBJCOPYFLAGS for vmlinux?
> Good catch!  I didn't realize that section even appeared in vmlinux; it
> should be entirely omitted.
>
> Removing it via objcopy would work, but seems suboptimal, since that
> won't let the compiler know the functions are unused (and thus that it
> can throw away code and data only referenced from __exit, or inline
> functions into their now-only caller, etc).  So, ideally, when compiling
> code in the kernel rather than in modules, we should tell the compiler
> enough to omit functions tagged as __exit.
>
> (Also, in the course of working on this, I discovered that several
> files declare functions as "static inline ... __exit", which makes no
> sense, and which actually forces an out-of-line version to exist even if
> the function has no body.  For instance, exit_amd_microcode and
> bcma_host_soc_unregister_driver.)
>
> The following patch seems to mostly do the right thing, though for some
> reason some __exit functions remain in the final binary (such as
> md_exit and mon_exit):
>
> --->8---
> From 1646d051a4a4c18b9a6163fceabcafa20628c728 Mon Sep 17 00:00:00 2001
> From: Josh Triplett <josh@joshtriplett.org>
> Date: Tue, 21 Oct 2014 16:14:19 -0700
> Subject: [PATCH] linux/init.h: Always omit __exit code and data for in-kernel
>  compilation
>
> __exit code and data only exists for module removal; when compiling such
> code in the kernel, omit the __exit functions to save space.  For x86
> defconfig this saves about 9k, and significantly more in the compiled
> binary size.

Does it boot? Usually we can't get rid of the exit section because we
have some table pointing at it somewhere for bug tables, alternatives,
etc. See this comment in arch/x86/kernel/vmlinux.lds.S for example:

        /*
         * .exit.text is discard at runtime, not link time, to deal with
         *  references from .altinstructions and .eh_frame
         */
        .exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
                EXIT_TEXT
        }

        .exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
                EXIT_DATA
        }


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

