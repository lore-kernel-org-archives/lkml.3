Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab3EJRJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:09:34 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:55338 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3EJRJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <517E9DAC.7030709@gmail.com>
References: <1366940798-15268-1-git-send-email-yinghai@kernel.org> <517E9DAC.7030709@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 10 May 2013 11:09:10 -0600
Message-ID: <CAErSpo6=EMckwU0L9dwSmzrMNqfgVzuoppq9phsPysz+XWs2eA@mail.gmail.com>
Subject: Re: [PATCH -v3] PCI, ACPI, hotplug: Fix BUS_CHECK event handle on
 root bridge
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Gavin Guo <tuffkidtt@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 10:19 AM, Jiang Liu <liuj97@gmail.com> wrote:
> Hi Yinghai,
>         Reviewed-by: Jiang Liu <jiang.liu@huawei.com>
>         Thanks!
>
> On 04/26/2013 09:46 AM, Yinghai Lu wrote:
>> Gavin found that acpiphp does not handle hotplug anymore even after
>> now we have acpiphp built-in preparing for v3.10.
>>
>> Bjorn analyzed bootlog, he found that
>>     acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
>>     ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
>>     \_SB_.PCI0:_OSC invalid UUID
>>     acpiphp: Slot [1] registered
>>     acpiphp: Slot [1-1] registered
>>    acpi root: \_SB_.PCI0 notify handler is installed
>>     _handle_hotplug_event_root: Bus check notify on \_SB_.PCI0
>>     _handle_hotplug_event_root: Bus check notify on \_SB_.PCI0
>> And that means:
>>    So we should be using acpiphp, which you do have built in statically,
>>    and it found a couple slots.  And we did get two bus check notifies on
>>    \_SB_.PCI0, so we *should* be re-enumerating PCI bus 0000:00.  But it
>>    looks like we're handling this as a host bridge hotplug event instead
>>    of a PCI device hotplug.  My guess is that
>>    handle_root_bridge_insertion() does nothing because the PCI0 ACPI
>>    device already exists, though I would expect to see the "acpi device
>>    exists..." in your dmesg log if this were the case.
>>
>> Also according to Rafael and Bjorn, it is perfect fine that we
>> should enumerate bus by sending event to root bridge after hotadd
>> device to slots under that root bridge or children bridges.
>>
>> It turns out that it is regression caused by
>> | commit 668192b678201d2fff27c6cc76bb003c1ec4a52a
>> | Author: Yinghai Lu <yinghai@kernel.org>
>> | Date:   Mon Jan 21 13:20:48 2013 -0800
>> |
>> |    PCI: acpiphp: Move host bridge hotplug to pci_root.c
>>
>> We should check slots when BUS_CHECK is sent to root bridge acpi handle.
>>
>> Restore the old behavoir by calling acpi_check_bridge and check_sub_bridge
>> in acpiphp.
>>
>> Jiang Liu acctually have simimar patch but it forgets calling
>> acpi_check_bridge() for system that have slots on root bus directly.
>> That is still valid, as in QEMU we still have that slots on bus 0 at
>> least. But my first version patch wrongly check if root bridge exists
>> before check_sub_bridge for children bridges.
>>
>> -v2: Don't check bridge for acpi_walk_namespace with check_sub_bridges.
>>      also put back bridge reference.
>> -v3: More changelog and etc.
>>
>> Reported-by: Gavin Guo <tuffkidtt@gmail.com>
>> Tested-by: Gavin Guo <tuffkidtt@gmail.com>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

I added the Acked-by and Reviewed-by and opened
https://bugzilla.kernel.org/show_bug.cgi?id=57961 just as a place to
store the dmesg logs.  I also backported it to v3.9 and added a CC:
stable tag because I think v3.9 has the same issue.  The backport is
also attached to the bugzilla.

I'll ask Linus to put this in v3.10.

Thanks,
  Bjorn
