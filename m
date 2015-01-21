Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbbAUQMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:12:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbbAUQMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:12:07 -0500
Message-ID: <54BFCE4D.2060806@redhat.com>
Date: Wed, 21 Jan 2015 11:05:33 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Al Stone <al.stone@linaro.org>, Timur Tabi <timur@codeaurora.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Mark Brown <broonie@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>,
        "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>,
        "parth.dixit@linaro.org" <parth.dixit@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH v7 04/17] ARM64 / ACPI: Introduce early_param for "acpi"
 and pass acpi=force to enable ACPI
References: <CAKv+Gu8vPKAdsNg7QC7xW+i8_BemWEx4mvBx6NrnAHi8Y+bNtw@mail.gmail.com> <20150119135144.GI11835@e104818-lin.cambridge.arm.com> <20150119151350.21B65C40948@trevor.secretlab.ca> <54BD3803.6020307@redhat.com> <20150119175233.GK11835@e104818-lin.cambridge.arm.com> <20150119180122.GJ21553@leverpostej> <54BE1FEA.5040109@linaro.org> <alpine.DEB.2.02.1501201901190.12653@kaball.uk.xensource.com> <20150121152326.GD6358@e104818-lin.cambridge.arm.com> <54BFC5F0.3020500@redhat.com> <20150121154243.GE6358@e104818-lin.cambridge.arm.com>
In-Reply-To: <20150121154243.GE6358@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 10:42 AM, Catalin Marinas wrote:
> On Wed, Jan 21, 2015 at 03:29:52PM +0000, Jon Masters wrote:
>> On 01/21/2015 10:23 AM, Catalin Marinas wrote:
>>> I have some questions for the ACPI and EFI folk:
>>>
>>> 1. When booting with ACPI, are the EFI run-time services required for
>>>    anything? If yes, Xen may have a bigger problem
>>
>> Yes. At least for some things. For example, installing an Operating
>> System would require that you make runtime services calls to set the
>> BootOrder/BootNext variables, and so on. Further, we use the GetTime
>> service and EFI based reboot to avoid having special drivers. I had
>> those added to SBBR as requirements for that reason.
> 
> So what would a kexec'ed kernel do here? Or we usually expect it to be
> short lived and doesn't need reboot, nor GetTime.

In the use case that I have, it'll use EFI Runtime Servies to handle
both the time of day (which it will need) and to subsequently reboot.
This is currently being worked on (integration into kdump).

> Xen is slightly more problematic but I wonder whether it could run a
> (paravirtualised) UEFI.
> 
>>> 2. Could a boot loader (either kernel doing kexec or Xen) emulate the
>>>    EFI system/config tables and still make them useful to the kernel but
>>>    without EFI_BOOT or EFI_RUNTIME_SERVICES?
>>
>> Yes. But again, without the other required pieces (including the
>> services function pointers in the systab which are required) you'd crash
>> soon after boot trying to make those calls.
> 
> My point was whether you can still pass information like RSDP address
> via EFI tables but explicitly disable runtime services so that the
> kernel won't try to make such calls (and crash).

Yes. As Graeme says, it works just to pass in the ACPI information and
turn off EFI *BUT* it does not work to say you have EFI and then not
provide the correct EFI services. To do so is out of spec, and in fact
it's one reason we weren't able to turn the GetTime service on generally
for x86 - some older x86 boxes didn't implement it originally (another
reason on our end we're requiring all of these services on day one so
that there won't be time for someone to miss them in firmware).

Jon.

