Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaI2Ldi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:33:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaI2Ldg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:33:36 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com, torvalds@linux-foundation.org
Subject: [RESEND PATCH 0/4] x86: /dev/mem fixes
Date: Mon, 29 Sep 2014 13:32:58 +0200
Message-Id: <1411990382-11902-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this is a combination of two patch sets I sent a while ago
1) Prevent possible PTE corruption with /dev/mem mmap
2) x86: allow read/write /dev/mem to access non-system RAM above high_memory

The original thread with both patch sets can be found here
   https://lkml.org/lkml/2014/8/14/229
   lkml: <1408025927-16826-1-git-send-email-fhrbata@redhat.com>

1) Prevent possible PTE corruption with /dev/mem mmap
x86: add arch_pfn_possible helper
x86: add phys addr validity check for /dev/mem mmap

Many thanks goes to Dave Hansen, who helped with the "final" check. Other than
that it did not get much attention, except H. Peter Anvin's complain that having
two checks for mmap and read/write for /dev/mem access is ridiculous. I for sure
do not object to this, but AFAICT it's not that simple to unify them and it's not
"directly" related to the PTE corruption. Please note that there are other
archs(ia64, arm) using these check. But I for sure can be missing something.

What this patch set does is using the existing interface to implement x86 specific
check in the least invasive way.

Anyway I tried to remove the high_memory check with a follow-up patch set 2)

2) x86: allow read/write /dev/mem to access non-system RAM above high_memory
x86: add high_memory check to (xlate|unxlate)_dev_mem_ptr
x86: remove high_memory check from valid_phys_addr_range

This is an attempt to remove the high_memory limit for the read/write access to
/dev/mem. IMHO there is no reason for this limit on x86. It is presented in
the generic valid_phys_addr_range, which is used only by (read|write)_mem. IIUIC
it's main purpose is for the generic xlate_dev_mem_ptr, which is using only the
direct kernel mapping __va translation. Since the valid_phys_addr_range is
called as the first check in (read|write)_mem, it basically does not allow to
access anything above high_memory on x86.

The first patch adds high_memory check to x86's (xlate|unxlate)_dev_mem_ptr, so
the direct kernel mapping can be safely used for system RAM bellow high_memory.
This is IMHO the only valid reason to use high_memory check in (read|write)_mem.

The second patch removes the high_memory check from valid_phys_addr_range,
allowing read/write to access non-system RAM above high_memory. So far this
was possible only by using mmap.

I hope I haven't overlooked something.

Many thanks

Frantisek Hrbata (4):
  x86: add arch_pfn_possible helper
  x86: add phys addr validity check for /dev/mem mmap
  x86: add high_memory check to (xlate|unxlate)_dev_mem_ptr
  x86: remove high_memory check from valid_phys_addr_range

 arch/x86/include/asm/io.h |  4 ++++
 arch/x86/mm/ioremap.c     |  9 ++++++---
 arch/x86/mm/mmap.c        | 12 ++++++++++++
 arch/x86/mm/physaddr.h    |  9 +++++++--
 4 files changed, 29 insertions(+), 5 deletions(-)

-- 
1.9.3

