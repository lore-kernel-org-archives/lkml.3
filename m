Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaHTP0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:26:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbaHTP0H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:26:07 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com, akpm@linux-foundation.org, dave.hansen@intel.com,
        dvlasenk@redhat.com, prarit@redhat.com, lwoodman@redhat.com,
        hannsj_uhl@de.ibm.com
Subject: [PATCH 0/2] x86: allow read/write /dev/mem to access non-system RAM above high_memory
Date: Wed, 20 Aug 2014 17:25:24 +0200
Message-Id: <1408548326-18665-1-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1408103043-31015-1-git-send-email-fhrbata@redhat.com>
References: <1408103043-31015-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch set depends on the following patches posted earlier.

[PATCH V2 1/2] x86: add arch_pfn_possible helper
   lkml: Message-Id: <1408103043-31015-2-git-send-email-fhrbata@redhat.com>
[PATCH V2 2/2] x86: add phys addr validity check for /dev/mem mmap
   lkml: Message-Id: <1408103043-31015-3-git-send-email-fhrbata@redhat.com>

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
allowing read/write to access non-system RAM above high_memory. So far this was
possible only by using mmap.

I hope I haven't overlooked something.

Many thanks

Frantisek Hrbata (2):
  x86: add high_memory check to (xlate|unxlate)_dev_mem_ptr
  x86: remove high_memory check from valid_phys_addr_range

 arch/x86/mm/ioremap.c | 9 ++++++---
 arch/x86/mm/mmap.c    | 2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

-- 
1.9.3

