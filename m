Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbaA1UnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:43:19 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21256 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbaA1UnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:43:18 -0500
Message-ID: <52E8168D.9060805@oracle.com>
Date: Tue, 28 Jan 2014 15:43:57 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
References: <52DE94A9.9060505@oracle.com> <20140121161438.GD9004@pd.tnic> <52DEB4A9.4070707@oracle.com> <20140121182554.GE9004@pd.tnic> <52E15AAE.4090106@oracle.com> <20140123192939.GB11190@pd.tnic> <52E17087.2060301@oracle.com> <20140128162431.GH815@pd.tnic>
In-Reply-To: <20140128162431.GH815@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 11:24 AM, Borislav Petkov wrote:
> On Thu, Jan 23, 2014 at 02:41:59PM -0500, Boris Ostrovsky wrote:
>> 32-bit only.
> Ok, I think I know what happens. Can you try this one (I missed doing
> this on 32-bit and 64-bit does it, which would explain why it didn't
> explode there):
>
> ---
> diff --git a/arch/x86/kernel/cpu/microcode/amd_early.c b/arch/x86/kernel/cpu/microcode/amd_early.c
> index 8384c0fa206f..03b759401bc1 100644
> --- a/arch/x86/kernel/cpu/microcode/amd_early.c
> +++ b/arch/x86/kernel/cpu/microcode/amd_early.c
> @@ -359,7 +359,7 @@ int __init save_microcode_in_initrd_amd(void)
>   		pr_info("microcode: updated early to new patch_level=0x%08x\n",
>   			ucode_new_rev);
>   
> -	if (!container)
> +	if (!container || !ucode_cpio.data)
>   		return -EINVAL;
>   
>   	eax   = cpuid_eax(0x00000001);


It fixes the case when there is no microcode in initrd but when 
microcode is corrupted (as was the case when we were pointing to Intel 
binary) we still die. Neither container nor ucode_cpio.data is NULL in 
this case.

-boris
