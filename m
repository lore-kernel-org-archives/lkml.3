Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbaHSLHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:07:53 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40677 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaHSLHv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:07:51 -0400
Message-ID: <53F33001.5000207@arm.com>
Date: Tue, 19 Aug 2014 12:07:45 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
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
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org> <1407166105-17675-6-git-send-email-hanjun.guo@linaro.org> <53F246D4.7040807@arm.com> <53F3297A.1040309@linaro.org>
In-Reply-To: <53F3297A.1040309@linaro.org>
X-OriginalArrivalTime: 19 Aug 2014 11:07:46.0906 (UTC) FILETIME=[CEB1EBA0:01CFBB9D]
X-MC-Unique: 114081912074811001
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/08/14 11:39, Hanjun Guo wrote:
> On 2014-8-19 2:32, Sudeep Holla wrote:
>> On 04/08/14 16:28, Hanjun Guo wrote:
>>> There are two flags: PSCI_COMPLIANT and PSCI_USE_HVC. When set,
>>> the former signals to the OS that the hardware is PSCI compliant.
>>> The latter selects the appropriate conduit for PSCI calls by
>>> toggling between Hypervisor Calls (HVC) and Secure Monitor Calls
>>> (SMC).
>>>
>>> FADT table contains such information, parse FADT to get the flags
>>> for PSCI init. Since ACPI 5.1 doesn't support self defined PSCI
>>> function IDs, which means that only PSCI 0.2+ is supported in ACPI.
>>>
>>> At the same time, only ACPI 5.1 or higher verison supports PSCI,
>>> and FADT Major.Minor version was introduced in ACPI 5.1, so we
>>> will check the version and only parse FADT table with version >= 5.1.
>>>
>>> If firmware provides ACPI tables with ACPI version less than 5.1,
>>> OS will be messed up with those information and have no way to
>>> bring up secondery CPUs, so disable ACPI if we get an FADT table
>>> with version less that 5.1.
>>>
> [...]
>>>
>>> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
>>> +{
>>> +    struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
>>> +
>>> +    /*
>>> +     * Revision in table header is the FADT Major version,
>>> +     * and there is a minor version of FADT which was introduced
>>> +     * by ACPI 5.1, we only deal with ACPI 5.1 or higher version
>>> +     * to get arm boot flags, or we will disable ACPI.
>>> +     */
>>> +    if (table->revision < 5 || fadt->minor_revision < 1) {
>>
>>                  &&
>
> Catalin also pointed out this bug :), but && is not enough, for example,
> this would not trigger of revision 4.1, although 4.1 is not exist, but
> the code will still confusing people, so I updated the code as:
>

Right I missed it :), the below code looks fine.

> +       if (table->revision > 5 ||
> +           (table->revision == 5 && fadt->minor_revision >= 1)) {
> +               return 0;
> +       } else {
> +               pr_info("FADT revision is %d.%d, no PSCI support, should be 5.1
> or higher\n",
> +                       table->revision, fadt->minor_revision);
> +               disable_acpi();

As suggested elsewhere try to eliminate this and have it once if
acpi_boot_init failed for any reasons.

Regards,
Sudeep

