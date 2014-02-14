Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaBNVkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:40:11 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44794 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaBNVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:40:09 -0500
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <CAErSpo4YwCaS+zc50L8PMO5nx9XscEua7nHXqM3eR3XzG4TtJQ@mail.gmail.com>
References: <52FE89FF.4020700@gmail.com>
	<CAErSpo4YwCaS+zc50L8PMO5nx9XscEua7nHXqM3eR3XzG4TtJQ@mail.gmail.com>
Date: Fri, 14 Feb 2014 13:40:08 -0800
Message-ID: <CAA93t1oWguvHkSuUqgBSjV7tgrvU2wgfBrnpRUZ_U7rqED6cUQ@mail.gmail.com>
Subject: Re: [PATCH] pciehp: Display the link state change reporting capability
From: Rajat Jain <rajatxjain@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

On Fri, Feb 14, 2014 at 1:35 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Feb 14, 2014 at 2:26 PM, Rajat Jain <rajatxjain@gmail.com> wrote:
>> With recent addition of Link state change based hot-plug, it makes
>> sense to display this capability in dbg_ctrl() addition to others.
>>
>> (Also move the call to dbg_ctrl() further down untill after the value
>> is populated in ctrl->link_active_reporting)
>>
>> Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
>> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
>> Signed-off-by: Guenter Roeck <groeck@juniper.net>
>
> This is fine as it is, but I'd like to get rid of dbg_ctrl()
> altogether someday.  I made pcie_init() more verbose with afe2478f2e3f
> ("PCI: pciehp: Announce slot capabilities (slot #, button, LEDs,
> etc)"), and it does include the PCI_EXP_LNKCAP_DLLLARC info.
>
> Is there anything important left in dbg_ctrl() that we don't already
> print elsewhere?  The PCI core prints the vendor/device and BAR info.
> Of course, we don't print the entire capabilities/status/control words
> anywhere else.  Is that important?

No, there doesn't seem a good use for it today. It all changes a short
while after it gets printed anyway.


>
>> ---
>>  drivers/pci/hotplug/pciehp_hpc.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
>> index da4b020..cbe8e924 100644
>> --- a/drivers/pci/hotplug/pciehp_hpc.c
>> +++ b/drivers/pci/hotplug/pciehp_hpc.c
>> @@ -747,6 +747,8 @@ static inline void dbg_ctrl(struct controller *ctrl)
>>                   EMI(ctrl)        ? "yes" : "no");
>>         ctrl_info(ctrl, "  Command Completed    : %3s\n",
>>                   NO_CMD_CMPL(ctrl) ? "no" : "yes");
>> +       ctrl_info(ctrl, "  Link Change Reporting: %3s\n",
>> +                 ctrl->link_active_reporting ? "yes" : "no");
>>         pcie_capability_read_word(pdev, PCI_EXP_SLTSTA, &reg16);
>>         ctrl_info(ctrl, "Slot Status            : 0x%04x\n", reg16);
>>         pcie_capability_read_word(pdev, PCI_EXP_SLTCTL, &reg16);
>> @@ -771,7 +773,6 @@ struct controller *pcie_init(struct pcie_device *dev)
>>         ctrl->slot_cap = slot_cap;
>>         mutex_init(&ctrl->ctrl_lock);
>>         init_waitqueue_head(&ctrl->queue);
>> -       dbg_ctrl(ctrl);
>>         /*
>>          * Controller doesn't notify of command completion if the "No
>>          * Command Completed Support" bit is set in Slot Capability
>> @@ -784,10 +785,9 @@ struct controller *pcie_init(struct pcie_device *dev)
>>
>>          /* Check if Data Link Layer Link Active Reporting is implemented */
>>          pcie_capability_read_dword(pdev, PCI_EXP_LNKCAP, &link_cap);
>> -        if (link_cap & PCI_EXP_LNKCAP_DLLLARC) {
>> -                ctrl_dbg(ctrl, "Link Active Reporting supported\n");
>> +       if (link_cap & PCI_EXP_LNKCAP_DLLLARC)
>>                  ctrl->link_active_reporting = 1;
>> -        }
>> +       dbg_ctrl(ctrl);
>>
>>         /* Clear all remaining event bits in Slot Status register */
>>         pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
>> --
>> 1.7.9.5
>>
