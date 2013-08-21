Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3HUMBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:01:47 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:51358 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3HUMBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:01:23 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 0/3] kprobes: add new dma insn slot cache for s390
Date: Wed, 21 Aug 2013 14:01:02 +0200
Message-Id: <1377086465-6471-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082111-0542-0000-0000-00000633F588
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kpropes insn caches allocate memory areas for insn slots with
module_alloc(). The assumption is that the kernel image and module area
are both within the same +/- 2GB memory area.
This however is not true for s390 where the kernel image resides within
the first 2GB (DMA memory area), but the module area is far away in the
vmalloc area, usually somewhere close below the 4TB area.

For new pc relative instructions s390 needs insn slots that are within
+/- 2GB of each area. That way we can patch displacements of pc-relative
instructions within the insn slots just like x86 and powerpc.

The module area works already with the normal insn slot allocator, however
there is currently no way to get insn slots that are within the first 2GB
on s390 (aka DMA area).

Therefore this patch set introduces a third insn slot cache besides the
normal insn and optinsn slot caches: the dmainsn slot cache. Slots can be
allocated and freed with get_dmainsn_slot() and free_dmainsn_slot().

Patch 1 unifies the current insn and optinsn caches implementation so we
don't end up with a lot of code duplication when adding a third cache.

Patch 2 simply adds the new dmainsn slot cache.

Patch 3 is the s390 usage of the new cache.

Looking at the last couple of sign-off chains I'm not sure how kprobes
patches should go upstream.. Andrew, Ingo, or simply via the s390 tree?

Heiko Carstens (3):
  kprobes: unify insn caches
  kprobes: provide new dmainsn cache
  s390/kprobes: add support for pc-relative long displacement instructions

 arch/Kconfig                    |    7 +++
 arch/s390/Kconfig               |    1 +
 arch/s390/include/asm/kprobes.h |    4 +-
 arch/s390/kernel/kprobes.c      |  124 ++++++++++++++++++++++++++++++++++++---
 include/linux/kprobes.h         |   31 ++++++++--
 kernel/kprobes.c                |   98 +++++++++++++++----------------
 6 files changed, 203 insertions(+), 62 deletions(-)

-- 
1.7.10.4

