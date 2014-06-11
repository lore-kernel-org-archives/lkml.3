Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341AbaFKRck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:32:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49568 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933274AbaFKRch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:32:37 -0400
Message-ID: <539892A7.2030200@zytor.com>
Date: Wed, 11 Jun 2014 10:32:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Find correct 64 bit ramdisk address for microcode
 early update
References: <1402463064-31697-1-git-send-email-yinghai@kernel.org>	<5397F24A.7020407@zytor.com> <CAE9FiQX3seRxbotg0OmLFm_WrtY-SoT9uupvZpbAqyur4Hq=aA@mail.gmail.com>
In-Reply-To: <CAE9FiQX3seRxbotg0OmLFm_WrtY-SoT9uupvZpbAqyur4Hq=aA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 10:30 AM, Yinghai Lu wrote:
> On Tue, Jun 10, 2014 at 11:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 06/10/2014 10:04 PM, Yinghai Lu wrote:
>>> When using kexec with 64bit kernel, bzImage and ramdisk could be
>>> loaded above 4G. We need this to get correct ramdisk adress.
>>>
>>> Make get_ramdisk_image() global and use it for early microcode
>>> updating. Also make it to take boot_params pointer for different
>>> usage.
>>>
>>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>>
>>
>> Have you tested this with early microcode loading on a 32-bit kernel?
>>
> 
> No, I did not test that on a 32bit kernel. We did not enabled ramdisk
> loading high
> above 4G, right?
> 
> Do you want to me to drop changes for 32 bit path (under those MARCO)?
> like:
> +++ linux-2.6/arch/x86/kernel/cpu/
> microcode/amd_early.c
> @@ -51,12 +51,12 @@ static struct cpio_data __init find_ucod
>          */
>         p       = (struct boot_params *)__pa_nodebug(&boot_params);
>         path    = (char *)__pa_nodebug(ucode_path);
> -       start   = (void *)p->hdr.ramdisk_image;
> -       size    = p->hdr.ramdisk_size;
> +       start   = (void *)(unsigned long)get_ramdisk_image(p);
> +       size    = get_ramdisk_size(p);
> 
> +++ linux-2.6/arch/x86/kernel/cpu/microcode/intel_early.c
> 
>         boot_params_p = (struct boot_params *)__pa_nodebug(&boot_params);
> -       ramdisk_image = boot_params_p->hdr.ramdisk_
> image;
> -       ramdisk_size  = boot_params_p->hdr.ramdisk_size;
> +       ramdisk_image = get_ramdisk_image(boot_params_p);
> +       ramdisk_size  = get_ramdisk_size(boot_params_p);
>         initrd_start_early = ramdisk_image;
>         initrd_end_early = initrd_start_early + ramdisk_size;
> 
> BTW, Is there any 32bit bootloader that could load ramdisk above 4G?
> 

It is not about loading over 4G, it is that some kinds of code (in
particular accessing global variables) from the early microcode loading
code doesn't work on 32 bits, so it needs to be tested.

	-hpa

