Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3FLGUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 02:20:21 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49300 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3FLGUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 02:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com>
References: <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
	<CAE9FiQU7cDzJdHxmqhJNgc9UCsRLgvCFQpv8+fLxD79pLEUC5A@mail.gmail.com>
	<CAErSpo4ncW8rkcpDiccORZedj30m7jRmpXK+amfDGn_wjwt7EA@mail.gmail.com>
	<CAE9FiQVqKag2TGah7x_1MAJ+c0UWgywgM_jKUoOnh+rq3bwBhg@mail.gmail.com>
	<CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com>
	<20130329032200.GA11990@google.com>
	<CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
	<CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
	<CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
	<CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
	<20130401235256.GA31966@google.com>
	<CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com>
	<CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com>
Date: Tue, 11 Jun 2013 23:20:18 -0700
X-Google-Sender-Auth: vB94PaSIazc60QrKhqvSHjjtYZU
Message-ID: <CAE9FiQWjQXwiTWju6cBc_o25jy_wmZ1u+Pifh1wdnxtV=i5ENw@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>
Cc: Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 1:10 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Mon, Apr 1, 2013 at 6:03 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>> commit 96e5d01cd536458435ef0678d9fa3dc542afb41f
>>> Author: Bjorn Helgaas <bhelgaas@google.com>
>>> Date:   Mon Apr 1 15:47:39 2013 -0600
>>>
>>>     Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
>>>
>>>     This reverts commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6.
>>>
>>>     Conflicts:
>>>         drivers/acpi/pci_root.c
>>>
>>>     Reference: https://bugzilla.kernel.org/show_bug.cgi?id=55211
>>>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>>
>> Acked-by: Yinghai Lu <yinghai@kernel.org>
>>
>> stable need this reverting too.
>
> I updated the changelog and added this to my for-linus branch, headed for v3.9.

We may need to revert this reverting for 3.10.

Today noticed that acpiphp jump in before pciehp on one setup.

current code from acpi_pci_root_add we have
  1. pci_acpi_scan_root
         ==> pci devices enumeration and bus scanning.
             ==> pci_alloc_child_bus
                 ==> pcibios_add_bus
                     ==> acpi_pci_add_bus
                         ==> acpiphp_enumerate_slots
                             ==> ...==> register_slot
                                  ==> device_is_managed_by_native_pciehp
                                        ==> check osc_set with
OSC_PCI_EXPRESS_NATIVE_HP_CONTROL
   2. _OSC set request

so we always have acpiphp hotplug slot registered at first.

so either we need to
A. revert reverting about _OSC
B. move pcibios_add_bus down to pci_bus_add_devices()
    as acpiphp and apci pci slot driver are some kind of drivers for pci_bus
C. A+B

Thanks

Yinghai
