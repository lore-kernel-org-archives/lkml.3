Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab3KMRfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:35:01 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:60139 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3KMRex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:34:53 -0500
Message-ID: <5283B83A.8030206@gmail.com>
Date: Wed, 13 Nov 2013 11:34:50 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Chris Zankel <chris@zankel.net>, Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 14/17] dt: Consolidate __dtb_start declarations in <linux/of_fdt.h>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org>	<1384285347-13506-15-git-send-email-geert@linux-m68k.org>	<5283A000.8090007@gmail.com> <CAMuHMdU6Lqup-MuAOH0iTg16b-SHw4D52WsoPXMsumOxQWbJrg@mail.gmail.com>
In-Reply-To: <CAMuHMdU6Lqup-MuAOH0iTg16b-SHw4D52WsoPXMsumOxQWbJrg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2013 11:20 AM, Geert Uytterhoeven wrote:
> On Wed, Nov 13, 2013 at 4:51 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On Tue, Nov 12, 2013 at 1:42 PM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>>> The different architectures used their own (and different) declarations:
>>>
>>>     extern struct boot_param_header __dtb_start;
>>>     extern u32 __dtb_start[];
>>>     extern char __dtb_start[];
>>>
>>> Consolidate them using the first variant in <linux/of_fdt.h>.
>>> This requires adding a few "address of" operators on architectures where
>>> __dtb_start was an array before.
>>>
>>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>>> Cc: Vineet Gupta <vgupta@synopsys.com>
>>> Cc: James Hogan <james.hogan@imgtec.com>
>>> Cc: Ralf Baechle <ralf@linux-mips.org>
>>> Cc: Jonas Bonn <jonas@southpole.se>
>>> CC: Chris Zankel <chris@zankel.net>
>>> Cc: Rob Herring <rob.herring@calxeda.com>
>>> Cc: devicetree@vger.kernel.org
>>> ---
>>>  arch/arc/include/asm/sections.h             |    1 -
>>>  arch/arc/kernel/setup.c                     |    2 +-
>>>  arch/metag/kernel/setup.c                   |    6 +-----
>>>  arch/mips/include/asm/mips-boards/generic.h |    4 ----
>>>  arch/mips/lantiq/prom.h                     |    2 --
>>>  arch/mips/netlogic/xlp/dt.c                 |    4 ++--
>>>  arch/mips/ralink/of.c                       |    2 --
>>>  arch/openrisc/kernel/setup.c                |    2 +-
>>>  arch/openrisc/kernel/vmlinux.h              |    2 --
>>>  arch/xtensa/kernel/setup.c                  |    3 +--
>>>  include/linux/of_fdt.h                      |    3 +++
>>>  11 files changed, 9 insertions(+), 22 deletions(-)
>>
>> This is great, but I would like to see this taken one step further and
>> move the selection logic into the core code. We can try to use the
>> built-in dtb if early_init_dt_scan is passed a NULL or invalid dtb. This
>> should work for most arches I think and still allows an arch to do a
>> different selection algorithm if desired.
> 
> Yes, that makes sense.
> 
>> Are the DT related patches dependent on the rest of the series?
> 
> Not really. There may be small rejects if you apply it out-of-order,
> but nothing serious.
> 
>> Something like this is what I have in mind:
>>
>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>> index 5c47910..723f854d 100644
>> --- a/drivers/of/fdt.c
>> +++ b/drivers/of/fdt.c
>> @@ -869,14 +869,16 @@ void * __init __weak
>> early_init_dt_alloc_memory_arch(u64 size, u64 align)
>>
>>  bool __init early_init_dt_scan(void *params)
>>  {
>> -       if (!params)
>> -               return false;
>> -
>>         /* Setup flat device-tree pointer */
>>         initial_boot_params = params;
>>
>> +       if (!initial_boot_params ||
>> +           (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER))
>> +               initial_boot_params = &__dtb_start;
>> +
>>         /* check device tree validity */
>> -       if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER) {
>> +       if (!initial_boot_params ||
> 
> initial_boot_params cannot be NULL here, so no need to check.

What about the case of no built-in dtb like on arm?

> 
>> +           (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER)) {
> 
> However, if __dtb_end == __dtb_start, you may be reading random
> data here from the next section. The OF_DT_HEADER check should cover
> this, but better safe than sorry?

Then we should also check that (__dtb_end != __dtb_start).

Rob

> 
>>                 initial_boot_params = NULL;
>>                 return false;
>>         }
> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 

