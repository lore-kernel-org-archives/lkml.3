Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbaIKOFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:05:11 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:40557 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbaIKOFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:05:07 -0400
MIME-Version: 1.0
In-Reply-To: <61335531.hz91PL2Gdf@vostro.rjw.lan>
References: <1409583475-6978-1-git-send-email-hanjun.guo@linaro.org>
 <20140911132935.068DCC408F6@trevor.secretlab.ca> <61335531.hz91PL2Gdf@vostro.rjw.lan>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 11 Sep 2014 15:04:46 +0100
X-Google-Sender-Auth: HxnkILHMJQ3wi9B-_LyDBz1KUC8
Message-ID: <CACxGe6tkzdpDaTm0J8bzSHev=a7+28cOnWUJxBcwr7z+GUpH4w@mail.gmail.com>
Subject: Re: [PATCH v3 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Olof Johansson <olof@lixom.net>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linaro-acpi <linaro-acpi@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 3:23 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Thursday, September 11, 2014 02:29:34 PM Grant Likely wrote:
>> On Mon,  1 Sep 2014 22:57:38 +0800, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>> > ACPI 5.1 has been released and now be freely available for
>> > download [1]. It fixed some major gaps to run ACPI on ARM,
>> > this patch just follow the ACPI 5.1 spec and prepare the
>> > code to run ACPI on ARM64.
>> >
>> > ACPI 5.1 has some major changes for the following tables and
>> > method which are essential for ARM platforms:
>> > 1) MADT table updates.
>> > 2) FADT updates for PSCI
>> > 3) GTDT
>> >
>> > This patch set is the ARM64 ACPI core patches covered MADT, FADT
>> > and GTDT, platform board specific drivers are not covered by this
>> > patch set, but we provide drivers for Juno to boot with ACPI only
>> > in the follwing patch set for review purpose.
>> >
>> > We first introduce acpi.c and its related head file which are needed
>> > by ACPI core, and then get RSDP to extract all the ACPI boot-time tables.
>> > When all the boot-time tables (FADT, MADT, GTDT) are ready, then
>> > parse them to init the sytem when booted. Specifically,
>> > a) we use FADT to init PSCI and use PSCI to boot SMP;
>> > b) Use MADT for GIC init and SMP init;
>> > c) GTDT for arch timer init.
>> >
>> > This patch set is based on 3.17-rc2 and was tested by Graeme on Juno
>> > and FVP base model boot with ACPI only OK, if you want to test them,
>> > you can pull from acpi-5.1-v3 branch in leg/acpi repo:
>> > git://git.linaro.org/leg/acpi/acpi.git
>> >
>> > Updates since v2:
>> >  - Refactor the code to make SMP/PSCI init with less sperated init
>> >    path by Tomasz
>> >  - make ACPI depend on EXPERT
>> >  - Address lots of comments from Catalin, Sudeep, Geoff
>> >  - Add Juno device ACPI driver patches for review
>> >
>> > Updates since v1:
>> >  - Set ACPI default off on ARM64 suggested by Olof;
>> >  - Rebase the patch set on top of linux-next branch/linux-pm tree which
>> >    includes the ACPICA for full ACPI 5.1 support.
>> >  - Update the document as suggested;
>> >  - Adress lots of comments from Mark, Sudeep, Randy, Naresh, Olof, Geoff
>> >    and more...
>> >
>> > [1]: http://www.uefi.org/sites/default/files/resources/ACPI_5_1release.pdf
>>
>> I've read through this entire series now. In my mind, aside from a few
>> comments that I know you're addressing, this is ready.  The hooks into
>> arm64 core code are not terribly invasive, it is nicely organized and
>> manageable. Get the next version out ASAP, but I would also like to see
>> the diffs from this version to the next so I don't need to review the
>> entire series again.
>>
>> Regarding the requests to refactor ACPICA to work better for ARM. I
>> completely agree that it should be done, but I do not think it should be
>> a prerequisite to getting this core support merged. That kind of
>> refactoring is far easier to justify when it has immediate improvement
>> on the mainline codebase, and it gives us a working baseline to test
>> against. Doing it the other way around just makes things harder.
>>
>> I would really like to see the next version of this series go into
>> linux-next. I think this is ready for some wider exposure. Have you got
>> a branch being pulled into Fengguang's autobuilder yet?
>
> Having looked at the patches recently, I don't see any major problems in
> them from the ACPI core perspective, so to me they are good to go.
>
> Question is who's going to handle them?

They should absolutely go via Catalin & Will's tree.

g.
