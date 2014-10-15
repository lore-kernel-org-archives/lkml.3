Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaJORFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:05:46 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:59353 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJORFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:05:43 -0400
Subject: [PATCH v1 00/10] Remove weak function declarations
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:05:41 -0600
Message-ID: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common usage of "weak" is for a default implementation of a function.
An architecture that needs something different can supply a non-weak
("strong") implementation, with the expectation that the linker will select
the strong version and discard the weak default version.

We have a few function declarations in header files annotated as "weak".
That causes every *every* definition to be marked "weak", which means there
is no strong version at all.  In this case, the linker selects one of the
weak versions based on link order.  I don't think this is what we want.

These patches remove almost all the weak annotations from header files
(MIPS still uses it for get_c0_compare_int(), apparently relying on the
fact that a weak symbol need not be defined at all).  In most cases, the
default implementation was already marked weak at the definition.  When it
wasn't, I added that.

It might be simplest if I ask Linus to pull these all as a group from my
branch [1].  I'll look for acks from the following people.  If I don't see
an ack, I'll drop the patch and you can take it yourself or ignore it as
you wish.

  Eric:                    audit
  Thomas, Ingo, or Peter:  x86
  Ralf:                    MIPS
  John or Thomas:          clocksource
  Jason:                   kgdb
  Ingo:                    uprobes
  Andrew:                  vmcore, memory-hotplug

I don't know whether these fix any actual bugs.  We *did* have a bug like
this on MIPS a while ago (10629d711ed7 ("PCI: Remove __weak annotation from
pcibios_get_phb_of_node decl")), so it's possible that they do fix
something.

[1] https://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=remove-weak-function-declarations

---

Bjorn Helgaas (10):
      audit: Remove "weak" from audit_classify_compat_syscall() declaration
      x86, intel-mid: Remove "weak" from function declarations
      MIPS: CPC: Make mips_cpc_phys_base() static
      MIPS: Remove "weak" from platform_maar_init() declaration
      MIPS: MT: Move "weak" from vpe_run() declaration to definition
      clocksource: Remove "weak" from clocksource_default_clock() declaration
      vmcore: Remove "weak" from function declarations
      kgdb: Remove "weak" from kgdb_arch_pc() declaration
      memory-hotplug: Remove "weak" from memory_block_size_bytes() declaration
      uprobes: Remove "weak" from function declarations


 arch/mips/include/asm/maar.h                       |    2 +-
 arch/mips/include/asm/mips-cpc.h                   |   10 ----------
 arch/mips/include/asm/vpe.h                        |    2 +-
 arch/mips/kernel/mips-cpc.c                        |    2 +-
 arch/mips/kernel/vpe-mt.c                          |    2 +-
 arch/x86/platform/intel-mid/intel_mid_weak_decls.h |    7 +++----
 include/linux/audit.h                              |    2 +-
 include/linux/clocksource.h                        |    2 +-
 include/linux/crash_dump.h                         |   15 +++++++--------
 include/linux/kgdb.h                               |    2 +-
 include/linux/memory.h                             |    2 +-
 include/linux/uprobes.h                            |   14 +++++++-------
 12 files changed, 25 insertions(+), 37 deletions(-)
