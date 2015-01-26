Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbbAZX34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:29:56 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:54941 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbbAZX3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:29:53 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, arnd@arndb.de, linux-mm@kvack.org
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/7] Kernel huge I/O mapping support
Date: Mon, 26 Jan 2015 16:13:22 -0700
Message-Id: <1422314009-31667-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioremap() and its related interfaces are used to create I/O
mappings to memory-mapped I/O devices.  The mapping sizes of
the traditional I/O devices are relatively small.  Non-volatile
memory (NVM), however, has many GB and is going to have TB soon.
It is not very efficient to create large I/O mappings with 4KB. 

This patch extends the ioremap() interfaces to transparently
create I/O mappings with huge pages.  There is no change necessary
to the drivers using ioremap().  Using huge pages will improve
performance of NVM and other devices with large memory, and reduce
the time to create their mappings as well.

The patchset introduces the following configs:
 HUGE_IOMAP - When selected, enable huge I/O mappings.  Require
              HAVE_ARCH_HUGE_VMAP set.
 HAVE_ARCH_HUGE_VMAP - Indicate arch supports huge KVA mappings

Patch 1-4 changes common files to support huge I/O mappings.  There
is no change in the functinalities until HUGE_IOMAP is set in patch 7.

Patch 5,6 implement HAVE_ARCH_HUGE_VMAP and HUGE_IOMAP funcs on x86,
and set HAVE_ARCH_HUGE_VMAP on x86.

Patch 7 adds HUGE_IOMAP to Kconfig, which is set to Y by default on
x86.

---
Toshi Kani (7):
  1/7 mm: Change __get_vm_area_node() to use fls_long()
  2/7 lib: Add huge I/O map capability interfaces
  3/7 mm: Change ioremap to set up huge I/O mappings
  4/7 mm: Change vunmap to tear down huge KVA mappings
  5/7 x86, mm: Support huge KVA mappings on x86
  6/7 x86, mm: Support huge I/O mappings on x86
  7/7 mm: Add config HUGE_IOMAP to enable huge I/O mappings

---
 Documentation/kernel-parameters.txt |  2 ++
 arch/Kconfig                        |  3 ++
 arch/x86/Kconfig                    |  1 +
 arch/x86/include/asm/page_types.h   |  8 +++++
 arch/x86/mm/ioremap.c               | 16 ++++++++++
 arch/x86/mm/pgtable.c               | 32 ++++++++++++++++++++
 include/asm-generic/pgtable.h       | 12 ++++++++
 include/linux/io.h                  |  5 ++++
 lib/ioremap.c                       | 60 +++++++++++++++++++++++++++++++++++++
 mm/Kconfig                          | 10 +++++++
 mm/vmalloc.c                        |  8 ++++-
 11 files changed, 156 insertions(+), 1 deletion(-)
