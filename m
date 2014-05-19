Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaESW6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:58:42 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:53357 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaESW6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:58:40 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/4] x86,mm: vdso fixes for an OOPS and /proc/PID/maps
Date: Mon, 19 May 2014 15:58:30 -0700
Message-Id: <cover.1400538962.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This applies to tip/x86/vdso.  Patch 1/4 is a resend.]

This fixes an OOPS on systems without an HPET and incomplete
information in /proc/PID/maps.

The latter is done by adding a new vm_ops callback to replace
arch_vma_name, which is inflexible and awkward to use correctly.

With this series applied, calling mremap on the vdso results in
sensible output in /proc/PID/maps and the vvar area shows up
correctly.  I don't want to guarantee that mremap on the vdso will
do anything sensible right now, but that's unchanged from before.
In fact, I suspect that mremapping the vdso on 32-bit tasks is
rather broken right now due to sigreturn.

In current kernels, mremapping the vdso blows away the name:
badc0de0000-badc0de2000 r-xp 00000000 00:00 0

Now it doesn't:
badc0de0000-badc0de1000 r-xp 00000000 00:00 0                            [vdso]

As a followup, it might pay to replace install_special_mapping with
a new install_vdso_mapping function that hardcodes the "[vdso]"
name, to separately fix all the other arch_vma_name users (maybe
just ARM?) and then kill arch_vma_name completely.

NB: This touches core mm code.  I'd appreciate some review by the mm
folks.

Andy Lutomirski (4):
  x86,vdso: Fix an OOPS accessing the hpet mapping w/o an hpet
  mm,fs: Add vm_ops->name as an alternative to arch_vma_name
  x86,mm: Improve _install_special_mapping and fix x86 vdso naming
  x86,mm: Replace arch_vma_name with vm_ops->name for vsyscalls

 arch/x86/include/asm/vdso.h  |  6 ++-
 arch/x86/mm/init_64.c        | 20 +++++-----
 arch/x86/vdso/vdso2c.h       |  5 ++-
 arch/x86/vdso/vdso32-setup.c |  7 ----
 arch/x86/vdso/vma.c          | 26 ++++++++-----
 fs/binfmt_elf.c              |  8 ++++
 fs/proc/task_mmu.c           |  6 +++
 include/linux/mm.h           | 10 ++++-
 include/linux/mm_types.h     |  6 +++
 mm/mmap.c                    | 89 +++++++++++++++++++++++++++++---------------
 10 files changed, 124 insertions(+), 59 deletions(-)

-- 
1.9.0

