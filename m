Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3EUQ1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:27:09 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:38385 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab3EUQ1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:27:07 -0400
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <CF6E51640088844D9CADE5541A7C2FEB33EBE413@CMEXMB1.ad.emulex.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <20130520224824.GA31740@google.com> <CF6E51640088844D9CADE5541A7C2FEB33EBE413@CMEXMB1.ad.emulex.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Tue, 21 May 2013 11:26:46 -0500
Message-ID: <CAHrUA36VUZc6y4seefV=zUY4_Sup4DxwenC3bSokuxS2idoROw@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: "Liu, Joseph" <Joseph.Liu@emulex.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Zhang, LongX" <longx.zhang@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang, Bjorn,

On 21 May 2013 10:41, Liu, Joseph <Joseph.Liu@emulex.com> wrote:
> Bjorn,
>
>>> diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>>> index ed4d094..7abefd9 100644
>>> --- a/drivers/pci/pcie/portdrv_pci.c
>>> +++ b/drivers/pci/pcie/portdrv_pci.c
>>> @@ -332,13 +332,11 @@ static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
>>>      pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
>>>      int retval;
>>>
>>> -    /* If fatal, restore cfg space for possible link reset at upstream */
>>> -    if (dev->error_state == pci_channel_io_frozen) {
>>> -            dev->state_saved = true;
>>> -            pci_restore_state(dev);
>>> -            pcie_portdrv_restore_config(dev);
>>> -            pci_enable_pcie_error_reporting(dev);
>>> -    }
>>> +    /* restore cfg space for possible link reset at upstream */
>>> +    dev->state_saved = true;
>>> +    pci_restore_state(dev);
>>> +    pcie_portdrv_restore_config(dev);
>>> +    pci_enable_pcie_error_reporting(dev);
>>>
>>>      /* get true return value from &status */
>>>      retval = device_for_each_child(&dev->dev, &status, slot_reset_iter);
>>
>>I think this patch changes the behavior in the case of a non-fatal error
>>where one of the .error_detected() methods returned
>>PCI_ERS_RESULT_NEED_RESET.  In that case, pcie_portdrv_slot_reset()
>>previously did not restore config space, but after your patch, it *will*
>>restore it.  We need an explanation of why this is safe.
>
> Here is my understanding of this part of the patch:
>
> I think your concern here should not be an issue. Whether it is a non-fatal error or a fatal error, as long as one of the .error_detected() method from the downstream drivers involved returns a PCI_ERS_RESULT_NEED_RESET, it should trump all others and a slot reset should be performed, even though it was originally due to a non-fatal error reported or only one of the downstream drivers requests it. In the case of AER driver, this should be implemented in the broadcast_error_message() with pci_walk_bus() by passing in the report_error_detected() function, and merging the results into the result_data->result...
>
> In any case, the fact that this pcie_portdrv_slot_reset() being invoked should be considered as a aftermath of a slot reset has been performed, thus the restore of config space should be performed after the reset. I suppose the restore should be to the same state as fresh power-on states, right?


Again, I think Joe has it exactly right.   The patch, I'm not so sure.
 In my earlier emails, I was assuming that the device has just gotten
either a hard reset (power has been turned off-n-on, e.g. using
pci-hotplug, or a 'soft reset' (whatever that means :-)).   If the
adapter has been reset, then it is appropriate to restore pci config
space to something resembling a fresh power-on.

If the adapter has NOT been reset, then, ummm .. changing
('restoring') the config space would be wrong ... if I recall
correctly, a pci link reset does not whack the config space, and if
the device itself has not been whacked, then all the contents of the
config space (dma mappings, etc) are all still valid, and should not
be changed!

So, the restore of the config space should be conditional, depending
on whether the device has been reset or not.

-- Linas
