Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaCQQYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:24:12 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:49320 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaCQQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:24:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUFoKrhKfHqE6cq=R54Uo5GyL1u=GZnBZAGZ+JJ-fR+fg@mail.gmail.com>
References: <20140311174555.23257.66798.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140311174809.23257.77363.stgit@bhelgaas-glaptop.roam.corp.google.com> <CAE9FiQUFoKrhKfHqE6cq=R54Uo5GyL1u=GZnBZAGZ+JJ-fR+fg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Mar 2014 10:23:48 -0600
Message-ID: <CAErSpo62pKkJeWrPC3Jp5Ppgwu2fmtf2gsPpsn0KNy1M0iMqSg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Do not enable INTx in pci_reenable_device()
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Cheng <chris.cheng@atrustcorp.com>,
        Jamie Chen <jamie.chen@intel.com>,
        Andreas Noever <andreas.noever@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 6:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Mar 11, 2014 at 10:48 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> Andreas reported that after 1f42db786b14 ("PCI: Enable INTx if BIOS left
>> them disabled"), pciehp surprise removal stopped working.
>>
>> This happens because pci_reenable_device() on the hotplug bridge (used in
>> the pciehp_configure_device() path) clears the Interrupt Disable bit, which
>> apparently breaks the bridge's MSI hotplug event reporting.
>>
>> Previously we cleared the Interrupt Disable bit in do_pci_enable_device(),
>> which is used by both pci_enable_device() and pci_reenable_device().  But
>> we use pci_reenable_device() after the driver may have enabled MSI or
>> MSI-X, and we *set* Interrupt Disable as part of enabling MSI/MSI-X.
>>
>> This patch clears Interrupt Disable only when MSI/MSI-X has not been
>> enabled.
>>
>> Fixes: 1f42db786b14 PCI: Enable INTx if BIOS left them disabled
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=71691
>> Reported-and-tested-by: Andreas Noever <andreas.noever@gmail.com>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>> CC: stable@vger.kernel.org
>> CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>> ---
>>  drivers/pci/pci.c |    3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index 8dc3e701ec57..79fc89c6c3f3 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -1192,6 +1192,9 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
>>                 return err;
>>         pci_fixup_device(pci_fixup_enable, dev);
>>
>> +       if (dev->msi_enabled || dev->msix_enabled)
>> +               return 0;
>> +
>>         pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
>>         if (pin) {
>>                 pci_read_config_word(dev, PCI_COMMAND, &cmd);
>
> looks ugly.
>
> We really should move out those irq handling out of pci_enable_device.

OK, I'll watch for your patch.

Bjorn
