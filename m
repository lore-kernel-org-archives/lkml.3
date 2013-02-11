Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab3BKTCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 14:02:03 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:55236 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758268Ab3BKTB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 14:01:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAMVG2svM+j8_sfWdSY+JVRspxDucp8aKRhLR+79wcM-V_DnbCg@mail.gmail.com>
References: <CAMVG2svG21yiM1wkH4_2pen2n+cr2-Zv7TbH3Gj+8MwevZjDbw@mail.gmail.com>
 <CAMVG2svM+j8_sfWdSY+JVRspxDucp8aKRhLR+79wcM-V_DnbCg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 11 Feb 2013 12:01:37 -0700
Message-ID: <CAErSpo6rGYLQeP8Myu=octSPY_0R+B7ptBLhLawd_A2E3NRsAw@mail.gmail.com>
Subject: Re: [3.8-rc7] PCI hotplug wakeup oops
To: Daniel J Blueman <daniel@quora.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Rafael]

On Mon, Feb 11, 2013 at 10:08 AM, Daniel J Blueman <daniel@quora.org> wrote:
> On 11 February 2013 21:03, Daniel J Blueman <daniel@quora.org> wrote:
>> With 3.8-rc7, when unplugging the Thunderbolt ethernet adapter (bus 0a
>> [1]) on a Macbook Pro 10,1, we see the PCIe port correctly released:
>>
>> pciehp 0000:06:03.0:pcie24: Card not present on Slot(3)
>> tg3 0000:0a:00.0: tg3_abort_hw timed out, TX_MODE_ENABLE will not
>> clear MAC_TX_MODE=ffffffff
>> tg3 0000:0a:00.0 eth0: No firmware running
>> tg3 0000:0a:00.0 eth0: Link is down
>> [sched_delayed] sched: RT throttling activated
>> pcieport 0000:00:01.1: System wakeup enabled by ACPI
>> pciehp 0000:09:00.0:pcie24: unloading service driver pciehp
>> pci_bus 0000:0a: busn_res: [bus 0a] is released
>> pci_bus 0000:09: busn_res: [bus 09-0a] is released
>>
>> After some activity later (eg I can reproduce this by switching to a
>> text console and back), often we'll see an oops:
>>
>> Unable to handle kernel paging request at 0000000000001070
>> pci_pme_list_scan+0x3d/0xe0
>> Call Trace:
>> process_one_work+0x193
>> ? process_one_work+0x131
>> ? pci_pme_wakeup+0x60
>> worker_thread+0x15d
>>
>> (gdb) list *(pci_pme_list_scan+0x3d)
>> 0xffffffff8123f6dd is in pci_pme_list_scan (drivers/pci/pci.c:1556).
>> 1551                                    /*
>> 1552                                     * If bridge is in low power state, the
>> 1553                                     * configuration space of subordinate devices
>> 1554                                     * may be not accessible
>> 1555                                     */
>> 1556                                    if (bridge && bridge->current_state != PCI_D0)
>> 1557                                            continue;
>> 1558                                    pci_pme_wakeup(pme_dev->dev, NULL);
>> 1559                            } else {
>> 1560                                    list_del(&pme_dev->list);
>>
>> Since a panic in vsnprintf happens after the oops (hence I can't catch
>> it with EFI pstore), it is almost certainly significant heap
>> corruption; this would explain why pme_dev became null (the load has
>> been ordered ahead).
>>
>> I'll see what I can find out with memory poisoning and list debugging.
>
> Enabling a bunch of related debugging, we see pme_dev is non-null and:
>
> BUG: Unable to handle NULL pointer dereference at
> pci_bus_read_config_word+0x6c
> PGD 26314c067 PUD 2633f9067 PMD 0
> Oops: 0000 [#1] SMP
> pci_check_pme_status+0x4f
> pci_pme_wakeup+0x21
> pci_pme_list_scan+0xd5
> process_one_work+0x1ca
> ? process_one_work+0x160
> ? pci_pme_wakeup+0x60
> worker_thread+0x14e
>
> Anyway, it looks like the device being unplugged wasn't removed from
> pci_pme_list as pci_pme_active(dev, false) wasn't called.
>
> From a quick review, I wasn't able to find the right place in the
> call-chain which I only see releases the child busses and PCIe port
> drivers. Anyone?

It looks like drivers *add* devices to pci_pme_list when they use
pci_enable_wake() or pci_wake_from_d3().  But many drivers never
remove their devices, and I don't see any place where the core does it
either.  My guess is we need to remove it in pci_stop_dev() (we
already do pcie_aspm_exit_link_state() there) or somewhere similar.

Bjorn
