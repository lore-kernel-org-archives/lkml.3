Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3AUKOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:14:49 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:48529 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3AUKOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:14:47 -0500
Message-ID: <50FD1504.5020408@synopsys.com>
Date: Mon, 21 Jan 2013 15:44:28 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.cross-arch,gmane.linux.kernel,gmane.linux.drivers.devicetree
To: Rob Herring <robherring2@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 32/76] ARC: [DeviceTree] Basic support
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-33-git-send-email-vgupta@synopsys.com> <50F97017.4090705@gmail.com>
In-Reply-To: <50F97017.4090705@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 09:23 PM, Rob Herring wrote:
> On 01/18/2013 06:24 AM, Vineet Gupta wrote:
>> This is minimal infrastructure needed for devicetree work.
>> It uses an a sample "skeleton" devicetree - embedded in kernel image -
>> to print the board, manufacturer by parsing the top-level "compatible"
>> string.
>>
>> As of now we don't need any additional "board" specific "machine_desc".
>>
>> TODO: support interpreting the command line as boot-loader passed dtb
>>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: devicetree-discuss@lists.ozlabs.org
>> Cc: Rob Herring <rob.herring@calxeda.com>
>> ---
>>  arch/arc/Kconfig                |    9 +++++
>>  arch/arc/Makefile               |    9 +++++
>>  arch/arc/boot/dtb/Makefile      |   22 ++++++++++++
> 
> This is .../boot/dts/Makefile on other arches. We should be consistent.

OK, everything moved over to boot/dts folder, boot/dtb nuked, although latter
seemed a clean approach - specially given that some arches have billions of source
files in them - anyways not a big worry for ARC port.


>> [snip....]
>>
>> +
>> +# Rule to build device tree blobs
>> +$(obj)/%.dtb: $(src)/../dts/%.dts FORCE
>> +	$(call if_changed_dep,dtc)
> 
> There are common rules that went into 3.8. Please use them.

How does the equivalent of following look like:

diff --git a/arch/arc/boot/dts/Makefile b/arch/arc/boot/dts/Makefile

@@ -1,7 +1,5 @@
 ifeq ($(CONFIG_OF),y)

-dtb-y  += skeleton.dtb
-
 # Built-in dtb
 builtindtb-y                           := skeleton

@@ -11,12 +9,6 @@ endif

 obj-y  += $(patsubst "%",%,$(builtindtb-y)).dtb.o

-clean-files += $(obj)/$(dtb-y) $(obj)/*.dtb.S $(obj)/*.dtb.o
-
-# Rule to build device tree blobs
-$(obj)/%.dtb: $(src)/../dts/%.dts FORCE
-       $(call if_changed_dep,dtc)
-
-$(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
+clean-files += *.dtb

One observation above is that the explicitly build dtb file (make ARCH=arc
angel4.dtb) doesn't get cleaned with make {clean,distclean} despite above
clean-files and this is true even for orig version.

>> +
>> +$(obj)/dtbs: $(addprefix $(obj)/, $(dtb-y))
>> +
>> +endif
>> diff --git a/arch/arc/boot/dts/skeleton.dts b/arch/arc/boot/dts/skeleton.dts
>> new file mode 100644
>> index 0000000..25a84fb
>> --- /dev/null
>> +++ b/arch/arc/boot/dts/skeleton.dts
>> @@ -0,0 +1,10 @@
>> +/*
>> + * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +/dts-v1/;
>> +
>> +/include/ "skeleton.dtsi"
>> diff --git a/arch/arc/boot/dts/skeleton.dtsi b/arch/arc/boot/dts/skeleton.dtsi
>> new file mode 100644
>> index 0000000..f6a457a
>> --- /dev/null
>> +++ b/arch/arc/boot/dts/skeleton.dtsi
>> @@ -0,0 +1,21 @@
>> +/*
>> + * Copyright (C) 2012 Synopsys, Inc. (www.synopsys.com)
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +/*
>> + * Skeleton device tree; the bare minimum needed to boot; just include and
>> + * add a compatible value.
>> + */
>> +
>> +/ {
>> +	compatible = "snps,arc-angel4", "snps,arc-ml509";
> 
> Normally, you wouldn't have this as part of skeleton. If you need
> something generic, then perhaps generic.dts would be better.

So you mean rename arc/arc/boot/dts/skeleton.dts to arch/arc/boot/dts/generic.dts
as that's what the semantics are here. I agree.

However I think skeleton semantics are better: I'll take out the specific boards
name from it, and for empty CONFIG_ARC_BUILTIN_DTB_NAME, include a real board DT
file rather than skeleton. OK ?


>> [snipped...]
>>  early_param("mem", setup_mem_sz);
>>  
>> +void __init early_init_dt_add_memory_arch(u64 base, u64 size)
>> +{
>> +	pr_err("%s(%llx, %llx)\n", __func__, base, size);
> 
> ? Is this todo?

Yes, ARC port currently doesn't handle the cmdline provided by DT - given that I
added the the DT support itself very recently. I plan to fix this soon, but assume
it not absolutely must in terms of requirements.


>> +#ifdef CONFIG_OF_FLATTREE
>> +void __init early_init_dt_setup_initrd_arch(unsigned long start,
>> +					    unsigned long end)
>> +{
>> +	pr_err("%s(%lx, %lx)\n", __func__, start, end);
> 
> And this?

Ditto !

Many thanks for your review.
-Vineet
