Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaBHDnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 22:43:42 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64168 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaBHDnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 22:43:41 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52F5A7EE.9@roeck-us.net>
Date: Fri, 07 Feb 2014 19:43:42 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
CC: Michal Simek <monstr@monstr.eu>, microblaze-uclinux@itee.uq.edu.au,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [Qemu-devel] Commit 34b9c07a3 (microblaze: Disable stack protection
 from bootloader) causing qemu crash
References: <20140207231731.GA8647@roeck-us.net> <20140208023131.GE24420@amz.ap-southeast-2.compute.internal>
In-Reply-To: <20140208023131.GE24420@amz.ap-southeast-2.compute.internal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 06:31 PM, Edgar E. Iglesias wrote:
> On Fri, Feb 07, 2014 at 03:17:31PM -0800, Guenter Roeck wrote:
>> Michal,
>>
>> commit 34b9c07a3 (microblaze: Disable stack protection from bootloader) results
>> in the following qemu crash in 3.14-rc1.
>>
>> /opt/buildbot/bin/qemu-system-microblaze -M petalogix-s3adsp1800 -kernel arch/microblaze/boot/linux.bin -no-reboot -append "console=ttyUL0,115200 " -nographic
>> qemu: fatal: fetching nop sequence
>>
>> IN: PC=20
>> rmsr=4300 resr=7 rear=c0389fe8 debug=0 imm=ffffffd0 iflags=0 fsr=0
>> btaken=1 btarget=c03a9f24 mode=kernel(saved=kernel) eip=512 ie=0
>> r00=00000000 r01=c0389fcc r02=c0386a52 r03=000000c0
>> r04=00004100 r05=9052fab4 r06=00000000 r07=90530ab4
>> r08=00000000 r09=00400000 r10=00400000 r11=c03a9f24
>> r12=00621000 r13=40aef0c0 r14=00000000 r15=c0000294
>> r16=00000000 r17=c03a9f28 r18=00000000 r19=00000000
>> r20=00000000 r21=00000000 r22=00000000 r23=00000000
>> r24=00000000 r25=00000000 r26=00000000 r27=00000000
>> r28=00000000 r29=00400000 r30=00000300 r31=c03932d4
>>
>>
>> Aborted (core dumped)
>>
>> I have seen this with qemu 1.6.0 and 1.7.0.
>>
>> Reverting the patch solves the problem.
>>
>> Is this a qemu bug, a bug in the code, or a bug in my configuration ?
>> Any idea what I can do about it ?
>
> Hi Guenter,
>
> Seems to be a typo in the kernel, the following should fix it.
>
> Cheers,
> Edgar
>
> ---8<---
> From: "Edgar E. Iglesias" <edgar.iglesias@xilinx.com>
> Date: Sat, 8 Feb 2014 10:59:59 +1000
> Subject: [PATCH] microblaze: Fix a typo when disabling stack protection
>
> Correct a typo causing the stack protector to be left enabled.
> 0xFFFFFFF -> 0xFFFFFFFF
>
> Signed-off-by: Edgar E. Iglesias <edgar.iglesias@xilinx.com>

Hi Edgar,

you are right, that fixes the problem.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks!
Guenter

> ---
>   arch/microblaze/kernel/head.S | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/microblaze/kernel/head.S b/arch/microblaze/kernel/head.S
> index b7fb043..17645b2 100644
> --- a/arch/microblaze/kernel/head.S
> +++ b/arch/microblaze/kernel/head.S
> @@ -66,7 +66,7 @@ real_start:
>   	mts	rmsr, r0
>   /* Disable stack protection from bootloader */
>   	mts	rslr, r0
> -	addi	r8, r0, 0xFFFFFFF
> +	addi	r8, r0, 0xFFFFFFFF
>   	mts	rshr, r8
>   /*
>    * According to Xilinx, msrclr instruction behaves like 'mfs rX,rpc'
>

