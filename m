Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315Ab3HOHn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:43:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52776 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757159Ab3HOHn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:43:56 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <520C86BD.2020903@roeck-us.net>
Date: Thu, 15 Aug 2013 00:43:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [ 00/17] 3.4.58-stable review
References: <20130813063501.728847844@linuxfoundation.org> <520A1D56.2050507@roeck-us.net> <20130813175858.GC7336@kroah.com> <20130813201936.GA18358@roeck-us.net> <20130815063158.GB25754@kroah.com>
In-Reply-To: <20130815063158.GB25754@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 11:31 PM, Greg Kroah-Hartman wrote:
> On Tue, Aug 13, 2013 at 01:19:36PM -0700, Guenter Roeck wrote:
>> I copied the individual log files for the 3.4 build to http://roeck-us.net/linux/logs
>> in case you want to browse through it.
>>
>> Here is a summary.
>>
>> mips/allmodconfig:
>> drivers/net/ethernet/3com/3c59x.c: In function 'vortex_init_one':
>> drivers/net/ethernet/3com/3c59x.c:1031:2: error: implicit declaration of function 'pci_iomap'
>>
>> We have seen that before in 3.10. Commit 78857614104 (MIPS: Expose
>> missing pci_io{map,unmap} declarations) fixes it.
>
> Now applied.
>
>> sound/oss/soundcard.c:69:31: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function)
>>
>> This requires
>> d4702b189c sound: Fix make allmodconfig on MIPS
>> a62ee234a5 sound: Fix make allmodconfig on MIPS correctly
>
> Now applied.
>
>> Unfortunately, after applying those patches the build still fails with
>>
>> ERROR: "min_low_pfn" [drivers/net/wireless/ath/ath6kl/ath6kl_sdio.ko] undefined!
>>
>> This has been fixed upstream with commit 8b9232141b (MIPS: Rewrite pfn_valid to work
>> in modules, too), which applies but results in build failures.
>
> What failures?  I've applied this now, as it makes sense.
>
>> There is a patch from Ben Hutchings which removes the use of
>> virt_addr_valid() (which causes the problem) from the ath6kl driver,
>> but that is not in mainline.
>
> Ok, I think I'll stop there for MIPS, that's a good start...
>

I screwed up my stable repo clone again :(, so the full build will take a bit.

mips builds on on 3.4 with all patches applied now fail with:
arch/mips/include/asm/page.h: Assembler messages:
arch/mips/include/asm/page.h:178: Error: Unrecognized opcode `static inline int pfn_valid(unsigned long pfn)'
arch/mips/include/asm/page.h:179: Error: junk at end of line, first unrecognized character is `{'
arch/mips/include/asm/page.h:181: Error: Unrecognized opcode `extern unsigned long max_mapnr'
arch/mips/include/asm/page.h:183: Error: Unrecognized opcode `return pfn>=ARCH_PFN_OFFSET&&pfn<max_mapnr'
arch/mips/include/asm/page.h:184: Error: junk at end of line, first unrecognized character is `}'

This is the error I referred to above. Reverting above pfn rework patch fixes that problem,
so you might want to remove that patch from the patch queue for now.

Guenter

