Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaBODFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 22:05:06 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:39869 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaBODFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 22:05:02 -0500
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com,
        joro@8bytes.org
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com, zhenhua@hp.com
Subject: [PATCH 0/1] Fix Crashdump failure caused by leftover DMA through a hardware IOMMU
Date: Fri, 14 Feb 2014 20:04:26 -0700
Message-Id: <1392433467-62357-1-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renamed from previous email thread: Crashdump Accepting Active IOMMU

This patch implements a fix for:
A kdump problem about DMA that has been discussed for a long time. That is,
when a kernel panics and boots into the kdump kernel, DMA started by the 
panicked kernel is not stopped before the kdump kernel is booted and the 
kdump kernel disables the IOMMU while this DMA continues.  This causes the
IOMMU to stop translating the DMA addresses as IOVAs and begin to treat them 
as physical memory addresses -- which causes the DMA to either:
(1) generate DMAR errors or (2) generate PCI SERR errors or (3) transfer  
data to or from incorrect areas of memory. Often this causes the dump to fail.

This patch modifies the behavior of the Intel iommu in the crashdump kernel: 
1. to skip disabling the iommu hardware translations
2. to leave the current translations in-place so that legacy DMA will continue
   using its current buffers until the device drivers in the crashdump kernel
   initialize and initialize their devices,
3. to use different portions of the iova address ranges for the device drivers
   in the crashdump kernel than the iova ranges that were in-use at the time
   of the panic.  

Advantages of this approach:
1. All manipulation of the IO-device is done by the Linux device-driver
   for that device.
2. This approach behaves in a manner very similar to operation when the
   panicked kernel was not using a hardware IOMMU.
3. Any activity between the IO-device and its RMRR areas is handled by the
   device-driver in the same manner as during a non-kdump boot.
4. If an IO-device has no driver in the kdump kernel, it is simply left alone.
   This supports the practice of creating a special kdump kernel without
   drivers for any devices that are not required for taking a crashdump. 

Bill Sumner (1):
  Fix Crashdump failure caused by leftover DMA through a hardware IOMMU

 drivers/iommu/intel-iommu.c | 1233 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 1172 insertions(+), 61 deletions(-)

-- 
Bill Sumner <bill.sumner@hp.com>

