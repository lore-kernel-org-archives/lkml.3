Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3FYRSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:18:07 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47565 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab3FYRSE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:18:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130625112348.GA13722@redhat.com>
References: <1371668174-32115-1-git-send-email-rkrcmar@redhat.com>
 <CAErSpo7O2YUUq-Ninu+BdmnrDGcU_h5=h=v1MBCoLorSDZW=Ow@mail.gmail.com> <20130625112348.GA13722@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 25 Jun 2013 11:17:43 -0600
Message-ID: <CAErSpo7sH_TsN73LZWRFgO+RqAhzgdiTXR86xJ7Ojmno6QTY5w@mail.gmail.com>
Subject: Re: [PATCH] PCI: avoid NULL deref in alloc_pcie_link_state
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Alex Williamson <alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 5:23 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Mon, Jun 24, 2013 at 07:38:45PM -0600, Bjorn Helgaas wrote:
>> [+cc Michael, Alex, Isaku]
>>
>> On Wed, Jun 19, 2013 at 12:56 PM, Radim Krčmář <rkrcmar@redhat.com> wrote:
>> > PCIe switch upstream port can be connected directly to the PCIe root bus
>> > in QEMU; ASPM does not expect this topology and dereferences NULL pointer
>> > when initializing.
>> >
>> > I have not confirmed this can happen on real hardware, but it is presented
>> > as a feature in QEMU, so there is no reason to panic if we can recover.
>>
>> This doesn't seem like a valid hardware topology to me.  If this *can*
>> occur on real hardware, we should fix it in Linux.  If not, maybe QEMU
>> should be changed to disallow it.
>
> I don't think it's a spec compliant topology either.
>
> Anything connected to an RC is either an integrated endpoint
> or a root port.
> There's no way to have an upstream port that is also
> an integrated endpoint or a root port - these are distinct
> device types.
>
> So I don't think Linux needs to support it.
>
> Having said that, there's all kind of broken hardware
> out there - crashing is not a friendly way to tell users
> that their hardware is not spec compliant.
> Maybe linux can print a friendly warning and ignore
> this port?

Indeed, that would be nicer.  I booted Win7 on the same config, and it
came up fine.  It did complain that it couldn't start the PCI-to-PCI
bridge driver on 00:03.0, the upstream port.

I'd like it if Linux could similarly tolerate that.  But since this is
a relatively low-priority issue, I'm going to hold out for a more
straightforward solution.  Checking for a null
"pdev->bus->parent->self" pointer is not very obvious.  I think we can
probably come up with a more direct check that reads better and
possibly even detects the issue at the upstream port, not the
downstream port.

I opened a bugzilla for this issue:
https://bugzilla.kernel.org/show_bug.cgi?id=60111

Radim, can you please attach a complete dmesg log showing the oops,
i.e., console output with "ignore_loglevel" and lspci -vv output (have
to use your patch so it boots, I guess)?  I tried to reproduce it and
I know the problem is there, but I haven't quite found the right
recipe yet.

Bjorn
