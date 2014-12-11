Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbaLKU1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:27:11 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:61198 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755AbaLKU1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:27:08 -0500
MIME-Version: 1.0
In-Reply-To: <20141211163831.GA2845@svl-evodev-groeck.juniper.net>
References: <546E7120.5080505@gmail.com> <20141211002630.GC22886@google.com> <20141211163831.GA2845@svl-evodev-groeck.juniper.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 11 Dec 2014 13:26:47 -0700
Message-ID: <CAErSpo62wQ6g74wNYYumgbAVJ3Mneu_dmWOhLBE6NWqQTXsvVQ@mail.gmail.com>
Subject: Re: [PATCH v2] PCI: pciehp: Check link state before accessing device
 during removal
To: Guenter Roeck <groeck@juniper.net>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 9:38 AM, Guenter Roeck <groeck@juniper.net> wrote:
> On Wed, Dec 10, 2014 at 05:26:30PM -0700, Bjorn Helgaas wrote:
>> On Thu, Nov 20, 2014 at 02:54:24PM -0800, Rajat Jain wrote:
>> > While removing a card, we can't assume the presence to mean that the
>> > access to card is OK. That is because the cause of removal may be a
>> > link down event, and the card may still be physically present. Thus,
>> > instead of presence, use the link state to decide whether or not it is
>> > OK to access the card devices.
>> >
>> > Here are the problem symptoms:
>> > During the removal of a card due to link down, sometimes the following
>> > error is seen (because pciehp_unconfigure_device() reads 0xFF from
>> > bridge control register as the link is down, which cause it to assume
>> > that the VGA bit is set):
>> >
>> > pciehp 0000:21:05.0:pcie24: pcie_isr: intr_loc 100
>> > pciehp 0000:21:05.0:pcie24: Data Link Layer State change
>> > pciehp 0000:21:05.0:pcie24: slot(5): Link Down event
>> > pciehp 0000:21:05.0:pcie24: Disabling domain:bus:device=0000:60:00
>> > pciehp 0000:21:05.0:pcie24: pciehp_unconfigure_device: domain:bus:dev = 0000:60:00
>> > pciehp 0000:21:05.0:pcie24: Cannot remove display device 0000:60:00.0
>> >
>> > Ofcourse, when the link comes back up, the device addition fails too:
>> >
>> > pciehp 0000:21:05.0:pcie24: pcie_isr: intr_loc 100
>> > pciehp 0000:21:05.0:pcie24: Data Link Layer State change
>> > pciehp 0000:21:05.0:pcie24: pciehp_check_link_active: lnk_status = 6011
>> > pciehp 0000:21:05.0:pcie24: slot(5): Link Up event
>> > pciehp 0000:21:05.0:pcie24: Enabling domain:bus:device=0000:60:00
>> > pciehp 0000:21:05.0:pcie24: pciehp_check_link_active: lnk_status = 6011
>> > pciehp 0000:21:05.0:pcie24: pciehp_check_link_status: lnk_status = 6011
>> > pciehp 0000:21:05.0:pcie24: Device 0000:60:00.0 already exists at 0000:60:00, cannot hot-add
>> > pciehp 0000:21:05.0:pcie24: Cannot add device at 0000:60:00
>> >
>> > The problem is not seen with this patch applied. The device removal and
>> > insertion works as expected.
>> >
>> > Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
>> > Signed-off-by: Rajat Jain <rajatjain@juniper.net>
>> > Signed-off-by: Guenter Roeck <groeck@juniper.net>
>> > ---
>> > v2: Use the already initialized "ctrl" instead of "p_slot->ctrl"
>> >
>> >  drivers/pci/hotplug/pciehp_pci.c |    8 ++++----
>> >  1 file changed, 4 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
>> > index 9e69403..911f85b 100644
>> > --- a/drivers/pci/hotplug/pciehp_pci.c
>> > +++ b/drivers/pci/hotplug/pciehp_pci.c
>> > @@ -77,7 +77,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
>> >  {
>> >     int rc = 0;
>> >     u8 bctl = 0;
>> > -   u8 presence = 0;
>> > +   bool link_active = false;
>> >     struct pci_dev *dev, *temp;
>> >     struct pci_bus *parent = p_slot->ctrl->pcie->port->subordinate;
>> >     u16 command;
>> > @@ -85,7 +85,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
>> >
>> >     ctrl_dbg(ctrl, "%s: domain:bus:dev = %04x:%02x:00\n",
>> >              __func__, pci_domain_nr(parent), parent->number);
>> > -   pciehp_get_adapter_status(p_slot, &presence);
>> > +   link_active = pciehp_check_link_active(ctrl);
>> >
>> >     pci_lock_rescan_remove();
>> >
>> > @@ -98,7 +98,7 @@ int pciehp_unconfigure_device(struct slot *p_slot)
>> >     list_for_each_entry_safe_reverse(dev, temp, &parent->devices,
>> >                                      bus_list) {
>> >             pci_dev_get(dev);
>> > -           if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE && presence) {
>> > +           if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE && link_active) {
>> >                     pci_read_config_byte(dev, PCI_BRIDGE_CONTROL, &bctl);
>> >                     if (bctl & PCI_BRIDGE_CTL_VGA) {
>> >                             ctrl_err(ctrl,
>>
>> Why do we even have this code to check for VGA devices?  I looked (briefly)
>> and couldn't find anything in the spec that prohibits removal of VGA
>> devices.
>>
> For my part I don't know. I only know that I had to integrate the patch into
> our images since I hit the problem repeatedly. Usually I wait with integrating
> Rajat's patches until you accept them, but this one was too disruptive.
>
> I would argue that while the patch may not be perfect, at least it improves
> the situation substantially.

I don't think removing the VGA checks is the way to fix the problem
you're seeing.  But I do want to investigate this code since we're in
the area.

>> If we do need it (and it looks like most or all hotplug drivers copied it),
>> isn't there still a race?  Can't we have the following sequence?
>>
>>   - pciehp_check_link_active()                # returns true
>>   - Link goes down
>>   - pci_read_config_byte()            # fails because link is down
>>
> I would guess so. Question is how to address it. Read the configuration byte
> first, then check if the link is down ? Check if link is still up after reading
> the configuration byte ? Add a note that there may be a potential race condition
> and do nothing until it is actually seen ?

I think we should just read PCI_BRIDGE_CONTROL and look for a 0xff
value.  That's not a legal value for the register, so if we see it, it
should be pretty safe to assume the link is down or the device is not
present at all.

Bjorn
