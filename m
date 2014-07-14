Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbaGNQUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:20:18 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43133 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbaGNQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:19:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@linuxfoundation.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: [PATCH v5] Fixes to Xen pciback for 3.17.
Date: Mon, 14 Jul 2014 12:18:50 -0400
Message-Id: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg: goto GHK

This is v5 version of patches to fix some issues in Xen PCIback.

One of the issues Xen PCI back has that patch:

is fixing is that a deadlock can happen if the PCI device is
assigned to a guest and we try to 'unbind' it from Xen 'pciback' driver.
The issue is rather simple - the SysFS mechanism for the 'unbind' path
takes a device lock and the code in Xen PCI uses the pci_reset_function
which also takes the same lock. Solution is to use the lock-less version
and mandate that callers of said function in Xen pciback take the lock.
Easy enough.

GHK:
To guard against this happening in the future we also add an assert in the
form of lockdep assertion. That is OK except that it looks ugly as we take
it straight from the 'struct device' instead of using an appropriate macro.
See:

+       lockdep_assert_held(&dev->dev.mutex);

(in [PATCH v5 2/6] xen/pciback: Don't deadlock when unbinding).

The patch: [PATCH v5 3/6] driver core: Provide an wrapper around the mutex
to do.

introduces a nice wrapper so it is bit cleaner. Greg, if you are OK with
it could you kindly Ack it as I would prefer to put this patchset
via the Xen tree. It would look now as:

-       lockdep_assert_held(&dev->dev.mutex);
+       device_lock_assert(&dev->dev);

I can also squash it in "[PATCH v5 2/6] xen/pciback: Don't deadlock when
 unbinding." but since that one is going through the stable tree I wasn't
sure whether you (Greg KH) would be OK with that.

END GHK:

Thank you!

Patches are also available on my git tree

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pciback-3.17.v5

 Documentation/ABI/testing/sysfs-driver-pciback | 25 +++++++++++++++
 drivers/xen/xen-pciback/passthrough.c          | 14 +++++++--
 drivers/xen/xen-pciback/pci_stub.c             | 42 ++++++++++++++------------
 drivers/xen/xen-pciback/pciback.h              |  7 +++--
 drivers/xen/xen-pciback/vpci.c                 | 14 +++++++--
 drivers/xen/xen-pciback/xenbus.c               |  4 +--
 include/linux/device.h                         |  5 +++
 7 files changed, 81 insertions(+), 30 deletions(-)

Konrad Rzeszutek Wilk (6):
      xen-pciback: Document the various parameters and attributes in SysFS
      xen/pciback: Don't deadlock when unbinding.
      driver core: Provide an wrapper around the mutex to do lockdep warnings
      xen/pciback: Include the domain id if removing the device whilst still in use
      xen/pciback: Print out the domain owning the device.
      xen/pciback: Remove tons of dereferences

