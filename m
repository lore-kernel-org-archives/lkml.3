Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab3KHTEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 14:04:22 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35156 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757444Ab3KHTEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 14:04:20 -0500
Message-ID: <527D35B3.9020702@codeaurora.org>
Date: Fri, 08 Nov 2013 11:04:19 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Use udiv/sdiv for __aeabi_{u}idiv library functions
References: <1383852042-10780-1-git-send-email-sboyd@codeaurora.org> <yw1xr4aqx1vi.fsf@unicorn.mansr.com>
In-Reply-To: <yw1xr4aqx1vi.fsf@unicorn.mansr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/13 09:02, Måns Rullgård wrote:
> Stephen Boyd <sboyd@codeaurora.org> writes:
>
>> +int __aeabi_idiv(int numerator, int denominator)
>> +{
>> +	if (static_key_false(&cpu_has_idiv)) {
>> +		int ret;
>> +
>> +		asm volatile (
>> +		".arch_extension idiv\n"
>> +		"sdiv %0, %1, %2"
>> +		: "=&r" (ret)
> There is no need for the & in the output constraint.  Dropping it allows
> using one of the source registers as destination which may sometimes be
> beneficial.

Ok. Thanks. That does seem to improve things.

before:

00000000 <__aeabi_idiv>:
   0:   e320f000        nop     {0}
   4:   eafffffe        b       0 <___aeabi_idiv>
   8:   e713f110        sdiv    r3, r0, r1
   c:   e1a00003        mov     r0, r3
  10:   e12fff1e        bx      lr

00000014 <__aeabi_uidiv>:
  14:   e320f000        nop     {0}
  18:   eafffffe        b       0 <___aeabi_uidiv>
  1c:   e733f110        udiv    r3, r0, r1
  20:   e1a00003        mov     r0, r3
  24:   e12fff1e        bx      lr

after:

00000000 <__aeabi_idiv>:
   0:   e320f000        nop     {0}
   4:   eafffffe        b       0 <___aeabi_idiv>
   8:   e710f110        sdiv    r0, r0, r1
   c:   e12fff1e        bx      lr

00000010 <__aeabi_uidiv>:
  10:   e320f000        nop     {0}
  14:   eafffffe        b       0 <___aeabi_uidiv>
  18:   e730f110        udiv    r0, r0, r1
  1c:   e12fff1e        bx      lr


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

