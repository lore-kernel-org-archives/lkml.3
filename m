Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaI2TGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:06:14 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52006 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaI2TGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:06:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXEUZvkuzwOrK+2zGVj0ywFaQsiWH7SHufZk9BRWnwddQ@mail.gmail.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
	<1412000971-9242-11-git-send-email-Liviu.Dudau@arm.com>
	<CAE9FiQXEUZvkuzwOrK+2zGVj0ywFaQsiWH7SHufZk9BRWnwddQ@mail.gmail.com>
Date: Mon, 29 Sep 2014 12:06:10 -0700
X-Google-Sender-Auth: sYeCQUtVY6OCme-pmC4PRbs3baQ
Message-ID: <CAE9FiQUkcPRMUEn01VJMyXz8aYvk6C5MBNZi5NCV2m3qkNabeg@mail.gmail.com>
Subject: Re: [PATCH v13 10/12] PCI: Assign unassigned bus resources in pci_scan_root_bus()
From: Yinghai Lu <yinghai@kernel.org>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:25 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Sep 29, 2014 at 7:29 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> If the firmware has not assigned all the bus resources and we are not just
>> probing the PCI buses, it makes sense to assign the unassigned resources
>> in pci_scan_root_bus().
>>
>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> CC: Arnd Bergmann <arnd@arndb.de>
>> CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
>> CC: Rob Herring <robh+dt@kernel.org>
>> ---
>>  drivers/pci/probe.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index 636d1c9..d2ebd49 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -1951,6 +1951,9 @@ struct pci_bus *pci_scan_root_bus(struct device *parent, int bus,
>>         if (!found)
>>                 pci_bus_update_busn_res_end(b, max);
>>
>> +       if (!pci_has_flag(PCI_PROBE_ONLY))
>> +               pci_assign_unassigned_bus_resources(b);
>> +
>>         pci_bus_add_devices(b);
>>         return b;
>>  }
>
> No, you can not do it that early.
>
> On x86, we need to call
> pcibios_resource_survey_bus at first.

on x86:
pcibios_init
pcibios_resource_survey()
pcibios_assign_resources() via fs_initcall
