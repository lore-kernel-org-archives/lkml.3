Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaHNRrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 13:47:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56801 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753713AbaHNRra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 13:47:30 -0400
Date: Thu, 14 Aug 2014 10:46:52 -0700
From: Kees Cook <keescook@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Mark Salter <msalter@redhat.com>, Nicolas Pitre <nico@linaro.org>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Rabin Vincent <rabin@rab.in>, Rob Herring <robh@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>
Subject: [PULL] ronx update (3.18)
Message-ID: <20140814174652.GA2045@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel,

Once the merge window for 3.17 closes, could you please pull these ARM
fixmap and RO/NX changes for 3.18?

Thanks!

-Kees

The following changes since commit e57e41931134e09fc6c03c8d4eb19d516cc6e59b:

  ARM: wire up memfd_create syscall (2014-08-09 14:07:59 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git tags/ronx-3.18

for you to fetch changes up to 41fc56ee0a0ea765236d86818523be55bca1eee2:

  ARM: mm: allow text and rodata sections to be read-only (2014-08-14 10:36:36 -0700)

----------------------------------------------------------------
This is a series of patches to support CONFIG_RODATA on ARM, so that
the kernel text is RO, and non-text sections default to NX. To support
on-the-fly kernel text patching (via ftrace, kprobes, etc), fixmap
support has been finalized based on several versions of various patches
that are floating around on the mailing list. This series attempts to
include the least intrusive version, so that others can build on it for
future fixmap work.

The series has been heavily tested, and appears to be working correctly:

With CONFIG_ARM_PTDUMP, expected page table permissions are seen in
/sys/kernel/debug/kernel_page_tables.

Using CONFIG_LKDTM, the kernel now correctly detects bad accesses for
for the following lkdtm tests via /sys/kernel/debug/provoke-crash/DIRECT:
        EXEC_DATA
        WRITE_RO
        WRITE_KERN

ftrace works:
        CONFIG_FTRACE_STARTUP_TEST passes
        Enabling tracing works:
                echo function > /sys/kernel/debug/tracing/current_tracer

kprobes works:
        CONFIG_ARM_KPROBES_TEST passes

kexec works:
        kexec will load and start a new kernel

Built with and without CONFIG_HIGHMEM, CONFIG_HIGHMEM_DEBUG, and
CONFIG_NR_CPUS=32.

Thanks to everyone who has been testing this series and working on its
various pieces!

----------------------------------------------------------------
Doug Anderson (1):
      arm: kgdb: Handle read-only text / modules

Kees Cook (3):
      arm: fixmap: implement __set_fixmap()
      ARM: mm: allow non-text sections to be non-executable
      ARM: mm: allow text and rodata sections to be read-only

Mark Salter (1):
      arm: use generic fixmap.h

Nikolay Borisov (1):
      ARM: kexec: Make .text R/W in machine_kexec

Rabin Vincent (1):
      arm: use fixmap for text patching when text is RO

Rob Herring (1):
      ARM: expand fixmap region to 3MB

 Documentation/arm/memory.txt      |   2 +-
 arch/arm/include/asm/cacheflush.h |  10 +++
 arch/arm/include/asm/fixmap.h     |  31 ++++----
 arch/arm/kernel/Makefile          |   2 +-
 arch/arm/kernel/ftrace.c          |  19 +++++
 arch/arm/kernel/jump_label.c      |   2 +-
 arch/arm/kernel/kgdb.c            |  29 +++++++
 arch/arm/kernel/machine_kexec.c   |   9 ++-
 arch/arm/kernel/patch.c           |  79 +++++++++++++++++--
 arch/arm/kernel/patch.h           |  12 ++-
 arch/arm/kernel/vmlinux.lds.S     |  20 +++++
 arch/arm/mm/Kconfig               |  21 ++++++
 arch/arm/mm/highmem.c             |  15 ++--
 arch/arm/mm/init.c                | 154 +++++++++++++++++++++++++++++++++++++-
 arch/arm/mm/mmu.c                 |  38 +++++++++-
 15 files changed, 399 insertions(+), 44 deletions(-)

-- 
Kees Cook
Chrome OS Security
