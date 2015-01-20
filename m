Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbbATM0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:26:55 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53807 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbATM0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:26:54 -0500
Message-ID: <54BE496D.3050604@linaro.org>
Date: Tue, 20 Jan 2015 20:26:21 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 11/17] ACPI / processor: Make it possible to get CPU
 hardware ID via GICC
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-12-git-send-email-hanjun.guo@linaro.org> <20150120111756.GE25575@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150120111756.GE25575@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月20日 19:17, Catalin Marinas wrote:
> On Wed, Jan 14, 2015 at 03:04:59PM +0000, Hanjun Guo wrote:
>> --- a/drivers/acpi/processor_core.c
>> +++ b/drivers/acpi/processor_core.c
>> @@ -64,6 +64,38 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>>   	return 0;
>>   }
>>
>> +/*
>> + * On ARM platform, MPIDR value is the hardware ID as apic ID
>> + * on Intel platforms
>> + */
>> +static int map_gicc_mpidr(struct acpi_subtable_header *entry,
>> +		int device_declaration, u32 acpi_id, int *mpidr)
>> +{
>> +	struct acpi_madt_generic_interrupt *gicc =
>> +	    container_of(entry, struct acpi_madt_generic_interrupt, header);
>> +
>> +	if (!(gicc->flags & ACPI_MADT_ENABLED))
>> +		return -ENODEV;
>> +
>> +	/* In the GIC interrupt model, logical processors are
>> +	 * required to have a Processor Device object in the DSDT,
>> +	 * so we should check device_declaration here
>> +	 */
>> +	if (device_declaration && (gicc->uid == acpi_id)) {
>> +		/*
>> +		 * Only bits [0:7] Aff0, bits [8:15] Aff1, bits [16:23] Aff2
>> +		 * and bits [32:39] Aff3 are meaningful, so pack the Affx
>> +		 * fields into a single 32 bit identifier to accommodate the
>> +		 * acpi processor drivers.
>> +		 */
>> +		*mpidr = ((gicc->arm_mpidr & 0xff00000000) >> 8)
>> +			 | gicc->arm_mpidr;
>
> Nitpick: I would clarify the comment here since "meaningful" doesn't
> necessarily mean that the other bits are 0. And if they are not, the
> above masking is not enough. Looking at the ACPI 5.1 spec, bits other
> than Aff[0-3] must be zero.
>
> Same for the pack_mpidr() comment.

OK, how about:

/*
  * bits other than [0:7] Aff0, [8:15] Aff1, [16:23] Aff2 and
  * [32:39] Aff3 must be 0 which is defined in ACPI 5.1, so pack
  * the Affx fields into a single 32 bit identifier to accommodate
  * the acpi processor drivers.
  */

Thanks
Hanjun
