Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab3C2TKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:10:38 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:65241 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756340Ab3C2TKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:10:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo63+8FZft7UH4jj78D9gvdW2XnU+-4YMFLKuCi+Zi9=uw@mail.gmail.com>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
	<1364444885-19751-2-git-send-email-yinghai@kernel.org>
	<CAErSpo63+8FZft7UH4jj78D9gvdW2XnU+-4YMFLKuCi+Zi9=uw@mail.gmail.com>
Date: Fri, 29 Mar 2013 12:10:37 -0700
X-Google-Sender-Auth: sRV5DExLeKlKzoKPEDeqQ3X6PTk
Message-ID: <CAE9FiQU0CdAp8rtaGBh3W1nGsfUsSQGEjyV8PqPoEZQVLLb9bA@mail.gmail.com>
Subject: Re: [PATCH 1/2] eisa, PCI: Fix bus res reference
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Whitehead <mwhitehe@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 11:10 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Mar 27, 2013 at 10:28 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>> Matthem found that 3.8.3 is having problems with an old (ancient)
>> PCI-to-EISA bridge, the Intel 82375. It worked with the 3.2 kernel.
>> He identified the 82375, but doesn't assign the struct resource *res
>> pointer inside the struct eisa_root_device, and panics.
>>
>> After looking at pci_eisa_init(), found it referring bus resource
>> directly instead of pci_bus_resource_n().
>>
>> After commit 45ca9e97 (PCI: add helpers for building PCI bus resource lists)
>> and commit 0efd5aab (PCI: add struct pci_host_bridge_window with CPU/bus
>> address offset), bus->resource[] is not used for pci root bus any more.
>>
>> Fix it by using pci_bus_resource_n() and correct idx for root bus.
>>
>> Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
>> Tested-by: Matthew Whitehead <mwhitehe@redhat.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>> Cc: stable@kernel.org
>>
>> ---
>>  drivers/eisa/pci_eisa.c |   10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> Index: linux-2.6/drivers/eisa/pci_eisa.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/eisa/pci_eisa.c
>> +++ linux-2.6/drivers/eisa/pci_eisa.c
>> @@ -22,7 +22,8 @@ static struct eisa_root_device pci_eisa_
>>  static int __init pci_eisa_init(struct pci_dev *pdev,
>>                                 const struct pci_device_id *ent)
>>  {
>> -       int rc;
>> +       int rc, n = 0;
>> +       struct resource *bus_res;
>>
>>         if ((rc = pci_enable_device (pdev))) {
>>                 printk (KERN_ERR "pci_eisa : Could not enable device %s\n",
>> @@ -30,9 +31,12 @@ static int __init pci_eisa_init(struct p
>>                 return rc;
>>         }
>>
>> +       if (pci_is_root_bus(pdev->bus))
>> +               n = PCI_BRIDGE_RESOURCE_NUM;
>> +       bus_res = pci_bus_resource_n(pdev->bus, n);
>
> I haven't figured out why the pci_is_root_bus() test is here.  Can you
> explain, maybe with a sample dmesg log and "lspci -vvx" output?

Just forwarded two boot.log.

for  root bus, pci_bus_resource_n[0, PCI_BRIDGE_RESOURCE_NUM) all
equal to 0.

>
> Doesn't the 82375 subtractively decode this PCI memory space, the same
> way a subtractive-decode P2P bridge does?  Can we  make this code look
> like the "if (dev->transparent)" block in pci_read_bridge_bases(),
> just breaking after the first resource we find, since
> eisa_root_register() can only deal with a single resource on the EISA
> bus?

they are using extra resource in pci_eisa_root.eisa_root_res to prevent multiple
registering between pci_eisa and virtual platform.

and later eisa resource does get registered under system root ioport resource.
