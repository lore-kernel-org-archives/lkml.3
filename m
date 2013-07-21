Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075Ab3GUTxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 15:53:14 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:56029 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3GUTxL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 15:53:11 -0400
MIME-Version: 1.0
Date: Sun, 21 Jul 2013 12:53:10 -0700
X-Google-Sender-Auth: fjR8xzFn9kA7e8akHbOQ6uZr82A
Message-ID: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
Subject: Linux 3.11-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's been another week, and -rc2 is out there.

The patch looks a bit odd, because by bulk 95% of the patch is just
the removal of the CSR staging driver that wasn't getting any
traction, so the diffstat (and the dirstat in particular) is not very
interesting or readable, since that driver removal basically
overshadows everything else. But I do admit to love seeing code
removal patches.

And of the rest of the patch, a noticeable part is all those
one-liners all over that just remove the __cpuinit markers that people
agreed were just more pain than gain to maintain. We had already made
the markers be no-ops earlier, so they didn't matter for code
generation, and here in rc2 they get actually removed.

End result: we have two separate events that generate a lot of noise
in the patch, but aren't really interesting per se. They do make the
patch harder to read, though.

Ignoring those noisy parts of the patch, there's a couple of things
worth noting about rc2. I think most of the patches here are nice
fixes, but I wanted to give two heads-ups:

 (a) the O_TMPFILE flag that is new to 3.11 has been going through a
few ABI/API cleanups (and a few fixes to the implementation too), but
I think we're done now. So if you're interested in the concept of
unnamed temporary files, go ahead and test it out. The lack of name
not only gets rid of races/complications with filename generation, it
can make the whole thing more efficient since you don't have the
directory operations that can cause serializing IO etc.

 (b) we had a late change to how ACPI backlight handling is done on
certain machines, and while this kind of thing really shouldn't be
done outside the merge window, I ended up pulling it anyway. But I'd
*really* like to have people test this thing particularly on laptops
with intel-based graphics. It should only matter (and hopefully
improve things) for the newer ones with BIOSes designed for Windows 8,
but hey, the more testing, the better. Backlight handling has been
painful before, so I'm mentioning this explicitly.

Anyway, apart from those two issues, I think the rest is pretty normal
for rc2. It started out a bit slow, but I think it ended up fairly
normal. Apart from the already mentioned issues, we've got drm stuff
(radeon in particular), some driver core fixes, s390/mips/arm/x86
updates, sound drivers, ext4/btrfs fixes, yadda yadda.

The shortlog since -rc1 is appended.

                           Linus

---
Aaro Koskinen (1):
      MIPS: tlbex: fix broken build in v3.11-rc1

Aaron Lu (2):
      ACPICA: expose OSI version
      ACPI / video: no automatic brightness changes by win8-compatible firmware

Aaron Plattner (1):
      ALSA: hda - Add new GPU codec ID to snd-hda

Al Viro (2):
      allow O_TMPFILE to work with O_WRONLY
      livelock avoidance in sget()

Alex Deucher (16):
      drm/radeon/hdmi: make sure we have an afmt block assigned
      drm/radeon/dpm: disable gfx PG on PALM
      drm/radeon: Disable dma rings for bo moves on r6xx
      drm/radeon: implement bo copy callback using CP DMA (v2)
      drm/radeon: use CP DMA on r6xx for bo moves
      drm/radeon: add fault decode function for cayman/TN (v2)
      drm/radeon: add fault decode function for SI (v2)
      drm/radeon: add fault decode function for CIK
      drm/radeon: allow selection of alignment in the sub-allocator
      drm/radeon: align VM PTBs (Page Table Blocks) to 32K
      drm/radeon/dpm/sumo: handle boost states properly when forcing a
perf level
      drm/radeon: add a module parameter to disable aspm
      drm/radeon: fix an endian bug in atom table parsing
      drm/radeon/dpm: fix atom vram table parsing
      drm/radeon/dpm/atom: fix broken gcc harder
      drm/radeon/dpm: add debugfs support for RS780/RS880 (v3)

Alexandre Belloni (2):
      iio: Fix iio_channel_has_info
      iio: inkern: fix iio_convert_raw_to_processed_unlocked

Anatol Pomozov (1):
      ext4: rate limit printk in buffer_io_error()

Andre Heider (1):
      drm/radeon/dpm/atom: restructure logic to work around a compiler bug

Catalin Marinas (1):
      arm64: Only enable local interrupts after the CPU is marked online

Chanwoo Choi (1):
      PM / Sleep: Fix comment typo in pm_wakeup.h

Chen Gang (1):
      arm64: add '#ifdef CONFIG_COMPAT' for aarch32_break_handler()

Chris Wilson (3):
      drm/i915: Fix write-read race with multiple rings
      drm/i915: Fix incoherence with fence updates on Sandybridge+
      Revert "drm/i915: Workaround incoherence between fences and LLC
across multiple CPUs"

Christian König (2):
      drm/radeon: fix UVD fence emit
      drm/radeon: never unpin UVD bo v3

Dan Carpenter (1):
      svcrdma: underflow issue in decode_write_list()

Daniel Baluta (1):
      ndisc: bool initializations should use true and false

Daniel Mack (1):
      regmap: cache: bail in regmap_async_complete() for bus-less maps

Daniel Vetter (2):
      drm/i915: reinit status page registers after gpu reset
      drm/i915: fix up ring cleanup for the i830/i845 CS tlb w/a

Dave Jones (1):
      linked-list: Remove __list_for_each

David Jeffery (1):
      lockd: protect nlm_blocked access in nlmsvc_retry_blocked

David S. Miller (1):
      net: Fix sysfs_format_mac() code duplication.

Dragos Foianu (2):
      ethtool: fixed trailing statements in ethtool
      net/irda: fixed style issues in irlan_eth

Eric Dumazet (3):
      ipv4: set transport header earlier
      vlan: mask vlan prio bits
      vlan: fix a race in egress prio management

Fabio Estevam (2):
      ASoC: sglt5000: Fix the default value of CHIP_SSS_CTRL
      ASoC: sglt5000: Fix SGTL5000_PLL_FRAC_DIV_MASK

Faidon Liambotis (1):
      MIPS: Octeon: Fix DT pruning bug with pip ports

Florian Fainelli (1):
      MIPS: BMIPS: Fix thinko to release slave TP from reset

Ganesan Ramalingam (1):
      MIPS: Netlogic: Fix USB block's coherent DMA mask

Girish K S (1):
      spi: s3c64xx: add missing check for polling mode

Greg Kroah-Hartman (7):
      sysfs.h: add __ATTR_RW() macro
      sysfs.h: add ATTRIBUTE_GROUPS() macro
      sysfs.h: add BIN_ATTR macro
      driver core: device.h: add RW and RO attribute macros
      sysfs: add support for binary attributes in groups
      driver core: add default groups to struct class
      staging: csr: remove driver

Guenter Roeck (2):
      Partially revert "drm/i915: unconditionally use mt forcewake on hsw/ivb"
      driver core: Introduce device_create_groups

H. Peter Anvin (1):
      x86, suspend: Handle CPUs which fail to #GP on RDMSR

Haiyang Zhang (1):
      hyperv: Fix the NETIF_F_SG flag setting in netvsc

Hauke Mehrtens (1):
      bgmac: add dependency to phylib

Heiko Carstens (4):
      s390/bpf,jit: call module_free() from any context
      s390/bpf,jit: use generic jit dumper
      s390/bpf,jit: address randomize and write protect jit code
      s390/bpf,jit: add pkt_type support

Imre Deak (1):
      drm/i915: fix lane bandwidth capping for DP 1.2 sinks

Ingo Tuchscherer (1):
      s390/zcrypt: Alias for new zcrypt device driver base module

J. Bruce Fields (1):
      nfsd4: fix minorversion support interface

Jacek Anaszewski (1):
      iio: lps331ap: Fix wrong in_pressure_scale output value

James Hogan (1):
      MIPS: KVM: Mark KVM_GUEST (T&E KVM) as BROKEN_ON_SMP

Jan Beulich (1):
      xen-netfront: pull on receive skb may need to happen earlier

Jan Kara (2):
      ext4: silence warning in ext4_writepages()
      ext4: fix warning in ext4_evict_inode()

Jason Wang (4):
      macvtap: fix the missing ret value of TUNSETQUEUE
      macvtap: do not assume 802.1Q when send vlan packets
      tuntap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS
      macvtap: do not zerocopy if iov needs more pages than MAX_SKB_FRAGS

Jayachandran C (1):
      MIPS: Netlogic: Add XLP PIC irqdomain

Jerome Glisse (1):
      drm/radeon: use radeon device for request firmware

Jonathan Cameron (1):
      iio:trigger: device_unregister->device_del to avoid double free

Josef Bacik (3):
      Btrfs: update drop progress before stopping snapshot dropping
      Btrfs: fix lock leak when resuming snapshot deletion
      Btrfs: re-add root to dead root list if we stop dropping it

Kees Cook (1):
      x86: Make sure IDT is page aligned

Kuninori Morimoto (1):
      ASoC: wm8978: enable symmetric rates

Lan Tianyu (1):
      ACPI / video: ignore BIOS initial backlight value for Fujitsu E753

Laurent Pinchart (2):
      drm/shmobile: Use the GEM PRIME helpers
      drm/rcar-du: Use the GEM PRIME helpers

Linus Torvalds (1):
      Linux 3.11-rc2

Liu ShuoX (2):
      PM / Sleep: avoid 'autosleep' in shutdown progress
      PNP / ACPI: avoid garbage in resource name

Maarten Lankhorst (1):
      drm/radeon: add missing ttm_eu_backoff_reservation to
radeon_bo_list_validate

Marc Zyngier (1):
      arm64: use common reboot infrastructure

Marek Vasut (2):
      iio: mxs-lradc: Fix misuse of iio->trig
      iio: mxs-lradc: Remove useless check in read_raw

Mark Brown (1):
      ASoC: wm8994: Remove overly noisy debug logging

Markos Chandras (1):
      MIPS: kvm: Kconfig: Drop HAVE_KVM dependency from VIRTUALIZATION

Matt Fleming (2):
      efivars: check for EFI_RUNTIME_SERVICES
      Revert "UEFI: Don't pass boot services regions to SetVirtualAddressMap()"

Matthew Garrett (1):
      ACPI / video: Always call acpi_video_init_brightness() on init

Michael Holzheu (2):
      s390/kdump: Disable mmap for s390
      s390/kdump: Allow copy_oldmem_page() copy to virtual memory

Michael Mueller (1):
      s390/ptrace: PTRACE_TE_ABORT_RAND

Michal Simek (1):
      spi/xilinx: Revert master->setup function removal

Neil Horman (1):
      atl1e: unmap partially mapped skb on dma error and free skb

NeilBrown (3):
      md/raid10: fix two problems with RAID10 resync.
      md: Remove recent change which allows devices to skip recovery.
      md/raid1: fix bio handling problems in process_checks()

Oliver Schinagl (3):
      sysfs: prevent warning when only using binary attributes
      sysfs: add more helper macro's for (bin_)attribute(_groups)
      sysfs: use file mode defines from stat.h

Padmavathi Venna (1):
      ASoC: Samsung: Set RFS and BFS in slave mode

Paolo Valente (1):
      pkt_sched: sch_qfq: remove a source of high packet delay/jitter

Paul Bolle (2):
      cpufreq: s3c24xx: rename CONFIG_CPU_FREQ_S3C24XX_DEBUGFS
      cpufreq: s3c24xx: fix "depends on ARM_S3C24XX" in Kconfig

Paul Gortmaker (28):
      alpha: delete __cpuinit usage from all users
      parisc: delete __cpuinit usage from all users
      MIPS: Delete __cpuinit/__CPUINIT usage from MIPS code
      arm: delete __cpuinit/__CPUINIT usage from all ARM users
      sparc: delete __cpuinit/__CPUINIT usage from all users
      arm64: delete __cpuinit usage from all users
      blackfin: delete __cpuinit usage from all blackfin files
      s390: delete __cpuinit usage from all s390 files
      sh: delete __cpuinit usage from all sh files
      tile: delete __cpuinit usage from all tile files
      metag: delete __cpuinit usage from all metag files
      cris: delete __cpuinit usage from all cris files
      frv: delete __cpuinit usage from all frv files
      hexagon: delete __cpuinit usage from all hexagon files
      m32r: delete __cpuinit usage from all m32r files
      openrisc: delete __cpuinit usage from all openrisc files
      xtensa: delete __cpuinit usage from all xtensa files
      score: delete __cpuinit usage from all score files
      x86: delete __cpuinit usage from all x86 files
      clocksource+irqchip: delete __cpuinit usage from all related files
      cpufreq: delete __cpuinit usage from all cpufreq files
      hwmon: delete __cpuinit usage from all hwmon files
      acpi: delete __cpuinit usage from all acpi files
      net: delete __cpuinit usage from all net files
      rcu: delete __cpuinit usage from all rcu files
      kernel: delete __cpuinit usage from all core kernel files
      drivers: delete __cpuinit usage from all remaining drivers files
      block: delete __cpuinit usage from all block files

Paulo Zanoni (1):
      drm/i915: switch disable_power_well default value to 1

Peng Tao (1):
      vfs: constify dentry parameter in d_count()

Peter Meerwald (1):
      iio staging: fix lis3l02dq, read error handling

Peter Ujfalusi (4):
      ASoC: omap-pcm: Request the DMA channel differently when DT is involved
      ASoC: omap-mcpdm: Do not use platform_get_resource_byname() for DMA
      ASoC: omap-dmic: Do not use platform_get_resource_byname() for DMA
      ASoC: omap-mcbsp: Use different method for DMA request when booted with DT

Rafael J. Wysocki (3):
      ACPI / scan: Do not try to attach scan handlers to devices having them
      ACPI / scan: Always call acpi_bus_scan() for bus check notifications
      ACPI / video / i915: No ACPI backlight if firmware expects Windows 8

Ralf Baechle (1):
      MIPS: Delete dead invocation of exception_exit().

Randy Dunlap (1):
      driver-core: fix new kernel-doc warning in base/platform.c

Richard Weinberger (5):
      um: Fix return value of strnlen_user()
      um: Mark stub pages mapping with VM_PFNMAP
      um: Fix wait_stub_done() error handling
      um: siginfo cleanup
      um: remove dead code

Sachin Kamat (1):
      hwmon: (abx500) Staticize abx500_temp_attributes

Sarveshwar Bandi (1):
      be2net: Fix to avoid hardware workaround when not needed

Sebastian Ott (1):
      s390/qdio: remove unused variable

Sergey Senozhatsky (1):
      radeon kms: do not flush uninitialized hotplug work

Srivatsa S. Bhat (2):
      cpufreq: Revert commit a66b2e to fix suspend/resume regression
      cpufreq: Revert commit 2f7021a8 to fix CPU hotplug regression

Stefan Behrens (1):
      Btrfs: fix wrong write offset when replacing a device

Stephen Warren (1):
      spi: revert master->setup function removal for altera and nuc900

Steven Miao (1):
      smp: blackfin: fix check error, using atomic_ops to handle atomic_t type

Sylvain 'ythier' Hitier (1):
      uvesafb: Really allow mtrr being 0, as documented and warn()ed

Takashi Iwai (13):
      sound: oss/vwsnd: Add missing inclusion of linux/delay.h
      sound: oss/vwsnd: Always define vwsnd_mutex
      ALSA: asihpi: Fix unlocked snd_pcm_stop() call
      ALSA: atiixp: Fix unlocked snd_pcm_stop() call
      ALSA: 6fire: Fix unlocked snd_pcm_stop() call
      ALSA: ua101: Fix unlocked snd_pcm_stop() call
      ALSA: usx2y: Fix unlocked snd_pcm_stop() call
      ALSA: pxa2xx: Fix unlocked snd_pcm_stop() call
      ASoC: atmel: Fix unlocked snd_pcm_stop() call
      ASoC: s6000: Fix unlocked snd_pcm_stop() call
      [media] saa7134: Fix unlocked snd_pcm_stop() call
      staging: line6: Fix unlocked snd_pcm_stop() call
      ALSA: seq-oss: Initialize MIDI clients asynchronously

Theodore Ts'o (9):
      ext4: fix ext4_get_group_number()
      ext4: don't show usrquota/grpquota twice in /proc/mounts
      ext4: fix spelling errors and a comment in extent_status tree
      ext4: don't allow ext4_free_blocks() to fail due to ENOMEM
      ext4: fix error handling in ext4_ext_truncate()
      ext4: simplify calculation of blocks to free on error
      ext4: make the extent_status code more robust against ENOMEM failures
      ext4: yield during large unlinks
      ext4: call ext4_es_lru_add() after handling cache miss

Tim Gardner (1):
      mlx5 core: Fix __udivdi3 when compiling for 32 bit arches

Tony Wu (1):
      MIPS: tlbex: Fix typo in r3000 tlb store handler

Toshi Kani (1):
      ACPI / memhotplug: Fix a stale pointer in error path

Tristan Schmelcher (1):
      uml: Fix which_tmpdir failure when /dev/shm is a symlink, and in
other edge cases

Trond Myklebust (2):
      SUNRPC: Fix another issue with rpc_client_register()
      NFSv4: Fix a regression against the FreeBSD server

Wei Yongjun (3):
      iio: dac: ad7303: fix error return code in ad7303_probe()
      iio: ti_am335x_adc: add missing .driver_module to struct iio_info
      staging:iio:ad7291: add missing .driver_module to struct iio_info

Will Deacon (1):
      arm64: mm: don't treat user cache maintenance faults as writes

Xiao Guangrong (1):
      KVM: MMU: avoid fast page fault fixing mmio page fault

Xiong Zhang (1):
      drm/i915: Correct obj->mm_list link to
dev_priv->dev_priv->mm.inactive_list

Xiong Zhou (1):
      x86/platform/ce4100: Add header file for reboot type

Zheng Liu (2):
      ext4: fix a BUG when opening a file with O_TMPFILE flag
      ext3: fix a BUG when opening a file with O_TMPFILE flag

stephen hemminger (1):
      vxlan: add necessary locking on device removal
