Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JHG7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:59:45 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:60023 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3JHG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:59:42 -0400
Date: Tue, 8 Oct 2013 08:59:38 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        Andi Kleen <ak@linux.intel.com>, fweisbec@gmail.com
Subject: Re: [PATCH 6/6] x86: Allow disabling HW_BREAKPOINTS and PERF_EVENTS
Message-ID: <20131008065938.GA4333@gmail.com>
References: <1380922788-23112-1-git-send-email-andi@firstfloor.org>
 <1380922788-23112-7-git-send-email-andi@firstfloor.org>
 <20131006164934.GA15167@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131006164934.GA15167@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> Andi Kleen <andi@firstfloor.org> wrote:
>
> >    text	   data	    bss	    dec	    hex	filename
> > 13692640	1922416	1478656	17093712	104d450	obj/vmlinux
> > 12980092	1787544	1470464	16238100	 f7c614	obj-noperf/vmlinux

[...]

> > Ok I trust you will do a better solution then to save the 700+k text. 
> > Ball is in your court.
> 
> Btw., could you send me your .config so I can investigate this?

Ok, you sent me your .config off-list - I won't re-post the full config, 
but it can be reproduced by others fairly accurately by appending the 
attached list of config symbols to a 'make defconfig' x86-64 .config and 
running 'make oldconfig'.

So I test-built a config close to your config with both tracing and perf 
on and off (note, I had OPROFILE and KVM in a module), and got the 
following kernel sizes:

     text           data     bss      dec            hex filename
 ====================================================================================
 12081246        1279656 1003520 14364422         db2f06 vmlinux.perf-OFF.tracing-OFF
 12979238        1785192 1150976 15915406         f2d98e vmlinux.perf-OFF.tracing-ON
 12232758        1325424 1003520 14561702         de31a6 vmlinux.perf-ON.tracing-OFF
 13223817        1877872 1150976 16252665         f7fef9 vmlinux.perf-ON.tracing-ON

Firstly, your 'perf increases vmlinux size by 700k' result does not seem 
to reproduce, at all. [*]

[ Are you sure you made the measurement correctly? Please send me _both_ 
  configs you used for the test, one with perf enabled, and the other one 
  with perf disabled, so I can double check it. I suppose you tested a 
  recent Linus kernel with your hardware-breakpoint patches applied. ]

Secondly and more importantly, visualized with relative sizes, in a 
feature matrix, makes it clearer what's going on with vmlinux .text:

                              perf-OFF   perf-ON

            ftrace-OFF               0     +151k

            ftrace-ON            +897k    +1142k

So basically ftrace is causing a big chunk of the instrumentation size 
increase. With tons of tracers and lots of kernel subsystems built into 
your .config that's a lot of nice instrumentation functionality and it's 
thus also a natural end result IMO.

The base cost of perf is +151k - not small but a far cry from your claimed 
+700k ...

In any case, on one hand I obviously welcome genuine kernel size 
reductions, on the other hand what you did in these patches wasn't really 
size reduction usable to too many people: all distros enable perf and 
tracing and very few kernel developers are left who are still using 
oprofile. You fought the symptom, not the reason.

So my NAK against your series stands. To sum up the technical reasons:

  - you blaming +700k on perf alone is wrong, or at most a red herring

  - your patches might break apps/ABI

  - your patch-set unnecessarily complicates things, making the kernel
    less maintainable

  - details of your patch-set are broken as well, see the discussions

( There might be more reasons, this is just off the top of my head.
  Any of these reasons would be enough to not apply your patches.)

You might want to concentrate your efforts from fighting perf 
functionality towards decreasing per tracepoint overhead instead,
without hurting kernel functionality and maintainability.

Thanks,

	Ingo

=================>
CONFIG_LOCALVERSION_AUTO=y
CONFIG_IRQ_TIME_ACCOUNTING=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_EXPERT=y
CONFIG_KALLSYMS_ALL=y
CONFIG_COMPAT_BRK=y
CONFIG_OPROFILE=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_JUMP_LABEL=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_X86_MCE_INJECT=y
CONFIG_NUMA_EMU=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_MMU_NOTIFIER=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=y
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
CONFIG_EFI_STUB=y
CONFIG_HZ_250=y
CONFIG_COMPAT_VDSO=y
CONFIG_PM_RUNTIME=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
CONFIG_X86_POWERNOW_K8=y
CONFIG_INTEL_IDLE=y
CONFIG_PCIEAER_INJECT=y
CONFIG_PCIE_PME=y
CONFIG_PCI_IOAPIC=y
CONFIG_IA32_AOUT=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_BPF_JIT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211_WEXT=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_BLK_DEV_CRYPTOLOOP=y
CONFIG_BLK_DEV_RAM=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_MEGARAID_SAS=y
CONFIG_SATA_NV=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SVW=y
CONFIG_PATA_ATIIXP=y
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_MPIIX=y
CONFIG_PATA_ACPI=y
CONFIG_ATA_GENERIC=y
CONFIG_DM_CRYPT=y
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_TUN=y
CONFIG_MDIO=y
CONFIG_VORTEX=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_TULIP=y
CONFIG_E1000E=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IXGB=y
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_R8169=y
CONFIG_BROADCOM_PHY=y
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=y
CONFIG_USB_NET_CDC_NCM=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_LEGACY_PTYS=y
CONFIG_SERIAL_KGDB_NMI=y
CONFIG_CONSOLE_POLL=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_RAW_DRIVER=y
CONFIG_HPET_MMAP=y
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_DRM_TTM=y
CONFIG_DRM_RADEON=y
CONFIG_FB_DDC=y
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
CONFIG_SOUND_PRIME=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HID_DRAGONRISE=y
CONFIG_HID_KYE=y
CONFIG_HID_TWINHAN=y
CONFIG_HID_ORTEK=y
CONFIG_HID_GREENASIA=y
CONFIG_HID_SMARTJOYPLUS=y
CONFIG_HID_THRUSTMASTER=y
CONFIG_HID_ZEROPLUS=y
CONFIG_USB_STORAGE_REALTEK=y
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
CONFIG_USB_STORAGE_ENE_UB6250=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_UDF_FS=y
CONFIG_UDF_NLS=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_FTRACE=y
CONFIG_PSTORE_RAM=y
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
CONFIG_CIFS=y
CONFIG_CIFS_DEBUG=y
CONFIG_NLS_ISO8859_15=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_ENABLE_WARN_DEPRECATED=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DETECT_HUNG_TASK=y
CONFIG_SCHED_DEBUG=y
CONFIG_LATENCYTOP=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FIREWIRE_OHCI_REMOTE_DMA=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_KDB=y
CONFIG_KDB_KEYBOARD=y
CONFIG_X86_PTDUMP=y
CONFIG_IO_DELAY_0XED=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
CONFIG_CRYPTO_CMAC=y
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM=y
CONFIG_KVM_INTEL=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
