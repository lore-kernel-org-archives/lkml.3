Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab3IRPJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:09:43 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45798 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3IRPJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:09:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130918033358.51CA1C42C9E@trevor.secretlab.ca>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
	<1379372965-22359-19-git-send-email-robherring2@gmail.com>
	<20130918033358.51CA1C42C9E@trevor.secretlab.ca>
Date: Wed, 18 Sep 2013 10:09:40 -0500
Message-ID: <CAL_JsqKkhPt0hMKvdh+71WN9ERTRvzJKXO9ZV076ks-XGxbn4A@mail.gmail.com>
Subject: Re: [PATCH 18/28] of: create default early_init_dt_add_memory_arch
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "microblaze-uclinux@itee.uq.edu.au" 
	<microblaze-uclinux@itee.uq.edu.au>,
        linux@openrisc.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 10:33 PM, Grant Likely <grant.likely@linaro.org> wrote:
> On Mon, 16 Sep 2013 18:09:14 -0500, Rob Herring <robherring2@gmail.com> wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> Create a weak version of early_init_dt_add_memory_arch which uses
>> memblock or is an empty function when memblock is not enabled. This
>> will unify all architectures except ones with custom memory bank
>> structs.
>
> Two comments below, but otherwise:
>
> Acked-by: Grant Likely <grant.likely@linaro.org>
>
>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>> index 0714dd4..a9dce7a 100644
>> --- a/drivers/of/fdt.c
>> +++ b/drivers/of/fdt.c
>> @@ -688,6 +688,17 @@ u64 __init dt_mem_next_cell(int s, __be32 **cellp)
>>       return of_read_number(p, s);
>>  }
>>
>> +void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
>> +{
>> +#ifdef CONFIG_HAVE_MEMBLOCK
>> +     base &= PAGE_MASK;
>> +     size &= PAGE_MASK;
>> +     memblock_add(base, size);
>> +#else
>> +     pr_err("%s: ignoring memory (%llx, %llx)\n", __func__, base, size);
>> +#endif
>> +}
>> +
>
> Can you do it this way instead:
>
> #ifdef CONFIG_HAVE_MEMBLOCK
> void __init __weak early_init_dt_add_memory_arch(u64 base, u64 size)
> {
>         base &= PAGE_MASK;
>         size &= PAGE_MASK;
>         memblock_add(base, size);
> }
> #endif
>
> If the platform doesn't provide an early_init_dt_add_memory_arch()
> function and it doesn't have a memblock implementation, then the build
> should outright fail. I don't see a scenario where we would want to
> successfully build the kernel without a working add memory function.

metag and x86 both have empty functions. I guess they get memory from
a different boot interface.

Rob

>
> Also, can you group this function with the common __weak
> early_init_dt_alloc_memory_arch() implementation? It would be good to
> group all the memblock specific functions together.
>
> g.
>
