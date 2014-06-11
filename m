Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaFKVQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 17:16:05 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:54673 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaFKVQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 17:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <1402196538.23860.24.camel@deadeye.wl.decadent.org.uk>
References: <20140604232347.966798903@linuxfoundation.org> <20140604232354.004988520@linuxfoundation.org>
 <1402196538.23860.24.camel@deadeye.wl.decadent.org.uk>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 11 Jun 2014 15:15:41 -0600
Message-ID: <CAErSpo6UcObn6HVKpw82Ncfgr64w2Ws120P2WfSLqAqaROsDTw@mail.gmail.com>
Subject: Re: [PATCH 3.14 186/228] PCI: Wrong register used to check pending traffic
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Gavin Shan <gwshan@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Alex Williamson <alex.williamson@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2014 at 9:02 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Wed, 2014-06-04 at 16:23 -0700, Greg Kroah-Hartman wrote:
>> 3.14-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Gavin Shan <gwshan@linux.vnet.ibm.com>
>>
>> commit d0b4cc4e32705ff00d90d32da7783c266c702c04 upstream.
>>
>> The incorrect register offset is passed to pci_wait_for_pending(), which is
>> caused by commit 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor
>> pci_wait_for_pending_transaction())").
>>
>> Fixes: 157e876ffe ("PCI: Add pci_wait_for_pending() (refactor pci_wait_for_pending_transaction())
>> Signed-off-by: Gavin Shan <gwshan@linux.vnet.ibm.com>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> Acked-by: Alex Williamson <alex.williamson@gmail.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> ---
>>  drivers/pci/pci.c |    5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -3043,7 +3043,8 @@ int pci_wait_for_pending_transaction(str
>>       if (!pci_is_pcie(dev))
>>               return 1;
>>
>> -     return pci_wait_for_pending(dev, PCI_EXP_DEVSTA, PCI_EXP_DEVSTA_TRPND);
>> +     return pci_wait_for_pending(dev, pci_pcie_cap(dev) + PCI_EXP_DEVSTA,
>> +                                 PCI_EXP_DEVSTA_TRPND);
>>  }
>>  EXPORT_SYMBOL(pci_wait_for_pending_transaction);
>>
>> @@ -3085,7 +3086,7 @@ static int pci_af_flr(struct pci_dev *de
>>               return 0;
>>
>>       /* Wait for Transaction Pending bit clean */
>> -     if (pci_wait_for_pending(dev, PCI_AF_STATUS, PCI_AF_STATUS_TP))
>> +     if (pci_wait_for_pending(dev, pos + PCI_AF_STATUS, PCI_AF_STATUS_TP))
>>               goto clear;
>>
>>       dev_err(&dev->dev, "transaction is not cleared; "
>
> This still seems to be broken because pci_wait_for_pending() does
> pci_read_config_word() but PCI_AF_STATUS is not word-aligned.

I agree; this does seem broken.  I think pci_read_config_word() will
return PCIBIOS_BAD_REGISTER_NUMBER without updating the value
returned, so I think we'll test garbage from the stack.

What do you think, Alex?

Bjorn
