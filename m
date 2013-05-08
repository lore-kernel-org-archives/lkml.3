Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab3EHRli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:41:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61586 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3EHRlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:41:36 -0400
Message-ID: <518A8E48.2080801@dawncrow.de>
Date: Wed, 08 May 2013 19:41:28 +0200
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jonathan Austin <Jonathan.Austin@arm.com>
Subject: Re: [PATCHv3] arm: Preserve the user r/w register TPIDRURW on context
 switch and fork
References: <51896934.5080803@dawncrow.de> <20130508085753.GA15568@mudshark.cambridge.arm.com>
In-Reply-To: <20130508085753.GA15568@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:/R0K2FE96A/PI+nYpKzwH90eqWNtwK75Rd9p9/KzGUh
 iMLIQXFC0cOETJsS/j1HG0rIu1q9S4tbZvPvjk+1nAuYXQt1wO
 yPUH58fwupjqwn9oCYnLCPlSnrNdKvxL3ie4q3owzOkXE0P122
 RrS04CVHvcPiqXzI9K0cKty+dqW8Jl7xnFoYQl3GtbC9+d+4US
 HcHcOTWgiVVqvRlHEF8qxr+THFU1pfxf+svoOxECuB3yDgkEUk
 MKEOgPYu/W4RmyMjNGmhCY7JVDBuwYijZN/8EcIUrHYHdJrjoD
 efACvg3ree6U7mXph8NEiWtaS6vkGWqZl0d+PPOxBPlUwUEp34
 JhsIsXJPk6U32qv6hl2U=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Will,

thx for having a look.

Am 08.05.2013 10:57, schrieb Will Deacon:> Hi Andre,
> 
> On Tue, May 07, 2013 at 09:51:00PM +0100, André Hentschel wrote:
>> From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
> 
> Might just be my mailer, but you should check that your name is intact here
> otherwise the git log will be mangled.

That's for my acute accent and already worked with my first linux patch, it's git generated.

>> Since commit 6a1c53124aa1 the user writeable TLS register was zeroed to
>> prevent it from being used as a covert channel between two tasks.
>>
>> There are more and more applications coming to WinRT, Wine could support them,
>> but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
>>
>> This patch preserves that register per thread instead of clearing it.
>> Unlike the TPIDRURO, which is already switched, the TPIDRURW
>> can be updated from userspace so needs careful treatment in the case that we
>> modify TPIDRURW and call fork(). To avoid this we must always read
>> TPIDRURW in copy_thread.
>>
>> Signed-off-by: André Hentschel <nerv@dawncrow.de>
>> Signed-off-by: Will Deacon <will.deacon@arm.com>
>> Signed-off-by: Jonathan Austin <jonathan.austin@arm.com> 
> 
> [...]
> 
>> diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
>> index 73409e6..22756ab 100644
>> --- a/arch/arm/include/asm/tls.h
>> +++ b/arch/arm/include/asm/tls.h
>> @@ -2,27 +2,30 @@
>>  #define __ASMARM_TLS_H
>>  
>>  #ifdef __ASSEMBLY__
>> -	.macro set_tls_none, tp, tmp1, tmp2
>> +#include <asm/asm-offsets.h>
>> +	.macro switch_tls_none, base, tp, tpuser, tmp1, tmp2
>>  	.endm
>>  
>> -	.macro set_tls_v6k, tp, tmp1, tmp2
>> +	.macro switch_tls_v6k, base, tp, tpuser, tmp1, tmp2
>> +	mrc	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
>>  	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
>> -	mov	\tmp1, #0
>> -	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
>> +	mcr	p15, 0, \tpuser, c13, c0, 2	@ and the user r/w register
>> +	strne	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
> 
> Why is this conditional?


Seems like a copy&paste one, i'll send a v4


