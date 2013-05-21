Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab3EUQwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:52:14 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:64955 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3EUQwM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <CF6E51640088844D9CADE5541A7C2FEB33EBE413@CMEXMB1.ad.emulex.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <20130520224824.GA31740@google.com> <CF6E51640088844D9CADE5541A7C2FEB33EBE413@CMEXMB1.ad.emulex.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 21 May 2013 10:51:51 -0600
Message-ID: <CAErSpo4kvEkUtYFXnoE8yDnHsUD8Z6EUrKaXaJ=yy4yMcJ0veA@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: "Liu, Joseph" <Joseph.Liu@emulex.com>
Cc: "Zhang, LongX" <longx.zhang@intel.com>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 9:41 AM, Liu, Joseph <Joseph.Liu@emulex.com> wrote:
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

Yes, I understand all this.  (Though as I pointed out, the current AER
code does not actually perform a reset based on
PCI_ERS_RESULT_NEED_RESET being returned.  The only time we currently
do a reset is for AER_FATAL errors.)

> In any case, the fact that this pcie_portdrv_slot_reset() being invoked should be considered as a aftermath of a slot reset has been performed, thus the restore of config space should be performed after the reset.

The intention has always been that .slot_reset() would be called to
inform the driver that a reset has been performed.  That was the case
even when Yanmin added pcie_portdrv_slot_reset() with commit
4bf3392e0.  Yet in that commit, pcie_portdrv_slot_reset() only does
the restore when the channel is frozen, i.e., when we're handling an
AER_FATAL error.

So far, I haven't seen any explanation of what changed to make us want
to do the restore always, even for non-fatal errors.  Maybe the
original test for the channel being frozen was just a mistake, but it
would have been much simpler to omit the test to begin with, so
obviously Yanmin thought it was necessary at the time.

Maybe the "error_state == pci_channel_io_frozen" test was a back-door
way to express "we only want to restore state when we've actually done
a reset."  That would sort of make sense, although there's no
documented connection between the frozen state and a device reset, and
no driver should rely on one.

If the idea of "only do a restore after a reset" is still valid, we
don't want to make this change to pcie_portdrv_slot_reset() because it
IS called in some cases when a reset has not been performed, namely
non-fatal errors when an .error_detected() method returns
PCI_ERS_RESULT_NEED_RESET.

> I suppose the restore should be to the same state as fresh power-on states, right?

I *think* that in pcie_portdrv_slot_reset(), we're probably restoring
the state saved by pcie_portdrv_probe(), i.e., the state saved by the
PCIe port driver after it has claimed and initialized the port.  This
is not fresh power-on state; a fresh power-on state would have BARs
and other config registers cleared, and we'd have to assign resources
to the device just like we do to a hot-added device.

Bjorn
