Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab3CSCJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:09:26 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:61975 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab3CSCJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130319020316.GB21319@kroah.com>
References: <20130316213512.2974.17303.stgit@amt.stowe>
	<20130316213519.2974.38954.stgit@amt.stowe>
	<20130316221159.GA3702@kroah.com>
	<1363477853.2423.25.camel@zim.stowe>
	<20130317010317.GB9641@kroah.com>
	<5147C541.1080304@gmail.com>
	<20130319020316.GB21319@kroah.com>
Date: Mon, 18 Mar 2013 20:09:22 -0600
Message-ID: <CADLC3L2hKYPsW4fvg6tbptBc1r7LS=7Ndwhp4mZ3BKzJq6z-eg@mail.gmail.com>
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
From: Robert Hancock <hancockrwd@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Myron Stowe <mstowe@redhat.com>, Myron Stowe <myron.stowe@redhat.com>,
        kay@vrfy.org, linux-hotplug@vger.kernel.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        yuxiangl@marvell.com, yxlraid@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 8:03 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Mar 18, 2013 at 07:54:09PM -0600, Robert Hancock wrote:
>> On 03/16/2013 07:03 PM, Greg KH wrote:
>> >On Sat, Mar 16, 2013 at 05:50:53PM -0600, Myron Stowe wrote:
>> >>On Sat, 2013-03-16 at 15:11 -0700, Greg KH wrote:
>> >>>On Sat, Mar 16, 2013 at 03:35:19PM -0600, Myron Stowe wrote:
>> >>>>Sysfs includes entries to memory that backs a PCI device's BARs, both I/O
>> >>>>Port space and MMIO.  This memory regions correspond to the device's
>> >>>>internal status and control registers used to drive the device.
>> >>>>
>> >>>>Accessing these registers from userspace such as "udevadm info
>> >>>>--attribute-walk --path=/sys/devices/..." does can not be allowed as
>> >>>>such accesses outside of the driver, even just reading, can yield
>> >>>>catastrophic consequences.
>> >>>>
>> >>>>Udevadm-info skips parsing a specific set of sysfs entries including
>> >>>>'resource'.  This patch extends the set to include the additional
>> >>>>'resource<N>' entries that correspond to a PCI device's BARs.
>> >>>
>> >>>Nice, are you also going to patch bash to prevent a user from reading
>> >>>these sysfs files as well?  :)
>> >>>
>> >>>And pciutils?
>> >>>
>> >>>You get my point here, right?  The root user just asked to read all of
>> >>>the data for this device, so why wouldn't you allow it?  Just like
>> >>>'lspci' does.  Or bash does.
>>
>> lspci doesn't randomly attempt to access device registers, AFAIK..
>
> Have you read the man page for the '-xxx' option to lspci?  lspci can be
> quite intrusive, and I used to have a number of systems that it would
> trash very easily if you ran it on them as root.
>
>> >>Yes :P , you raise a very good point, there are a lot of way a user can
>> >>poke around in those BARs.  However, there is a difference between
>> >>shooting yourself in the foot and getting what you deserve versus
>> >>unknowingly executing a common command such as udevadm and having the
>> >>system hang.
>> >>>
>> >>>If this hardware has a problem, then it needs to be fixed in the kernel,
>> >>>not have random band-aids added to various userspace programs to paper
>> >>>over the root problem here.  Please fix the kernel driver and all should
>> >>>be fine.  No need to change udevadm.
>> >>
>> >>Xiangliang initially proposed a patch within the PCI core.  Ignoring the
>> >>specific issue with the proposal which I pointed out in the
>> >>https://lkml.org/lkml/2013/3/7/242 thread, that just doesn't seem like
>> >>the right place to effect a change either as PCI's core isn't concerned
>> >>with the contents or access limitations of those regions, those are
>> >>issues that the driver concerns itself with.
>> >>
>> >>So things seem to be gravitating towards the driver.  I'm fairly
>> >>ignorant of this area but as Robert succinctly pointed out in the
>> >>originating thread - the AHCI driver only uses the device's MMIO region.
>> >>The I/O related regions are for legacy SFF-compatible ATA ports and are
>> >>not used to driver the device.  This, coupled with the observance that
>> >>userspace accesses such as udevadm, and others like you additionally
>> >>point out, do not filter through the device's driver for seems to
>> >>suggest that changes to the driver will not help here either.
>> >
>> >A PCI quirk should handle this properly, right?  Why not do that?  Worse
>> >thing, the quirk could just not expose these sysfs files for this
>> >device, which would solve all userspace program issues, right?
>>
>> A PCI quirk implies there is something wrong with this device in
>> particular. This isn't the case. The device responds properly when
>> it's accessed as intended. The problem is that udevadm (or other
>> processes, like a random grep through sysfs for example) is
>> effectively reading registers willy-nilly. This is absolutely not
>> safe to do on many devices - and certainly not while a driver is
>> attached to the device and has claimed the port or MMIO regions that
>> are being accessed.
>
> Then we need to fix that!
>
> In the kernel!
>
> Don't try to gloss over the problem by changing one random userspace
> program, you will never catch them all.  Fix the root problem here
> people, that's all I'm asking for.
>
>> Blocking access through these files to a device with an active driver
>> that's claimed the regions would significantly reduce the chances of
>> something like this causing problems.
>
> Great, that's one possible solution, the other is just not creating the
> files at all for known problem devices, right?

I don't think one can reasonably enumerate all problem devices. There
are probably countless devices which can potentially break if their
resources (especially IO ports) are read in unexpected ways. Aside
from devices like this one, which apparently don't like certain IO
ports being read with certain access widths, there's every device in
existence with read-to-reset type registers. The fix to this needs to
apply to all devices.

>
> My main point here is, you aren't going to fix this in userspace, fix it
> in the kernel.

The kernel can help the situation by blocking access to devices with
an active driver, but it can't fix all cases. Suppose the device has
no driver loaded yet, how is the kernel supposed to tell the
difference between software with a legitimate need to access these
files for virtualization device assignment, etc. and something like
udevadm or a random grep command that's reading the files without any
idea what it's doing? udevadm does need to be fixed to avoid accessing
these files because it's unnecessary and dangerous.
