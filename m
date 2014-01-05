Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbaAERxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:53:09 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56234 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaAERxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:53:07 -0500
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <20131218010207.GC15119@google.com>
References: <52B0AEAD.6050604@gmail.com>
	<20131218010207.GC15119@google.com>
Date: Sun, 5 Jan 2014 09:53:05 -0800
Message-ID: <CAA93t1qh2Wn2uPKUGvbqrOJxDfqAqTNFSqOryC36Wm=gnygUog@mail.gmail.com>
Subject: Re: [PATCH v3 4/8] pciehp: Don't disable the link permanently, during removal
From: Rajat Jain <rajatxjain@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatjain.linux@gmail.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
        Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        yinghai@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

Just checking on the fate of this patch set...

On Tue, Dec 17, 2013 at 5:02 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc yinghai@kernel.org (seems to be Yinghai's preferred email]
>
> On Tue, Dec 17, 2013 at 12:06:05PM -0800, Rajat Jain wrote:
>> We need future link up events for hot-add, thus don't disable
>> the link permanently during device removal. Also, remove the static
>> functions that are now left unused.
>
> The changelog should mention that this reverts part of 2debd9289997 ("PCI:
> pciehp: Disable/enable link during slot power off/on").

Sure. Do you want me to submit another patch set (bumping up the
version) with this change log, or you'd want to add this change log
while merging?

>
> Yinghai, can you tell us whether this is an issue on your systems?

As Yinghai confirms further down this thread, his issue was confirmed
by Intel to be a bug in the repeater chip.
----------------------------------
Yinghai writes:
> According to HW guys and Intel, that should be bug of repeater.
>
---------------------------------
 I don't know about the details of his scenario, except that when the
adapter was disabled the repeater kept on flapping the link up & down
(and hence disabling the link solved the problem then). Yinghai
couldn't test, but I believe with this patch even if we disable
presence detect interrupt, the "adapter present / no present" messages
would (rightly) convert to "Link Up / Link Down" messages (since the
repeater keeps on flapping the link).

Since it is a platform specific bug, I'm not sure what can be done to
remove those messages except may be reduce the verbosity? If you'd
like I could change all the INFO messages to DBG messages.

Please let me know how to proceed further on this. Also, did you get a
chance to look at the subsequent patches of this patch set, I was
wondering if you had any comments there?

Thanks,

Rajat

>
>> Signed-off-by: Rajat Jain <rajatjain@juniper.net>
>> Signed-off-by: Guenter Roeck <groeck@juniper.net>
>> ---
>> v3: no change, created by splitting the patch v2 [2/4]
>> v2: (non existent)
>> v1: (non existent)
>>
>>  drivers/pci/hotplug/pciehp_hpc.c |   18 ------------------
>>  1 file changed, 18 deletions(-)
>>
>> diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
>> index b45b568..ab12555 100644
>> --- a/drivers/pci/hotplug/pciehp_hpc.c
>> +++ b/drivers/pci/hotplug/pciehp_hpc.c
>> @@ -278,11 +278,6 @@ static void pcie_wait_link_active(struct controller *ctrl)
>>       __pcie_wait_link_active(ctrl, true);
>>  }
>>
>> -static void pcie_wait_link_not_active(struct controller *ctrl)
>> -{
>> -     __pcie_wait_link_active(ctrl, false);
>> -}
>> -
>>  static bool pci_bus_check_dev(struct pci_bus *bus, int devfn)
>>  {
>>       u32 l;
>> @@ -383,11 +378,6 @@ static int pciehp_link_enable(struct controller *ctrl)
>>       return __pciehp_link_set(ctrl, true);
>>  }
>>
>> -static int pciehp_link_disable(struct controller *ctrl)
>> -{
>> -     return __pciehp_link_set(ctrl, false);
>> -}
>> -
>>  int pciehp_get_attention_status(struct slot *slot, u8 *status)
>>  {
>>       struct controller *ctrl = slot->ctrl;
>> @@ -620,14 +610,6 @@ int pciehp_power_off_slot(struct slot * slot)
>>       u16 cmd_mask;
>>       int retval;
>>
>> -     /* Disable the link at first */
>> -     pciehp_link_disable(ctrl);
>> -     /* wait the link is down */
>> -     if (ctrl->link_active_reporting)
>> -             pcie_wait_link_not_active(ctrl);
>> -     else
>> -             msleep(1000);
>> ->>       slot_cmd = POWER_OFF;
>>       cmd_mask = PCI_EXP_SLTCTL_PCC;
>>       retval = pcie_write_cmd(ctrl, slot_cmd, cmd_mask);
>> --
>> 1.7.9.5
>>
