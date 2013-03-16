Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3CPVfV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 17:35:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3CPVfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 17:35:19 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH] udevadm-info: Don't access sysfs entries backing device I/O
	port space
To: kay@vrfy.org
Cc: linux-hotplug@vger.kernel.org, greg@kroah.com, alex.williamson@redhat.com,
        linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        linux-kernel@vger.kernel.org
Date: Sat, 16 Mar 2013 15:35:12 -0600
Message-ID: <20130316213512.2974.17303.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been working on identifying the root cause of an issue exposed by
'udevadm' that was first exposed on the linux-pci mail list [1] and
believe that there is now enough of an understanding to propose a fix.

What was originally witnessed was the platform hanging after "udevadm info
--attribute-walk --path=/sys/devices/pci0000:00/<...>/block/sda" is ran.
Xiangliang was able to isolate the failure to accesses involving a Marvell
9125 device's I/O BARs, or more specifically, accesses to the I/O port
space backing the device's I/O BARs (a.k.a. the device's I/O port
resources, or regions).  With this knowledge he was able to reproduce the
hang targeting the device's sysfs 'resource<N>' entries, where N
represents an I/O BARs, with "cat /sys/devices/<...>/resource<N>".

In my research, looking for possible solutions, I noticed that kernel
commit 8633328 introduced sysfs based reading and writing of I/O port
related 'resource<N>' entries as part of adding virtualization based
device assignment functionality [2].  Note that these regions directly map
to the device's control and status registers [3].

Putting together these pieces of information we now understand that:
  o  udevadm based attribute walking initiates read accesses of all the
     entries in a device's sysfs directory [4],
  o  sysfs 'resource<N>' entries correspond to the device's internal
     status and control registers used for driving the device,
  o  If the 'resource<N>' entry corresponds to a device's I/O BAR, the
     device's control and status registers are directly accessible by
     userspace.

Allowing userspace access to a device's registers introduces potential
simultaneous interaction with the device by a second, competing, entity;
There is the device's driver, which believes it exclusively owns the
device, and an unknown, potential second entity, which can effect control
and status changes to the device asynchronously.

Device status and control registers being accessed from an entity that has
no idea what is being read or written is just asking for trouble.  Even
just reading can have consequences as the register may be a "read once to
clear" or some similar type.  I think we have just been lucky, or
blissfully ignorant, concerning problems that may have, and still could
be, occurring due to this situation.


There is an aspect at play here that I still do not understand (likely
something obvious that I'm just not seeing).  The sysfs read routine for
accessing I/O port 'resource<N>' entries only supports 1, 2, and 4 byte
reads (which respectively correspond to inb/outb, inw/outw, and inl/outl
I/O port accessors).  When "udevadm ..." executes, the udev internals
attempt reads of 4K byte chunks.

  "udevadm info --attribute-walk --path=<pci_device_path>"

  print_device_chain()
    print_all_attributes()
      ...
      udev_device_get_sysattr_value()
        char value[4096];
        ...
        size = read(fd, value, sizeof(value));
        ...

  -- ^ userspace ^ -- v kernel v --

  pci_read_resource_io(..., count)	# sysfs read setup in pci_create_attr()
    pci_resource_io(..., count, ...)
      ...
      if (port + count - 1 > pci_resource_end(pdev, i))
        return -EINVAL;
      ...

What I don't understand is how the device's I/O port space is successfully
getting read.  It looks to me like 'pci_resource_io()' would fail the
access size check and return '-EINVAL' having never attempted the read's
access to I/O port space causing the system to hang.

I'm keep looking into this but I do *not* have access to a platform with a
Marvell 9125 device.


Reference(s)/Foot Note(s):
  [1] https://lkml.org/lkml/2013/3/7/242
  [2] Note that due to the implementation specifics only the 'resource<N>'
      entries representing I/O BARs can be read or written via sysfs.
      Sysfs' 'resource<N>' entries representing MMIO do not have sysfs
      based read/write routines as only mmap'ing of these entries is
      exposed (./drivers/pci/pci-sysfs.c::pci_create_attr()).
  [3] The kernel's sysfs documentation states: "Attributes should be ASCII
      text files..." (./Documentation/filesystems/sysfs.txt).  I wonder if
      this is just out-of-date infomation as sysfs obviously supports
      creating binary files (./fs/sysfs/bin.c::sysfs_create_bin_file()).
  [4] Note that udevadm-info does skip a specifically named set of entries
      (./src/udevadm-info.c::skip_attribute()).
---

Myron Stowe (1):
      udevadm-info: Don't access sysfs 'resource<N>' files


 src/udevadm-info.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

-- 
