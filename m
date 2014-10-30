Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbaJ3AmY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 20:42:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36592 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbaJ3AmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 20:42:23 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: akpm@linux-foundation.org, linux-mm@kvack.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 0/6] mm, x86: New special mapping ops
Date: Wed, 29 Oct 2014 17:42:10 -0700
Message-Id: <cover.1414629045.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt to make the core special mapping infrastructure
track what arch vdso code needs better than it currently does.  It
adds:

.start_addr_set: A callback to notify arch code that a special mapping
was mremapped.  (CRIU does this.  Without something like this, it's
somewhat broken for 64-bit userspace and completely broken for 32-bit
userspace on Intel hardware.  Apparently no one has noticed the 64-bit
breakage, and no one ever ported CRIU to 32-bit in the first place.)

.fault: Directly fault handling on the vdso.  Imagine that!  It turns
out that storing a list of struct page pointers in the special mapping
data is awkward for pretty much everyone and completely precludes
mapping things that aren't pages without dirty hacks.  (x86 uses dirty
hacks for the HPET mapping.  See below.)

vm_insert_pfn_prot: The only way to support VMAs with different
protections on different pages right now is to either use
(io_)remap_pfn_range or to twiddle the ptes directly.  This is annoying.

One might ask why anyone would ever want different prot values in the
same VMA.  It turns out that x86 maps the HPET into the vvar area, and
the HPET needs to be uncached.

I think that this kind of trick makes no sense on a COW-able mapping or
on any mapping that isn't a pure PFN mapping.  The new interface
enforces this.

The x86 parts are in here mainly as examples for how the new core
interfaces would be used.  I don't know of anything wrong with them,
but I would not go so far as to pretend that I've tested them adequately.

Andy Lutomirski (6):
  mm: Add a mechanism to track the current address of a special mapping
  x86,vdso: Use special mapping tracking for the vdso
  mm: Add a vm_special_mapping .fault method
  mm: Add vm_insert_pfn_prot
  x86,vdso: Use .fault instead of remap_pfn_range for the vvar mapping
  x86,vdso: Use .fault for the vdso text mapping

 arch/x86/ia32/ia32_signal.c |  11 ++--
 arch/x86/include/asm/elf.h  |  26 +++-----
 arch/x86/include/asm/mmu.h  |   4 +-
 arch/x86/include/asm/vdso.h |  19 +++++-
 arch/x86/kernel/signal.c    |   9 +--
 arch/x86/vdso/vdso2c.h      |   7 ---
 arch/x86/vdso/vma.c         | 141 +++++++++++++++++++++++++++++++-------------
 include/linux/mm.h          |   5 ++
 include/linux/mm_types.h    |  26 +++++++-
 mm/memory.c                 |  25 +++++++-
 mm/mmap.c                   |  38 +++++++++---
 mm/mremap.c                 |   2 +
 12 files changed, 221 insertions(+), 92 deletions(-)

-- 
1.9.3

