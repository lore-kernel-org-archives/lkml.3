Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3H2VJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:09:59 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50208 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab3H2VJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:09:56 -0400
MIME-Version: 1.0
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 29 Aug 2013 15:09:35 -0600
Message-ID: <CAErSpo4cC7XKQn+2Pg9r+VDrcqKP4M4KQFRqQAvegTbnkUWf+A@mail.gmail.com>
Subject: Re: [PATCH v8 6/6] PCI: update device mps when doing pci hotplug
To: Yinghai Lu <yinghai@kernel.org>
Cc: Yijing Wang <wangyijing@huawei.com>, Jon Mason <jdmason@kudzu.us>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Jin Feng <joe.jin@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-kernel, since more folks might be interested]

On Mon, Aug 26, 2013 at 6:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Aug 26, 2013 at 2:33 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> The current Linux default is PCIE_BUS_TUNE_OFF, and given that I don't
>> want to touch any MPS settings in that mode, I don't see a way to
>> safely fix https://bugzilla.kernel.org/show_bug.cgi?id=60671 (the
>> problem with hot-added devices not working because MPS is incorrect).
>> In the long term, I hope we can fix it by making the default
>> PCIE_BUS_SAFE, but that doesn't help right now.
>>
>> That leaves us with only the workaround of booting the Huawei rh5885
>> box with "pci=pcie_bus_safe".
>>
>> I'm willing to accept that because I think we can argue that this is
>> really a BIOS defect.  The BIOS *can* program MPS to values that will
>> be safe for hotplug even if the OS does nothing, i.e., it can set
>> MPS=128 in all paths that lead to a hotpluggable slot.  I think that's
>> probably what this BIOS *should* do, since it has no way of knowing
>> whether the OS will support hotplug or whether the OS will reprogram
>> any MPS values.
>
> BIOS should have several settings for MPS:
> 1. 128
> 2. auto or performance.
>
> When it set to Auto, Linux will have problem with hot-add.
>
> Default one was 128 before, that is ok,
> as from sndbrige and ivbridge, chipset could support more than 128.
>
> BIOS want to set it auto.
> BIOS guys is claiming that other OSes are ok with Auto, but only Linux
> has problem.

I don't understand the argument the BIOS guys are making.

1.  If the BIOS sets MPS=128 for all devices all the time, everything
should always work.  Performance won't be optimal, but it should
always work.

This requires no OS support at all, so the current Linux default of
doing nothing is fine.

2.  If the BIOS sets MPS to something larger than 128 for hardwired
devices only (where no hotplug is possible), the BIOS either knows
that the root complex will split peer-to-peer packets as required (sec
1.3.1), or it assumes there will be no peer-to-peer traffic between
hierarchies.

This should also work fine with no OS support, unless we do
peer-to-peer traffic and the root complex doesn't split packets.

3.  If the BIOS sets MPS to something larger than 128 in a path that
leads to a hotplug slot, the BIOS assumes the OS actively manages MPS
for hotplug.

This requires OS support because if we hot-add a device that only
supports MPS=128, the OS must reprogram the upstream path before using
the device.

I don't know what the BIOS "auto" setting means, but it must mean
something in case 3, because that's the only case where OS support is
required.  But if the OS is smart enough to manage MPS for hot-added
devices, why can't the OS also program MPS for the whole system at
boot-time?

That's why I don't understand what BIOS wants to do.  It sounds like
they want the performance benefit of larger MPS for devices present in
hot-plug slots at boot-time, even if the OS doesn't actively manage
MPS and things blow up if that device is replaced with one that
supports a smaller MPS.  That choice doesn't make sense.

In case 3, with a non-MPS-aware OS, you get better performance for a
while, but blow up if a card is replaced.  And with an MPS-aware OS,
there should be no advantage to case 3: the OS should be able to get
good performance by programming MPS itself, even without help from the
BIOS.

Bjorn
