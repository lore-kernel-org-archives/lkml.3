Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbbAFNn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:43:29 -0500
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:50483 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754979AbbAFNn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:43:27 -0500
Message-ID: <54ABE67B.1070706@nexus-software.ie>
Date: Tue, 06 Jan 2015 13:43:23 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: Re: [PATCH 1/2] x86: Add Isolated Memory Regions for Quark X1000
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <1419873783-5161-2-git-send-email-pure.logic@nexus-software.ie> <20150106073634.GB59754@vmdeb7>
In-Reply-To: <20150106073634.GB59754@vmdeb7>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 07:36, Darren Hart wrote:

>> Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
>
> Since you have Intel (C) below and then your own, are you the sole author?

Yes, for the platform code.

Platform code tears-down IMRs and sets-up up a new one around the 
kernel. Quark BSP does a similar thing in a different place.

To be safe I'm happy to add a Intel (C) to this file anyway.

>> +config IMR
>> +	tristate "Isolated Memory Region support"
>> +	default m
>> +	depends on IOSF_MBI
>> +	---help---
>> +	  This option enables support for Isolated Memory Regions.
>
> It supports manipulating them specifically, correct? No support is needed to
> trigger an IMR violation and reboot the system, that happens in
> hardware/firmware without any OS involvement.

Exactly.

> So we're specifically providing the means to manipulate the IMRs.

True - I'll add that statement to the description.

>> +/*
>> + * Right now IMRs are not reported via CPUID though it'd be really great if
>> + * future silicon did report via CPUID for this feature bringing it in-line with
>> + * other similar features - like MTRRs, MSRs etc.
>
> I think we can drop the editorializing :-)

:)

>
> /*
>   * Unfortunately, IMRs are not reported via CPUID, unlike MTRRs, MSRs, etc.
>   * Define a macro analogous to cpu_has_x type features.
>   */

Done.

>> +/* Definition of read/write masks from published BSP code */
>> +#define IMR_READ_ACCESS_ALL	0xBFFFFFFF
>> +#define IMR_WRITE_ACCESS_ALL	0xFFFFFFFF
>> +
>> +/* Number of IMRs provided by Quark X1000 SoC */
>> +#define QUARK_X1000_IMR_NUM	0x07
>
> Hrm, I thought there were 8?

There are. All of the loops look like this

for (i = 0; i <= imr_dev.num; i++)

aka

for (i = 0; i <= QUARK_X1000_IMR_NUM; i++)

Worth changing IMR_NUM to 8 and changing the loops to < IMR_NUM to 
remove confusion.

> Also in the datasheet here:
>
> https://communities.intel.com/servlet/JiveServlet/previewBody/21828-102-2-25120/329676_QuarkDatasheet.pdf
>
>> + *
>> + * addr_lo
>> + * 31		Lock bit
>> + * 30		Enable bit - not implemented on Quark X1000
>
> With the exception of bit 30, also marked as reserved per the above datasheet.

Fair point. I'll refer to the spec directly for all of the bits.

>> +struct imr {
>> +	u32 addr_lo;
>> +	u32 addr_hi;
>> +	u32 rmask;
>> +	u32 wmask;
>> +};
>> +
>> +#define IMR_NUM_REGS	(sizeof(struct imr)/sizeof(u32))
>
> Perhaps call the imr imr_regs so nobody breaks this in the future by adding
> something other than a u32 to it? Alternatively, use a datatype that enforces
> this... like the union Andy suggested...

I'll take a look and see which suggestion fits better

>> +#define IMR_SHIFT	8
>> +#define imr_to_phys(x)	(x << IMR_SHIFT)
>> +#define phys_to_imr(x)	(x >> IMR_SHIFT)
>> +
>> +/**
>> + * imr_enabled
>> + * Determines if an IMR is enabled based on address range
>> + *
>> + * @imr:	Pointer to IMR descriptor
>> + * @return	true if IMR enabled false if disabled
>> + */
>> +static int imr_enabled(struct imr *imr)
>> +{
>> +	return (imr_to_phys(imr->addr_lo) && imr_to_phys(imr->addr_hi));
>
> What are testing here? You have bit 30 marked as "Enabled" above (but it isn't
> in the datasheet). With Reserved bits in each register, this test for non-zero
> doesn't seem robust.

Good question.

Bit 30 is not present in X1000 silicon, though is present in the BSP 
code. Lets forget about all non-X1000 cases for now since X1000 is the 
only processor currently available.

On X1000 the only means of determining if an IMR is enabled is if it's 
address bits are set to some address everybody agrees means 'off', since 
the enable bit doesn't exist. Everybody in this case is ROM, BIOS, 2nd 
stage bootloader and kernel.

In the BSP code, that address is zero. So in lieu of bit 30 'enable' we 
have address 0x00000000.

The kernel could define an alternative address to 0x00000000 but, then 
this would break with the convention in BIOS etc.

Since BIOS and grub code both use 0x00000000 as the 'off' address I 
think it makes sense for the kernel to continue to use that address.

>> +	/* Error out if we have an overlap or no free IMR entries */
>
> According to the datasheet, overlapping ranges are valid, and access must be
> granted by all IMRs associated with a given address. Why declare an overlap as
> invalid here?

Simplicity.

It's more straight forward to define your IMR memory map if you don't 
allow the address ranges to stomp all over each other.

None of the BSP reference code does overlap.

If there's an argument for an overlap use-case it can be supported 
pretty simply by simply removing the overlap checks.

My own view is that it's not really desirable and easier to debug IMRs 
generally on a platform if overlaps aren't allowed.


Best,
BOD
