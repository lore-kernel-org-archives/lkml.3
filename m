Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaHXX2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 19:28:16 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:42091 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144AbaHXX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 19:28:13 -0400
MIME-Version: 1.0
In-Reply-To: <20140822130640.GM13147@bart.dudau.co.uk>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-5-git-send-email-Liviu.Dudau@arm.com> <CAL_JsqJm6qWNdrJ2F8xddFUj46y42n6hQVu1nkTaA-5Tbg--XQ@mail.gmail.com>
 <20140822130640.GM13147@bart.dudau.co.uk>
From: Rob Herring <robherring2@gmail.com>
Date: Sun, 24 Aug 2014 18:27:48 -0500
Message-ID: <CAL_JsqLGa3em5Phct-H0Q=vB5AnA78h19uA=4xi3xHA1rCVq+A@mail.gmail.com>
Subject: Re: [PATCH v9 04/12] PCI: OF: Fix the conversion of IO ranges into IO resources.
To: Liviu Dudau <liviu@dudau.co.uk>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 8:06 AM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> On Thu, Aug 21, 2014 at 11:08:48PM -0500, Rob Herring wrote:
>> On Tue, Aug 12, 2014 at 11:25 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> > The ranges property for a host bridge controller in DT describes
>> > the mapping between the PCI bus address and the CPU physical address.
>> > The resources framework however expects that the IO resources start
>> > at a pseudo "port" address 0 (zero) and have a maximum size of IO_SPACE_LIMIT.
>> > The conversion from pci ranges to resources failed to take that into account.
>> >
>> > In the process move the function into drivers/of/address.c as it now
>> > depends on pci_address_to_pio() code and make it return an error code.
>> >
>> > Cc: Grant Likely <grant.likely@linaro.org>
>> > Cc: Rob Herring <robh+dt@kernel.org>
>>
>> Humm, this says I'm cc'ed, but I'm not which defeats the point of
>> recording the Cc's in the commit.
>
> Appologies, I've screwed up my git send-email arguments.
>
>>
>> I still have the same concerns that this will break existing users.
>> Are you sure integrator is the only platform affected?
>
> microblaze and powerpc have their similar handcoded routine for parsing ranges
> where they pre-compute the io_base and adjust the values again when registering
> resources. I'm not absolutely sure they are not broken as I lack the appropriate
> platforms to test (I've been asking for an FPGA engineer to build me a microblaze
> image with all the bits included but haven't received anything yet and it is
> possible Xilinx has now shifted their interests towards ARM + PCI as the ML605
> board that I have seems to have been discontinued).

I will settle for "I've read through the $arch code and believe they
are not broken". It is unrealistic for you to test on everything.

> mips is doing the same thing and I believe is not affected, pci-host-generic.c
> was adjusting the returned values afterwards so that will not be needed and Lorenzo
> has a patch for the driver to adapt it to this series anyway.
>
> pcie-designware.c also recalculates the io.start and io.end values, so that's fine
> for now. The only ones that I believe are still affected are pci-tegra.c and
> pcie-rcar.c for which I will need to provide a patch similar to integrator unless
> the code gets converted to the new range parsing.

Well, the latter would be nice, but they certainly have to be fixed.
Now that I think about it, this needs to be handled in a bisectable
way. So I think you need to fix all affected platforms in this patch
rather than a separate patch as you have done.

Rob
