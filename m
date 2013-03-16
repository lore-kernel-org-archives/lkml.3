Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3CPWze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 18:55:34 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45162 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3CPWz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 18:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130316221159.GA3702@kroah.com>
References: <20130316213512.2974.17303.stgit@amt.stowe> <20130316213519.2974.38954.stgit@amt.stowe>
 <20130316221159.GA3702@kroah.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 16 Mar 2013 16:55:07 -0600
Message-ID: <CAErSpo7OJrMDhoacZbQeJcjsPHfKfNyq0SCtu8qqGbVYj5NvLw@mail.gmail.com>
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Myron Stowe <myron.stowe@redhat.com>, kay@vrfy.org,
        linux hotplug mailing <linux-hotplug@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Xiangliang Yu <yuxiangl@marvell.com>,
        xiangliang yu <yxlraid@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 4:11 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Mar 16, 2013 at 03:35:19PM -0600, Myron Stowe wrote:
>> Sysfs includes entries to memory that backs a PCI device's BARs, both I/O
>> Port space and MMIO.  This memory regions correspond to the device's
>> internal status and control registers used to drive the device.
>>
>> Accessing these registers from userspace such as "udevadm info
>> --attribute-walk --path=/sys/devices/..." does can not be allowed as
>> such accesses outside of the driver, even just reading, can yield
>> catastrophic consequences.
>>
>> Udevadm-info skips parsing a specific set of sysfs entries including
>> 'resource'.  This patch extends the set to include the additional
>> 'resource<N>' entries that correspond to a PCI device's BARs.
>
> Nice, are you also going to patch bash to prevent a user from reading
> these sysfs files as well?  :)
>
> And pciutils?
>
> You get my point here, right?  The root user just asked to read all of
> the data for this device, so why wouldn't you allow it?  Just like
> 'lspci' does.  Or bash does.
>
> If this hardware has a problem, then it needs to be fixed in the kernel,
> not have random band-aids added to various userspace programs to paper
> over the root problem here.  Please fix the kernel driver and all should
> be fine.  No need to change udevadm.

I'm not sure that "udevadm info" (or bash) reading device registers is
a good idea because we don't know what the device is, and we don't
have any idea what the side effects of reading its registers will be.
Just to be clear, this is about device-specific I/O port registers,
not config space, so we can't expect any sort of consistency.

We could put a quirk in the kernel for this device (obviously the
issue is independent of whether the driver is loaded), but no doubt
other devices with I/O BARs will have access size restrictions, side
effects, or other issues.  Adding quirks for them feels like a
never-ending job.

It might have been a mistake to put the resourceN files in sysfs in
the first place, or to make them read/writable, because users expect
sysfs files to contain ASCII.  For memory BARs, resourceN only allows
mmap, not read/write, so at least we side-step similar issues there.

Bjorn
