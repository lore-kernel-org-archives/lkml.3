Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbaIOXZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:25:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbaIOXZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:25:44 -0400
Message-ID: <54177534.806@redhat.com>
Date: Mon, 15 Sep 2014 19:24:36 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, Olof Johansson <olof@lixom.net>
CC: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
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
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v4 09/18] ARM64 / ACPI: Parse FADT table to get PSCI flags
 for PSCI init
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-10-git-send-email-hanjun.guo@linaro.org> <20140915063808.GC26649@localhost> <20140915145410.GD5415@arm.com>
In-Reply-To: <20140915145410.GD5415@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 10:54 AM, Catalin Marinas wrote:
> On Mon, Sep 15, 2014 at 07:38:08AM +0100, Olof Johansson wrote:
>> On Fri, Sep 12, 2014 at 10:00:07PM +0800, Hanjun Guo wrote:
>>> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
>>> +{
>>> +	struct acpi_table_fadt *fadt = (struct acpi_table_fadt *)table;
>>> +
>>> +	/*
>>> +	 * Revision in table header is the FADT Major revision,
>>> +	 * and there is a minor revision of FADT which was introduced
>>> +	 * by ACPI 5.1, we only deal with ACPI 5.1 or higher revision
>>> +	 * to get arm boot flags, or we will disable ACPI.
>>> +	 */
>>> +	if (table->revision > 5 ||
>>> +	    (table->revision == 5 && fadt->minor_revision >= 1))
>>> +		return 0;
>>
>> The commend and code disagree. The code says 5.1 or newer, while the comment say
>> _only_ 5.1. One or the other needs to change.
> 
> I don't think the comment and code disagree, it says "we only deal with
> ACPI 5.1 _or_ higher revision".
> 
> But since you mention it and following my other thread with Grant, I
> think at least for now we should make this check 5.1 only.

The problem with making this 5.1 only is that the specification will
move forward. The way the specification works is that the version
increments, structures grow new members, but additions are done in a
backward-compatible way. Therefore there's no reason why an ACPI6.0
system (in theory) should not be able to boot a 5.1 kernel[0]. By
artificially restricting this compatibility, users are worse off.

Jon.

[0] There will be examples where this is not true - let's say there's a
GICvX specification that's incompatible with GICv3+ and GICvX folks
don't necessarily choose to implement backward compatibility for GICv3.
If there's a new MADT subtype record handling GICvX then the OS would
need to support minimally the ACPI rev that adds this type.
