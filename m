Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab3DWQGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:06:21 -0400
Received: from multi.imgtec.com ([194.200.65.239]:56419 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756466Ab3DWQGP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:06:15 -0400
Message-ID: <5176B173.40107@imgtec.com>
Date: Tue, 23 Apr 2013 17:06:11 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-kernel@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, "Rob Landley" <rob@landley.net>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 2/8] metag: minimal TZ1090 (Comet) SoC infrastructure
References: <1366727607-27444-1-git-send-email-james.hogan@imgtec.com> <1366727607-27444-3-git-send-email-james.hogan@imgtec.com> <201304231725.34826.arnd@arndb.de>
In-Reply-To: <201304231725.34826.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_04_23_17_06_13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing Arnd.

On 23/04/13 16:25, Arnd Bergmann wrote:
> On Tuesday 23 April 2013, James Hogan wrote:
> 
>> @@ -46,6 +46,12 @@ core-y					+= arch/metag/boot/dts/
>>  core-y					+= arch/metag/kernel/
>>  core-y					+= arch/metag/mm/
>>  
>> +# SoCs
>> +socdir-$(CONFIG_SOC_TZ1090)		+= tz1090
>> +
>> +socdirs		:= $(filter-out ., $(patsubst %,%/,$(socdir-y)))
>> +core-y		+= $(addprefix arch/metag/soc/, $(socdirs))
>> +
> 
> Does it actually make sense to have subdirectories per soc? I would 
> suggest you copy from arm64 rather from arm for the platform support and
> do it as minimal as possible. Any code you need can go into a shared directory
> as a start, and if you end up needing more of a hierarchical structure,
> you can add that later. Hopefully we've come to the point now where almost
> everything can live in drivers/* though.

Where is the shared directory for arm64 platforms? (arch/arm64 is
looking pretty bare).

It's certainly heading in that direction a lot. For this patchset I
could get away with dropping arch/metag/soc/*, and deal with anything
that really requires something like it later.

The machine callbacks I was planning on using in future patches are:
* init_time() for calling into the appropriate common clock driver from
time_init(), prior to setting up the timer so that the right frequency
can be reported based on the clock hierarchy specified in DT. I guess
this could be made more general, allowing any enabled clock component to
be initialised at this time.
* init_irq(), for dynamically detecting evaluation silicon and if so
telling the interrupt controller that there are no mask registers (easy
to drop tbh since nobody uses TZ1090 evaluation silicon any longer).
* probably something for setting up power management (suspend to ram /
standby and associated asm code), which would also be used by some
TZ1090 based boards requiring their own power management variations.

> 
>> diff --git a/arch/metag/configs/tz1090_defconfig b/arch/metag/configs/tz1090_defconfig
>> new file mode 100644
>> index 0000000..4794094
>> --- /dev/null
>> +++ b/arch/metag/configs/tz1090_defconfig
> 
> Also, if this is compatible with your previous platform, I would recommend just
> having a single defconfig that runs on all supported hardware. It's easy enough
> for users to turn off the drivers and platforms they don't need.

Unfortunately the selects in the SOC_TZ1090 are important as they enable
workarounds for hardware quirks which would have a performance impact on
newer cores without those quirks. At the moment (i.e. without doing
dynamic fixups of kernel code like I believe x86 does, and without an
updated compiler that can support fast jump labels), we can probably
only achieve single-SoC multi-board support in a given kernel, at least
when it comes to the TZ1090.

> 
>> diff --git a/arch/metag/soc/tz1090/setup.c b/arch/metag/soc/tz1090/setup.c
>> new file mode 100644
>> index 0000000..fbd7074
>> --- /dev/null
>> +++ b/arch/metag/soc/tz1090/setup.c
>> +
>> +#include <linux/init.h>
>> +#include <asm/mach/arch.h>
>> +
>> +static const char *tz1090_boards_compat[] __initdata = {
>> +	"toumaz,tz1090",
>> +	NULL,
>> +};
>> +
>> +MACHINE_START(TZ1090, "Generic TZ1090")
>> +	.dt_compat	= tz1090_boards_compat,
>> +MACHINE_END
> 
> Have you looked at the patch I sent for default platform code on ARM?
> The idea is to default to an empty machine descriptor if nothing matches
> the root compatible entry of the DT. The same would work here to allow
> you to run without any board code at all.

No I hadn't seen that. I'll look into it. This was meant as a stub to
later be extended, and at the moment without this we would fall back to
an almost identical definition in arch/metag/kernel/machines.c which
wouldn't do any harm at this stage.

Thanks
James

