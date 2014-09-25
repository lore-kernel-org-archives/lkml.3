Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaIYT7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:59:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50422 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIYT7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:59:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXuJZnj74dwTbKJCQNJ+OdEbjSB0fpwqh92+WZ_XGnrxQ@mail.gmail.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com>
 <1411498874-9864-7-git-send-email-Liviu.Dudau@arm.com> <CAE9FiQXuJZnj74dwTbKJCQNJ+OdEbjSB0fpwqh92+WZ_XGnrxQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 25 Sep 2014 13:59:26 -0600
Message-ID: <CAErSpo6eUEV81n1rFjjvRcFVmsFkeUxhdL6JauTmx_Et6XdBuQ@mail.gmail.com>
Subject: Re: [PATCH v12 06/12] PCI: Create pci_host_bridge before its
 associated bus in pci_create_root_bus.
To: Yinghai Lu <yinghai@kernel.org>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
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
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 12:15 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Sep 23, 2014 at 12:01 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
>> As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
>> the creation order has been changed for no good reason. Revert the order of
>> creation as we are going to depend on the pci_host_bridge structure to retrieve the
>> domain number of the root bus.
>>
>> Cc: Bjorn Helgaas <bhelgaas@google.com>
>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
>> Acked-by: Grant Likely <grant.likely@linaro.org>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Tested-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>>  drivers/pci/probe.c | 32 +++++++++++++++++---------------
>>  1 file changed, 17 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
>> index e3cf8a2..5ff72ec 100644
>> --- a/drivers/pci/probe.c
>> +++ b/drivers/pci/probe.c
>> @@ -515,7 +515,7 @@ static void pci_release_host_bridge_dev(struct device *dev)
>>         kfree(bridge);
>>  }
>>
>> -static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
>> +static struct pci_host_bridge *pci_alloc_host_bridge(void)
>>  {
>>         struct pci_host_bridge *bridge;
>>
>> @@ -524,7 +524,8 @@ static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
>>                 return NULL;
>>
>>         INIT_LIST_HEAD(&bridge->windows);
>> -       bridge->bus = b;
>> +       bridge->dev.release = pci_release_host_bridge_dev;
>> +
>>         return bridge;
>>  }
>>
>> @@ -1761,9 +1762,15 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>>         char bus_addr[64];
>>         char *fmt;
>>
>> +       bridge = pci_alloc_host_bridge();
>> +       if (!bridge)
>> +               return NULL;
>> +
>> +       bridge->dev.parent = parent;
>> +
>>         b = pci_alloc_bus();
>>         if (!b)
>> -               return NULL;
>> +               goto err_out;
>>
>>         b->sysdata = sysdata;
>>         b->ops = ops;
>> @@ -1772,26 +1779,19 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>>         if (b2) {
>>                 /* If we already got to this bus through a different bridge, ignore it */
>>                 dev_dbg(&b2->dev, "bus already known\n");
>> -               goto err_out;
>> +               goto err_bus_out;
>>         }
>>
>> -       bridge = pci_alloc_host_bridge(b);
>> -       if (!bridge)
>> -               goto err_out;
>> -
>> -       bridge->dev.parent = parent;
>> -       bridge->dev.release = pci_release_host_bridge_dev;
>> +       bridge->bus = b;
>>         dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
>>         error = pcibios_root_bridge_prepare(bridge);
>> -       if (error) {
>> -               kfree(bridge);
>> +       if (error)
>>                 goto err_out;
>> -       }
>>
>>         error = device_register(&bridge->dev);
>>         if (error) {
>>                 put_device(&bridge->dev);
>> -               goto err_out;
>> +               goto err_bus_out;
>>         }
>>         b->bridge = get_device(&bridge->dev);
>>         device_enable_async_suspend(b->bridge);
>> @@ -1848,8 +1848,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>>  class_dev_reg_err:
>>         put_device(&bridge->dev);
>>         device_unregister(&bridge->dev);
>> -err_out:
>> +err_bus_out:
>>         kfree(b);
>> +err_out:
>> +       kfree(bridge);
>>         return NULL;
>>  }
>
> Hi Bjorn,
>
> Noticed that you put this one into pci/next.
>
> This patch has problem for the class_dev_reg_err path.
> as device_unregister(&bridge->dev) will trigger pci_release_host_bridge_dev.
> So will have double free for bridge or else.
>
> Please drop this patch from pci/next.
>
> Also looks strange that the patch have long CC list, but just omit me
> and Jiang Liu that
> touched those code before.

Thanks for noticing that.  I was concerned, but couldn't remember the details.

I dropped this patch and the subsequent ones from pci/host and rebased
my "next" branch.

Sorry I didn't notice you weren't on the CC list.

Bjorn
