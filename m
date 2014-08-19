Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaHSMPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:15:24 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:52444 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaHSMPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:15:21 -0400
Message-ID: <53F33F7A.7030307@linaro.org>
Date: Tue, 19 Aug 2014 20:13:46 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v2 05/18] ARM64 / ACPI: Parse FADT table to get PSCI flags
 for PSCI init
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-6-git-send-email-hanjun.guo@linaro.org> <20140818142721.GR20043@localhost> <53F2C983.8000800@linaro.org> <20140819111000.GG3302@leverpostej>
In-Reply-To: <20140819111000.GG3302@leverpostej>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-8-19 19:10, Mark Rutland wrote:
>>>> @@ -47,6 +49,26 @@ void __init __acpi_unmap_table(char *map, unsigned long size)
>>>>  	early_memunmap(map, size);
>>>>  }
>>>>  
>>>> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
>>>> +{
>>>> +	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
>>>> +
>>>> +	/*
>>>> +	 * Revision in table header is the FADT Major version,
>>>> +	 * and there is a minor version of FADT which was introduced
>>>> +	 * by ACPI 5.1, we only deal with ACPI 5.1 or higher version
>>>> +	 * to get arm boot flags, or we will disable ACPI.
>>>> +	 */
>>>> +	if (table->revision < 5 || fadt->minor_revision < 1) {
>>>
>>> If we ever get revision 6.0, this would trigger.
>>
>> Yes, good catch, actually I already fixed that in my local git repo,
>>
>> +       if (table->revision > 5 ||
>> +           (table->revision == 5 && fadt->minor_revision >= 1)) {
>> +               return 0;
>> +       } else {
>> +               pr_info("FADT revision is %d.%d, no PSCI support, should be 5.1
>> or higher\n",
>> +                       table->revision, fadt->minor_revision);
>> +               disable_acpi();
>> +               return -EINVAL;
>> +       }
> 
> Given you return in the first path, you don't need the remaining code to
> live in an else block.

Agreed, I will update it, and move disable_acpi() outside this function and keep
it in one place as Sudeep suggested.

Thanks
Hanjun

