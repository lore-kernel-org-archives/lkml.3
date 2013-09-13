Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3IMM6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 08:58:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64800 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab3IMM6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 08:58:33 -0400
From: Andy Whitcroft <apw@canonical.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc: Andy Whitcroft <apw@canonical.com>, Ben Howard <ben.howard@canonical.com>,
        linux-scsi@vger.kernel.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] Hyper-V TRIM support
Date: Fri, 13 Sep 2013 13:58:25 +0100
Message-Id: <1379077109-29606-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tl;dr -- enable TRIM support for Hyper-V emulated disks.

The Hyper-V hypervisor can support TRIM for its devices, advertising this
via the appropriate VPD pages.  However the emulated disks only claim
to be SPC-2 devices.  According to the specs VPD pages (in general) did
exist at SPC-2 but the specific pages we interogate for the TRIM support
did not until SPC-3 therefore the kernel avoids reading the relevant pages
for SPC-2 devices and prevents TRIM from being offered for these devices.
Additionally at SPC-2 we prefer ReadCapacity10 over ReadCapacity16 and
unless we use RC16 we will not identify the device as TRIM capable also
preventing TRIM being offered.

As the VPD page zero does list which pages are valid for each device, it
could be argued that we could simply attempt to use these pages for all
devices which claim to be SPC-2 and above.  While this seems valid the
code documents a number of devices which take badly to having even VPD
page 0 interogated even when supposedly supported.  Therefore it seems
appropriate to add a scsi device flag to allow a device to request SPC-3
VPD pages be used when only at SPC-2.

Similarly for the ReadCapacity selection it seems dangerous to invert
the order for all SPC-2 devices.  So it seems appropriate to add a scsi
device flag to request we try RC16 before RC10 (mirroring the existing
flag for the opposite).

The following four patches add the two scsi device flags and select those
flags for the Hyper-V emulated disks.

Patches against v3.11.

Comments?

-apw

Andy Whitcroft (4):
  scsi: add scsi device flag to request VPD pages be used at SPC-2
  scsi: add scsi device flag to request READ CAPACITY (16) be preferred
  scsi: hyper-v storage -- mark as VPD capable at SPC-2
  scsi: hyper-v storage -- mark as preferring READ CAPACITY (16) at
    SPC-2

 drivers/scsi/sd.c          | 8 +++++++-
 drivers/scsi/storvsc_drv.c | 2 ++
 include/scsi/scsi_device.h | 2 ++
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
1.8.1.2

