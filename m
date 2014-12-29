Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176AbaL2OuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 09:50:00 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28927 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbaL2Ot7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 09:49:59 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-bd-54a16a14fbb8
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-mm@kvack.org
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/4] kstrdup optimization
Date: Mon, 29 Dec 2014 15:48:26 +0100
Message-id: <1419864510-24834-1-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEJMWRmVeSWpSXmKPExsVy+t/xq7oiWQtDDN48N7O4te4cq8XlXXPY
	LO6t+c9qsfbIXXYHFo9Nnyaxe/RtWcXo8XmTXABzFJdNSmpOZllqkb5dAlfGnzl7WQpmClS8
	a5nB2sB4hqeLkZNDQsBEYtrj3+wQtpjEhXvr2boYuTiEBJYySqzctpURwuljkji36xRYFZuA
	psTfzTfZQGwRoI6PZy4zdzFycDALlEjcOisGYgoL6EocOG8CYrIIqEp8WCgKUswr4Cyx7d8T
	JohVchInj01mncDIvYCRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGiL+/7mBceszqEKMA
	B6MSD2/CiQUhQqyJZcWVuYcYJTiYlUR4pS0XhgjxpiRWVqUW5ccXleakFh9iZOLglGpgrL3H
	vFGJbeuPmAULv7AIvpgXs6+t5gnbCgfFLrOuxi1fI3zaX77aXMR4blbv5zNck1U3Gi3+N7NC
	wOVN8KW1lc9Ltb5fF3ncrf0naU7roehDi10mvOab5SbowittOPn8FZ/Uv+87fVJ+f+tpn6ej
	t1R3n8b0BSLlRzhflFvMFdRwND5xfEHVHSWW4oxEQy3mouJEAEcFD6zVAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

kstrdup if often used to duplicate strings where neither source neither
destination will be ever modified. In such case we can just reuse the source
instead of duplicating it. The problem is that we must be sure that
the source is non-modifiable and its life-time is long enough.

I suspect the good candidates for such strings are strings located in kernel
.rodata section, they cannot be modifed because the section is read-only and
their life-time is equal to kernel life-time.

This small patchset proposes alternative version of kstrdup - kstrdup_const,
which returns source string if it is located in .rodata otherwise it fallbacks
to kstrdup.
To verify if the source is in .rodata function checks if the address is between
sentinels __start_rodata, __end_rodata, I think it is OK, but maybe sombebody
with deeper knowledge can say if it is OK for all supported architectures and
configuration options.

The main patch is accompanied by three patches constifying kstrdup for cases
where situtation described above happens frequently.

The patchset is based on next-20141226.

As I have tested it on mobile platform (exynos4210-trats) it saves above 2600
string duplications. Below simple stats about the most frequent duplications:
Count String
  880 power
  874 subsystem
  130 device
  126 parameters
   61 iommu_group
   40 driver
   28 bdi
   28 none
   25 sclk_mpll
   23 sclk_usbphy0
   23 sclk_hdmi24m
   23 xusbxti
   22 sclk_vpll
   22 sclk_epll
   22 xxti
   20 sclk_hdmiphy
   11 aclk100

Regards
Andrzej


Andrzej Hajda (4):
  mm/util: add kstrdup_const
  kernfs: use kstrdup_const for node name allocation
  clk: use kstrdup_const for clock name allocations
  mm/slab: use kstrdup_const for allocating cache names

 drivers/clk/clk.c      | 12 ++++++------
 fs/kernfs/dir.c        | 12 ++++++------
 include/linux/string.h |  3 +++
 mm/slab_common.c       |  6 +++---
 mm/util.c              | 22 ++++++++++++++++++++++
 5 files changed, 40 insertions(+), 15 deletions(-)

-- 
1.9.1

