Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbaEEWof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:44:35 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:46412 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaEEWoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:44:34 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel\@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman\@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH 1/3] arm64: adjust el0_sync so that a function can be called
References: <1398627854-9617-1-git-send-email-larry.bassel@linaro.org>
	<1398627854-9617-2-git-send-email-larry.bassel@linaro.org>
	<20140429094211.GC17007@arm.com>
Date: Mon, 05 May 2014 15:44:30 -0700
In-Reply-To: <20140429094211.GC17007@arm.com> (Catalin Marinas's message of
	"Tue, 29 Apr 2014 10:42:11 +0100")
Message-ID: <7hsionc0c1.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+ Mark R. since we looked at this together a little at ELC]

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Sun, Apr 27, 2014 at 08:44:12PM +0100, Larry Bassel wrote:
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 39ac630..eda7755 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
> [...]
>> @@ -421,28 +421,30 @@ el0_da:
>>  	/*
>>  	 * Data abort handling
>>  	 */
>> -	mrs	x0, far_el1
>> -	bic	x0, x0, #(0xff << 56)
>>  	disable_step x1
>>  	isb
>>  	enable_dbg
>>  	// enable interrupts before calling the main handler
>>  	enable_irq
>> +	mrs	x0, far_el1
>> +	bic	x0, x0, #(0xff << 56)
>>  	mov	x1, x25
>>  	mov	x2, sp

>>  	b	do_mem_abort
>
> Reading the far_el1 after enable_dbg and enable_irq is racy, we can no
> longer guarantee its value in the original data abort context.

Catalin, can you confirm x26 would be a safe place to stash far_el1 and
then restore it after ct_user_exit.  Something like this (which seems to
work for me):

el0_da:
        /*                                                                                                                                                    * Data abort handling                                                                                                                                */
        mrs     x26, far_el1
        disable_step x1
        isb
        enable_dbg
        // enable interrupts before calling the main handler                                                                                          
        enable_irq
        ct_user_exit
        mov     x0, x26
        bic     x0, x0, #(0xff << 56)
        mov     x1, x25
        mov     x2, sp
        adr     lr, ret_from_exception
        b       do_mem_abort

Kevin
