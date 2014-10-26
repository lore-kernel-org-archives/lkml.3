Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbaJZRbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 13:31:31 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48713 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJZRb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 13:31:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo4C=zANrE6muRf93nxLtmOG-U0xhWQPV_=fb8dFaKG8yw@mail.gmail.com>
References: <2354837.kuMZPK0Y1Q@segfault>
	<CAErSpo6zLY8RVAHnLe81jjOE8cxGzskjPq3HL7eZVOtC-WF6=w@mail.gmail.com>
	<2298090.n99M7dPPE3@segfault>
	<CAErSpo4C=zANrE6muRf93nxLtmOG-U0xhWQPV_=fb8dFaKG8yw@mail.gmail.com>
Date: Sun, 26 Oct 2014 13:31:28 -0400
Message-ID: <CADnq5_O54_rjL=hxg8-4GV57JC=6j16OeFOM-zbmoMuL5yJKqw@mail.gmail.com>
Subject: Re: [Bulk] Re: [3.16-rcX][pciehp][radeon] PCIe HotPlug conflicts with
 radeon GPU
From: Alex Deucher <alexdeucher@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Shawn Starr <shawn.starr@rogers.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 12:11 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Alex, Christian, dri-devel]
>
> On Sat, Oct 11, 2014 at 1:37 PM, Shawn Starr <shawn.starr@rogers.com> wrote:
>> On September 11, 2014 04:26:21 PM Bjorn Helgaas wrote:
>>> [+cc linux-pci]
>>>
>>> On Sat, Aug 2, 2014 at 10:02 AM, Shawn Starr <shawn.starr@rogers.com> wrote:
>>> > Hello devs,
>>> >
>>> > There are two issues I am encountering with the PCIe Hotplug driver on my
>>> > Lenovo Laptop (W500). I note this goes back further than 3.15.
>>> >
>>> > It is noted here:
>>> > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=
>>> > f244d8b623dae7a7bc695b0336f67729b95a9736
>>> > https://bugzilla.kernel.org/show_bug.cgi?id=79701
>>> >
>>> > And my open bug here:
>>> > https://bugzilla.kernel.org/show_bug.cgi?id=77261
>>> >
>>> > 1) If I enable the device to use both the integrated and discrete GPU,
>>> > pciehp will decide to force unload radeon because it puts itself into a
>>> > power saving state, fails back to the Intel integrated GPU in this case
>>> > unless I tell radeon.ko to runpm=0 (no power management, then pciehp wont
>>> > touch it).
>>> >
>>> > 2) If the Radeon GPU resets and you use pci_reset=1 for kernel module
>>> > option, pciehp decides to force unload radeon even though the GPU is
>>> > trying to setup after failing.
>>> >
>>> > Kernel I am using right now: 3.16.0-0.rc7.git3.1.fc21.x86_64 (about to
>>> > boot into snapshot kernel-core-3.16.0-0.rc7.git4.1.fc21.x86_64)
>>> Hi Shawn,
>>>
>>> Thanks for the report and sorry that it got dropped.  But I see you're
>>> cc'd on https://bugzilla.kernel.org/show_bug.cgi?id=79701, so you've
>>> probably seen the work there.  If you can try out the patches I just
>>> posted, that would be great.
>>>
>>> Bjorn
>>
>> Hi Bjorn,
>>
>> For #1) This is fixed in linux-next (tracking 3.18.0-0.rc0.git1.2.fc22.1.x86_64
>> nondebug kernel for Fedora). PCIe HotPlug no longer unloads radeon. For this
>> bugzilla report we can close it.
>>
>> #2) This still has weird results however, radeon.hard_reset=1 is experimental
>> and while it attempts to reset GPU, PCIe HotPlug seems to interact in this.
>>
>> This can be tested by adding to grub command line radeon.hard_reset=1.
>> When X has started up, trigger a reset by cat
>> /sys/kernel/debug/dri/#/radeon_gpu_reset. It will output 0, cat it again will
>> show 1.
>>
>> Attempt to drag a window. The this will trigger a GPU reset, but fail to
>> recover, its unknown if PCIe HotPlug is preventing a proper reset or not but
>> there is pciehp calls in the stack trace.
>
> A PCIe device reset usually looks like a hotplug event because the
> PCIe link goes down and comes back up.  As far as the PCI core is
> concerned, it can't tell the difference between (1) a simple reset
> where the link bounces and (2) removal of one device followed by
> addition of another.
>
> b440bde74f04 ("PCI: Add pci_ignore_hotplug() to ignore hotplug events
> for a device") addressed this for some similar cases, but it looks
> like we probably need some more calls to pci_ignore_hotplug() in the
> radeon driver reset methods.
>
> Can you please open a bugzilla and attach the complete dmesg log,
> including the GPU reset and recovery failure?

Is there a way we could temporarily disable pci hotplug around a GPU reset?

Alex
