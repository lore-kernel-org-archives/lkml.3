Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575AbaKYV4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:56:49 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19785 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaKYV4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:56:48 -0500
Message-ID: <5474FBC6.7090603@oracle.com>
Date: Tue, 25 Nov 2014 16:59:34 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Richard Hendershot <rshendershot@mchsi.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 3.17 100/141] x86, microcode: Fix accessing dis_ucode_ldr
 on 32-bit
References: <20141119205153.916605840@linuxfoundation.org> <5474C67A.7040200@oracle.com> <20141125182410.GB4128@pd.tnic> <5474CDCE.6040000@oracle.com> <20141125184351.GC4128@pd.tnic> <5474D0A1.2020600@oracle.com> <20141125190849.GF4128@pd.tnic> <5474D86E.6020608@oracle.com> <20141125202628.GG4128@pd.tnic> <20141125203634.GA6433@laptop.dumpdata.com> <20141125211708.GH4128@pd.tnic>
In-Reply-To: <20141125211708.GH4128@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 04:17 PM, Borislav Petkov wrote:
> On Tue, Nov 25, 2014 at 03:36:34PM -0500, Konrad Rzeszutek Wilk wrote:
>> Is there an use-case for this in virtualization at all?
> Not that I know of...
>
>> Why not make it in general then? Like:
>>
>> if (cpu_has_hypervisor)
>> 	return;
> Ah, good idea. Although we need to do it by-foot because the cpu_has
> stuff hasn't been initialized yet that early. Boris, I'm guessing
> something that should work... ?
>
> ---
> diff --git a/arch/x86/kernel/cpu/microcode/core_early.c b/arch/x86/kernel/cpu/microcode/core_early.c
> index 2c017f242a78..77137b317e2a 100644
> --- a/arch/x86/kernel/cpu/microcode/core_early.c
> +++ b/arch/x86/kernel/cpu/microcode/core_early.c
> @@ -74,6 +74,16 @@ static int x86_family(void)
>   	return x86;
>   }
>   
> +static bool x86_guest(void)
> +{
> +	u32 eax = 0x1;
> +	u32 ebx, ecx = 0, edx;
> +
> +	native_cpuid(&eax, &ebx, &ecx, &edx);

This should be cpuid(0x1, &eax, &ebx, &ecx, &edx). Otherwise we are not 
getting bits that the hypervisor wants the guest to see (on Xen cpuid() 
turns into hypercall, on baremetal it's native).

With that change it works and

Tested-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

(May be worth adding a comment as to what is_guest() is checking for 
since 31 is a magic number).

BTW, the crash had nothing to do with accessing dis_ucode_ldr, we are 
crashing much later, in load_ucode_intel_ap(), trying to access 
*initrd_start_p. And the reason we didn't crash before was because 
compiler optimized out whole load_ucode_ap() since 
check_loader_disabled_ap() was always true.

Thanks.
-boris

> +
> +	return !!(ecx & BIT(31));
> +}
> +
>   static bool __init check_loader_disabled_bsp(void)
>   {
>   #ifdef CONFIG_X86_32
> @@ -98,6 +108,9 @@ void __init load_ucode_bsp(void)
>   {
>   	int vendor, x86;
>   
> +	if (x86_guest())
> +		return;
> +
>   	if (check_loader_disabled_bsp())
>   		return;
>   
> @@ -134,6 +147,9 @@ void load_ucode_ap(void)
>   {
>   	int vendor, x86;
>   
> +	if (x86_guest())
> +		return;
> +
>   	if (check_loader_disabled_ap())
>   		return;
>

