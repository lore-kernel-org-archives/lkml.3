Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3HWLEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:04:46 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:59180 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3HWLEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:04:23 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v2 0/3] kprobes: add new dma insn slot cache for s390
Date: Fri, 23 Aug 2013 13:04:11 +0200
Message-Id: <1377255854-30163-1-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082311-4966-0000-0000-000006AC0DEE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kpropes insn caches allocate memory areas for insn slots with
module_alloc().  The assumption is that the kernel image and module area
are both within the same +/- 2GB memory area.

This however is not true for s390 where the kernel image resides within
the first 2GB (DMA memory area), but the module area is far away in the
vmalloc area, usually somewhere close below the 4TB area.

For new pc relative instructions s390 needs insn slots that are within +/-
2GB of each area.  That way we can patch displacements of pc-relative
instructions within the insn slots just like x86 and powerpc.

The module area works already with the normal insn slot allocator, however
there is currently no way to get insn slots that are within the first 2GB
on s390 (aka DMA area).

Therefore this patch set modifies the kprobes insn slot cache code in order
to allow to specify a custom allocator for the insn slot cache pages.
In addition architecure can now have private insn slot caches withhout the
need to modify common code.

Patch 1 unifies and simplifies the current insn and optinsn caches
        implementation. This is a preparation which allows to add more
        insn caches in a simple way.

Patch 2 adds the possibility to specify a custom allocator.

Patch 3 makes s390 use the new insn slot mechanisms and adds support for
        pc-relative instructions with long displacements.

v1->v2: add possibility to specifiy a custom allocator and move the new
        dmainsn cache into s390 code and leave common code alone.

Heiko Carstens (3):
  kprobes: unify insn caches
  kprobes: allow to specify custum allocator for insn caches
  s390/kprobes: add support for pc-relative long displacement instructions

 arch/s390/include/asm/kprobes.h |    4 +-
 arch/s390/kernel/kprobes.c      |  144 +++++++++++++++++++++++++++++++++++++--
 include/linux/kprobes.h         |   34 +++++++--
 kernel/kprobes.c                |   95 +++++++++++---------------
 4 files changed, 209 insertions(+), 68 deletions(-)

-- 
1.7.10.4

