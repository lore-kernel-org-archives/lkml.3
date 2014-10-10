Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbaJJUI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 16:08:27 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:47953 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaJJUI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 16:08:26 -0400
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linaro-kernel@lists.linaro.org,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFC 0/4] dma-buf Constraints-Enabled Allocation helpers
Date: Sat, 11 Oct 2014 01:37:54 +0530
Message-Id: <1412971678-4457-1-git-send-email-sumit.semwal@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Why:
====
 While sharing buffers using dma-buf, currently there's no mechanism to let
devices share their memory access constraints with each other to allow for
delayed allocation of backing storage.

This RFC attempts to introduce the idea of memory constraints of a device,
and how these constraints can be shared and used to help allocate buffers that
can satisfy requirements of all devices attached to a particular dma-buf.

How:
====
 A constraints_mask is added to dma_parms of the device, and at the time of
each device attachment to a dma-buf, the dma-buf uses this constraints_mask
to calculate the access_mask for the dma-buf.

Allocators can be defined for each of these constraints_masks, and then helper
functions can be used to allocate the backing storage from the matching
allocator satisfying the constraints of all devices interested.

A new miscdevice, /dev/cenalloc [1] is created, which acts as the dma-buf
exporter to make this transparent to the devices.

More details in the patch description of "cenalloc: Constraint-Enabled
Allocation helpers for dma-buf".


At present, the constraint_mask is only a bitmask, but it should be possible to
change it to a struct and adapt the constraint_mask calculation accordingly,
based on discussion.


Important requirement:
======================
 Of course, delayed allocation can only work if all participating devices 
will wait for other devices to have 'attached' before mapping the buffer
for the first time.

As of now, users of dma-buf(drm prime, v4l2 etc) call the attach() and then
map_attachment() almost immediately after it. This would need to be changed if
they were to benefit from constraints.


What 'cenalloc' is not:
=======================
- not 'general' allocator helpers - useful only for constraints-enabled
  devices that share buffers with others using dma-buf.
- not a replacement for existing allocation mechanisms inside various
  subsystems; merely a possible alternative.
- no page-migration - it would be very complementary to the delayed allocation
   suggested here.

TODOs: 
======
- demonstration test cases
- vma helpers for allocators
- more sample allocators
- userspace ioctl (It should be a simple one, and we have one ready, but wanted
   to agree on the kernel side of things first)


May the brickbats begin, please! :)

Best regards,
~Sumit.

[1]: 'C'onstraints 'EN'abled 'ALLOC'ation helpers = cenalloc: it might not be a
very appealing name, so suggestions are very welcome!


Benjamin Gaignard (1):
  cenalloc: a sample allocator for contiguous page allocation

Sumit Semwal (3):
  dma-buf: Add constraints sharing information
  cenalloc: Constraint-Enabled Allocation helpers for dma-buf
  cenalloc: Build files for constraint-enabled allocation helpers

 MAINTAINERS                               |   1 +
 drivers/Kconfig                           |   2 +
 drivers/Makefile                          |   1 +
 drivers/cenalloc/Kconfig                  |   8 +
 drivers/cenalloc/Makefile                 |   3 +
 drivers/cenalloc/cenalloc.c               | 597 ++++++++++++++++++++++++++++++
 drivers/cenalloc/cenalloc.h               |  99 +++++
 drivers/cenalloc/cenalloc_priv.h          | 188 ++++++++++
 drivers/cenalloc/cenalloc_system_contig.c | 225 +++++++++++
 drivers/dma-buf/dma-buf.c                 |  50 ++-
 include/linux/device.h                    |   7 +-
 include/linux/dma-buf.h                   |  14 +
 12 files changed, 1189 insertions(+), 6 deletions(-)
 create mode 100644 drivers/cenalloc/Kconfig
 create mode 100644 drivers/cenalloc/Makefile
 create mode 100644 drivers/cenalloc/cenalloc.c
 create mode 100644 drivers/cenalloc/cenalloc.h
 create mode 100644 drivers/cenalloc/cenalloc_priv.h
 create mode 100644 drivers/cenalloc/cenalloc_system_contig.c

-- 
1.9.1

