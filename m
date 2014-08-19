Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaHSW4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 18:56:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:8523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbaHSW4T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 18:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,898,1400050800"; 
   d="scan'208";a="587163716"
From: "Moore, Robert" <robert.moore@intel.com>
To: Hanjun Guo <hanjun.guo@linaro.org>, Mark Rutland <mark.rutland@arm.com>
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
        Robert Richter <rric@kernel.org>, "Zheng, Lv" <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: RE: [PATCH v2 05/18] ARM64 / ACPI: Parse FADT table to get PSCI
 flags for PSCI init
Thread-Topic: [PATCH v2 05/18] ARM64 / ACPI: Parse FADT table to get PSCI
 flags for PSCI init
Thread-Index: AQHPuvJ85wUXF3W88k+aAuTIfqBk2ZvXwOCAgAB6zwCAABHRAIAAPajQ
Date: Tue, 19 Aug 2014 22:55:59 +0000
Message-ID: <94F2FBAB4432B54E8AACC7DFDE6C92E37D1E7D1B@ORSMSX112.amr.corp.intel.com>
References: <1407166105-17675-1-git-send-email-hanjun.guo@linaro.org>
 <1407166105-17675-6-git-send-email-hanjun.guo@linaro.org>
 <20140818142721.GR20043@localhost> <53F2C983.8000800@linaro.org>
 <20140819111000.GG3302@leverpostej> <53F33F7A.7030307@linaro.org>
In-Reply-To: <53F33F7A.7030307@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should warn you that FADT version numbers are notoriously unreliable; In fact, in ACPICA we were eventually forced to abandon them entirely. We use the actual size of the FADT instead.

Bob



> -----Original Message-----
> From: Hanjun Guo [mailto:hanjun.guo@linaro.org]
> Sent: Tuesday, August 19, 2014 5:14 AM
> To: Mark Rutland
> Cc: Catalin Marinas; Rafael J. Wysocki; graeme.gregory@linaro.org; Arnd
> Bergmann; Olof Johansson; grant.likely@linaro.org; Sudeep Holla; Will
> Deacon; Jason Cooper; Marc Zyngier; Bjorn Helgaas; Daniel Lezcano; Mark
> Brown; Rob Herring; Robert Richter; Zheng, Lv; Moore, Robert; Lorenzo
> Pieralisi; Liviu Dudau; Randy Dunlap; Charles Garcia-Tobin; linux-
> acpi@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; linaro-acpi@lists.linaro.org
> Subject: Re: [PATCH v2 05/18] ARM64 / ACPI: Parse FADT table to get PSCI
> flags for PSCI init
> 
> On 2014-8-19 19:10, Mark Rutland wrote:
> >>>> @@ -47,6 +49,26 @@ void __init __acpi_unmap_table(char *map, unsigned
> long size)
> >>>>  	early_memunmap(map, size);
> >>>>  }
> >>>>
> >>>> +static int __init acpi_parse_fadt(struct acpi_table_header *table)
> >>>> +{
> >>>> +	struct acpi_table_fadt *fadt = (struct acpi_table_fadt
> *)table;
> >>>> +
> >>>> +	/*
> >>>> +	 * Revision in table header is the FADT Major version,
> >>>> +	 * and there is a minor version of FADT which was introduced
> >>>> +	 * by ACPI 5.1, we only deal with ACPI 5.1 or higher version
> >>>> +	 * to get arm boot flags, or we will disable ACPI.
> >>>> +	 */
> >>>> +	if (table->revision < 5 || fadt->minor_revision < 1) {
> >>>
> >>> If we ever get revision 6.0, this would trigger.
> >>
> >> Yes, good catch, actually I already fixed that in my local git repo,
> >>
> >> +       if (table->revision > 5 ||
> >> +           (table->revision == 5 && fadt->minor_revision >= 1)) {
> >> +               return 0;
> >> +       } else {
> >> +               pr_info("FADT revision is %d.%d, no PSCI support,
> >> + should be 5.1
> >> or higher\n",
> >> +                       table->revision, fadt->minor_revision);
> >> +               disable_acpi();
> >> +               return -EINVAL;
> >> +       }
> >
> > Given you return in the first path, you don't need the remaining code
> > to live in an else block.
> 
> Agreed, I will update it, and move disable_acpi() outside this function
> and keep it in one place as Sudeep suggested.
> 
> Thanks
> Hanjun

