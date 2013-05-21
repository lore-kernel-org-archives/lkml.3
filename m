Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3EUQRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:17:23 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45873 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3EUQRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <1369122001.4432.14.camel@ymzhang.sh.intel.com>
References: <F7B8FD780A346D46A0042F5C63B06AE785E3B2@SHSMSX102.ccr.corp.intel.com>
 <20130520224824.GA31740@google.com> <1369122001.4432.14.camel@ymzhang.sh.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 21 May 2013 10:17:01 -0600
Message-ID: <CAErSpo5Ysg48TJMVRLZpEWuFy1q-Eu5hTJVhtOST9sEFZJoduA@mail.gmail.com>
Subject: Re: Subject : [ PATCH ] pci-reset-error_state-to-pci_channel_io_normal-at-report_slot_reset
To: "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Cc: "Zhang, LongX" <longx.zhang@intel.com>,
        "linasvepstas@gmail.com" <linasvepstas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Joseph.Liu@Emulex.Com" <Joseph.Liu@emulex.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 1:40 AM, Yanmin Zhang
<yanmin_zhang@linux.intel.com> wrote:
> On Mon, 2013-05-20 at 16:48 -0600, Bjorn Helgaas wrote:
>> On Fri, Apr 26, 2013 at 06:28:59AM +0000, Zhang, LongX wrote:
>> > From: Zhang Long <longx.zhang@intel.com>
>> >
>> > Specific pci device drivers might have many functions to call
>> > pci_channel_offline to check device states. When slot_reset happens,
>> > drivers' slot_reset callback might call such functions and eventually
>> > abort the reset.
>> >
>> > The patch resets pdev->error_state to pci_channel_io_normal at
>> > the begining of report_slot_reset.
>> >
>> > Thank Liu Joseph for pointing it out.
>> >
>> > Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
>> > Signed-off-by: Zhang Long <longx.zhang@intel.com>
>> > ---
>> >  drivers/pci/pcie/aer/aerdrv_core.c |    1 +
>> >  drivers/pci/pcie/portdrv_pci.c     |   12 +++++-------
>> >  2 files changed, 6 insertions(+), 7 deletions(-)
> Thank all for the kind comments.
>
>> >
>> > diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
>> > index 564d97f..c61fd44 100644
>> > --- a/drivers/pci/pcie/aer/aerdrv_core.c
>> > +++ b/drivers/pci/pcie/aer/aerdrv_core.c
>> > @@ -286,6 +286,7 @@ static int report_slot_reset(struct pci_dev *dev, void *data)
>> >     result_data = (struct aer_broadcast_data *) data;
>> >
>> >     device_lock(&dev->dev);
>> > +   dev->error_state = pci_channel_io_normal;
>> >     if (!dev->driver ||
>> >             !dev->driver->err_handler ||
>> >             !dev->driver->err_handler->slot_reset)
>> > diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
>> > index ed4d094..7abefd9 100644
>> > --- a/drivers/pci/pcie/portdrv_pci.c
>> > +++ b/drivers/pci/pcie/portdrv_pci.c
>> > @@ -332,13 +332,11 @@ static pci_ers_result_t pcie_portdrv_slot_reset(struct pci_dev *dev)
>> >     pci_ers_result_t status = PCI_ERS_RESULT_RECOVERED;
>> >     int retval;
>> >
>> > -   /* If fatal, restore cfg space for possible link reset at upstream */
>> > -   if (dev->error_state == pci_channel_io_frozen) {
>> > -           dev->state_saved = true;
>> > -           pci_restore_state(dev);
>> > -           pcie_portdrv_restore_config(dev);
>> > -           pci_enable_pcie_error_reporting(dev);
>> > -   }
>> > +   /* restore cfg space for possible link reset at upstream */
>> > +   dev->state_saved = true;
> It's indeed a dirty trick to change it to true. The reason is suspend. The port would
> suspend/resume at suspend-to-ram. When the port is suspended, PCI power framework calls
> pci_save_state. When the port is resumed, PCI framework calls pci_restore_state and
> dev->state_saved is set to false.

I can read the code as well as you can.  The above does nothing to
explain why dev->saved_config_space is still valid even when
state_saved is false.

But I want to drop this issue because it was there before your patch,
and we're clearly not going to resolve it here.

> A better solution is to add double space in pci_dev->saved_config_space/saved_cap_space,
> which seems consume unnecessary resource.
>
>> > +   pci_restore_state(dev);
>> > +   pcie_portdrv_restore_config(dev);
>> > +   pci_enable_pcie_error_reporting(dev);
>> >
>> >     /* get true return value from &status */
>> >     retval = device_for_each_child(&dev->dev, &status, slot_reset_iter);
>> I think this patch changes the behavior in the case of a non-fatal error
>> where one of the .error_detected() methods returned
>> PCI_ERS_RESULT_NEED_RESET.  In that case, pcie_portdrv_slot_reset()
>> previously did not restore config space, but after your patch, it *will*
>> restore it.  We need an explanation of why this is safe.
> AER standard doesn't define such behavior like if we need reset a slot.
> When we implemented the feature in kernel, we assumed at non-fatal error,
> config space is still good.
>
> With the new patch, we change the behavior a little.
>
>>
>> I think you should split this into two patches: the first would remove the
>> "if (dev->error_state == pci_channel_io_frozen)" test from portdrv_pci.c
> The first patch would depend on the 2nd patch as 2nd patch resets error_state
> to pci_channel_io_normal.

Not true.  The pcie_portdrv_slot_reset() change does not depend on the
report_slot_reset() change.  If the first patch makes
pcie_portdrv_slot_reset() do the restore without even looking at
dev->error_state, there's no dependency on the report_slot_reset()
change.

>> and explain the reason, and the second would make the aerdrv_core.c change.

Bjorn
