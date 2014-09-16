Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaIPMYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 08:24:34 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:36409 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaIPMYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:24:32 -0400
Date: Tue, 16 Sep 2014 07:24:26 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Shea Levy <shea@shealevy.com>
Cc: linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
Subject: Re: [RFC PATCH 0/2] Loop device psuedo filesystem
Message-ID: <20140916122426.GA30588@ubuntu-hedt>
Mail-Followup-To: Shea Levy <shea@shealevy.com>,
	linux-kernel@vger.kernel.org, lxc-devel@lists.linuxcontainers.org
References: <1401227936-15698-1-git-send-email-seth.forshee@canonical.com>
 <20140915203844.GA14761@nixos.hsd1.nh.comcast.net>
 <20140915205532.GA16651@ubuntu-hedt>
 <20140915232052.GA2235@nixos.hsd1.nh.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915232052.GA2235@nixos.hsd1.nh.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 07:20:52PM -0400, Shea Levy wrote:
> Hi Seth,
> 
> I applied your patches to 3.15-rc7, and had the same problem, the build
> fails with:
> 
> > make[3]: *** No rule to make target `fs/loopfs/loopfs.c', needed by `fs/loopfs/loopfs.o'.  Stop.
> 
> I've attached the config I used, I generated it via make allnoconfig and
> then enabled MODULES, BLK, BLK_DEV, and BLK_DEV_LOOP=m in make nconfig.
> 
> The build succeeds if I set BLK_DEV_LOOP=y, so I'll go ahead with my
> testing using that.

Ah, I probably didn't ever try it with BLK_DEV_LOOP=m. I think I see the
problem. Try making this change:

-loopfs-$(CONFIG_BLK_DEV_LOOP)          := inode.o
+loopfs-objs                            := inode.o

> 
> ~Shea
> 
> On Mon, Sep 15, 2014 at 03:55:32PM -0500, Seth Forshee wrote:
> > On Mon, Sep 15, 2014 at 04:38:44PM -0400, Shea Levy wrote:
> > > Hi,
> > > 
> > > I wanted to test these patches (to support creating and filling a disk
> > > image containing a btrfs filesystem and several subvolumes as an
> > > unprivileged user), but the build fails due to what looks like a missing
> > > loopfs.c in fs/loopfs (or alternatively an erroneous line in
> > > fs/loopfs/Makefile). I built based off of 3.17-rc5.
> > 
> > There's no loopfs.c, loopfs.o gets built from inode.o which is in turn
> > built from inode.c. I'm pretty sure the patches built when I posted
> > them, which seems to be 3.15-rc7 based on the branch I've got here.
> > 
> > Seth
> > 
> > > 
> > > ~Shea
> > > 
> > > 
> > > On Tue, May 27, 2014 at 11:58:54PM +0200, Seth Forshee wrote:
> > > > I'm posting these patches in response to the ongoing discussion of loop
> > > > devices in containers at [1].
> > > > 
> > > > The patches implement a psuedo filesystem for loop devices, which will
> > > > allow use of loop devices in containters using standard utilities. Under
> > > > normal use a loopfs mount will initially contain a single device node
> > > > for loop-control which can be used to request and release loop devices.
> > > > Any devices allocated via this node will automatically appear in that
> > > > loopfs mount (and in devtmpfs) but not in any other loopfs mounts.
> > > > CAP_SYS_ADMIN in the userns of the process which performed the mount is
> > > > allowed to perform privileged loop ioctls on these devices.
> > > > 
> > > > Alternately loopfs can be mounted with the hostmount option, intended
> > > > for mounting /dev/loop in the host. This is the default mount for any
> > > > devices not created via loop-control in a loopfs mount (e.g. devices
> > > > created during driver init, devices created via /dev/loop-control, etc).
> > > > This is only available to system-wide CAP_SYS_ADMIN.
> > > > 
> > > > I still have some testing to do on these patches, but they work at
> > > > minimum for simple use cases. It's possible to use an unmodified losetup
> > > > if it's new enough to know about loop-control, with a couple of caveats:
> > > > 
> > > >  * /dev/loop-control must be symlinked to /dev/loop/loop-control
> > > >  * In some cases losetup attempts to use /dev/loopN when the device node
> > > >    is at /dev/loop/N. For example, 'losetup -f disk.img' fails.
> > > > 
> > > > Device nodes for loop partitions are not created in loopfs. These
> > > > devices are created by the generic block layer, and the loop driver has
> > > > no way of knowing when they are created, so some kind of hook into the
> > > > driver will be needed to support this.
> > > > 
> > > > Thanks,
> > > > Seth
> > > > 
> > > > [1] http://article.gmane.org/gmane.linux.kernel/1703988
> > > > 
> > > > Seth Forshee (2):
> > > >   loop: Add loop filesystem
> > > >   loop: Permit priveleged operations within user namespaces
> > > > 
> > > >  drivers/block/loop.c       | 137 +++++++++++++----
> > > >  drivers/block/loop.h       |   2 +
> > > >  fs/Makefile                |   1 +
> > > >  fs/loopfs/Makefile         |   6 +
> > > >  fs/loopfs/inode.c          | 360 +++++++++++++++++++++++++++++++++++++++++++++
> > > >  include/linux/loopfs.h     |  53 +++++++
> > > >  include/uapi/linux/magic.h |   1 +
> > > >  7 files changed, 535 insertions(+), 25 deletions(-)
> > > >  create mode 100644 fs/loopfs/Makefile
> > > >  create mode 100644 fs/loopfs/inode.c
> > > >  create mode 100644 include/linux/loopfs.h
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > Please read the FAQ at  http://www.tux.org/lkml/
> > > > 
> > > > 

> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86 3.15.0-rc7 Kernel Configuration
> #
> CONFIG_64BIT=y
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> CONFIG_ZONE_DMA32=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> CONFIG_KERNEL_GZIP=y
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> # CONFIG_SYSVIPC is not set
> # CONFIG_FHANDLE is not set
> # CONFIG_USELIB is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> # CONFIG_RCU_STALL_COMMON is not set
> # CONFIG_TREE_RCU_TRACE is not set
> # CONFIG_IKCONFIG is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_SUPPORTS_INT128=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> # CONFIG_CGROUPS is not set
> # CONFIG_CHECKPOINT_RESTORE is not set
> # CONFIG_NAMESPACES is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_RELAY is not set
> # CONFIG_BLK_DEV_INITRD is not set
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_ANON_INODES=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> # CONFIG_SYSFS_SYSCALL is not set
> # CONFIG_KALLSYMS is not set
> # CONFIG_PRINTK is not set
> # CONFIG_BUG is not set
> # CONFIG_PCSPKR_PLATFORM is not set
> # CONFIG_BASE_FULL is not set
> # CONFIG_FUTEX is not set
> # CONFIG_EPOLL is not set
> # CONFIG_SIGNALFD is not set
> # CONFIG_TIMERFD is not set
> # CONFIG_EVENTFD is not set
> # CONFIG_SHMEM is not set
> # CONFIG_AIO is not set
> CONFIG_EMBEDDED=y
> CONFIG_HAVE_PERF_EVENTS=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> # CONFIG_VM_EVENT_COUNTERS is not set
> # CONFIG_COMPAT_BRK is not set
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> # CONFIG_PROFILING is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> # CONFIG_KPROBES is not set
> # CONFIG_JUMP_LABEL is not set
> # CONFIG_UPROBES is not set
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR is not set
> CONFIG_CC_STACKPROTECTOR_NONE=y
> # CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_CONTEXT_TRACKING=y
> CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_MODULES_USE_ELF_RELA=y
> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> CONFIG_BASE_SMALL=1
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> # CONFIG_MODULE_UNLOAD is not set
> # CONFIG_MODVERSIONS is not set
> # CONFIG_MODULE_SRCVERSION_ALL is not set
> # CONFIG_MODULE_SIG is not set
> CONFIG_BLOCK=y
> CONFIG_BLK_DEV_BSG=y
> # CONFIG_BLK_DEV_BSGLIB is not set
> # CONFIG_BLK_DEV_INTEGRITY is not set
> # CONFIG_BLK_CMDLINE_PARSER is not set
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> # CONFIG_DEFAULT_DEADLINE is not set
> CONFIG_DEFAULT_CFQ=y
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="cfq"
> CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
> CONFIG_INLINE_READ_UNLOCK=y
> CONFIG_INLINE_READ_UNLOCK_IRQ=y
> CONFIG_INLINE_WRITE_UNLOCK=y
> CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
> # CONFIG_FREEZER is not set
> 
> #
> # Processor type and features
> #
> # CONFIG_ZONE_DMA is not set
> # CONFIG_SMP is not set
> CONFIG_X86_MPPARSE=y
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> # CONFIG_HYPERVISOR_GUEST is not set
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> # CONFIG_MPENTIUMII is not set
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MPSC is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_GENERIC_CPU=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> # CONFIG_PROCESSOR_SELECT is not set
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> CONFIG_HPET_TIMER=y
> # CONFIG_DMI is not set
> CONFIG_SWIOTLB=y
> CONFIG_IOMMU_HELPER=y
> CONFIG_NR_CPUS=1
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> # CONFIG_X86_MCE is not set
> # CONFIG_I8K is not set
> # CONFIG_MICROCODE is not set
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> # CONFIG_X86_MSR is not set
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> # CONFIG_HIGHMEM4G is not set
> # CONFIG_HIGHMEM64G is not set
> # CONFIG_VMSPLIT_3G is not set
> # CONFIG_VMSPLIT_3G_OPT is not set
> # CONFIG_VMSPLIT_2G is not set
> # CONFIG_VMSPLIT_2G_OPT is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_DIRECT_GBPAGES=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_SELECT_MEMORY_MODEL=y
> # CONFIG_FLATMEM_MANUAL is not set
> CONFIG_SPARSEMEM_MANUAL=y
> CONFIG_SPARSEMEM=y
> CONFIG_HAVE_MEMORY_PRESENT=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> # CONFIG_MEMORY_HOTPLUG is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> # CONFIG_COMPACTION is not set
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_VIRT_TO_BUS=y
> # CONFIG_KSM is not set
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_FRONTSWAP is not set
> # CONFIG_CMA is not set
> # CONFIG_ZBUD is not set
> # CONFIG_ZSMALLOC is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_X86_RESERVE_LOW=64
> # CONFIG_MTRR is not set
> # CONFIG_ARCH_RANDOM is not set
> # CONFIG_X86_SMAP is not set
> # CONFIG_SECCOMP is not set
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> # CONFIG_SCHED_HRTICK is not set
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> # CONFIG_RELOCATABLE is not set
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> # CONFIG_SUSPEND is not set
> # CONFIG_HIBERNATION is not set
> # CONFIG_PM_RUNTIME is not set
> # CONFIG_SFI is not set
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> 
> #
> # CPU Idle
> #
> # CONFIG_CPU_IDLE is not set
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> 
> #
> # Memory power savings
> #
> # CONFIG_I7300_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> # CONFIG_PCI is not set
> CONFIG_ISA_DMA_API=y
> # CONFIG_PCCARD is not set
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> # CONFIG_BINFMT_ELF is not set
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> # CONFIG_BINFMT_SCRIPT is not set
> # CONFIG_HAVE_AOUT is not set
> # CONFIG_BINFMT_MISC is not set
> # CONFIG_COREDUMP is not set
> # CONFIG_IA32_EMULATION is not set
> CONFIG_X86_DEV_DMA_OPS=y
> # CONFIG_NET is not set
> CONFIG_HAVE_BPF_JIT=y
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> # CONFIG_DEVTMPFS is not set
> # CONFIG_STANDALONE is not set
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> # CONFIG_FW_LOADER is not set
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> # CONFIG_DMA_SHARED_BUFFER is not set
> 
> #
> # Bus devices
> #
> # CONFIG_MTD is not set
> # CONFIG_PARPORT is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_BLK_DEV=y
> # CONFIG_BLK_DEV_NULL_BLK is not set
> # CONFIG_BLK_DEV_FD is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=m
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_BLK_DEV_HD is not set
> 
> #
> # Misc devices
> #
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_ATMEL_SSC is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_SRAM is not set
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_93CX6 is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> 
> #
> # Altera FPGA firmware download module
> #
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> # CONFIG_INTEL_MIC_CARD is not set
> # CONFIG_ECHO is not set
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> # CONFIG_SCSI is not set
> # CONFIG_SCSI_DMA is not set
> # CONFIG_SCSI_NETLINK is not set
> # CONFIG_ATA is not set
> # CONFIG_MD is not set
> # CONFIG_MACINTOSH_DRIVERS is not set
> 
> #
> # Input device support
> #
> # CONFIG_INPUT is not set
> 
> #
> # Hardware I/O ports
> #
> # CONFIG_SERIO is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> # CONFIG_GAMEPORT is not set
> 
> #
> # Character devices
> #
> # CONFIG_TTY is not set
> # CONFIG_DEVKMEM is not set
> # CONFIG_IPMI_HANDLER is not set
> # CONFIG_HW_RANDOM is not set
> # CONFIG_NVRAM is not set
> # CONFIG_RAW_DRIVER is not set
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> # CONFIG_I2C is not set
> # CONFIG_SPI is not set
> # CONFIG_SPMI is not set
> # CONFIG_HSI is not set
> 
> #
> # PPS support
> #
> # CONFIG_PPS is not set
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> # CONFIG_POWER_SUPPLY is not set
> # CONFIG_POWER_AVS is not set
> # CONFIG_HWMON is not set
> # CONFIG_THERMAL is not set
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_CORE is not set
> # CONFIG_MFD_CROS_EC is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_MFD_KEMPLD is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_ABX500_CORE is not set
> # CONFIG_MFD_SYSCON is not set
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> # CONFIG_MFD_TMIO is not set
> # CONFIG_REGULATOR is not set
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> 
> #
> # Direct Rendering Manager
> #
> # CONFIG_DRM is not set
> 
> #
> # Frame buffer Devices
> #
> # CONFIG_FB is not set
> # CONFIG_EXYNOS_VIDEO is not set
> # CONFIG_BACKLIGHT_LCD_SUPPORT is not set
> # CONFIG_VGASTATE is not set
> # CONFIG_SOUND is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> # CONFIG_USB_SUPPORT is not set
> # CONFIG_MMC is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> # CONFIG_RTC_CLASS is not set
> # CONFIG_DMADEVICES is not set
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> # CONFIG_VIRT_DRIVERS is not set
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_STAGING is not set
> # CONFIG_X86_PLATFORM_DEVICES is not set
> # CONFIG_CHROME_PLATFORMS is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> # CONFIG_MAILBOX is not set
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_PWM is not set
> # CONFIG_IPACK_BUS is not set
> # CONFIG_RESET_CONTROLLER is not set
> # CONFIG_FMC is not set
> 
> #
> # PHY Subsystem
> #
> # CONFIG_GENERIC_PHY is not set
> # CONFIG_PHY_SAMSUNG_USB2 is not set
> # CONFIG_POWERCAP is not set
> # CONFIG_MCB is not set
> 
> #
> # Firmware Drivers
> #
> # CONFIG_EDD is not set
> # CONFIG_FIRMWARE_MEMMAP is not set
> # CONFIG_DELL_RBU is not set
> # CONFIG_DCDBAS is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> # CONFIG_EXT2_FS is not set
> # CONFIG_EXT3_FS is not set
> # CONFIG_EXT4_FS is not set
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> # CONFIG_XFS_FS is not set
> # CONFIG_GFS2_FS is not set
> # CONFIG_BTRFS_FS is not set
> # CONFIG_NILFS2_FS is not set
> # CONFIG_FS_POSIX_ACL is not set
> # CONFIG_FILE_LOCKING is not set
> # CONFIG_FSNOTIFY is not set
> # CONFIG_DNOTIFY is not set
> # CONFIG_INOTIFY_USER is not set
> # CONFIG_FANOTIFY is not set
> # CONFIG_QUOTA is not set
> # CONFIG_QUOTACTL is not set
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> # CONFIG_MSDOS_FS is not set
> # CONFIG_VFAT_FS is not set
> # CONFIG_NTFS_FS is not set
> 
> #
> # Pseudo filesystems
> #
> # CONFIG_PROC_FS is not set
> # CONFIG_KERNFS is not set
> # CONFIG_SYSFS is not set
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> # CONFIG_CONFIGFS_FS is not set
> # CONFIG_MISC_FILESYSTEMS is not set
> # CONFIG_NLS is not set
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> # CONFIG_DEBUG_FS is not set
> # CONFIG_HEADERS_CHECK is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> # CONFIG_FRAME_POINTER is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_MAGIC_SYSRQ is not set
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VIRTUAL is not set
> # CONFIG_DEBUG_MEMORY_INIT is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> # CONFIG_DEBUG_STACKOVERFLOW is not set
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_PANIC_TIMEOUT=0
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_ATOMIC_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> # CONFIG_DEBUG_KOBJECT is not set
> # CONFIG_DEBUG_LIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_SPARSE_RCU_POINTER is not set
> # CONFIG_TORTURE_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_TRACE is not set
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_FENTRY=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACING_SUPPORT=y
> # CONFIG_FTRACE is not set
> 
> #
> # Runtime Testing
> #
> # CONFIG_TEST_LIST_SORT is not set
> # CONFIG_BACKTRACE_SELF_TEST is not set
> # CONFIG_RBTREE_TEST is not set
> # CONFIG_INTERVAL_TREE_TEST is not set
> # CONFIG_PERCPU_TEST is not set
> # CONFIG_ATOMIC64_SELFTEST is not set
> # CONFIG_TEST_STRING_HELPERS is not set
> # CONFIG_TEST_KSTRTOX is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_TEST_MODULE is not set
> # CONFIG_TEST_USER_COPY is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> # CONFIG_EARLY_PRINTK is not set
> # CONFIG_X86_PTDUMP is not set
> # CONFIG_DEBUG_RODATA is not set
> # CONFIG_DEBUG_SET_MODULE_RONX is not set
> # CONFIG_DEBUG_NX_TEST is not set
> # CONFIG_DOUBLEFAULT is not set
> # CONFIG_DEBUG_TLBFLUSH is not set
> # CONFIG_IOMMU_STRESS is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> CONFIG_IO_DELAY_0X80=y
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> CONFIG_DEFAULT_IO_DELAY_TYPE=0
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> # CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set
> 
> #
> # Security options
> #
> # CONFIG_KEYS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> # CONFIG_CRYPTO is not set
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> # CONFIG_BINARY_PRINTF is not set
> 
> #
> # Library routines
> #
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> # CONFIG_CRC_CCITT is not set
> # CONFIG_CRC16 is not set
> # CONFIG_CRC_T10DIF is not set
> # CONFIG_CRC_ITU_T is not set
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> # CONFIG_CRC7 is not set
> # CONFIG_LIBCRC32C is not set
> # CONFIG_CRC8 is not set
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> # CONFIG_RANDOM32_SELFTEST is not set
> # CONFIG_XZ_DEC is not set
> # CONFIG_XZ_DEC_BCJ is not set
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> # CONFIG_AVERAGE is not set
> # CONFIG_CORDIC is not set
> # CONFIG_DDR is not set

