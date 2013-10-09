Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3JIAOM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 20:14:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60557 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3JIAOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 20:14:09 -0400
Date: Wed, 09 Oct 2013 01:14:07 +0100
To: torvalds@linux-foundation.org
Subject: [RFC][PATCH 00/13] coredump cleanups
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VThPj-0002vI-LM@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	This series tries to regularize the coredump writes/seeks/rlimit handling
etc.  Quite a bit of boilerplate code removed, another open-coded caller of
->write() converted to use of normal codepath (which was the original reason
I've got into that mess).  RLIMIT_CORE handling got a lot more uniform,
short writes handling fixed (we had weird cases where a very large ->write()
to pipe might happen and where short write had been treated as an error).

	It needs more testing; I don't have any test setups that could deal
with spufs, for example, and while it seems to produce normal coredumps on
what I have tested, I'd still like more eyes on it.

	The same series is in the tip of vfs.git#experimental, so if you prefer
git access for review...

Shortlog:
      restore 32bit aout coredump
      new helper: dump_emit()
      switch elf_core_write_extra_phdrs() to dump_emit()
      switch elf_core_write_extra_data() to dump_emit()
      binfmt_elf: convert writing actual dump pages to dump_emit()
      convert the rest of binfmt_elf_fdpic to dump_emit()
      switch elf_coredump_extra_notes_write() to dump_emit()
      aout: switch to dump_emit
      binfmt_elf: count notes towards coredump limit
      make dump_emit() use vfs_write() instead of banging at ->f_op->write directly
      dump_skip(): dump_seek() replacement taking coredump_params
      spufs: get rid of dump_emit() wrappers
      new helper: dump_align()

Diffstat:
 arch/ia64/kernel/elfcore.c                   |   12 +--
 arch/powerpc/include/asm/spu.h               |    3 +-
 arch/powerpc/platforms/cell/spu_syscalls.c   |    5 +-
 arch/powerpc/platforms/cell/spufs/coredump.c |   89 ++++++--------------
 arch/powerpc/platforms/cell/spufs/spufs.h    |    3 +-
 arch/x86/ia32/ia32_aout.c                    |   86 ++++++++++----------
 arch/x86/um/elfcore.c                        |   15 +---
 fs/binfmt_aout.c                             |    9 +-
 fs/binfmt_elf.c                              |   84 ++++++-------------
 fs/binfmt_elf_fdpic.c                        |  114 +++++++-------------------
 fs/coredump.c                                |   64 +++++++++------
 include/linux/binfmts.h                      |    1 +
 include/linux/coredump.h                     |    6 +-
 include/linux/elf.h                          |    6 +-
 include/linux/elfcore.h                      |    7 +-
 kernel/elfcore.c                             |   10 +--
 16 files changed, 196 insertions(+), 318 deletions(-)

