Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3I0Ror (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 13:44:47 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:41757 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab3I0Roq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 13:44:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
References: <1380270519.27811.10.camel@pasglop>
	<CAE9FiQVkW7d7vFx_kPJG-FEvO71SZjZmpR+dnwVm61wkYK=0YA@mail.gmail.com>
Date: Fri, 27 Sep 2013 10:44:44 -0700
X-Google-Sender-Auth: MqV09WHVy70B-VdSlTDV_slWSVs
Message-ID: <CAE9FiQW+b7OtN4hJc6uygzbqzaCOkn3WcLDgSg5isHAJfdgmwg@mail.gmail.com>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
From: Yinghai Lu <yinghai@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 9:01 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Fri, Sep 27, 2013 at 1:28 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
>> Hi Linus, Yinghai !
>>
>> Please consider reverting:
>>
>> 928bea964827d7824b548c1f8e06eccbbc4d0d7d
>> PCI: Delay enabling bridges until they're needed
>>
>> (I'd suggest to revert now and maybe merge a better patch later)
>>
>> This breaks PCI on the PowerPC "powernv" platform (which is booted via
>> kexec) and probably x86 as well under similar circumstances. It will
>> basically break PCIe if the bus master bit of the bridge isn't set at
>> boot (by the firmware for example, or because kexec'ing cleared it).
>>
>> The reason is that the PCIe port driver will call pci_enable_device() on
>> the bridge (on everything under the sun actually), which will marked the
>> device enabled (but will not do a set_master).
>>
>> Because of that, pci_enable_bridge() later on (called as a result of the
>> child device driver doing pci_enable_device) will see the bridge as
>> already enabled and will not call pci_set_master() on it.

Ben,

looks like PCIe port driver does call pci_enable_device AND pci_set_master()

| int pcie_port_device_register(struct pci_dev *dev)
| {
|        int status, capabilities, i, nr_service;
|        int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
|
|        /* Enable PCI Express port device */
|        status = pci_enable_device(dev);
|        if (status)
|                return status;
|
|        /* Get and check PCI Express port services */
|        capabilities = get_port_device_capability(dev);
|        if (!capabilities)
|                return 0;
|
|        pci_set_master(dev);

so how come that pci_set_master is not called for powerpc?

Can you send out lspci -vvxxx with current linus-tree and v3.11?

Yinghai
