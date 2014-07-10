Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaGJTx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:53:59 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:54543 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaGJTx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.03.1407101241010.4703@AMR>
References: <1403628537-16367-1-git-send-email-keith.busch@intel.com>
 <20140710183840.GA12663@google.com> <alpine.LRH.2.03.1407101241010.4703@AMR>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 10 Jul 2014 13:53:36 -0600
Message-ID: <CAErSpo76yxvWJma=kTMRuhf8wXM9q_Nfb219MhsTtC_CS00OvQ@mail.gmail.com>
Subject: Re: [RFC PATCH] Let device drivers disable msi on shutdown
To: Keith Busch <keith.busch@intel.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 12:53 PM, Keith Busch <keith.busch@intel.com> wrote:
> On Thu, 10 Jul 2014, Bjorn Helgaas wrote:
>>
>> [+cc LKML, Greg KH for driver core async shutdown question]
>> On Tue, Jun 24, 2014 at 10:48:57AM -0600, Keith Busch wrote:
>>>
>>> To provide context why I want to do this asynchronously, NVM-Express has
>>> one PCI device per controller, of which there could be dozens in a
>>> system,
>>> and each one may take many seconds (I've heard over ten in some cases)
>>> to safely shutdown.
>>
>>
>> I don't see anything in device_shutdown() that would wait for this
>> sort of asynchronous shutdown to complete.  So how do we know it's
>> finished before we turn off the power, reset, kexec, etc.?
>>
>> If we need to do asynchronous shutdown, it seems like we need some
>> sort of driver core infrastructure to manage that.
>
>
> Yes, good point! To address that, I did submit this patch:
>
> http://lists.infradead.org/pipermail/linux-nvme/2014-May/000827.html
>
> I need to fix the EXPORT_SYMBOL_GPL usage for a v2, but before that, I
> wan't to know the reason the driver can't use MSIx in an async shutdown
> shutdown, and came to the patch mentioned above.
>
> I'd originally had the async shutdown use legacy interrupts, but I
> know some NVMe devices do not support legacy, so can't use my original
> proposal. If I can't rely on MSI/MSI-x being enabled in an async shutdown,
> then I have to add polling, which I suppose we can live with.

OK, I wasn't aware of your async shutdown patch.  Given that, I would
think we'd want to somehow delay the rest of pci_device_shutdown()
until after the driver's async shutdown completes.  We don't want to
do either the MSI shutdown or the pci_clear_master() until after it
completes, do we?  And if we delay that, there would be no need to
move the MSI shutdown from the core to the driver.

Bjorn
