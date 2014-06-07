Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750851AbaFGEfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 00:35:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:38875 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaFGEff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 00:35:35 -0400
Message-ID: <1402115699.3247.286.camel@pasglop>
Subject: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 07 Jun 2014 14:34:59 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here is the bulk of the powerpc changes for this merge window. It got a bit
delayed in part because I wasn't paying attention, and in part because I
discovered I had a core PCI change without a PCI maintainer ack in it. Bjorn
eventually agreed it was ok to merge it though we'll probably improve it
later and I didn't want to rebase to add his ack.

There is going to be a bit more next week, essentially fixes that I still
want to sort through and test.

The biggest item this time is the support to build the ppc64 LE kernel
with our new v2 ABI. We previously supported v2 userspace but the kernel
itself was a tougher nut to crack. This is now sorted mostly thanks to Anton
and Rusty.

We also have a fairly big series from Cedric that add support for 64-bit
LE zImage boot wrapper. This was made harder by the fact that traditionally
our zImage wrapper was always 32-bit, but our new LE toolchains don't really
support 32-bit anymore (it's somewhat there but not really "supported") so
we didn't want to rely on it. This meant more churn that just endian fixes.

This brings some more LE bits as well, such as the ability to run in LE mode
without a hypervisor (ie. under OPAL firmware) by doing the right OPAL call
to reinitialize the CPU to take HV interrupts in the right mode and the usual
pile of endian fixes. 

There's another series from Gavin adding EEH improvements (one day we *will*
have a release with less than 20 EEH patches, I promise !).

Another highlight is the support for the "Split core" functionality on P8
by Michael. This allows a P8 core to be split into "sub cores" of 4 threads
which allows the subcores to run different guests under KVM (the HW still
doesn't support a partition per thread).

And then the usual misc bits and fixes ...

Cheers,
Ben.

The following changes since commit 011e4b02f1da156ac7fea28a9da878f3c23af739:

  powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST mode (2014-05-28 13:24:26 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

for you to fetch changes up to 0c0a3e5a100bbc4aaedd140e82b429227a76701b:

  powerpc/powernv: Add missing include to LPC code (2014-06-07 08:57:21 +1000)

----------------------------------------------------------------
Alexander Graf (2):
      powerpc: Use 64k io pages when we never see an HEA
      PPC: ePAPR: Fix hypercall on LE guest

Alistair Popple (4):
      IBM Currituck: Clean up board specific code before adding Akebono code
      IBM Akebono: Add the Akebono platform
      powerpc: Added PCI MSI support using the HSTA module
      ppc476: Enable a linker work around for IBM errata #46

Andrew Murray (1):
      powerpc/pci: Use of_pci_range_parser helper in pci_process_bridge_OF_ranges

Anton Blanchard (36):
      powerpc: Don't build assembly files with ABIv2
      powerpc: No need to use dot symbols when branching to a function
      powerpc: Remove superflous function descriptors in assembly only code
      powerpc: Don't use a function descriptor for system call table
      powerpc: Remove some unnecessary uses of _GLOBAL() and _STATIC()
      powerpc: Remove _INIT_GLOBAL(), _STATIC() and _INIT_STATIC()
      powerpc: Remove dot symbol usage in exception macros
      powerpc: Create DOTSYM to wrap dot symbol usage
      powerpc: Remove function descriptors and dot symbols on new ABI
      powerpc: ABIv2 function calls must place target address in r12
      powerpc: Ignore .TOC. relocations
      powerpc: Add ABIv2 support to ppc_function_entry
      powerpc: Use ppc_function_entry instead of open coding it
      powerpc: Fix branch patching code for ABIv2
      powerpc: Fix kernel thread creation on ABIv2
      powerpc: Fix ABIv2 issues with stack offsets in assembly code
      powerpc/tm: Use STK_PARAM
      powerpc/tm: Fix GOT save offset for ABIv2
      powerpc/tracing: TRACE_WITH_FRAME_BUFFER creates invalid stack frames
      powerpc: Fix SMP issues with ppc64le ABIv2
      powerpc: Fix ABIv2 issue with dereference_function_descriptor
      powerpc: Add _GLOBAL_TOC for ABIv2 assembly functions exported to modules
      powerpc: ftrace_caller, _mcount is exported to modules so needs _GLOBAL_TOC()
      powerpc/kprobes: Fix ABIv2 issues with kprobe_lookup_name
      powerpc/modules: Create is_module_trampoline()
      powerpc/modules: Create module_trampoline_target()
      powerpc/ftrace: Use module loader helpers to parse trampolines
      powerpc/ftrace: Fix ABIv2 issues with __ftrace_make_call
      powerpc: Build little endian ppc64 kernel with ABIv2
      selftests/powerpc: Update for ABIv2
      powerpc: 64bit sendfile is capped at 2GB
      powerpc/powernv: Fix endian issues in memory error handling code
      powerpc: Allow ppc_md platform hook to override memory_block_size_bytes
      powerpc/powernv: Set memory_block_size_bytes to 256MB
      powerpc: Exported functions __clear_user and copy_page use r2 so need _GLOBAL_TOC()
      powerpc/pseries: hcall functions are exported to modules, need _GLOBAL_TOC()

Benjamin Herrenschmidt (10):
      Merge commit 'f3cae355a962784101478504ef7f6a389ad62979' into next
      Merge remote-tracking branch 'anton/abiv2' into next
      Revert "powerpc/powernv: Fundamental reset on PLX ports"
      powerpc/powernv: Add calls to support little endian host
      powerpc/serial: Use saner flags when creating legacy ports
      powerpc/powernv: Provide debugfs access to the LPC bus via OPAL
      powerpc/powernv: Add missing include to LPC code

Cédric Le Goater (15):
      powerpc/boot: Fix do_div for 64bit wrapper
      powerpc/boot: Use a common prom_args struct in oflib
      powerpc/boot: Use prom_arg_t in oflib
      powerpc/boot: Add byteswapping routines in oflib
      powerpc/boot: Add PROM_ERROR define in oflib
      powerpc/boot: Rework of_claim() to make it 64bit friendly
      powerpc/boot: Define typedef ihandle as u32
      powerpc/boot: Fix compile warning in 64bit
      powerpc/boot: Define byteswapping routines for little endian
      powerpc/boot: Add 64bit and little endian support to addnote
      powerpc/boot: Add little endian support to elf utils
      powerpc/boot: Define a routine to enter prom
      powerpc/boot: Modify entry point for 64bit
      powerpc/boot: Add a global entry point for pseries
      powerpc/boot: Add support for 64bit little endian wrapper

Diana Craciun (3):
      powerpc/fsl: Added binding for Freescale CoreNet coherency fabric (CCF)
      powerpc/fsl: Updated device trees for platforms with corenet version 2
      powerpc/fsl: Updated corenet-cf compatible string for corenet1-cf chips

Gautham R. Shenoy (2):
      powerpc: powernv: Framework to show the correct clock in /proc/cpuinfo
      powerpc: powernv: Implement ppc_md.get_proc_freq()

Gavin Shan (25):
      powerpc/eeh: Remove EEH_PE_PHB_DEAD
      powerpc/powernv: Remove PNV_EEH_STATE_REMOVED
      powerpc/powernv: Move PNV_EEH_STATE_ENABLED around
      powerpc/powernv: Remove fields in PHB diag-data dump
      powerpc/eeh: EEH_PE_ISOLATED not reflect HW state
      powerpc/eeh: Block PCI-CFG access during PE reset
      powerpc/powernv: Use EEH PCI config accessors
      powerpc/eeh: Avoid I/O access during PE reset
      powerpc/eeh: Cleanup eeh_gather_pci_data()
      powerpc/eeh: Use cached capability for log dump
      powerpc/eeh: Cleanup EEH subsystem variables
      powerpc/eeh: Allow to disable EEH
      powerpc/eeh: No hotplug on permanently removed dev
      powerpc/powernv: Fix endless reporting frozen PE
      powerpc/pseries: Fix overwritten PE state
      powerpc/powernv: Reset root port in firmware
      powerpc/eeh: Make the delay for PE reset unified
      powerpc/pci: Mask linkDown on resetting PCI bus
      powrpc/powernv: Reset PHB in kdump kernel
      powerpc/eeh: Can't recover from non-PE-reset case
      powerpc/powernv: Fundamental reset on PLX ports
      powerpc/powernv: Missed IOMMU table type
      powerpc/powernv: Don't use pe->pbus to get the domain number
      powerpc/prom: Stop scanning dev-tree for fdump early
      powerpc/eeh: Fix build error for celleb

James Hogan (1):
      powerpc: Remove non-uapi linkage.h export

Jeff Bailey (1):
      powerpc: Clear ELF personality flag if ELFv2 is not requested.

Lijun Pan (1):
      powerpc/mpc85xx: Remove P1023 RDS support

Liu Gang (1):
      powerpc/rmu: Fix the error memory free parameters

Liu Ping Fan (1):
      powerpc/mm: use macro PGTABLE_EADDR_SIZE instead of digital

Martijn de Gouw (1):
      powerpc/85xx: Add OCA4080 board support

Michael Ellerman (10):
      powerpc/kvm/book3s_hv: Rework the secondary inhibit code
      powerpc/powernv: Make it possible to skip the IRQHAPPENED check in power7_nap()
      powerpc: Add threads_per_subcore
      powerpc: Check cpu_thread_in_subcore() in __cpu_up()
      powerpc/kvm/book3s_hv: Use threads_per_subcore in KVM
      powerpc/powernv: Add support for POWER8 split core on powernv
      powerpc/xmon: Fix up xmon format strings
      powerpc: Add cpu family documentation
      powerpc/mm: Check paca psize is up to date for huge mappings
      selftests/powerpc: Test the THP bug we fixed in the previous commit

Michael Neuling (2):
      powerpc/tm: Remove unnecessary r1 save
      powerpc/tm: Add checking to treclaim/trechkpt

Nishanth Aravamudan (2):
      powerpc/numa: Enable USE_PERCPU_NUMA_NODE_ID
      powerpc/numa: Enable CONFIG_HAVE_MEMORYLESS_NODES

Paul Gortmaker (2):
      powerpc: Drop return value from set_breakpoint as it is unused
      powerpc: Fix smp_processor_id() in preemptible splat in set_breakpoint

Philippe Bergheaud (1):
      powerpc: memcpy optimization for 64bit LE

Prabhakar Kushwaha (2):
      powerpc/mpc85xx:Add initial device tree support of T104x
      powerpc/fsl-booke: Add initial T104x_QDS board support

Preeti U Murthy (1):
      powerpc: Fix comment around arch specific definition of RECLAIM_DISTANCE

Rickard Strandqvist (2):
      macintosh/windfarm_pm121.c: Fix for possible null pointer dereference
      arch: powerpc/fadump: Cleaning up inconsistent NULL checks

Rusty Russell (12):
      powerpc: make module stub code endian independent
      powerpc: modules implement R_PPC64_TOCSAVE relocation.
      powerpc: EXPORT_SYMBOL(.TOC.)
      powerpc: module: handle MODVERSION for .TOC.
      powerpc: Fix up TOC. for modules.
      powerpc: Handle new ELFv2 module relocations
      powerpc: modules: comment about de-dotifying symbols when using the ELFv2 ABI.
      powerpc: modules: change r2 save/restore offset for ELFv2 ABI.
      powerpc: modules: use r12 for stub jump address.
      powerpc: modules: skip r2 setup for ELFv2
      powerpc: modules: implement stubs for ELFv2 ABI.
      powerpc/module: Fix stubs for BE

Sam bobroff (3):
      powerpc: Split __SYSFS_SPRSETUP macro
      powerpc: Fix regression of per-CPU DSCR setting
      powerpc: Document sysfs DSCR interface

Scott Wood (6):
      powerpc/fsl-rio: Fix fsl_rio_setup error paths and use-after-unmap
      powerpc/fsl-booke64: Set vmemmap_psize to 4K
      powerpc: fix build of epapr_paravirt on 64-bit book3s
      powerpc: Fix unused variable warning for epapr_has_idle
      powerpc/mpic: Don't init the fsl error int until after mpic init
      powerpc/fsl: Add fsl,portid-mapping to corenet1-cf chips

Stephen Chivers (1):
      powerpc/legacy_serial: Support MVME5100 UARTS with shifted registers

Stuart Yoder (1):
      powerpc: move epapr paravirt init of power_save to an initcall

Tang Yuantian (1):
      clk: qoriq: Update the clock bindings

Tony Breeds (1):
      powerpc/le: Show the endianess of the LPAR under PowerVM.

Ulrich Weigand (1):
      powerpc: Fix unsafe accesses to parameter area in ELFv2

Valentin Longchamp (3):
      devicetree: bindings: add Zarlink to the vendor prefixes
      devcietree: bindings: add some MFD Keymile FPGAs
      powerpc/mpc85xx: add support for Keymile's kmcoge4 board

Vasant Hegde (2):
      powerpc/powernv: Return secondary CPUs to firmware before FW update
      powerpc/powernv: Pass buffer size to OPAL validate flash call

Wang Dongsheng (1):
      fsl/pci: fix RC cannot detect PME message coming

Wei Yang (1):
      powerpc/eeh: Skip eeh sysfs when eeh is disabled

harninder rai (1):
      powerpc/mpc85xx: Add BSC9132 QDS Support

 Documentation/ABI/stable/sysfs-devices-system-cpu  |  25 ++
 .../clock/{corenet-clock.txt => qoriq-clock.txt}   |  10 +-
 Documentation/devicetree/bindings/mfd/bfticu.txt   |  25 ++
 Documentation/devicetree/bindings/mfd/qriox.txt    |  17 +
 .../devicetree/bindings/powerpc/4xx/akebono.txt    |  54 +++
 .../devicetree/bindings/powerpc/4xx/hsta.txt       |  19 +
 .../devicetree/bindings/powerpc/fsl/board.txt      |  17 +
 .../devicetree/bindings/powerpc/fsl/ccf.txt        |  46 +++
 .../devicetree/bindings/powerpc/fsl/cpus.txt       |  11 +
 .../devicetree/bindings/powerpc/fsl/pamu.txt       |  10 +
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 Documentation/powerpc/cpu_families.txt             | 221 +++++++++++
 arch/powerpc/Kconfig                               |   8 +
 arch/powerpc/Makefile                              |  16 +-
 arch/powerpc/boot/Makefile                         |  24 +-
 arch/powerpc/boot/addnote.c                        | 128 +++---
 arch/powerpc/boot/crt0.S                           | 180 ++++++++-
 arch/powerpc/boot/dcr.h                            |   4 +
 arch/powerpc/boot/dts/akebono.dts                  | 415 ++++++++++++++++++++
 arch/powerpc/boot/dts/b4860emu.dts                 |   7 +-
 arch/powerpc/boot/dts/bsc9132qds.dts               |  35 ++
 arch/powerpc/boot/dts/bsc9132qds.dtsi              | 101 +++++
 arch/powerpc/boot/dts/fsl/b4420si-post.dtsi        |   4 -
 arch/powerpc/boot/dts/fsl/b4420si-pre.dtsi         |   2 +
 arch/powerpc/boot/dts/fsl/b4860si-post.dtsi        |   4 -
 arch/powerpc/boot/dts/fsl/b4860si-pre.dtsi         |   4 +
 arch/powerpc/boot/dts/fsl/b4si-post.dtsi           |   3 +-
 arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi      | 185 +++++++++
 arch/powerpc/boot/dts/fsl/bsc9132si-pre.dtsi       |  66 ++++
 arch/powerpc/boot/dts/fsl/p2041si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/p2041si-pre.dtsi         |   4 +
 arch/powerpc/boot/dts/fsl/p3041si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/p3041si-pre.dtsi         |   4 +
 arch/powerpc/boot/dts/fsl/p4080si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/p4080si-pre.dtsi         |   8 +
 arch/powerpc/boot/dts/fsl/p5020si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/p5020si-pre.dtsi         |   2 +
 arch/powerpc/boot/dts/fsl/p5040si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/p5040si-pre.dtsi         |   4 +
 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi        | 430 +++++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t1042si-post.dtsi        |  37 ++
 arch/powerpc/boot/dts/fsl/t104xsi-pre.dtsi         | 104 +++++
 arch/powerpc/boot/dts/fsl/t4240si-post.dtsi        |   3 +-
 arch/powerpc/boot/dts/fsl/t4240si-pre.dtsi         |  12 +
 arch/powerpc/boot/dts/kmcoge4.dts                  | 152 ++++++++
 arch/powerpc/boot/dts/oca4080.dts                  | 118 ++++++
 arch/powerpc/boot/dts/p1023rds.dts                 | 219 -----------
 arch/powerpc/boot/dts/t1040qds.dts                 |  46 +++
 arch/powerpc/boot/dts/t1042qds.dts                 |  46 +++
 arch/powerpc/boot/dts/t104xqds.dtsi                | 166 ++++++++
 arch/powerpc/boot/dts/t4240emu.dts                 |  15 +-
 arch/powerpc/boot/elf_util.c                       |   4 +
 arch/powerpc/boot/of.c                             |   4 +-
 arch/powerpc/boot/of.h                             |  19 +-
 arch/powerpc/boot/ofconsole.c                      |   6 +-
 arch/powerpc/boot/oflib.c                          |  92 +++--
 arch/powerpc/boot/ppc_asm.h                        |  12 +
 arch/powerpc/boot/pseries-head.S                   |   8 +
 arch/powerpc/boot/stdio.c                          |  14 +
 arch/powerpc/boot/swab.h                           |  29 ++
 arch/powerpc/boot/treeboot-akebono.c               | 163 ++++++++
 arch/powerpc/boot/util.S                           |   4 +-
 arch/powerpc/boot/wrapper                          |  20 +-
 arch/powerpc/boot/zImage.lds.S                     |  25 +-
 arch/powerpc/configs/44x/akebono_defconfig         | 148 +++++++
 arch/powerpc/configs/85xx/kmp204x_defconfig        | 225 +++++++++++
 arch/powerpc/configs/corenet32_smp_defconfig       |   1 +
 arch/powerpc/configs/mpc85xx_defconfig             |   1 -
 arch/powerpc/configs/mpc85xx_smp_defconfig         |   1 -
 arch/powerpc/include/asm/code-patching.h           |  40 +-
 arch/powerpc/include/asm/context_tracking.h        |   4 +-
 arch/powerpc/include/asm/cputhreads.h              |   7 +
 arch/powerpc/include/asm/debug.h                   |   3 +-
 arch/powerpc/include/asm/eeh.h                     |  46 ++-
 arch/powerpc/include/asm/elf.h                     |   2 +
 arch/powerpc/include/asm/exception-64e.h           |   6 +-
 arch/powerpc/include/asm/exception-64s.h           |   2 +-
 arch/powerpc/include/asm/ftrace.h                  |   2 +
 arch/powerpc/include/asm/hw_breakpoint.h           |   2 +-
 arch/powerpc/include/asm/irqflags.h                |   8 +-
 arch/powerpc/include/asm/kprobes.h                 |   5 +-
 arch/powerpc/include/asm/kvm_ppc.h                 |   7 +
 arch/powerpc/include/asm/linkage.h                 |   2 +
 arch/powerpc/include/asm/machdep.h                 |   8 +
 arch/powerpc/include/asm/module.h                  |   4 +
 arch/powerpc/include/asm/opal.h                    |  18 +-
 arch/powerpc/include/asm/paca.h                    |   3 +
 arch/powerpc/include/asm/ppc-pci.h                 |   1 +
 arch/powerpc/include/asm/ppc_asm.h                 |  72 ++--
 arch/powerpc/include/asm/processor.h               |   2 +-
 arch/powerpc/include/asm/reg.h                     |  10 +
 arch/powerpc/include/asm/sections.h                |   2 +
 arch/powerpc/include/asm/smp.h                     |   8 -
 arch/powerpc/include/asm/string.h                  |   4 -
 arch/powerpc/include/asm/systbl.h                  |   8 +-
 arch/powerpc/include/asm/topology.h                |  15 +-
 arch/powerpc/include/uapi/asm/Kbuild               |   1 -
 arch/powerpc/include/uapi/asm/elf.h                |  10 +-
 arch/powerpc/kernel/asm-offsets.c                  |   1 +
 arch/powerpc/kernel/cpu_setup_fsl_booke.S          |  28 +-
 arch/powerpc/kernel/eeh.c                          | 212 ++++++----
 arch/powerpc/kernel/eeh_driver.c                   | 118 +++++-
 arch/powerpc/kernel/eeh_pe.c                       |  47 ++-
 arch/powerpc/kernel/eeh_sysfs.c                    |   3 +
 arch/powerpc/kernel/entry_64.S                     | 126 +++---
 arch/powerpc/kernel/epapr_paravirt.c               |  19 +-
 arch/powerpc/kernel/exceptions-64e.S               | 140 +++----
 arch/powerpc/kernel/exceptions-64s.S               | 206 +++++-----
 arch/powerpc/kernel/fadump.c                       |  13 +-
 arch/powerpc/kernel/ftrace.c                       | 137 ++-----
 arch/powerpc/kernel/head_64.S                      | 117 +++---
 arch/powerpc/kernel/hw_breakpoint.c                |   8 +-
 arch/powerpc/kernel/idle_book3e.S                  |   2 +-
 arch/powerpc/kernel/idle_power4.S                  |   2 +-
 arch/powerpc/kernel/idle_power7.S                  |  13 +-
 arch/powerpc/kernel/legacy_serial.c                |  36 +-
 arch/powerpc/kernel/misc_64.S                      |  46 ++-
 arch/powerpc/kernel/module_64.c                    | 279 ++++++++++---
 arch/powerpc/kernel/pci-common.c                   | 108 +++---
 arch/powerpc/kernel/pci_of_scan.c                  |   9 +
 arch/powerpc/kernel/ppc_ksyms.c                    |   2 -
 arch/powerpc/kernel/process.c                      |  32 +-
 arch/powerpc/kernel/prom_init_check.sh             |   2 +-
 arch/powerpc/kernel/rtas_pci.c                     |  66 +++-
 arch/powerpc/kernel/setup-common.c                 |  20 +-
 arch/powerpc/kernel/setup_64.c                     |  12 +-
 arch/powerpc/kernel/signal.c                       |   2 +-
 arch/powerpc/kernel/smp.c                          |  43 +--
 arch/powerpc/kernel/sysfs.c                        |  51 ++-
 arch/powerpc/kernel/systbl.S                       |  18 +-
 arch/powerpc/kernel/tm.S                           |  69 ++--
 arch/powerpc/kvm/book3s_hv.c                       |  34 +-
 arch/powerpc/kvm/book3s_hv_builtin.c               |  31 ++
 arch/powerpc/kvm/book3s_hv_interrupts.S            |   2 +-
 arch/powerpc/kvm/book3s_hv_rmhandlers.S            |  37 +-
 arch/powerpc/kvm/powerpc.c                         |   2 +-
 arch/powerpc/lib/Makefile                          |   2 -
 arch/powerpc/lib/copypage_64.S                     |   4 +-
 arch/powerpc/lib/copypage_power7.S                 |  12 +-
 arch/powerpc/lib/copyuser_64.S                     |   2 +-
 arch/powerpc/lib/copyuser_power7.S                 |  32 +-
 arch/powerpc/lib/hweight_64.S                      |   8 +-
 arch/powerpc/lib/mem_64.S                          |   4 +-
 arch/powerpc/lib/memcpy_64.S                       |  26 +-
 arch/powerpc/lib/memcpy_power7.S                   |  26 +-
 arch/powerpc/lib/string_64.S                       |   2 +-
 arch/powerpc/mm/hash_low_64.S                      |  44 ++-
 arch/powerpc/mm/hash_utils_64.c                    |  92 +++--
 arch/powerpc/mm/slb.c                              |  12 +-
 arch/powerpc/mm/slb_low.S                          |  14 +-
 arch/powerpc/mm/tlb_nohash.c                       |   7 +-
 arch/powerpc/platforms/44x/Kconfig                 |  42 ++
 arch/powerpc/platforms/44x/Makefile                |   3 +-
 .../platforms/44x/{currituck.c => ppc476.c}        | 120 ++++--
 arch/powerpc/platforms/44x/ppc476_modules.lds      |  15 +
 arch/powerpc/platforms/85xx/Kconfig                |  19 +-
 arch/powerpc/platforms/85xx/Makefile               |   3 +-
 arch/powerpc/platforms/85xx/bsc913x_qds.c          |  74 ++++
 arch/powerpc/platforms/85xx/corenet_generic.c      |   9 +-
 .../platforms/85xx/{p1023_rds.c => p1023_rdb.c}    |  36 +-
 arch/powerpc/platforms/85xx/smp.c                  |   3 +-
 arch/powerpc/platforms/Kconfig.cputype             |   5 +
 arch/powerpc/platforms/cell/smp.c                  |   5 +-
 arch/powerpc/platforms/embedded6xx/Kconfig         |   1 +
 arch/powerpc/platforms/pasemi/powersave.S          |   2 +-
 arch/powerpc/platforms/powernv/Makefile            |   2 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c          | 264 +++++++------
 arch/powerpc/platforms/powernv/eeh-powernv.c       |   4 +
 arch/powerpc/platforms/powernv/opal-flash.c        |  50 ++-
 arch/powerpc/platforms/powernv/opal-lpc.c          | 151 ++++++++
 .../powerpc/platforms/powernv/opal-memory-errors.c |   8 +-
 arch/powerpc/platforms/powernv/opal-takeover.S     |   2 +
 arch/powerpc/platforms/powernv/opal-wrappers.S     |   5 +-
 arch/powerpc/platforms/powernv/opal.c              |  22 ++
 arch/powerpc/platforms/powernv/pci-ioda.c          |  26 +-
 arch/powerpc/platforms/powernv/pci.c               | 202 +++++-----
 arch/powerpc/platforms/powernv/pci.h               |  11 +-
 arch/powerpc/platforms/powernv/powernv.h           |   2 +
 arch/powerpc/platforms/powernv/setup.c             |  56 ++-
 arch/powerpc/platforms/powernv/smp.c               |  25 +-
 arch/powerpc/platforms/powernv/subcore-asm.S       |  95 +++++
 arch/powerpc/platforms/powernv/subcore.c           | 392 +++++++++++++++++++
 arch/powerpc/platforms/powernv/subcore.h           |  18 +
 arch/powerpc/platforms/pseries/eeh_pseries.c       |  43 ++-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  17 +-
 arch/powerpc/platforms/pseries/hvCall.S            |  10 +-
 arch/powerpc/platforms/pseries/pseries.h           |   2 +
 arch/powerpc/platforms/pseries/setup.c             |   7 +
 arch/powerpc/platforms/pseries/smp.c               |   5 +-
 arch/powerpc/platforms/wsp/scom_smp.c              |   3 +-
 arch/powerpc/sysdev/Kconfig                        |   6 +
 arch/powerpc/sysdev/Makefile                       |   1 +
 arch/powerpc/sysdev/fsl_pci.c                      |   3 +-
 arch/powerpc/sysdev/fsl_rio.c                      |  10 +-
 arch/powerpc/sysdev/fsl_rmu.c                      |   6 +-
 arch/powerpc/sysdev/mpic.c                         |   8 +-
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c              | 215 +++++++++++
 arch/powerpc/sysdev/ppc4xx_pci.c                   |  21 +-
 arch/powerpc/xmon/xmon.c                           |  28 +-
 drivers/cpufreq/powernv-cpufreq.c                  |   1 +
 drivers/cpufreq/unicore2-cpufreq.c                 |   4 +-
 drivers/macintosh/windfarm_pm121.c                 |  16 +-
 drivers/pci/pci.c                                  |  21 +-
 tools/testing/selftests/powerpc/Makefile           |   2 +-
 .../selftests/powerpc/copyloops/asm/ppc_asm.h      |   5 +-
 tools/testing/selftests/powerpc/mm/Makefile        |  18 +
 .../selftests/powerpc/mm/hugetlb_vs_thp_test.c     |  72 ++++
 207 files changed, 6903 insertions(+), 1778 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-devices-system-cpu
 rename Documentation/devicetree/bindings/clock/{corenet-clock.txt => qoriq-clock.txt} (95%)
 create mode 100644 Documentation/devicetree/bindings/mfd/bfticu.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/qriox.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/akebono.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/4xx/hsta.txt
 create mode 100644 Documentation/devicetree/bindings/powerpc/fsl/ccf.txt
 create mode 100644 Documentation/powerpc/cpu_families.txt
 create mode 100644 arch/powerpc/boot/dts/akebono.dts
 create mode 100644 arch/powerpc/boot/dts/bsc9132qds.dts
 create mode 100644 arch/powerpc/boot/dts/bsc9132qds.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/bsc9132si-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/t1040si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/t1042si-post.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/t104xsi-pre.dtsi
 create mode 100644 arch/powerpc/boot/dts/kmcoge4.dts
 create mode 100644 arch/powerpc/boot/dts/oca4080.dts
 delete mode 100644 arch/powerpc/boot/dts/p1023rds.dts
 create mode 100644 arch/powerpc/boot/dts/t1040qds.dts
 create mode 100644 arch/powerpc/boot/dts/t1042qds.dts
 create mode 100644 arch/powerpc/boot/dts/t104xqds.dtsi
 create mode 100644 arch/powerpc/boot/pseries-head.S
 create mode 100644 arch/powerpc/boot/swab.h
 create mode 100644 arch/powerpc/boot/treeboot-akebono.c
 create mode 100644 arch/powerpc/configs/44x/akebono_defconfig
 create mode 100644 arch/powerpc/configs/85xx/kmp204x_defconfig
 rename arch/powerpc/platforms/44x/{currituck.c => ppc476.c} (72%)
 create mode 100644 arch/powerpc/platforms/44x/ppc476_modules.lds
 create mode 100644 arch/powerpc/platforms/85xx/bsc913x_qds.c
 rename arch/powerpc/platforms/85xx/{p1023_rds.c => p1023_rdb.c} (75%)
 create mode 100644 arch/powerpc/platforms/powernv/subcore-asm.S
 create mode 100644 arch/powerpc/platforms/powernv/subcore.c
 create mode 100644 arch/powerpc/platforms/powernv/subcore.h
 create mode 100644 arch/powerpc/sysdev/ppc4xx_hsta_msi.c
 create mode 100644 tools/testing/selftests/powerpc/mm/Makefile
 create mode 100644 tools/testing/selftests/powerpc/mm/hugetlb_vs_thp_test.c


