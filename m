Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbaIFFqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 01:46:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:40984 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbaIFFqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 01:46:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,478,1406617200"; 
   d="log'?scan'208";a="587128732"
Date: Sat, 6 Sep 2014 13:45:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [drm] INFO: trying to register non-static key.
Message-ID: <20140906054512.GA7794@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

0day kernel testing robot got the below dmesg and the first bad commit is

git://anongit.freedesktop.org/drm-intel topic/core-stuff
commit 4e396fc20db96c0af710601f081ffb41b0fe611c
Author:     Daniel Vetter <daniel.vetter@ffwll.ch>
AuthorDate: Fri Sep 5 14:27:41 2014 +0200
Commit:     Daniel Vetter <daniel.vetter@ffwll.ch>
CommitDate: Fri Sep 5 14:34:48 2014 +0200

    drm: Drop modeset locking from crtc init function
    
    At driver init no one can access modeset objects and we're
    single-threaded. So locking is just cargo-culting here. Worse, with
    the new ww mutexes and ww mutex slowpath debugging the mutex_lock
    might actually fail, and we don't have the full-blown ww recovery
    dance.
    
    Which then leads to fireworks when we try to unlock the not-locked
    crtc lock.
    
    An audit of all the functions called from here shows that none of them
    contain locking checks, so there's also no reason to keep the locking
    around just for consistency of caller contexts. Besides that I have
    the rule (at least in i915) that such places where we take locks just
    to simplify locking checks and not for correctness always require a
    comment.
    
    This regression was introduced in
    
    commit 51fd371bbaf94018a1223b4e2cf20b9880fd92d4
    Author: Rob Clark <robdclark@gmail.com>
    Date:   Tue Nov 19 12:10:12 2013 -0500
    
        drm: convert crtc and connection_mutex to ww_mutex (v5)
    
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=83341
    Cc: Rob Clark <robdclark@gmail.com>
    Cc: thellstrom@vmware.com
    Cc: maarten.lankhorst@canonical.com
    Cc: stable@vger.kernel.org
    Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>

===================================================
PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
===================================================
Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.

+------------------------------------------------------------------+------------+------------+------------+
|                                                                  | 5c551b501a | 4e396fc20d | 5a2aa64d4e |
+------------------------------------------------------------------+------------+------------+------------+
| boot_successes                                                   | 31         | 0          | 0          |
| boot_failures                                                    | 29         | 20         | 11         |
| Kernel_panic-not_syncing:Out_of_memory_and_no_killable_processes | 25         |            |            |
| backtrace:lock_torture_stats                                     | 25         |            |            |
| BUG:unable_to_handle_kernel_paging_request                       | 3          |            |            |
| Oops                                                             | 2          | 20         | 11         |
| EIP_is_at__lock_acquire                                          | 1          |            |            |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt            | 1          |            |            |
| backtrace:set_memory_np                                          | 2          |            |            |
| backtrace:free_init_pages                                        | 2          |            |            |
| backtrace:populate_rootfs                                        | 2          |            |            |
| backtrace:kernel_init_freeable                                   | 2          | 20         | 11         |
| EIP_is_at__change_page_attr_set_clr                              | 1          |            |            |
| Kernel_panic-not_syncing:Fatal_exception                         | 1          | 20         | 11         |
| BUG:kernel_boot_hang                                             | 1          |            |            |
| INFO:trying_to_register_non-static_key                           | 0          | 20         | 11         |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference             | 0          | 20         | 11         |
| EIP_is_at__ww_mutex_lock                                         | 0          | 20         | 11         |
| backtrace:drm_modeset_lock_all                                   | 0          | 20         | 11         |
| backtrace:drm_encoder_init                                       | 0          | 20         | 11         |
| backtrace:cirrus_modeset_init                                    | 0          | 20         | 11         |
| backtrace:__pci_register_driver                                  | 0          | 20         | 11         |
| backtrace:drm_pci_init                                           | 0          | 20         | 11         |
| backtrace:cirrus_init                                            | 0          | 20         | 11         |
+------------------------------------------------------------------+------------+------------+------------+

[    0.836476] [drm] radeon kernel modesetting enabled.
[    0.837550] [TTM] Zone  kernel: Available graphics memory: 145694 kiB
[    0.838064] [TTM] Initializing pool allocator
[    0.838626] INFO: trying to register non-static key.
[    0.839022] the code is fine but needs lockdep annotation.
[    0.839454] turning off the locking correctness validator.
[    0.839884] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc2-00221-g4e396fc #5
[    0.840367] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    0.840367]  00000000 00000000 d341fc08 c69981fd c7394920 d341fc7c c5c7b341 c6c9ea3c
[    0.840367]  0900b705 d3440000 d341fc90 c5c79b96 d3440000 402dc174 d3440000 402dc174
[    0.840367]  00000005 01440000 00000000 d2529848 d2529848 00000000 c73626e0 d34405d0
[    0.840367] Call Trace:
[    0.840367]  [<c69981fd>] dump_stack+0x48/0x60
[    0.840367]  [<c5c7b341>] __lock_acquire+0x1c21/0x1da0
[    0.840367]  [<c5c79b96>] ? __lock_acquire+0x476/0x1da0
[    0.840367]  [<c5c78a96>] ? __lock_is_held+0x46/0x60
[    0.840367]  [<c5c7bd11>] lock_acquire+0x91/0xc0
[    0.840367]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c69a607c>] __ww_mutex_lock+0x6c/0x780
[    0.840367]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c625e531>] drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c625e7c4>] drm_modeset_lock_all_crtcs+0x34/0x50
[    0.840367]  [<c625e884>] __drm_modeset_lock_all+0xa4/0xe0
[    0.840367]  [<c625e8ca>] drm_modeset_lock_all+0xa/0x30
[    0.840367]  [<c625022b>] drm_encoder_init+0x1b/0xe0
[    0.840367]  [<c5d0ea08>] ? kmem_cache_alloc+0x98/0x190
[    0.840367]  [<c6366d81>] ? cirrus_modeset_init+0xe1/0x1c0
[    0.840367]  [<c6366da7>] cirrus_modeset_init+0x107/0x1c0
[    0.840367]  [<c6365e47>] cirrus_driver_load+0x57/0x120
[    0.840367]  [<c624b75e>] drm_dev_register+0x9e/0x100
[    0.840367]  [<c624cea1>] drm_get_pci_dev+0x91/0x1c0
[    0.840367]  [<c5c77e5b>] ? trace_hardirqs_on+0xb/0x10
[    0.840367]  [<c69a5f58>] ? mutex_unlock+0x8/0x10
[    0.840367]  [<c6366fcc>] cirrus_pci_probe+0xac/0xf0
[    0.840367]  [<c6113337>] pci_device_probe+0x77/0xe0
[    0.840367]  [<c5d7fbb0>] ? sysfs_create_link+0x20/0x40
[    0.840367]  [<c63c3673>] driver_probe_device+0x73/0x230
[    0.840367]  [<c6113292>] ? pci_match_device+0xc2/0xf0
[    0.840367]  [<c63c3911>] __driver_attach+0x91/0xa0
[    0.840367]  [<c63c3880>] ? __device_attach+0x50/0x50
[    0.840367]  [<c63c1f7f>] bus_for_each_dev+0x4f/0x80
[    0.840367]  [<c63c39d9>] driver_attach+0x19/0x20
[    0.840367]  [<c63c3880>] ? __device_attach+0x50/0x50
[    0.840367]  [<c63c2897>] bus_add_driver+0x137/0x1f0
[    0.840367]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.840367]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.840367]  [<c63c4044>] driver_register+0x54/0xe0
[    0.840367]  [<c6113595>] __pci_register_driver+0x45/0x50
[    0.840367]  [<c624d0ba>] drm_pci_init+0xea/0x110
[    0.840367]  [<c5c77e5b>] ? trace_hardirqs_on+0xb/0x10
[    0.840367]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.840367]  [<c6edb706>] cirrus_init+0x20/0x22
[    0.840367]  [<c6eafc92>] do_one_initcall+0x16a/0x179
[    0.840367]  [<c5c54f00>] ? parse_args+0x150/0x3e0
[    0.840367]  [<c6eafd8e>] kernel_init_freeable+0xed/0x16a
[    0.840367]  [<c69925db>] kernel_init+0xb/0xe0
[    0.840367]  [<c69a9521>] ret_from_kernel_thread+0x21/0x30
[    0.840367]  [<c69925d0>] ? rest_init+0x120/0x120
[    0.862651] BUG: unable to handle kernel NULL pointer dereference at   (null)
[    0.863236] IP: [<c69a610a>] __ww_mutex_lock+0xfa/0x780
[    0.863655] *pdpt = 00000000125ad001 *pde = 0000000000000000 
[    0.864131] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[    0.864521] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc2-00221-g4e396fc #5
[    0.865109] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    0.865883] task: d3440000 ti: d341e000 task.ti: d341e000
[    0.866310] EIP: 0060:[<c69a610a>] EFLAGS: 00010082 CPU: 0
[    0.866638] EIP is at __ww_mutex_lock+0xfa/0x780
[    0.866638] EAX: 00000000 EBX: d2520b40 ECX: d2529834 EDX: d341fcdc
[    0.866638] ESI: d2529810 EDI: d2529814 EBP: d341fcf8 ESP: d341fcb4
[    0.866638]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    0.866638] CR0: 8005003b CR2: 00000000 CR3: 125ac000 CR4: 000006b0
[    0.866638] Stack:
[    0.866638]  00000000 00000001 d2520b58 c625e531 c625e531 d2529848 00000001 d3440000
[    0.866638]  d2520b40 00000246 d2529834 00000000 11111111 d341fcdc d2520b40 d2529810
[    0.866638]  d2520b40 d341fd0c c625e531 d2529800 d2528c00 d2520b40 d341fd20 c625e7c4
[    0.866638] Call Trace:
[    0.866638]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.866638]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.866638]  [<c625e531>] drm_modeset_lock+0x31/0xf0
[    0.866638]  [<c625e7c4>] drm_modeset_lock_all_crtcs+0x34/0x50
[    0.866638]  [<c625e884>] __drm_modeset_lock_all+0xa4/0xe0
[    0.866638]  [<c625e8ca>] drm_modeset_lock_all+0xa/0x30
[    0.866638]  [<c625022b>] drm_encoder_init+0x1b/0xe0
[    0.866638]  [<c5d0ea08>] ? kmem_cache_alloc+0x98/0x190
[    0.866638]  [<c6366d81>] ? cirrus_modeset_init+0xe1/0x1c0
[    0.866638]  [<c6366da7>] cirrus_modeset_init+0x107/0x1c0
[    0.866638]  [<c6365e47>] cirrus_driver_load+0x57/0x120
[    0.866638]  [<c624b75e>] drm_dev_register+0x9e/0x100
[    0.866638]  [<c624cea1>] drm_get_pci_dev+0x91/0x1c0
[    0.866638]  [<c5c77e5b>] ? trace_hardirqs_on+0xb/0x10
[    0.866638]  [<c69a5f58>] ? mutex_unlock+0x8/0x10
[    0.866638]  [<c6366fcc>] cirrus_pci_probe+0xac/0xf0
[    0.866638]  [<c6113337>] pci_device_probe+0x77/0xe0
[    0.866638]  [<c5d7fbb0>] ? sysfs_create_link+0x20/0x40
[    0.866638]  [<c63c3673>] driver_probe_device+0x73/0x230
[    0.866638]  [<c6113292>] ? pci_match_device+0xc2/0xf0
[    0.866638]  [<c63c3911>] __driver_attach+0x91/0xa0
[    0.866638]  [<c63c3880>] ? __device_attach+0x50/0x50
[    0.866638]  [<c63c1f7f>] bus_for_each_dev+0x4f/0x80
[    0.866638]  [<c63c39d9>] driver_attach+0x19/0x20
[    0.866638]  [<c63c3880>] ? __device_attach+0x50/0x50
[    0.866638]  [<c63c2897>] bus_add_driver+0x137/0x1f0
[    0.866638]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.866638]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.866638]  [<c63c4044>] driver_register+0x54/0xe0
[    0.866638]  [<c6113595>] __pci_register_driver+0x45/0x50
[    0.866638]  [<c624d0ba>] drm_pci_init+0xea/0x110
[    0.866638]  [<c5c77e5b>] ? trace_hardirqs_on+0xb/0x10
[    0.866638]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.866638]  [<c6edb706>] cirrus_init+0x20/0x22
[    0.866638]  [<c6eafc92>] do_one_initcall+0x16a/0x179
[    0.866638]  [<c5c54f00>] ? parse_args+0x150/0x3e0
[    0.866638]  [<c6eafd8e>] kernel_init_freeable+0xed/0x16a
[    0.866638]  [<c69925db>] kernel_init+0xb/0xe0
[    0.866638]  [<c69a9521>] ret_from_kernel_thread+0x21/0x30
[    0.866638]  [<c69925d0>] ? rest_init+0x120/0x120
[    0.866638] Code: 55 e4 89 f0 e8 a8 e9 2c ff 8b 45 d8 8d 55 e4 8b 48 04 89 f0 e8 d8 eb 2c ff 8b 46 28 8d 4e 24 8d 55 e4 89 56 28 89 4d e4 89 45 e8 <89> 10 8b 45 d8 89 4d d4 89 45 ec 8d 74 26 00 8d bc 27 00 00 00
[    0.866638] EIP: [<c69a610a>] __ww_mutex_lock+0xfa/0x780 SS:ESP 0068:d341fcb4
[    0.866638] CR2: 0000000000000000
[    0.866638] ---[ end trace 5dc0d5f349200b14 ]---
[    0.866638] Kernel panic - not syncing: Fatal exception

git bisect start 5a2aa64d4eafdaef278ff495025c59a5cd96eafb 69e273c0b0a3c337a521d083374c918dc52c666f --
git bisect good 82c3b0c30522510fcee89a14302aeb06df65f8d1  # 22:42     20+      5  Merge 'spi/fix/rockchip' into devel-roam-i386-201409052138
git bisect good 259fc4e3fc3c3f073edd07564eb82433d7c86cc7  # 23:47     20+      0  Merge 'drm-intel/drm-intel-nightly' into devel-roam-i386-201409052138
git bisect  bad 70d805ad73fa5ee4d860ff10f4ff98050c01c2d9  # 00:58      0-      1  Merge 'hch-scsi-queue/core-for-3.18' into devel-roam-i386-201409052138
git bisect good 16cd192c2100085aa6ce04ec186fe62346a3b173  # 01:31     20+     20  Merge 'drm/drm-mst-dell-30-hacks' into devel-roam-i386-201409052138
git bisect  bad 31c010b13c93e6a7e8553be9b1d885b61df434b4  # 01:50      1-     20  Merge 'drm-intel/topic/core-stuff' into devel-roam-i386-201409052138
git bisect  bad 4e396fc20db96c0af710601f081ffb41b0fe611c  # 02:15      0-      4  drm: Drop modeset locking from crtc init function
# first bad commit: [4e396fc20db96c0af710601f081ffb41b0fe611c] drm: Drop modeset locking from crtc init function
git bisect good 5c551b501aa8637e844ea85eaea10f4f75aff716  # 03:00     60+     29  drm/i915/hdmi: Enable pipe pixel replication for SD interlaced modes
git bisect  bad 5a2aa64d4eafdaef278ff495025c59a5cd96eafb  # 03:00      0-     11  0day head guard for 'devel-roam-i386-201409052138'
git bisect good fb762340e55638332407560396aea380b7af9cbf  # 03:11     60+     26  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/geert/linux-m68k
git bisect good 92d88cb068a5dc66d53ef017999b2419b125f764  # 04:16     60+      2  Add linux-next specific files for 20140905


This script may reproduce the error.

----------------------------------------------------------------------------
#!/bin/bash

kernel=$1
initrd=yocto-minimal-i386.cgz

wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/raw/master/initrd/$initrd

kvm=(
	qemu-system-x86_64
	-cpu kvm64
	-enable-kvm
	-kernel $kernel
	-initrd $initrd
	-m 320
	-smp 1
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-rtc base=localtime
	-serial stdio
	-display none
	-monitor null 
)

append=(
	hung_task_panic=1
	earlyprintk=ttyS0,115200
	debug
	apic=debug
	sysrq_always_enabled
	rcupdate.rcu_cpu_stall_timeout=100
	panic=-1
	softlockup_panic=1
	nmi_watchdog=panic
	oops=panic
	load_ramdisk=2
	prompt_ramdisk=0
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
	drbd.minor_count=8
)

"${kvm[@]}" --append "${append[*]}"
----------------------------------------------------------------------------

Thanks,
Fengguang

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-yocto-ivb41-46:20140906021532:i386-randconfig-r3-0905::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc2-00221-g4e396fc (kbuild@roam) (gcc v=
ersion 4.9.1 (Debian 4.9.1-11) ) #5 SMP Sat Sep 6 02:13:54 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0ed0-0x000f0edf] mapped at =
[c00f0ed0]
[    0.000000]   mpc: f0ee0-f0fb0
[    0.000000] initial memory mapped: [mem 0x00000000-0x07bfffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13a00000-0x13bfffff]
[    0.000000]  [mem 0x13a00000-0x13bfffff] page 4k
[    0.000000] BRK [0x077af000, 0x077affff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x139fffff]
[    0.000000]  [mem 0x10000000-0x139fffff] page 4k
[    0.000000] BRK [0x077b0000, 0x077b0fff] PGTABLE
[    0.000000] BRK [0x077b1000, 0x077b1fff] PGTABLE
[    0.000000] BRK [0x077b2000, 0x077b2fff] PGTABLE
[    0.000000] BRK [0x077b3000, 0x077b3fff] PGTABLE
[    0.000000] BRK [0x077b4000, 0x077b4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x13c00000-0x13fdffff]
[    0.000000]  [mem 0x13c00000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x13cad000-0x13fdffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0CF0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE1854 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000BF9 (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE17A4 000078 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE181C 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:13caa001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat c6ea0ec0, node_mem_map d3=
884028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:1 nr_cpu_ids:1 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @d3c96000 s29152 r0 d15904 u45=
056
[    0.000000] pcpu-alloc: s29152 r0 d15904 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 13c98600
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80990
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-r3-0905/linux-devel:devel-roam-i386-201409052138:4e396fc20db96c0a=
f710601f081ffb41b0fe611c:bisect-linux/.vmlinuz-4e396fc20db96c0af710601f081f=
fb41b0fe611c-20140906021433-2-ivb41 branch=3Dlinux-devel/devel-roam-i386-20=
1409052138 BOOT_IMAGE=3D/kernel/i386-randconfig-r3-0905/4e396fc20db96c0af71=
0601f081ffb41b0fe611c/vmlinuz-3.17.0-rc2-00221-g4e396fc drbd.minor_count=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 291388K/327160K available (13994K kernel code, 847K =
rwdata, 4280K rodata, 636K init, 8288K bss, 35772K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xff9fe000   ( 690 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xc6eaf000 - 0xc6f4e000   ( 636 kB)
[    0.000000]       .data : 0xc69aae38 - 0xc6eadea0   (5132 kB)
[    0.000000]       .text : 0xc5c00000 - 0xc69aae38   (13995 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D1
[    0.000000] NR_IRQS:2304 nr_irqs:256 0
[    0.000000] CPU 0 irqstacks, hard=3Dd3408000 soft=3Dd340a000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4911 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.506 MHz processor
[    0.004000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D10774024)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] ACPI: Core revision 20140724
[    0.008532] ACPI: All ACPI Tables successfully acquired
[    0.009059] Security Framework initialized
[    0.009401] SELinux:  Initializing.
[    0.009724] SELinux:  Starting in permissive mode
[    0.010139] AppArmor: AppArmor disabled by boot time parameter
[    0.010639] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.011188] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.012299] Initializing cgroup subsys net_cls
[    0.012690] Initializing cgroup subsys perf_event
[    0.013132] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013132] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.028336] debug: unmapping init [mem 0xc6f4e000-0xc6f57fff]
[    0.032547] Getting VERSION: 1050014
[    0.032861] Getting VERSION: 1050014
[    0.033165] Getting ID: 0
[    0.033391] Getting ID: f000000
[    0.033658] Getting LVT0: 8700
[    0.033909] Getting LVT1: 8400
[    0.034171] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.034628] enabled ExtINT on CPU#0
[    0.035579] ENABLING IO-APIC IRQs
[    0.035863] init IO_APIC IRQs
[    0.036005]  apic 0 pin 0 not connected
[    0.036348] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.037029] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.037685] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.038347] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.039006] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.039659] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.040020] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.040682] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.041337] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.042027] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.042713] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.043385] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.044021] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.044699] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.045361] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.046027]  apic 0 pin 16 not connected
[    0.046347]  apic 0 pin 17 not connected
[    0.046675]  apic 0 pin 18 not connected
[    0.046994]  apic 0 pin 19 not connected
[    0.047315]  apic 0 pin 20 not connected
[    0.048003]  apic 0 pin 21 not connected
[    0.048328]  apic 0 pin 22 not connected
[    0.048648]  apic 0 pin 23 not connected
[    0.049114] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.049585] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, m=
odel: 06, stepping: 01)
[    0.050311] Using local APIC timer interrupts.
[    0.050311] calibrating APIC timer ...
[    0.052000] ... lapic delta =3D 6249992
[    0.052000] ... PM-Timer delta =3D 357924
[    0.052000] ... PM-Timer result ok
[    0.052000] ..... delta 6249992
[    0.052000] ..... mult: 268435112
[    0.052000] ..... calibration result: 3999994
[    0.052000] ..... CPU clock speed is 2693.1195 MHz.
[    0.052000] ..... host bus clock speed is 999.3994 MHz.
[    0.052000] Performance Events: no PMU driver, software events only.
[    0.052000] x86: Booted up 1 node, 1 CPUs
[    0.052000] smpboot: Total of 1 processors activated (5387.01 BogoMIPS)
[    0.052000] evm: security.selinux
[    0.052000] evm: security.capability
[    0.052317] xor: measuring software checksum speed
[    0.092003]    pIII_sse  :  9383.000 MB/sec
[    0.132003]    prefetch64-sse: 11360.000 MB/sec
[    0.132373] xor: using function: prefetch64-sse (11360.000 MB/sec)
[    0.132891] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.133455] prandom: seed boundary self test passed
[    0.134301] prandom: 100 self tests passed
[    0.134637] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    0.135176] pinctrl core: initialized pinctrl subsystem
[    0.136025] regulator-dummy: no parameters
[    0.136643] NET: Registered protocol family 16
[    0.137717] cpuidle: using governor ladder
[    0.138552] ACPI: bus type PCI registered
[    0.139063] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.139650] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.140007] PCI: Using configuration type 1 for base access
[    0.216007] raid6: mmxx1     4951 MB/s
[    0.284007] raid6: mmxx2     5332 MB/s
[    0.352013] raid6: sse1x1    4082 MB/s
[    0.420011] raid6: sse1x2    5086 MB/s
[    0.488005] raid6: sse2x1    8011 MB/s
[    0.556004] raid6: sse2x2   10018 MB/s
[    0.556314] raid6: using algorithm sse2x2 (10018 MB/s)
[    0.557020] raid6: using intx1 recovery algorithm
[    0.557709] ACPI: Added _OSI(Module Device)
[    0.558048] ACPI: Added _OSI(Processor Device)
[    0.558407] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.558781] ACPI: Added _OSI(Processor Aggregator Device)
[    0.562429] ACPI: Interpreter enabled
[    0.562745] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140724/hwxface-580)
[    0.563505] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140724/hwxface-580)
[    0.564208] ACPI: (supports S0 S3 S5)
[    0.564515] ACPI: Using IOAPIC for interrupt routing
[    0.564935] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.572533] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.573035] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.573496] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.574210] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.575241] PCI host bridge to bus 0000:00
[    0.575619] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.576005] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.576507] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.576995] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.577489] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.577974] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.578471] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.579010] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.579609] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.580460] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.581424] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.584215] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.585468] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.586024] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.586543] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.587101] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.587853] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.588270] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.588844] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.589683] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.591177] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.592919] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.597795] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.598611] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.600005] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.601211] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.605074] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.605872] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.606743] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.610049] pci_bus 0000:00: on NUMA node 0
[    0.611057] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.611730] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.612300] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.612945] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.613523] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.614382] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.615767] SCSI subsystem initialized
[    0.616068] pps_core: LinuxPPS API ver. 1 registered
[    0.616474] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.617198] PTP clock support registered
[    0.617535] EDAC MC: Ver: 3.0.0
[    0.617943] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.618541] PCI: Using ACPI for IRQ routing
[    0.618881] PCI: pci_cache_line_size set to 64 bytes
[    0.619358] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.620011] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.620865] irda_init()
[    0.621098] NET: Registered protocol family 23
[    0.621497] Bluetooth: Core ver 2.19
[    0.621803] NET: Registered protocol family 31
[    0.622157] Bluetooth: HCI device and connection manager initialized
[    0.622673] Bluetooth: HCI socket layer initialized
[    0.623065] Bluetooth: L2CAP socket layer initialized
[    0.623531] Bluetooth: SCO socket layer initialized
[    0.624020] NET: Registered protocol family 8
[    0.624370] NET: Registered protocol family 20
[    0.625079] nfc: nfc_init: NFC Core ver 0.1
[    0.625459] NET: Registered protocol family 39
[    0.626325] Switched to clocksource kvm-clock
[    0.626881] FS-Cache: Loaded
[    0.627151] pnp: PnP ACPI init
[    0.627520] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.627520] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.627520] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.627520] pnp 00:03: [dma 2]
[    0.627520] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.627882] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.628512] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.629430] pnp: PnP ACPI: found 6 devices
[    0.664806] cfg80211: Calling CRDA to update world regulatory domain
[    0.665451] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.665901] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.666349] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.666784] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.667230] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.667662] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.668171] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.668707] NET: Registered protocol family 2
[    0.669391] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    0.670011] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    0.670730] TCP: Hash tables configured (established 4096 bind 4096)
[    0.671268] TCP: reno registered
[    0.671540] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.672048] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.672752] NET: Registered protocol family 1
[    0.673128] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.673597] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.674055] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.674564] pci 0000:00:02.0: Boot video device
[    0.674936] PCI: CLS 0 bytes, default 64
[    0.675434] Unpacking initramfs...
[    0.746562] debug: unmapping init [mem 0xd3cad000-0xd3fdffff]
[    0.747755] apm: BIOS not found.
[    0.748342] cryptomgr_test (21) used greatest stack depth: 7152 bytes le=
ft
[    0.748961] NatSemi SCx200 Driver
[    0.749302] spin_lock-torture:--- Start of test: nwriters_stress=3D2 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    0.750490] spin_lock-torture: Creating torture_shuffle task
[    0.750993] spin_lock-torture: Creating torture_stutter task
[    0.751480] spin_lock-torture: torture_shuffle task started
[    0.751932] spin_lock-torture: Creating lock_torture_writer task
[    0.752456] spin_lock-torture: torture_stutter task started
[    0.752914] spin_lock-torture: Creating lock_torture_writer task
[    0.753415] spin_lock-torture: lock_torture_writer task started
[    0.753907] spin_lock-torture: Creating lock_torture_stats task
[    0.754407] spin_lock-torture: lock_torture_writer task started
[    0.754896] torture_init_begin: refusing rcu init: spin_lock running
[    0.755682] futex hash table entries: 256 (order: 2, 16384 bytes)
[    0.756244] Initialise system trusted keyring
[    0.756647] audit: initializing netlink subsys (disabled)
[    0.757138] audit: type=3D2000 audit(1409936248.376:1): initialized
[    0.757836] spin_lock-torture: lock_torture_stats task started
[    0.762504] zbud: loaded
[    0.764606] ntfs: driver 2.1.30 [Flags: R/W].
[    0.765216] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    0.765690] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.766233] QNX4 filesystem 0.2.3 registered.
[    0.766784] JFS: nTxBlock =3D 2276, nTxLock =3D 18211
[    0.768733] SGI XFS with ACLs, security attributes, debug enabled
[    0.770260] NILFS version 2 loaded
[    0.770549] befs: version: 0.9.3
[    0.771454] gfs2: GFS2 installed
[    0.772071] SELinux:  Registering netfilter hooks
[    0.774346] NET: Registered protocol family 38
[    0.774731] Key type asymmetric registered
[    0.775094] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    0.775686] io scheduler noop registered
[    0.776020] io scheduler deadline registered (default)
[    0.776445] start plist test
[    0.777829] end plist test
[    0.778317] test_string_helpers: Running tests...
[    0.779952] hgafb: HGA card not detected.
[    0.780329] hgafb: probe of hgafb.0 failed with error -22
[    0.781886] v86d (82) used greatest stack depth: 6792 bytes left
[    0.782833] uvesafb: Getting VBE info block failed (eax=3D0x10a, err=3D0)
[    0.783353] uvesafb: vbe_init() failed with -22
[    0.783714] uvesafb: probe of uvesafb.0 failed with error -22
[    0.784368] ipmi message handler version 39.2
[    0.784731] ipmi device interface
[    0.785043] IPMI System Interface driver.
[    0.785417] ipmi_si: Adding default-specified kcs state machine
[    0.785900] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    0.786675] ipmi_si: Interface detection failed
[    0.787037] ipmi_si: Adding default-specified smic state machine
[    0.787526] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    0.788370] ipmi_si: Interface detection failed
[    0.788733] ipmi_si: Adding default-specified bt state machine
[    0.789206] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    0.789970] ipmi_si: Interface detection failed
[    0.790423] ipmi_si: Unable to find any System Interface(s)
[    0.791194] GHES: HEST is not enabled!
[    0.806507] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.832283] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    0.833581] lp: driver loaded but no devices found
[    0.833973] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    0.834475] scx200_gpio: no SCx200 gpio present
[    0.834838] nsc_gpio initializing
[    0.835114] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    0.835980] [drm] Initialized drm 1.1.0 20060810
[    0.836476] [drm] radeon kernel modesetting enabled.
[    0.837550] [TTM] Zone  kernel: Available graphics memory: 145694 kiB
[    0.838064] [TTM] Initializing pool allocator
[    0.838626] INFO: trying to register non-static key.
[    0.839022] the code is fine but needs lockdep annotation.
[    0.839454] turning off the locking correctness validator.
[    0.839884] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc2-00221-g=
4e396fc #5
[    0.840367] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.840367]  00000000 00000000 d341fc08 c69981fd c7394920 d341fc7c c5c7b=
341 c6c9ea3c
[    0.840367]  0900b705 d3440000 d341fc90 c5c79b96 d3440000 402dc174 d3440=
000 402dc174
[    0.840367]  00000005 01440000 00000000 d2529848 d2529848 00000000 c7362=
6e0 d34405d0
[    0.840367] Call Trace:
[    0.840367]  [<c69981fd>] dump_stack+0x48/0x60
[    0.840367]  [<c5c7b341>] __lock_acquire+0x1c21/0x1da0
[    0.840367]  [<c5c79b96>] ? __lock_acquire+0x476/0x1da0
[    0.840367]  [<c5c78a96>] ? __lock_is_held+0x46/0x60
[    0.840367]  [<c5c7bd11>] lock_acquire+0x91/0xc0
[    0.840367]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c69a607c>] __ww_mutex_lock+0x6c/0x780
[    0.840367]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c625e531>] drm_modeset_lock+0x31/0xf0
[    0.840367]  [<c625e7c4>] drm_modeset_lock_all_crtcs+0x34/0x50
[    0.840367]  [<c625e884>] __drm_modeset_lock_all+0xa4/0xe0
[    0.840367]  [<c625e8ca>] drm_modeset_lock_all+0xa/0x30
[    0.840367]  [<c625022b>] drm_encoder_init+0x1b/0xe0
[    0.840367]  [<c5d0ea08>] ? kmem_cache_alloc+0x98/0x190
[    0.840367]  [<c6366d81>] ? cirrus_modeset_init+0xe1/0x1c0
[    0.840367]  [<c6366da7>] cirrus_modeset_init+0x107/0x1c0
[    0.840367]  [<c6365e47>] cirrus_driver_load+0x57/0x120
[    0.840367]  [<c624b75e>] drm_dev_register+0x9e/0x100
[    0.840367]  [<c624cea1>] drm_get_pci_dev+0x91/0x1c0
[    0.840367]  [<c5c77e5b>] ? trace_hardirqs_on+0xb/0x10
[    0.840367]  [<c69a5f58>] ? mutex_unlock+0x8/0x10
[    0.840367]  [<c6366fcc>] cirrus_pci_probe+0xac/0xf0
[    0.840367]  [<c6113337>] pci_device_probe+0x77/0xe0
[    0.840367]  [<c5d7fbb0>] ? sysfs_create_link+0x20/0x40
[    0.840367]  [<c63c3673>] driver_probe_device+0x73/0x230
[    0.840367]  [<c6113292>] ? pci_match_device+0xc2/0xf0
[    0.840367]  [<c63c3911>] __driver_attach+0x91/0xa0
[    0.840367]  [<c63c3880>] ? __device_attach+0x50/0x50
[    0.840367]  [<c63c1f7f>] bus_for_each_dev+0x4f/0x80
[    0.840367]  [<c63c39d9>] driver_attach+0x19/0x20
[    0.840367]  [<c63c3880>] ? __device_attach+0x50/0x50
[    0.840367]  [<c63c2897>] bus_add_driver+0x137/0x1f0
[    0.840367]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.840367]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.840367]  [<c63c4044>] driver_register+0x54/0xe0
[    0.840367]  [<c6113595>] __pci_register_driver+0x45/0x50
[    0.840367]  [<c624d0ba>] drm_pci_init+0xea/0x110
[    0.840367]  [<c5c77e5b>] ? trace_hardirqs_on+0xb/0x10
[    0.840367]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.840367]  [<c6edb706>] cirrus_init+0x20/0x22
[    0.840367]  [<c6eafc92>] do_one_initcall+0x16a/0x179
[    0.840367]  [<c5c54f00>] ? parse_args+0x150/0x3e0
[    0.840367]  [<c6eafd8e>] kernel_init_freeable+0xed/0x16a
[    0.840367]  [<c69925db>] kernel_init+0xb/0xe0
[    0.840367]  [<c69a9521>] ret_from_kernel_thread+0x21/0x30
[    0.840367]  [<c69925d0>] ? rest_init+0x120/0x120
[    0.862651] BUG: unable to handle kernel NULL pointer dereference at   (=
null)
[    0.863236] IP: [<c69a610a>] __ww_mutex_lock+0xfa/0x780
[    0.863655] *pdpt =3D 00000000125ad001 *pde =3D 0000000000000000=20
[    0.864131] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
[    0.864521] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.17.0-rc2-00221-g=
4e396fc #5
[    0.865109] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[    0.865883] task: d3440000 ti: d341e000 task.ti: d341e000
[    0.866310] EIP: 0060:[<c69a610a>] EFLAGS: 00010082 CPU: 0
[    0.866638] EIP is at __ww_mutex_lock+0xfa/0x780
[    0.866638] EAX: 00000000 EBX: d2520b40 ECX: d2529834 EDX: d341fcdc
[    0.866638] ESI: d2529810 EDI: d2529814 EBP: d341fcf8 ESP: d341fcb4
[    0.866638]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[    0.866638] CR0: 8005003b CR2: 00000000 CR3: 125ac000 CR4: 000006b0
[    0.866638] Stack:
[    0.866638]  00000000 00000001 d2520b58 c625e531 c625e531 d2529848 00000=
001 d3440000
[    0.866638]  d2520b40 00000246 d2529834 00000000 11111111 d341fcdc d2520=
b40 d2529810
[    0.866638]  d2520b40 d341fd0c c625e531 d2529800 d2528c00 d2520b40 d341f=
d20 c625e7c4
[    0.866638] Call Trace:
[    0.866638]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.866638]  [<c625e531>] ? drm_modeset_lock+0x31/0xf0
[    0.866638]  [<c625e531>] drm_modeset_lock+0x31/0xf0
[    0.866638]  [<c625e7c4>] drm_modeset_lock_all_crtcs+0x34/0x50
[    0.866638]  [<c625e884>] __drm_modeset_lock_all+0xa4/0xe0
[    0.866638]  [<c625e8ca>] drm_modeset_lock_all+0xa/0x30
[    0.866638]  [<c625022b>] drm_encoder_init+0x1b/0xe0
[    0.866638]  [<c5d0ea08>] ? kmem_cache_alloc+0x98/0x190
[    0.866638]  [<c6366d81>] ? cirrus_modeset_init+0xe1/0x1c0
[    0.866638]  [<c6366da7>] cirrus_modeset_init+0x107/0x1c0
[    0.866638]  [<c6365e47>] cirrus_driver_load+0x57/0x120
[    0.866638]  [<c624b75e>] drm_dev_register+0x9e/0x100
[    0.866638]  [<c624cea1>] drm_get_pci_dev+0x91/0x1c0
[    0.866638]  [<c5c77e5b>] ? trace_hardirqs_on+0xb/0x10
[    0.866638]  [<c69a5f58>] ? mutex_unlock+0x8/0x10
[    0.866638]  [<c6366fcc>] cirrus_pci_probe+0xac/0xf0
[    0.866638]  [<c6113337>] pci_device_probe+0x77/0xe0
[    0.866638]  [<c5d7fbb0>] ? sysfs_create_link+0x20/0x40
[    0.866638]  [<c63c3673>] driver_probe_device+0x73/0x230
[    0.866638]  [<c6113292>] ? pci_match_device+0xc2/0xf0
[    0.866638]  [<c63c3911>] __driver_attach+0x91/0xa0
[    0.866638]  [<c63c3880>] ? __device_attach+0x50/0x50
[    0.866638]  [<c63c1f7f>] bus_for_each_dev+0x4f/0x80
[    0.866638]  [<c63c39d9>] driver_attach+0x19/0x20
[    0.866638]  [<c63c3880>] ? __device_attach+0x50/0x50
[    0.866638]  [<c63c2897>] bus_add_driver+0x137/0x1f0
[    0.866638]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.866638]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.866638]  [<c63c4044>] driver_register+0x54/0xe0
[    0.866638]  [<c6113595>] __pci_register_driver+0x45/0x50
[    0.866638]  [<c624d0ba>] drm_pci_init+0xea/0x110
[    0.866638]  [<c5c77e5b>] ? trace_hardirqs_on+0xb/0x10
[    0.866638]  [<c6edb6e6>] ? mgag200_init+0x22/0x22
[    0.866638]  [<c6edb706>] cirrus_init+0x20/0x22
[    0.866638]  [<c6eafc92>] do_one_initcall+0x16a/0x179
[    0.866638]  [<c5c54f00>] ? parse_args+0x150/0x3e0
[    0.866638]  [<c6eafd8e>] kernel_init_freeable+0xed/0x16a
[    0.866638]  [<c69925db>] kernel_init+0xb/0xe0
[    0.866638]  [<c69a9521>] ret_from_kernel_thread+0x21/0x30
[    0.866638]  [<c69925d0>] ? rest_init+0x120/0x120
[    0.866638] Code: 55 e4 89 f0 e8 a8 e9 2c ff 8b 45 d8 8d 55 e4 8b 48 04 =
89 f0 e8 d8 eb 2c ff 8b 46 28 8d 4e 24 8d 55 e4 89 56 28 89 4d e4 89 45 e8 =
<89> 10 8b 45 d8 89 4d d4 89 45 ec 8d 74 26 00 8d bc 27 00 00 00
[    0.866638] EIP: [<c69a610a>] __ww_mutex_lock+0xfa/0x780 SS:ESP 0068:d34=
1fcb4
[    0.866638] CR2: 0000000000000000
[    0.866638] ---[ end trace 5dc0d5f349200b14 ]---
[    0.866638] Kernel panic - not syncing: Fatal exception
[    0.866638] Kernel Offset: 0x4c00000 from 0xc1000000 (relocation range: =
0xc0000000-0xd47dffff)

Elapsed time: 5
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
3-0905/4e396fc20db96c0af710601f081ffb41b0fe611c/vmlinuz-3.17.0-rc2-00221-g4=
e396fc -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 =
prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r3-0905/=
linux-devel:devel-roam-i386-201409052138:4e396fc20db96c0af710601f081ffb41b0=
fe611c:bisect-linux/.vmlinuz-4e396fc20db96c0af710601f081ffb41b0fe611c-20140=
906021433-2-ivb41 branch=3Dlinux-devel/devel-roam-i386-201409052138 BOOT_IM=
AGE=3D/kernel/i386-randconfig-r3-0905/4e396fc20db96c0af710601f081ffb41b0fe6=
11c/vmlinuz-3.17.0-rc2-00221-g4e396fc drbd.minor_count=3D8'  -initrd /kerne=
l-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 1 -net nic,vlan=3D1,model=
=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb =
-rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-yocto-ivb41-46 -serial fi=
le:/dev/shm/kboot/serial-yocto-ivb41-46 -daemonize -display none -monitor n=
ull=20

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-ivb42-104:20140906025146:i386-randconfig-r3-0905::"
Content-Transfer-Encoding: quoted-printable

early console in setup code
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.17.0-rc2-00220-g5c551b5 (kbuild@roam) (gcc v=
ersion 4.9.1 (Debian 4.9.1-11) ) #8 SMP Sat Sep 6 02:49:23 CST 2014
[    0.000000] KERNEL supported cpus:
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000013fdffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000013fe0000-0x0000000013ffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-2014=
0531_083030-gandalf 04/01/2014
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x13fe0 max_arch_pfn =3D 0x1000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask FF80000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f0eb0-0x000f0ebf] mapped at =
[c00f0eb0]
[    0.000000]   mpc: f0ec0-f0fa4
[    0.000000] initial memory mapped: [mem 0x00000000-0x0f9fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12400000-0x125fffff]
[    0.000000]  [mem 0x12400000-0x125fffff] page 4k
[    0.000000] BRK [0x0f5ee000, 0x0f5eefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x10000000-0x123fffff]
[    0.000000]  [mem 0x10000000-0x123fffff] page 4k
[    0.000000] BRK [0x0f5ef000, 0x0f5effff] PGTABLE
[    0.000000] BRK [0x0f5f0000, 0x0f5f0fff] PGTABLE
[    0.000000] BRK [0x0f5f1000, 0x0f5f1fff] PGTABLE
[    0.000000] BRK [0x0f5f2000, 0x0f5f2fff] PGTABLE
[    0.000000] BRK [0x0f5f3000, 0x0f5f3fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x0fffffff]
[    0.000000]  [mem 0x00100000-0x0fffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x12600000-0x13fdffff]
[    0.000000]  [mem 0x12600000-0x13fdffff] page 4k
[    0.000000] RAMDISK: [mem 0x1279b000-0x13fdffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000F0C90 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x13FE18BD 000034 (v01 BOCHS  BXPCRSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACP 0x13FE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 B=
XPC 00000001)
[    0.000000] ACPI: DSDT 0x13FE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: FACS 0x13FE0000 000040
[    0.000000] ACPI: SSDT 0x13FE0BAB 000C5A (v01 BOCHS  BXPCSSDT 00000001 B=
XPC 00000001)
[    0.000000] ACPI: APIC 0x13FE1805 000080 (v01 BOCHS  BXPCAPIC 00000001 B=
XPC 00000001)
[    0.000000] ACPI: HPET 0x13FE1885 000038 (v01 BOCHS  BXPCHPET 00000001 B=
XPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 319MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 13fe0000
[    0.000000]   low ram: 0 - 13fe0000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:12798001, primary cpu clock
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x13fdffff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x13fdffff]
[    0.000000] On node 0 totalpages: 81790
[    0.000000] free_area_init_node: node 0, pgdat ceca0ec0, node_mem_map d2=
2c3028
[    0.000000]   DMA zone: 40 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 760 pages used for memmap
[    0.000000]   Normal zone: 77792 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] e820: [mem 0x14000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 11 pages/cpu @d2779000 s29152 r0 d15904 u45=
056
[    0.000000] pcpu-alloc: s29152 r0 d15904 u45056 alloc=3D11*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 1277b600
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 80990
[    0.000000] Kernel command line: hung_task_panic=3D1 earlyprintk=3DttyS0=
,115200 debug apic=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_time=
out=3D100 panic=3D-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic=
 load_ramdisk=3D2 prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 =
vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-r=
andconfig-r3-0905/linux-devel:devel-roam-i386-201409052138:5c551b501aa8637e=
844ea85eaea10f4f75aff716:bisect-linux/.vmlinuz-5c551b501aa8637e844ea85eaea1=
0f4f75aff716-20140906024956-39-ivb42 branch=3Dlinux-devel/devel-roam-i386-2=
01409052138 BOOT_IMAGE=3D/kernel/i386-randconfig-r3-0905/5c551b501aa8637e84=
4ea85eaea10f4f75aff716/vmlinuz-3.17.0-rc2-00220-g5c551b5 drbd.minor_count=
=3D8
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 byt=
es)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 byte=
s)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 269768K/327160K available (13994K kernel code, 847K =
rwdata, 4280K rodata, 636K init, 8288K bss, 57392K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd35000 - 0xfffff000   (2856 kB)
[    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.000000]     vmalloc : 0xd47e0000 - 0xff9fe000   ( 690 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd3fe0000   ( 319 MB)
[    0.000000]       .init : 0xcecaf000 - 0xced4e000   ( 636 kB)
[    0.000000]       .data : 0xce7aae78 - 0xcecadea0   (5132 kB)
[    0.000000]       .text : 0xcda00000 - 0xce7aae78   (13995 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D2, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D2
[    0.000000] NR_IRQS:2304 nr_irqs:440 0
[    0.000000] CPU 0 irqstacks, hard=3Dd1c0a000 soft=3Dd1c0c000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 4911 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.508 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.004000] Calibrating delay loop (skipped) preset value.. 5387.01 Bogo=
MIPS (lpj=3D10774032)
[    0.004000] pid_max: default: 32768 minimum: 301
[    0.004000] ACPI: Core revision 20140724
[    0.009217] ACPI: All ACPI Tables successfully acquired
[    0.009795] Security Framework initialized
[    0.010126] SELinux:  Initializing.
[    0.010449] SELinux:  Starting in permissive mode
[    0.010826] AppArmor: AppArmor disabled by boot time parameter
[    0.011332] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
[    0.011863] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 by=
tes)
[    0.012516] Initializing cgroup subsys net_cls
[    0.012888] Initializing cgroup subsys perf_event
[    0.013322] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.013322] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.014808] debug: unmapping init [mem 0xced4e000-0xced57fff]
[    0.019493] Getting VERSION: 1050014
[    0.019793] Getting VERSION: 1050014
[    0.020005] Getting ID: 0
[    0.020254] Getting ID: f000000
[    0.020525] Getting LVT0: 8700
[    0.020764] Getting LVT1: 8400
[    0.021002] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.021443] enabled ExtINT on CPU#0
[    0.022408] ENABLING IO-APIC IRQs
[    0.022678] init IO_APIC IRQs
[    0.022912]  apic 0 pin 0 not connected
[    0.023266] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.024032] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.024704] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.025341] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.025987] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.026625] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.027268] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.027903] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.028023] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.028650] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.029314] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.029955] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.030590] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.031258] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.032023] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.032663]  apic 0 pin 16 not connected
[    0.032987]  apic 0 pin 17 not connected
[    0.033288]  apic 0 pin 18 not connected
[    0.033589]  apic 0 pin 19 not connected
[    0.033901]  apic 0 pin 20 not connected
[    0.034203]  apic 0 pin 21 not connected
[    0.034505]  apic 0 pin 22 not connected
[    0.034834]  apic 0 pin 23 not connected
[    0.035285] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.036004] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, m=
odel: 06, stepping: 01)
[    0.037421] Using local APIC timer interrupts.
[    0.037421] calibrating APIC timer ...
[    0.040000] ... lapic delta =3D 6250083
[    0.040000] ... PM-Timer delta =3D 357959
[    0.040000] ... PM-Timer result ok
[    0.040000] ..... delta 6250083
[    0.040000] ..... mult: 268439020
[    0.040000] ..... calibration result: 4000053
[    0.040000] ..... CPU clock speed is 2693.2389 MHz.
[    0.040000] ..... host bus clock speed is 1000.0053 MHz.
[    0.040091] Performance Events: no PMU driver, software events only.
[    0.041955] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.043265] CPU 1 irqstacks, hard=3Dd1c94000 soft=3Dd1c96000
[    0.044005] x86: Booting SMP configuration:
[    0.044615] .... node  #0, CPUs:      #1
[    0.004000] Initializing CPU#1
[    0.004000] kvm-clock: cpu 1, msr 0:12798021, secondary cpu clock
[    0.004000] masked ExtINT on CPU#1
[    0.057994] x86: Booted up 1 node, 2 CPUs
[    0.057941] KVM setup async PF for cpu 1
[    0.057941] kvm-stealtime: cpu 1, msr 12786600
[    0.059546] smpboot: Total of 2 processors activated (10774.03 BogoMIPS)
[    0.062101] evm: security.selinux
[    0.062514] evm: security.capability
[    0.064268] xor: measuring software checksum speed
[    0.104007]    pIII_sse  :  7095.000 MB/sec
[    0.144006]    prefetch64-sse:  8571.000 MB/sec
[    0.144566] xor: using function: prefetch64-sse (8571.000 MB/sec)
[    0.145306] prandom: seed boundary self test passed
[    0.146855] prandom: 100 self tests passed
[    0.147352] atomic64_test: passed for i586+ platform with CX8 and with S=
SE
[    0.148009] pinctrl core: initialized pinctrl subsystem
[    0.149266] regulator-dummy: no parameters
[    0.150177] NET: Registered protocol family 16
[    0.151812] cpuidle: using governor ladder
[    0.152763] ACPI: bus type PCI registered
[    0.153561] PCI : PCI BIOS area is rw and x. Use pci=3Dnobios if you wan=
t it NX.
[    0.154424] PCI: PCI BIOS revision 2.10 entry at 0xfd456, last bus=3D0
[    0.155173] PCI: Using configuration type 1 for base access
[    0.248022] raid6: mmxx1     3075 MB/s
[    0.316015] raid6: mmxx2     4130 MB/s
[    0.384016] raid6: sse1x1    3590 MB/s
[    0.452023] raid6: sse1x2    3235 MB/s
[    0.520010] raid6: sse2x1    5007 MB/s
[    0.588047] raid6: sse2x2    6473 MB/s
[    0.588406] raid6: using algorithm sse2x2 (6473 MB/s)
[    0.588789] raid6: using intx1 recovery algorithm
[    0.589793] ACPI: Added _OSI(Module Device)
[    0.590133] ACPI: Added _OSI(Processor Device)
[    0.590483] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.590846] ACPI: Added _OSI(Processor Aggregator Device)
[    0.595366] ACPI: Interpreter enabled
[    0.595765] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140724/hwxface-580)
[    0.596667] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140724/hwxface-580)
[    0.597446] ACPI: (supports S0 S3 S5)
[    0.597730] ACPI: Using IOAPIC for interrupt routing
[    0.598161] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.607088] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.607596] acpi PNP0A03:00: _OSC: OS supports [Segments]
[    0.608037] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.608746] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.609747] PCI host bridge to bus 0000:00
[    0.610067] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.610490] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.610953] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.611423] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.611885] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.612011] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.612474] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.612985] pci_bus 0000:00: root bus resource [mem 0x14000000-0xfebffff=
f]
[    0.613556] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.614769] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.616688] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.620914] pci 0000:00:01.1: reg 0x20: [io  0xc040-0xc04f]
[    0.622807] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x=
01f7]
[    0.623657] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.624006] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x=
0177]
[    0.624838] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.626049] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.627196] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX=
4 ACPI
[    0.628017] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX=
4 SMB
[    0.629340] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.632011] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.634247] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.642084] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.643394] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.645166] pci 0000:00:03.0: reg 0x10: [mem 0xfebc0000-0xfebdffff]
[    0.647017] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.653134] pci 0000:00:03.0: reg 0x30: [mem 0xfeb80000-0xfebbffff pref]
[    0.654439] pci 0000:00:04.0: [8086:25ab] type 00 class 0x088000
[    0.656007] pci 0000:00:04.0: reg 0x10: [mem 0xfebf1000-0xfebf100f]
[    0.660931] pci_bus 0000:00: on NUMA node 0
[    0.662603] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.663633] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.664480] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.665494] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.666373] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.668000] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.669811] SCSI subsystem initialized
[    0.670402] pps_core: LinuxPPS API ver. 1 registered
[    0.671003] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.672022] PTP clock support registered
[    0.672546] EDAC MC: Ver: 3.0.0
[    0.673162] EDAC DEBUG: edac_mc_sysfs_init: device mc created
[    0.674123] PCI: Using ACPI for IRQ routing
[    0.674641] PCI: pci_cache_line_size set to 64 bytes
[    0.676137] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.676893] e820: reserve RAM buffer [mem 0x13fe0000-0x13ffffff]
[    0.678245] irda_init()
[    0.678603] NET: Registered protocol family 23
[    0.679217] Bluetooth: Core ver 2.19
[    0.679700] NET: Registered protocol family 31
[    0.680005] Bluetooth: HCI device and connection manager initialized
[    0.680803] Bluetooth: HCI socket layer initialized
[    0.681427] Bluetooth: L2CAP socket layer initialized
[    0.682107] Bluetooth: SCO socket layer initialized
[    0.682731] NET: Registered protocol family 8
[    0.683282] NET: Registered protocol family 20
[    0.684416] cfg80211: Calling CRDA to update world regulatory domain
[    0.685549] nfc: nfc_init: NFC Core ver 0.1
[    0.686130] NET: Registered protocol family 39
[    0.687366] Switched to clocksource kvm-clock
[    0.687366] FS-Cache: Loaded
[    0.687366] pnp: PnP ACPI init
[    0.687366] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.687366] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.687366] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.687366] pnp 00:03: [dma 2]
[    0.687366] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.687864] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.688472] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.689393] pnp: PnP ACPI: found 6 devices
[    0.724881] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.725320] pci_bus 0000:00: resource 5 [io  0x0d00-0xadff]
[    0.725746] pci_bus 0000:00: resource 6 [io  0xae0f-0xaeff]
[    0.726166] pci_bus 0000:00: resource 7 [io  0xaf20-0xafdf]
[    0.726584] pci_bus 0000:00: resource 8 [io  0xafe4-0xffff]
[    0.727019] pci_bus 0000:00: resource 9 [mem 0x000a0000-0x000bffff]
[    0.727491] pci_bus 0000:00: resource 10 [mem 0x14000000-0xfebfffff]
[    0.728064] NET: Registered protocol family 2
[    0.728793] TCP established hash table entries: 4096 (order: 2, 16384 by=
tes)
[    0.729392] TCP bind hash table entries: 4096 (order: 5, 147456 bytes)
[    0.730091] TCP: Hash tables configured (established 4096 bind 4096)
[    0.730604] TCP: reno registered
[    0.730874] UDP hash table entries: 256 (order: 2, 20480 bytes)
[    0.731356] UDP-Lite hash table entries: 256 (order: 2, 20480 bytes)
[    0.732045] NET: Registered protocol family 1
[    0.732405] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.732883] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.733328] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.733823] pci 0000:00:02.0: Boot video device
[    0.734185] PCI: CLS 0 bytes, default 64
[    0.734683] Unpacking initramfs...
[    1.572044] debug: unmapping init [mem 0xd279b000-0xd3fdffff]
[    1.573662] apm: BIOS not found.
[    1.574300] cryptomgr_test (27) used greatest stack depth: 7152 bytes le=
ft
[    1.574996] NatSemi SCx200 Driver
[    1.575317] spin_lock-torture:--- Start of test: nwriters_stress=3D4 sta=
t_interval=3D60 verbose=3D1 shuffle_interval=3D3 stutter=3D5 shutdown_secs=
=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[    1.576550] spin_lock-torture: Creating torture_shuffle task
[    1.577078] spin_lock-torture: Creating torture_stutter task
[    1.577523] spin_lock-torture: torture_shuffle task started
[    1.577968] spin_lock-torture: Creating lock_torture_writer task
[    1.577978] spin_lock-torture: torture_stutter task started
[    1.578999] spin_lock-torture: Creating lock_torture_writer task
[    1.579465] spin_lock-torture: lock_torture_writer task started
[    1.579948] spin_lock-torture: Creating lock_torture_writer task
[    1.579973] spin_lock-torture: lock_torture_writer task started
[    1.586364] spin_lock-torture: Creating lock_torture_writer task
[    1.587112] spin_lock-torture: lock_torture_writer task started
[    1.587922] spin_lock-torture: Creating lock_torture_stats task
[    1.587931] spin_lock-torture: lock_torture_writer task started
[    1.589475] torture_init_begin: refusing rcu init: spin_lock running
[    1.590803] futex hash table entries: 512 (order: 3, 32768 bytes)
[    1.591637] Initialise system trusted keyring
[    1.592273] audit: initializing netlink subsys (disabled)
[    1.593025] audit: type=3D2000 audit(1409942693.970:1): initialized
[    1.594053] spin_lock-torture: lock_torture_stats task started
[    1.601425] zbud: loaded
[    1.603601] ntfs: driver 2.1.30 [Flags: R/W].
[    1.604306] efs: 1.0a - http://aeschi.ch.eu.org/efs/
[    1.604786] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.605317] QNX4 filesystem 0.2.3 registered.
[    1.605873] JFS: nTxBlock =3D 2107, nTxLock =3D 16860
[    1.607532] SGI XFS with ACLs, security attributes, debug enabled
[    1.609732] NILFS version 2 loaded
[    1.610012] befs: version: 0.9.3
[    1.611088] gfs2: GFS2 installed
[    1.611696] SELinux:  Registering netfilter hooks
[    1.615541] NET: Registered protocol family 38
[    1.615922] Key type asymmetric registered
[    1.616328] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.616910] io scheduler noop registered
[    1.617217] io scheduler deadline registered (default)
[    1.617606] start plist test
[    1.620024] end plist test
[    1.620783] test_string_helpers: Running tests...
[    1.623634] hgafb: HGA card not detected.
[    1.624246] hgafb: probe of hgafb.0 failed with error -22
[    1.625832] kworker/u4:0 (91) used greatest stack depth: 6980 bytes left
[    1.625889] uvesafb: failed to execute /sbin/v86d
[    1.625890] uvesafb: make sure that the v86d helper is installed and exe=
cutable
[    1.625893] uvesafb: Getting VBE info block failed (eax=3D0x4f00, err=3D=
-2)
[    1.625895] uvesafb: vbe_init() failed with -22
[    1.625905] uvesafb: probe of uvesafb.0 failed with error -22
[    1.625993] ipmi message handler version 39.2
[    1.626003] ipmi device interface
[    1.626069] IPMI System Interface driver.
[    1.626142] ipmi_si: Adding default-specified kcs state machine
[    1.626144] ipmi_si: Trying default-specified kcs state machine at i/o a=
ddress 0xca2, slave address 0x0, irq 0
[    1.626169] ipmi_si: Interface detection failed
[    1.633811] kworker/u4:0 (90) used greatest stack depth: 6964 bytes left
[    1.640088] ipmi_si: Adding default-specified smic state machine
[    1.640945] ipmi_si: Trying default-specified smic state machine at i/o =
address 0xca9, slave address 0x0, irq 0
[    1.642279] ipmi_si: Interface detection failed
[    1.652049] ipmi_si: Adding default-specified bt state machine
[    1.652798] ipmi_si: Trying default-specified bt state machine at i/o ad=
dress 0xe4, slave address 0x0, irq 0
[    1.653959] ipmi_si: Interface detection failed
[    1.668225] ipmi_si: Unable to find any System Interface(s)
[    1.669677] GHES: HEST is not enabled!
[    1.696482] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.725223] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.727494] lp: driver loaded but no devices found
[    1.728100] sonypi: Sony Programmable I/O Controller Driver v1.26.
[    1.728858] scx200_gpio: no SCx200 gpio present
[    1.729400] nsc_gpio initializing
[    1.729812] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    1.731116] [drm] Initialized drm 1.1.0 20060810
[    1.731844] [drm] radeon kernel modesetting enabled.
[    1.733577] [TTM] Zone  kernel: Available graphics memory: 134884 kiB
[    1.734354] [TTM] Initializing pool allocator
[    1.736797] [drm] fb mappable at 0xFC000000
[    1.737307] [drm] vram aper at 0xFC000000
[    1.737794] [drm] size 4194304
[    1.738162] [drm] fb depth is 24
[    1.738551] [drm]    pitch is 3072
[    1.739264] cirrus 0000:00:02.0: fb0: cirrusdrmfb frame buffer device
[    1.740054] cirrus 0000:00:02.0: registered panic notifier
[    1.752038] [drm] Initialized cirrus 1.0.0 20110418 for 0000:00:02.0 on =
minor 0
[    1.753997] parport_pc 00:04: reported by Plug and Play ACPI
[    1.754832] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    1.856382] lp0: using parport0 (interrupt-driven).
[    1.859359] Floppy drive(s): fd0 is 1.44M
[    1.861603] loop: module loaded
[    1.862013] HP CISS Driver (v 3.6.26)
[    1.862922] MM: desc_per_page =3D 128
[    1.863758] nbd: registered device at major 43
[    1.867551] dummy-irq: no IRQ given.  Use irq=3DN
[    1.867957] lkdtm: No crash points registered, enable through debugfs
[    1.868552] Phantom Linux Driver, version n0.9.8, init OK
[    1.869107] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    1.870185] Loading iSCSI transport class v2.0-870.
[    1.870825] rdac: device handler registered
[    1.871239] hp_sw: device handler registered
[    1.871581] emc: device handler registered
[    1.871916] alua: device handler registered
[    1.872254] st: Version 20101219, fixed bufsize 32768, s/g segs 256
[    1.872861] SCSI Media Changer driver v0.25=20
[    1.873273] parport0: powerup/reset Butterfly
[    1.876639] FDC 0 is a S82078B
[    1.988236] parport_pc 00:04: registered master spi42
[    1.989177] spi spi42.1: spi_bitbang_setup, 66 nsec/bit
[    1.989926] spi spi42.1: setup mode 0, 8 bits/w, 15000000 Hz max --> 0
[    1.990947] parport_pc 00:04: registered child spi42.1
[    1.991639] parport0: dataflash at spi42.1
[    1.992199] parport0: AVR Butterfly
[    1.992664] parport0: cannot grant exclusive access for device spi-lm70l=
lp
[    1.993576] spi-lm70llp: spi_lm70llp probe fail, status -12
[    1.994744] I2O subsystem v1.325
[    1.995185] i2o: max drivers =3D 8
[    1.995828] I2O Configuration OSM v1.323
[    1.996392] I2O Bus Adapter OSM v1.317
[    1.996906] I2O Block Device OSM v1.325
[    1.997713] I2O SCSI Peripheral OSM v1.316
[    1.998258] I2O ProcFS OSM v1.316
[    1.998726] Fusion MPT base driver 3.04.20
[    1.999253] Copyright (c) 1999-2008 LSI Corporation
[    1.999880] Fusion MPT SPI Host driver 3.04.20
[    2.000484] Fusion MPT FC Host driver 3.04.20
[    2.000858] Fusion MPT SAS Host driver 3.04.20
[    2.001223] Fusion MPT misc device (ioctl) driver 3.04.20
[    2.001688] mptctl: Registered with Fusion MPT base driver
[    2.002114] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    2.003156] aoe: AoE v85 initialised.
[    2.003573] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    2.004970] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.005378] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.005944] parport0: cannot grant exclusive access for device parkbd
[    2.006680] apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
[    2.007432] wistron_btns: System unknown
[    2.008771] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    2.009574] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[    2.010952] rtc (null): invalid alarm value: 1900-1-5 0:0:0
[    2.011429] rtc-test rtc-test.0: rtc core: registered test as rtc0
[    2.011987] rtc (null): invalid alarm value: 1900-1-5 0:0:0
[    2.012559] rtc-test rtc-test.1: rtc core: registered test as rtc1
[    2.013148] i2c /dev entries driver
[    2.013589] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, re=
vision 0
[    2.112315] i2c-parport-light: adapter type unspecified
[    2.112961] pps pps0: new PPS source ktimer
[    2.113284] pps pps0: ktimer PPS source registered
[    2.113653] pps_parport: parallel port PPS client
[    2.114019] parport0: cannot grant exclusive access for device pps_parpo=
rt
[    2.114570] pps_parport: couldn't register with parport0
[    2.115039] Driver for 1-wire Dallas network protocol.
[    2.115552] DS1WM w1 busmaster driver - (c) 2004 Szabolcs Gyurko
[    2.532082] applesmc: supported laptop not found!
[    2.532477] applesmc: driver init failed (ret=3D-19)!
[    3.444159] acquirewdt: WDT driver for Acquire single board computer ini=
tialising
[    3.445777] acquirewdt: I/O address 0x0043 already in use
[    3.446215] acquirewdt: probe of acquirewdt failed with error -5
[    3.446774] advantechwdt: WDT driver for Advantech single board computer=
 initialising
[    3.447533] advantechwdt: initialized. timeout=3D60 sec (nowayout=3D1)
[    3.448125] geodewdt: No timers were available
[    3.448529] ib700wdt: WDT driver for IB700 single board computer initial=
ising
[    3.449153] ib700wdt: START method I/O 443 is not available
[    3.449583] ib700wdt: probe of ib700wdt failed with error -5
[    3.450066] wafer5823wdt: WDT driver for Wafer 5823 single board compute=
r initialising
[    3.450686] wafer5823wdt: I/O address 0x0443 already in use
[    3.451167] it87_wdt: no device
[    3.451988] sc1200wdt: build 20020303
[    3.452317] sc1200wdt: io parameter must be specified
[    3.452728] pc87413_wdt: Version 1.1 at io 0x2E
[    3.453080] pc87413_wdt: cannot register miscdev on minor=3D130 (err=3D-=
16)
[    3.453577] sbc8360: failed to register misc device
[    3.453964] cpu5wdt: misc_register failed
[    3.454303] smsc37b787_wdt: SMsC 37B787 watchdog component driver 1.1 in=
itialising...
[    3.455984] smsc37b787_wdt: Unable to register miscdev on minor 130
[    3.456511] w83877f_wdt: I/O address 0x0443 already in use
[    3.456936] machzwd: MachZ ZF-Logic Watchdog driver initializing
[    3.457392] machzwd: no ZF-Logic found
[    3.457851] EDAC DEBUG: i7300_init:=20
[    3.458192] EDAC DEBUG: i82875p_init: 875p pci_get_device fail
[    3.458693] EDAC DEBUG: i82975x_init: i82975x pci_get_device fail
[    3.459195] EDAC DEBUG: i3200_init: i3200 pci_get_device fail
[    3.459662] EDAC DEBUG: x38_init: x38 pci_get_device fail
[    3.460123] EDAC DEBUG: i82860_init: 860 pci_get_device fail
[    3.461790] iscsi: registered transport (iser)
[    3.462471] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    3.463106] hidraw: raw HID events driver (C) Jiri Kosina
[    3.464116] Initializing Realtek PCIE storage driver...
[    3.464542] vme_user: VME User Space Access Driver
[    3.464945] vme_user: No cards, skipping registration
[    3.465327] vme_pio2: No cards, skipping registration
[    3.465794] FPGA DOWNLOAD --->
[    3.466036] FPGA image file name: xlinx_fpga_firmware.bit
[    3.466603] GPIO INIT FAIL!!
[    3.467117] pktgen: Packet Generator for packet performance testing. Ver=
sion: 2.74
[    3.467982] GACT probability on
[    3.468253] Mirror/redirect action on
[    3.468544] Simple TC action Loaded
[    3.469082] netem: version 1.3
[    3.469352] u32 classifier
[    3.469577]     input device check on
[    3.469875]     Actions configured
[    3.470200] Netfilter messages via NETLINK v0.30.
[    3.470598] nfnl_acct: registering with nfnetlink.
[    3.471040] nf_conntrack version 0.5.0 (4215 buckets, 16860 max)
[    3.471812] ctnetlink v0.93: registering with nfnetlink.
[    3.472361] nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>
[    3.473130] xt_time: kernel timezone is -0000
[    3.473522] IPVS: Registered protocols (TCP, SCTP)
[    3.473926] IPVS: Connection hash table configured (size=3D4096, memory=
=3D32Kbytes)
[    3.474577] IPVS: Creating netns size=3D1428 id=3D0
[    3.475009] IPVS: ipvs loaded.
[    3.475263] IPVS: [wrr] scheduler registered.
[    3.475603] IPVS: [lblc] scheduler registered.
[    3.475952] IPVS: [lblcr] scheduler registered.
[    3.476336] IPVS: [dh] scheduler registered.
[    3.476664] IPVS: [sh] scheduler registered.
[    3.477035] IPVS: [nq] scheduler registered.
[    3.477412] ipip: IPv4 over IPv4 tunneling driver
[    3.478062] gre: GRE over IPv4 demultiplexor driver
[    3.478469] ip_gre: GRE over IPv4 tunneling driver
[    3.479477] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.479991] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[    3.480518] arp_tables: (C) 2002 David S. Miller
[    3.480906] TCP: cubic registered
[    3.481166] TCP: highspeed registered
[    3.481448] TCP: htcp registered
[    3.481700] TCP: vegas registered
[    3.481963] TCP: illinois registered
[    3.482236] Initializing XFRM netlink socket
[    3.482614] NET: Registered protocol family 15
[    3.483024] Ebtables v2.0 registered
[    3.483718] NET: Registered protocol family 4
[    3.484110] NET: Registered protocol family 5
[    3.484470] NET: Registered protocol family 9
[    3.484811] X25: Linux Version 0.2
[    3.485316] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.485781] Bluetooth: BNEP filters: protocol=20
[    3.486122] Bluetooth: BNEP socket layer initialized
[    3.486523] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    3.486969] Bluetooth: HIDP socket layer initialized
[    3.487397] lec:lane_module_init: lec.c: initialized
[    3.487825] NET: Registered protocol family 35
[    3.488252] 8021q: 802.1Q VLAN Support v1.8
[    3.488887] sctp: Hash tables configured (established 1638 bind 1820)
[    3.489621] 9pnet: Installing 9P2000 support
[    3.490010] NET: Registered protocol family 37
[    3.490425] NET: Registered protocol family 36
[    3.490838] openvswitch: Open vSwitch switching datapath
[    3.491314] mpls_gso: MPLS GSO support
[    3.492154]=20
[    3.492154] printing PIC contents
[    3.492528] ... PIC  IMR: ffff
[    3.492770] ... PIC  IRR: 1053
[    3.493051] ... PIC  ISR: 0000
[    3.493285] ... PIC ELCR: 0c00
[    3.493543] printing local APIC contents on CPU#0/0:
[    3.493927] ... APIC ID:      00000000 (0)
[    3.494253] ... APIC VERSION: 01050014
[    3.494571] ... APIC TASKPRI: 00000000 (00)
[    3.494897] ... APIC PROCPRI: 00000000
[    3.495177] ... APIC LDR: 01000000
[    3.495464] ... APIC DFR: ffffffff
[    3.495752] ... APIC SPIV: 000001ff
[    3.496010] ... APIC ISR field:
[    3.496010] 000000000000000000000000000000000000000000000000000000000000=
0000
[    3.496010] ... APIC TMR field:
[    3.496010] 000000000e20000000000000000000000000000000000000000000000000=
0000
[    3.496010] ... APIC IRR field:
[    3.496010] 000000000000000000000000000000000000000000000000000000000000=
8000
[    3.496010] ... APIC ESR: 00000000
[    3.496010] ... APIC ICR: 000008fd
[    3.496010] ... APIC ICR2: 02000000
[    3.496010] ... APIC LVTT: 000000ef
[    3.496010] ... APIC LVTPC: 00010000
[    3.496010] ... APIC LVT0: 00010700
[    3.496010] ... APIC LVT1: 00000400
[    3.496010] ... APIC LVTERR: 000000fe
[    3.496010] ... APIC TMICT: 0003cd6d
[    3.496010] ... APIC TMCCT: 00000000
[    3.496010] ... APIC TDCR: 00000003
[    3.496010]=20
[    3.502115] number of MP IRQ sources: 15.
[    3.502483] number of IO-APIC #0 registers: 24.
[    3.502832] testing the IO APIC.......................
[    3.503252] IO APIC #0......
[    3.503489] .... register #00: 00000000
[    3.503817] .......    : physical APIC id: 00
[    3.504160] .......    : Delivery Type: 0
[    3.504470] .......    : LTS          : 0
[    3.504797] .... register #01: 00170011
[    3.505128] .......     : max redirection entries: 17
[    3.505542] .......     : PRQ implemented: 0
[    3.505863] .......     : IO APIC version: 11
[    3.506190] .... register #02: 00000000
[    3.506535] .......     : arbitration: 00
[    3.506847] .... IRQ redirection table:
[    3.507155] 1    0    0   0   0    0    0    00
[    3.507543] 0    0    0   0   0    1    1    31
[    3.507940] 0    0    0   0   0    1    1    30
[    3.508314] 0    0    0   0   0    1    1    33
[    3.508666] 1    0    0   0   0    1    1    34
[    3.509074] 1    1    0   0   0    1    1    35
[    3.509454] 0    0    0   0   0    1    1    36
[    3.509848] 0    0    0   0   0    1    1    37
[    3.510250] 0    0    0   0   0    1    1    38
[    3.510622] 0    1    0   0   0    1    1    39
[    3.511011] 1    1    0   0   0    1    1    3A
[    3.511361] 1    1    0   0   0    1    1    3B
[    3.511715] 0    0    0   0   0    1    1    3C
[    3.512075] 0    0    0   0   0    1    1    3D
[    3.512426] 0    0    0   0   0    1    1    3E
[    3.512781] 0    0    0   0   0    1    1    3F
[    3.513128] 1    0    0   0   0    0    0    00
[    3.513487] 1    0    0   0   0    0    0    00
[    3.513879] 1    0    0   0   0    0    0    00
[    3.514256] 1    0    0   0   0    0    0    00
[    3.514628] 1    0    0   0   0    0    0    00
[    3.514987] 1    0    0   0   0    0    0    00
[    3.515339] 1    0    0   0   0    0    0    00
[    3.515687] 1    0    0   0   0    0    0    00
[    3.516044] IRQ to pin mappings:
[    3.516293] IRQ0 -> 0:2
[    3.516504] IRQ1 -> 0:1
[    3.516722] IRQ3 -> 0:3
[    3.516951] IRQ4 -> 0:4
[    3.517178] IRQ5 -> 0:5
[    3.517407] IRQ6 -> 0:6
[    3.517623] IRQ7 -> 0:7
[    3.517876] IRQ8 -> 0:8
[    3.518101] IRQ9 -> 0:9
[    3.518327] IRQ10 -> 0:10
[    3.518572] IRQ11 -> 0:11
[    3.518810] IRQ12 -> 0:12
[    3.519034] IRQ13 -> 0:13
[    3.519258] IRQ14 -> 0:14
[    3.519481] IRQ15 -> 0:15
[    3.519748] .................................... done.
[    3.520170] Using IPI No-Shortcut mode
[    3.520718] Loading compiled-in X.509 certificates
[    3.521109] registered taskstats version 1
[    3.522609] Btrfs loaded, integrity-checker=3Don
[    3.523087] BTRFS: selftest: Running btrfs free space cache tests
[    3.523566] BTRFS: selftest: Running extent only tests
[    3.523991] BTRFS: selftest: Running bitmap only tests
[    3.524412] BTRFS: selftest: Running bitmap and extent tests
[    3.524866] BTRFS: selftest: Free space cache tests finished
[    3.525302] BTRFS: selftest: Running extent buffer operation tests
[    3.525794] BTRFS: selftest: Running btrfs_split_item tests
[    3.526286] BTRFS: selftest: Running find delalloc tests
[   61.592335] lock_torture_st invoked oom-killer: gfp_mask=3D0x40d0, order=
=3D2, oom_score_adj=3D0
[   61.593498] CPU: 0 PID: 36 Comm: lock_torture_st Not tainted 3.17.0-rc2-=
00220-g5c551b5 #8
[   61.594189] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[   61.595025]  00000000 00000000 d1da3d50 ce79823d d1dba070 d1da3d98 ce796=
7ad ceaa3c78
[   61.595756]  d1dba42c 000040d0 00000002 00000000 d1da3d98 00000246 cda78=
a96 cebf15bc
[   61.596502]  00000286 cebf15bc 00000002 00000246 00000000 00000002 ca2dc=
60c d1da3de8
[   61.597202] Call Trace:
[   61.597420]  [<ce79823d>] dump_stack+0x48/0x60
[   61.597768]  [<ce7967ad>] dump_header.isra.10+0x66/0x366
[   61.598212]  [<cda78a96>] ? __lock_is_held+0x46/0x60
[   61.598638]  [<cdadd330>] out_of_memory+0x4c0/0x4d0
[   61.599043]  [<cdadcfa0>] ? out_of_memory+0x130/0x4d0
[   61.599485]  [<cdae1c17>] __alloc_pages_nodemask+0x8f7/0x910
[   61.599943]  [<cda80000>] ? lock_torture_stats_print+0x2a0/0x2a0
[   61.600470]  [<cdae1ca7>] alloc_kmem_pages+0x17/0x20
[   61.600925]  [<cdaf0d01>] kmalloc_order+0x11/0x30
[   61.601288]  [<cdb0ee0a>] __kmalloc+0x10a/0x1d0
[   61.601661]  [<cda80000>] ? lock_torture_stats_print+0x2a0/0x2a0
[   61.602157]  [<cda7fd87>] lock_torture_stats_print+0x27/0x2a0
[   61.602630]  [<cda80000>] ? lock_torture_stats_print+0x2a0/0x2a0
[   61.603114]  [<cda80024>] lock_torture_stats+0x24/0x70
[   61.603546]  [<cda5541e>] kthread+0xae/0xd0
[   61.603873]  [<cda50000>] ? drain_workqueue+0x110/0x260
[   61.604327]  [<ce7a9561>] ret_from_kernel_thread+0x21/0x30
[   61.604800]  [<cda55370>] ? __kthread_unpark+0x50/0x50
[   61.605190] Mem-Info:
[   61.605370] DMA per-cpu:
[   61.605609] CPU    0: hi:    0, btch:   1 usd:   0
[   61.606026] CPU    1: hi:    0, btch:   1 usd:   0
[   61.606462] Normal per-cpu:
[   61.606687] CPU    0: hi:   90, btch:  15 usd:   0
[   61.607075] CPU    1: hi:   90, btch:  15 usd:  21
[   61.607486] active_anon:0 inactive_anon:0 isolated_anon:0
[   61.607486]  active_file:2008 inactive_file:42946 isolated_file:0
[   61.607486]  unevictable:17876 dirty:0 writeback:0 unstable:0
[   61.607486]  free:751 slab_reclaimable:1192 slab_unreclaimable:1326
[   61.607486]  mapped:0 shmem:0 pagetables:0 bounce:0
[   61.607486]  free_cma:0
[   61.609863] DMA free:1108kB min:120kB low:148kB high:180kB active_anon:0=
kB inactive_anon:0kB active_file:0kB inactive_file:14164kB unevictable:0kB =
isolated(anon):0kB isolated(file):0kB present:15992kB managed:15916kB mlock=
ed:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:12kB s=
lab_unreclaimable:260kB kernel_stack:8kB pagetables:0kB unstable:0kB bounce=
:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:87080 all_unreclaimable? =
yes
[   61.613041] lowmem_reserve[]: 0 247 247 247
[   61.613444] Normal free:1896kB min:1952kB low:2440kB high:2928kB active_=
anon:0kB inactive_anon:0kB active_file:8032kB inactive_file:157620kB unevic=
table:71504kB isolated(anon):0kB isolated(file):0kB present:311168kB manage=
d:253852kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_re=
claimable:4756kB slab_unreclaimable:5044kB kernel_stack:568kB pagetables:0k=
B unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:3169=
0240 all_unreclaimable? yes
[   61.616772] lowmem_reserve[]: 0 0 0 0
[   61.617109] DMA: 1*4kB (R) 0*8kB 1*16kB (R) 0*32kB 1*64kB (R) 0*128kB 0*=
256kB 0*512kB 1*1024kB (R) 0*2048kB 0*4096kB =3D 1108kB
[   61.618201] Normal: 0*4kB 1*8kB (R) 0*16kB 1*32kB (R) 1*64kB (R) 0*128kB=
 1*256kB (R) 1*512kB (R) 1*1024kB (R) 0*2048kB 0*4096kB =3D 1896kB
[   61.619448] 62830 total pagecache pages
[   61.619747] 81790 pages RAM
[   61.619963] 0 pages HighMem/MovableOnly
[   61.620308] 14329 pages reserved
[   61.620578] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_s=
core_adj name
[   61.621233] Kernel panic - not syncing: Out of memory and no killable pr=
ocesses...
[   61.621233]=20
[   61.621976] CPU: 0 PID: 36 Comm: lock_torture_st Not tainted 3.17.0-rc2-=
00220-g5c551b5 #8
[   61.622655] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS =
1.7.5-20140531_083030-gandalf 04/01/2014
[   61.623483]  00000002 00000000 d1da3d80 ce79823d 00000000 d1da3d98 ce796=
255 00000002
[   61.624197]  00000000 00000002 ca2dc60c d1da3de8 cdadd33c ceaa3e98 00000=
000 00000000
[   61.624302]  cdadcfa0 00000000 00000002 ca2e0e0c 00000000 00000000 cebe7=
d00 00000000
[   61.624302] Call Trace:
[   61.624302]  [<ce79823d>] dump_stack+0x48/0x60
[   61.624302]  [<ce796255>] panic+0x81/0x187
[   61.624302]  [<cdadd33c>] out_of_memory+0x4cc/0x4d0
[   61.624302]  [<cdadcfa0>] ? out_of_memory+0x130/0x4d0
[   61.624302]  [<cdae1c17>] __alloc_pages_nodemask+0x8f7/0x910
[   61.624302]  [<cda80000>] ? lock_torture_stats_print+0x2a0/0x2a0
[   61.624302]  [<cdae1ca7>] alloc_kmem_pages+0x17/0x20
[   61.624302]  [<cdaf0d01>] kmalloc_order+0x11/0x30
[   61.624302]  [<cdb0ee0a>] __kmalloc+0x10a/0x1d0
[   61.624302]  [<cda80000>] ? lock_torture_stats_print+0x2a0/0x2a0
[   61.624302]  [<cda7fd87>] lock_torture_stats_print+0x27/0x2a0
[   61.624302]  [<cda80000>] ? lock_torture_stats_print+0x2a0/0x2a0
[   61.624302]  [<cda80024>] lock_torture_stats+0x24/0x70
[   61.624302]  [<cda5541e>] kthread+0xae/0xd0
[   61.624302]  [<cda50000>] ? drain_workqueue+0x110/0x260
[   61.624302]  [<ce7a9561>] ret_from_kernel_thread+0x21/0x30
[   61.624302]  [<cda55370>] ? __kthread_unpark+0x50/0x50
[   61.624302] Kernel Offset: 0xca00000 from 0xc1000000 (relocation range: =
0xc0000000-0xd47dffff)

Elapsed time: 65
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-r=
3-0905/5c551b501aa8637e844ea85eaea10f4f75aff716/vmlinuz-3.17.0-rc2-00220-g5=
c551b5 -append 'hung_task_panic=3D1 earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=3D100 panic=3D=
-1 softlockup_panic=3D1 nmi_watchdog=3Dpanic oops=3Dpanic load_ramdisk=3D2 =
prompt_ramdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=
=3D/dev/ram0 rw link=3D/kbuild-tests/run-queue/kvm/i386-randconfig-r3-0905/=
linux-devel:devel-roam-i386-201409052138:5c551b501aa8637e844ea85eaea10f4f75=
aff716:bisect-linux/.vmlinuz-5c551b501aa8637e844ea85eaea10f4f75aff716-20140=
906024956-39-ivb42 branch=3Dlinux-devel/devel-roam-i386-201409052138 BOOT_I=
MAGE=3D/kernel/i386-randconfig-r3-0905/5c551b501aa8637e844ea85eaea10f4f75af=
f716/vmlinuz-3.17.0-rc2-00220-g5c551b5 drbd.minor_count=3D8'  -initrd /kern=
el-tests/initrd/quantal-core-i386.cgz -m 320 -smp 2 -net nic,vlan=3D1,model=
=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300esb =
-rtc base=3Dlocaltime -pidfile /dev/shm/kboot/pid-quantal-ivb42-104 -serial=
 file:/dev/shm/kboot/serial-quantal-ivb42-104 -daemonize -display none -mon=
itor null=20

--6c2NcOVqGQ03X4Wi
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="i386-randconfig-r3-0905-5a2aa64d4eafdaef278ff495025c59a5cd96eafb-INFO:-trying-to-register-non-static-key--46796.log"
Content-Transfer-Encoding: base64

SEVBRCBpcyBub3cgYXQgNWEyYWE2NC4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdkZXZlbC1y
b2FtLWkzODYtMjAxNDA5MDUyMTM4JwpnaXQgY2hlY2tvdXQgNjllMjczYzBiMGEzYzMzN2E1
MjFkMDgzMzc0YzkxOGRjNTJjNjY2ZgpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9r
dm0vaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2
LTIwMTQwOTA1MjEzODo2OWUyNzNjMGIwYTNjMzM3YTUyMWQwODMzNzRjOTE4ZGM1MmM2NjZm
OmJpc2VjdC1saW51eAoKMjAxNC0wOS0wNSAyMjowMzoyNCA2OWUyNzNjMGIwYTNjMzM3YTUy
MWQwODMzNzRjOTE4ZGM1MmM2NjZmIHJldXNlIC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIz
LTA5MDUvNjllMjczYzBiMGEzYzMzN2E1MjFkMDgzMzc0YzkxOGRjNTJjNjY2Zi92bWxpbnV6
LTMuMTcuMC1yYzMKCjIwMTQtMDktMDUgMjI6MDM6MjQgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUg
Li4JMTguCTE5LgkyMCBTVUNDRVNTCgpiaXNlY3Q6IGdvb2QgY29tbWl0IDY5ZTI3M2MwYjBh
M2MzMzdhNTIxZDA4MzM3NGM5MThkYzUyYzY2NmYKZ2l0IGJpc2VjdCBzdGFydCA1YTJhYTY0
ZDRlYWZkYWVmMjc4ZmY0OTUwMjVjNTlhNWNkOTZlYWZiIDY5ZTI3M2MwYjBhM2MzMzdhNTIx
ZDA4MzM3NGM5MThkYzUyYzY2NmYgLS0KL2Mva2VybmVsLXRlc3RzL2xpbmVhci1iaXNlY3Q6
IFsiLWIiLCAiNWEyYWE2NGQ0ZWFmZGFlZjI3OGZmNDk1MDI1YzU5YTVjZDk2ZWFmYiIsICIt
ZyIsICI2OWUyNzNjMGIwYTNjMzM3YTUyMWQwODMzNzRjOTE4ZGM1MmM2NjZmIiwgIi9jL2tl
cm5lbC10ZXN0cy9iaXNlY3QtdGVzdC1ib290LWZhaWx1cmUuc2giLCAiL2MvYm9vdC1iaXNl
Y3QvbGludXgvb2JqLWJpc2VjdCJdCkJpc2VjdGluZzogMTE5OCByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTEgc3RlcHMpCls4MmMzYjBjMzA1MjI1MTBm
Y2VlODlhMTQzMDJhZWIwNmRmNjVmOGQxXSBNZXJnZSAnc3BpL2ZpeC9yb2NrY2hpcCcgaW50
byBkZXZlbC1yb2FtLWkzODYtMjAxNDA5MDUyMTM4CnJ1bm5pbmcgL2Mva2VybmVsLXRlc3Rz
L2Jpc2VjdC10ZXN0LWJvb3QtZmFpbHVyZS5zaCAvYy9ib290LWJpc2VjdC9saW51eC9vYmot
YmlzZWN0CmxzIC1hIC9rYnVpbGQtdGVzdHMvcnVuLXF1ZXVlL2t2bS9pMzg2LXJhbmRjb25m
aWctcjMtMDkwNS9saW51eC1kZXZlbDpkZXZlbC1yb2FtLWkzODYtMjAxNDA5MDUyMTM4Ojgy
YzNiMGMzMDUyMjUxMGZjZWU4OWExNDMwMmFlYjA2ZGY2NWY4ZDE6YmlzZWN0LWxpbnV4Cgoy
MDE0LTA5LTA1IDIyOjA2OjU2IDgyYzNiMGMzMDUyMjUxMGZjZWU4OWExNDMwMmFlYjA2ZGY2
NWY4ZDEgY29tcGlsaW5nClF1ZXVlZCBidWlsZCB0YXNrIHRvIC9rYnVpbGQtdGVzdHMvYnVp
bGQtcXVldWUvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUtODJjM2IwYzMwNTIyNTEwZmNlZTg5
YTE0MzAyYWViMDZkZjY1ZjhkMQpDaGVjayBmb3Iga2VybmVsIGluIC9rZXJuZWwvaTM4Ni1y
YW5kY29uZmlnLXIzLTA5MDUvODJjM2IwYzMwNTIyNTEwZmNlZTg5YTE0MzAyYWViMDZkZjY1
ZjhkMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMvYnVpbGQtcXVl
dWUvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUtODJjM2IwYzMwNTIyNTEwZmNlZTg5YTE0MzAy
YWViMDZkZjY1ZjhkMQp3YWl0aW5nIGZvciBjb21wbGV0aW9uIG9mIC9rYnVpbGQtdGVzdHMv
YnVpbGQtcXVldWUvcm9hbS1pMzg2L2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LTgyYzNiMGMz
MDUyMjUxMGZjZWU4OWExNDMwMmFlYjA2ZGY2NWY4ZDEKa2VybmVsOiAva2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMy0wOTA1LzgyYzNiMGMzMDUyMjUxMGZjZWU4OWExNDMwMmFlYjA2ZGY2
NWY4ZDEvdm1saW51ei0zLjE3LjAtcmMzLTAwNDcwLWc4MmMzYjBjCgoyMDE0LTA5LTA1IDIy
OjQwOjU2IGRldGVjdGluZyBib290IHN0YXRlIC4JNAkxOQkyMCBTVUNDRVNTCgpCaXNlY3Rp
bmc6IDYwOSByZXZpc2lvbnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgMTAg
c3RlcHMpClsyNTlmYzRlM2ZjM2MzZjA3M2VkZDA3NTY0ZWI4MjQzM2Q3Yzg2Y2M3XSBNZXJn
ZSAnZHJtLWludGVsL2RybS1pbnRlbC1uaWdodGx5JyBpbnRvIGRldmVsLXJvYW0taTM4Ni0y
MDE0MDkwNTIxMzgKcnVubmluZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1m
YWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tidWls
ZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1L2xpbnV4LWRl
dmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDkwNTIxMzg6MjU5ZmM0ZTNmYzNjM2YwNzNlZGQw
NzU2NGViODI0MzNkN2M4NmNjNzpiaXNlY3QtbGludXgKCjIwMTQtMDktMDUgMjI6NDI6NTcg
MjU5ZmM0ZTNmYzNjM2YwNzNlZGQwNzU2NGViODI0MzNkN2M4NmNjNyBjb21waWxpbmcKUXVl
dWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRj
b25maWctcjMtMDkwNS0yNTlmYzRlM2ZjM2MzZjA3M2VkZDA3NTY0ZWI4MjQzM2Q3Yzg2Y2M3
CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS8y
NTlmYzRlM2ZjM2MzZjA3M2VkZDA3NTY0ZWI4MjQzM2Q3Yzg2Y2M3CndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWct
cjMtMDkwNS0yNTlmYzRlM2ZjM2MzZjA3M2VkZDA3NTY0ZWI4MjQzM2Q3Yzg2Y2M3CndhaXRp
bmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9yb2FtLWkz
ODYvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUtMjU5ZmM0ZTNmYzNjM2YwNzNlZGQwNzU2NGVi
ODI0MzNkN2M4NmNjNwprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUv
MjU5ZmM0ZTNmYzNjM2YwNzNlZGQwNzU2NGViODI0MzNkN2M4NmNjNy92bWxpbnV6LTMuMTcu
MC1yYzMtMDA5OTctZzI1OWZjNGUKCjIwMTQtMDktMDUgMjM6NDU6NTcgZGV0ZWN0aW5nIGJv
b3Qgc3RhdGUgLi4JMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA4MiByZXZpc2lvbnMgbGVmdCB0
byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNyBzdGVwcykKWzcwZDgwNWFkNzNmYTVlZTRk
ODYwZmYxMGY0ZmY5ODA1MGMwMWMyZDldIE1lcmdlICdoY2gtc2NzaS1xdWV1ZS9jb3JlLWZv
ci0zLjE4JyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0MDkwNTIxMzgKcnVubmluZyAvYy9r
ZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0
L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kz
ODYtcmFuZGNvbmZpZy1yMy0wOTA1L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0
MDkwNTIxMzg6NzBkODA1YWQ3M2ZhNWVlNGQ4NjBmZjEwZjRmZjk4MDUwYzAxYzJkOTpiaXNl
Y3QtbGludXgKCjIwMTQtMDktMDUgMjM6NDc6MjcgNzBkODA1YWQ3M2ZhNWVlNGQ4NjBmZjEw
ZjRmZjk4MDUwYzAxYzJkOSBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS03MGQ4MDVhZDcz
ZmE1ZWU0ZDg2MGZmMTBmNGZmOTgwNTBjMDFjMmQ5CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tl
cm5lbC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS83MGQ4MDVhZDczZmE1ZWU0ZDg2MGZmMTBm
NGZmOTgwNTBjMDFjMmQ5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS03MGQ4MDVhZDczZmE1ZWU0
ZDg2MGZmMTBmNGZmOTgwNTBjMDFjMmQ5CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2ti
dWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9sa3AtaHN4MDEtY29uc3VtZXIvaTM4Ni1yYW5kY29u
ZmlnLXIzLTA5MDUtNzBkODA1YWQ3M2ZhNWVlNGQ4NjBmZjEwZjRmZjk4MDUwYzAxYzJkOQpr
ZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvNzBkODA1YWQ3M2ZhNWVl
NGQ4NjBmZjEwZjRmZjk4MDUwYzAxYzJkOS92bWxpbnV6LTMuMTcuMC1yYzMtMDEwMTktZzcw
ZDgwNWEKCjIwMTQtMDktMDYgMDA6NTA6MjcgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4uLi4u
Li4uLi4uLi4uLi4gVEVTVCBGQUlMVVJFClsgICAgMS40MTIxNzRdIFtkcm1dIHJhZGVvbiBr
ZXJuZWwgbW9kZXNldHRpbmcgZW5hYmxlZC4KWyAgICAxLjQxMzIxOF0gW1RUTV0gWm9uZSAg
a2VybmVsOiBBdmFpbGFibGUgZ3JhcGhpY3MgbWVtb3J5OiAxMzQ4NzAga2lCClsgICAgMS40
MTM3MTBdIFtUVE1dIEluaXRpYWxpemluZyBwb29sIGFsbG9jYXRvcgpbICAgIDEuNDE0MzAz
XSBJTkZPOiB0cnlpbmcgdG8gcmVnaXN0ZXIgbm9uLXN0YXRpYyBrZXkuClsgICAgMS40MTQ2
OTFdIHRoZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRzIGxvY2tkZXAgYW5ub3RhdGlvbi4KWyAg
ICAxLjQxNTA5Nl0gdHVybmluZyBvZmYgdGhlIGxvY2tpbmcgY29ycmVjdG5lc3MgdmFsaWRh
dG9yLgpbICAgIDEuNDE1NTAwXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBwZXIvMCBOb3Qg
dGFpbnRlZCAzLjE3LjAtcmMzLTAxMDE5LWc3MGQ4MDVhICMxClsgICAgMS40MTYwNDldIEhh
cmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJSVgsIDE5OTYpLCBC
SU9TIDEuNy41LTIwMTQwNTMxXzA4MzAzMC1nYW5kYWxmIDA0LzAxLzIwMTQKWyAgICAxLjQx
NjA0OV0gIDAwMDAwMDAwIDAwMDAwMDAwIGNmYzQ5YzA4IGQwZDlhZWJkIGQxNzk3ZDM4IGNm
YzQ5YzdjIGQwMDdiNzcxIGQxMGExZmI4ClsgICAgMS40MTYwNDldICAwOTQwYjIwNSBjZmM0
MDAwMCBjZmM0OWM5MCBkMDA3OWZjNiBjZmM0MDAwMCA1MDJjODE2YSBjZmM0MDAwMCA1MDJj
ODE2YQpbICAgIDEuNDE2MDQ5XSAgMDAwMDAwMDUgMDFjNDAwMDAgMDAwMDAwMDAgY2E3Yzg4
NDggY2E3Yzg4NDggMDAwMDAwMDAgZDE3Njc3NjAgY2ZjNDA1ZDAKWyAgICAxLjQxNjA0OV0g
Q2FsbCBUcmFjZToKWyAgICAxLjQxNjA0OV0gIFs8ZDBkOWFlYmQ+XSBkdW1wX3N0YWNrKzB4
NDgvMHg2MApbICAgIDEuNDE2MDQ5XSAgWzxkMDA3Yjc3MT5dIF9fbG9ja19hY3F1aXJlKzB4
MWMyMS8weDFkYTAKWyAgICAxLjQxNjA0OV0gIFs8ZDAwNzlmYzY+XSA/IF9fbG9ja19hY3F1
aXJlKzB4NDc2LzB4MWRhMApbICAgIDEuNDE2MDQ5XSAgWzxkMDA3OGVjNj5dID8gX19sb2Nr
X2lzX2hlbGQrMHg0Ni8weDYwClsgICAgMS40MTYwNDldICBbPGQwMDdjMTQxPl0gbG9ja19h
Y3F1aXJlKzB4OTEvMHhjMApbICAgIDEuNDE2MDQ5XSAgWzxkMDY1ZmE1MT5dID8gZHJtX21v
ZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjQxNjA0OV0gIFs8ZDBkYThkMmM+XSBfX3d3
X211dGV4X2xvY2srMHg2Yy8weDc4MApbICAgIDEuNDE2MDQ5XSAgWzxkMDY1ZmE1MT5dID8g
ZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjQxNjA0OV0gIFs8ZDA2NWZhNTE+
XSA/IGRybV9tb2Rlc2V0X2xvY2srMHgzMS8weGYwClsgICAgMS40MTYwNDldICBbPGQwNjVm
YTUxPl0gPyBkcm1fbW9kZXNldF9sb2NrKzB4MzEvMHhmMApbICAgIDEuNDE2MDQ5XSAgWzxk
MDY1ZmE1MT5dIGRybV9tb2Rlc2V0X2xvY2srMHgzMS8weGYwClsgICAgMS40MTYwNDldICBb
PGQwNjVmY2U0Pl0gZHJtX21vZGVzZXRfbG9ja19hbGxfY3J0Y3MrMHgzNC8weDUwClsgICAg
MS40MTYwNDldICBbPGQwNjVmZGE0Pl0gX19kcm1fbW9kZXNldF9sb2NrX2FsbCsweGE0LzB4
ZTAKWyAgICAxLjQxNjA0OV0gIFs8ZDA2NWZkZWE+XSBkcm1fbW9kZXNldF9sb2NrX2FsbCsw
eGEvMHgzMApbICAgIDEuNDE2MDQ5XSAgWzxkMDY1MTJlYj5dIGRybV9lbmNvZGVyX2luaXQr
MHgxYi8weGUwClsgICAgMS40MTYwNDldICBbPGQwMTBlZTQ4Pl0gPyBrbWVtX2NhY2hlX2Fs
bG9jKzB4OTgvMHgxOTAKWyAgICAxLjQxNjA0OV0gIFs8ZDA3Njg1NTE+XSA/IGNpcnJ1c19t
b2Rlc2V0X2luaXQrMHhlMS8weDFjMApbICAgIDEuNDE2MDQ5XSAgWzxkMDc2ODU3Nz5dIGNp
cnJ1c19tb2Rlc2V0X2luaXQrMHgxMDcvMHgxYzAKWyAgICAxLjQxNjA0OV0gIFs8ZDA3Njc2
MTc+XSBjaXJydXNfZHJpdmVyX2xvYWQrMHg1Ny8weDEyMApbICAgIDEuNDE2MDQ5XSAgWzxk
MDY0YzgxZT5dIGRybV9kZXZfcmVnaXN0ZXIrMHg5ZS8weDEwMApbICAgIDEuNDE2MDQ5XSAg
WzxkMDY0ZGY2MT5dIGRybV9nZXRfcGNpX2RldisweDkxLzB4MWMwClsgICAgMS40MTYwNDld
ICBbPGQwMDc4MjhiPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHgxMApbICAgIDEuNDE2
MDQ5XSAgWzxkMGRhOGMwOD5dID8gbXV0ZXhfdW5sb2NrKzB4OC8weDEwClsgICAgMS40MTYw
NDldICBbPGQwNzY4NzljPl0gY2lycnVzX3BjaV9wcm9iZSsweGFjLzB4ZjAKWyAgICAxLjQx
NjA0OV0gIFs8ZDA1MTNlZDc+XSBwY2lfZGV2aWNlX3Byb2JlKzB4NzcvMHhlMApbICAgIDEu
NDE2MDQ5XSAgWzxkMDE3ZmZmMD5dID8gc3lzZnNfY3JlYXRlX2xpbmsrMHgyMC8weDQwClsg
ICAgMS40MTYwNDldICBbPGQwN2M0ZTEzPl0gZHJpdmVyX3Byb2JlX2RldmljZSsweDczLzB4
MjMwClsgICAgMS40MTYwNDldICBbPGQwNTEzZTMyPl0gPyBwY2lfbWF0Y2hfZGV2aWNlKzB4
YzIvMHhmMApbICAgIDEuNDE2MDQ5XSAgWzxkMDdjNTBiMT5dIF9fZHJpdmVyX2F0dGFjaCsw
eDkxLzB4YTAKWyAgICAxLjQxNjA0OV0gIFs8ZDA3YzUwMjA+XSA/IF9fZGV2aWNlX2F0dGFj
aCsweDUwLzB4NTAKWyAgICAxLjQxNjA0OV0gIFs8ZDA3YzM3MWY+XSBidXNfZm9yX2VhY2hf
ZGV2KzB4NGYvMHg4MApbICAgIDEuNDE2MDQ5XSAgWzxkMDdjNTE3OT5dIGRyaXZlcl9hdHRh
Y2grMHgxOS8weDIwClsgICAgMS40MTYwNDldICBbPGQwN2M1MDIwPl0gPyBfX2RldmljZV9h
dHRhY2grMHg1MC8weDUwClsgICAgMS40MTYwNDldICBbPGQwN2M0MDM3Pl0gYnVzX2FkZF9k
cml2ZXIrMHgxMzcvMHgxZjAKWyAgICAxLjQxNjA0OV0gIFs8ZDEyZTI2ZmE+XSA/IG1nYWcy
MDBfaW5pdCsweDIyLzB4MjIKWyAgICAxLjQxNjA0OV0gIFs8ZDEyZTI2ZmE+XSA/IG1nYWcy
MDBfaW5pdCsweDIyLzB4MjIKWyAgICAxLjQxNjA0OV0gIFs8ZDA3YzU3ZTQ+XSBkcml2ZXJf
cmVnaXN0ZXIrMHg1NC8weGUwClsgICAgMS40MTYwNDldICBbPGQwNTE0MTM1Pl0gX19wY2lf
cmVnaXN0ZXJfZHJpdmVyKzB4NDUvMHg1MApbICAgIDEuNDE2MDQ5XSAgWzxkMDY0ZTE3YT5d
IGRybV9wY2lfaW5pdCsweGVhLzB4MTEwClsgICAgMS40MTYwNDldICBbPGQwMDc4MjhiPl0g
PyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHgxMApbICAgIDEuNDE2MDQ5XSAgWzxkMTJlMjZm
YT5dID8gbWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAgIDEuNDE2MDQ5XSAgWzxkMTJlMjcx
YT5dIGNpcnJ1c19pbml0KzB4MjAvMHgyMgpbICAgIDEuNDE2MDQ5XSAgWzxkMTJiNmM5Mj5d
IGRvX29uZV9pbml0Y2FsbCsweDE2YS8weDE3OQpbICAgIDEuNDE2MDQ5XSAgWzxkMDA1NTAw
MD5dID8gcGFyc2VfYXJncysweDFlMC8weDNlMApbICAgIDEuNDE2MDQ5XSAgWzxkMTJiNmQ4
ZT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZWQvMHgxNmEKWyAgICAxLjQxNjA0OV0gIFs8
ZDBkOTUyYWI+XSBrZXJuZWxfaW5pdCsweGIvMHhlMApbICAgIDEuNDE2MDQ5XSAgWzxkMGRh
YzFjMT5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsgICAgMS40MTYwNDld
ICBbPGQwZDk1MmEwPl0gPyByZXN0X2luaXQrMHgxMjAvMHgxMjAKWyAgICAxLjQzNzE5N10g
QlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2Ug
YXQgICAobnVsbCkKWyAgICAxLjQzNzc5M10gSVA6IFs8ZDBkYThkYmE+XSBfX3d3X211dGV4
X2xvY2srMHhmYS8weDc4MApbICAgIDEuNDM4MTk1XSAqcGRwdCA9IDAwMDAwMDAwMDAwMDAw
MDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMS40Mzg2NjFdIE9vcHM6IDAwMDIg
WyMxXSBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAgMS40MzkwMzRdIENQVTogMCBQSUQ6IDEg
Q29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTcuMC1yYzMtMDEwMTktZzcwZDgwNWEg
IzEKWyAgICAxLjQzOTYwMV0gSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoaTQ0
MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS43LjUtMjAxNDA1MzFfMDgzMDMwLWdhbmRhbGYg
MDQvMDEvMjAxNApbICAgIDEuNDQwMzU3XSB0YXNrOiBjZmM0MDAwMCB0aTogY2ZjNDgwMDAg
dGFzay50aTogY2ZjNDgwMDAKWyAgICAxLjQ0MDc2OF0gRUlQOiAwMDYwOls8ZDBkYThkYmE+
XSBFRkxBR1M6IDAwMDEwMDgyIENQVTogMApbICAgIDEuNDQxMTc5XSBFSVAgaXMgYXQgX193
d19tdXRleF9sb2NrKzB4ZmEvMHg3ODAKWyAgICAxLjQ0MTE4OF0gRUFYOiAwMDAwMDAwMCBF
Qlg6IGNiYzc5MmMwIEVDWDogY2E3Yzg4MzQgRURYOiBjZmM0OWNkYwpbICAgIDEuNDQxMTg4
XSBFU0k6IGNhN2M4ODEwIEVESTogY2E3Yzg4MTQgRUJQOiBjZmM0OWNmOCBFU1A6IGNmYzQ5
Y2I0ClsgICAgMS40NDExODhdICBEUzogMDA3YiBFUzogMDA3YiBGUzogMDBkOCBHUzogMDBl
MCBTUzogMDA2OApbICAgIDEuNDQxMTg4XSBDUjA6IDgwMDUwMDNiIENSMjogMDAwMDAwMDAg
Q1IzOiAxMTM2MjAwMCBDUjQ6IDAwMDAwNmIwClsgICAgMS40NDExODhdIFN0YWNrOgpbICAg
IDEuNDQxMTg4XSAgMDAwMDAwMDAgMDAwMDAwMDEgY2JjNzkyZDggZDA2NWZhNTEgZDA2NWZh
NTEgY2E3Yzg4NDggMDAwMDAwMDEgY2ZjNDAwMDAKWyAgICAxLjQ0MTE4OF0gIGNiYzc5MmMw
IDAwMDAwMjQ2IGNhN2M4ODM0IDAwMDAwMDAwIDExMTExMTExIGNmYzQ5Y2RjIGNiYzc5MmMw
IGNhN2M4ODEwClsgICAgMS40NDExODhdICBjYmM3OTJjMCBjZmM0OWQwYyBkMDY1ZmE1MSBj
YTdjODgwMCBjZmQzZmMwMCBjYmM3OTJjMCBjZmM0OWQyMCBkMDY1ZmNlNApbICAgIDEuNDQx
MTg4XSBDYWxsIFRyYWNlOgpbICAgIDEuNDQxMTg4XSAgWzxkMDY1ZmE1MT5dID8gZHJtX21v
ZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjQ0MTE4OF0gIFs8ZDA2NWZhNTE+XSA/IGRy
bV9tb2Rlc2V0X2xvY2srMHgzMS8weGYwClsgICAgMS40NDExODhdICBbPGQwNjVmYTUxPl0g
ZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjQ0MTE4OF0gIFs8ZDA2NWZjZTQ+
XSBkcm1fbW9kZXNldF9sb2NrX2FsbF9jcnRjcysweDM0LzB4NTAKWyAgICAxLjQ0MTE4OF0g
IFs8ZDA2NWZkYTQ+XSBfX2RybV9tb2Rlc2V0X2xvY2tfYWxsKzB4YTQvMHhlMApbICAgIDEu
NDQxMTg4XSAgWzxkMDY1ZmRlYT5dIGRybV9tb2Rlc2V0X2xvY2tfYWxsKzB4YS8weDMwClsg
ICAgMS40NDExODhdICBbPGQwNjUxMmViPl0gZHJtX2VuY29kZXJfaW5pdCsweDFiLzB4ZTAK
WyAgICAxLjQ0MTE4OF0gIFs8ZDAxMGVlNDg+XSA/IGttZW1fY2FjaGVfYWxsb2MrMHg5OC8w
eDE5MApbICAgIDEuNDQxMTg4XSAgWzxkMDc2ODU1MT5dID8gY2lycnVzX21vZGVzZXRfaW5p
dCsweGUxLzB4MWMwClsgICAgMS40NDExODhdICBbPGQwNzY4NTc3Pl0gY2lycnVzX21vZGVz
ZXRfaW5pdCsweDEwNy8weDFjMApbICAgIDEuNDQxMTg4XSAgWzxkMDc2NzYxNz5dIGNpcnJ1
c19kcml2ZXJfbG9hZCsweDU3LzB4MTIwClsgICAgMS40NDExODhdICBbPGQwNjRjODFlPl0g
ZHJtX2Rldl9yZWdpc3RlcisweDllLzB4MTAwClsgICAgMS40NDExODhdICBbPGQwNjRkZjYx
Pl0gZHJtX2dldF9wY2lfZGV2KzB4OTEvMHgxYzAKWyAgICAxLjQ0MTE4OF0gIFs8ZDAwNzgy
OGI+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weDEwClsgICAgMS40NDExODhdICBbPGQw
ZGE4YzA4Pl0gPyBtdXRleF91bmxvY2srMHg4LzB4MTAKWyAgICAxLjQ0MTE4OF0gIFs8ZDA3
Njg3OWM+XSBjaXJydXNfcGNpX3Byb2JlKzB4YWMvMHhmMApbICAgIDEuNDQxMTg4XSAgWzxk
MDUxM2VkNz5dIHBjaV9kZXZpY2VfcHJvYmUrMHg3Ny8weGUwClsgICAgMS40NDExODhdICBb
PGQwMTdmZmYwPl0gPyBzeXNmc19jcmVhdGVfbGluaysweDIwLzB4NDAKWyAgICAxLjQ0MTE4
OF0gIFs8ZDA3YzRlMTM+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4NzMvMHgyMzAKWyAgICAx
LjQ0MTE4OF0gIFs8ZDA1MTNlMzI+XSA/IHBjaV9tYXRjaF9kZXZpY2UrMHhjMi8weGYwClsg
ICAgMS40NDExODhdICBbPGQwN2M1MGIxPl0gX19kcml2ZXJfYXR0YWNoKzB4OTEvMHhhMApb
ICAgIDEuNDQxMTg4XSAgWzxkMDdjNTAyMD5dID8gX19kZXZpY2VfYXR0YWNoKzB4NTAvMHg1
MApbICAgIDEuNDQxMTg4XSAgWzxkMDdjMzcxZj5dIGJ1c19mb3JfZWFjaF9kZXYrMHg0Zi8w
eDgwClsgICAgMS40NDExODhdICBbPGQwN2M1MTc5Pl0gZHJpdmVyX2F0dGFjaCsweDE5LzB4
MjAKWyAgICAxLjQ0MTE4OF0gIFs8ZDA3YzUwMjA+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDUw
LzB4NTAKWyAgICAxLjQ0MTE4OF0gIFs8ZDA3YzQwMzc+XSBidXNfYWRkX2RyaXZlcisweDEz
Ny8weDFmMApbICAgIDEuNDQxMTg4XSAgWzxkMTJlMjZmYT5dID8gbWdhZzIwMF9pbml0KzB4
MjIvMHgyMgpbICAgIDEuNDQxMTg4XSAgWzxkMTJlMjZmYT5dID8gbWdhZzIwMF9pbml0KzB4
MjIvMHgyMgpbICAgIDEuNDQxMTg4XSAgWzxkMDdjNTdlND5dIGRyaXZlcl9yZWdpc3Rlcisw
eDU0LzB4ZTAKWyAgICAxLjQ0MTE4OF0gIFs8ZDA1MTQxMzU+XSBfX3BjaV9yZWdpc3Rlcl9k
cml2ZXIrMHg0NS8weDUwClsgICAgMS40NDExODhdICBbPGQwNjRlMTdhPl0gZHJtX3BjaV9p
bml0KzB4ZWEvMHgxMTAKWyAgICAxLjQ0MTE4OF0gIFs8ZDAwNzgyOGI+XSA/IHRyYWNlX2hh
cmRpcnFzX29uKzB4Yi8weDEwClsgICAgMS40NDExODhdICBbPGQxMmUyNmZhPl0gPyBtZ2Fn
MjAwX2luaXQrMHgyMi8weDIyClsgICAgMS40NDExODhdICBbPGQxMmUyNzFhPl0gY2lycnVz
X2luaXQrMHgyMC8weDIyClsgICAgMS40NDExODhdICBbPGQxMmI2YzkyPl0gZG9fb25lX2lu
aXRjYWxsKzB4MTZhLzB4MTc5ClsgICAgMS40NDExODhdICBbPGQwMDU1MDAwPl0gPyBwYXJz
ZV9hcmdzKzB4MWUwLzB4M2UwClsgICAgMS40NDExODhdICBbPGQxMmI2ZDhlPl0ga2VybmVs
X2luaXRfZnJlZWFibGUrMHhlZC8weDE2YQpbICAgIDEuNDQxMTg4XSAgWzxkMGQ5NTJhYj5d
IGtlcm5lbF9pbml0KzB4Yi8weGUwClsgICAgMS40NDExODhdICBbPGQwZGFjMWMxPl0gcmV0
X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICAxLjQ0MTE4OF0gIFs8ZDBkOTUy
YTA+XSA/IHJlc3RfaW5pdCsweDEyMC8weDEyMApbICAgIDEuNDQxMTg4XSBDb2RlOiA1NSBl
NCA4OSBmMCBlOCAyOCBjMSAyYyBmZiA4YiA0NSBkOCA4ZCA1NSBlNCA4YiA0OCAwNCA4OSBm
MCBlOCA1OCBjMyAyYyBmZiA4YiA0NiAyOCA4ZCA0ZSAyNCA4ZCA1NSBlNCA4OSA1NiAyOCA4
OSA0ZCBlNCA4OSA0NSBlOCA8ODk+IDEwIDhiIDQ1IGQ4IDg5IDRkIGQ0IDg5IDQ1IGVjIDhk
IDc0IDI2IDAwIDhkIGJjIDI3IDAwIDAwIDAwClsgICAgMS40NDExODhdIEVJUDogWzxkMGRh
OGRiYT5dIF9fd3dfbXV0ZXhfbG9jaysweGZhLzB4NzgwIFNTOkVTUCAwMDY4OmNmYzQ5Y2I0
ClsgICAgMS40NDExODhdIENSMjogMDAwMDAwMDAwMDAwMDAwMApbICAgIDEuNDQxMTg4XSAt
LS1bIGVuZCB0cmFjZSAwNjZiOTY2NTg5MzJiYTM1IF0tLS0KWyAgICAxLjQ0MTE4OF0gS2Vy
bmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlvbgova2VybmVsL2kzODYt
cmFuZGNvbmZpZy1yMy0wOTA1LzcwZDgwNWFkNzNmYTVlZTRkODYwZmYxMGY0ZmY5ODA1MGMw
MWMyZDkvZG1lc2ctcXVhbnRhbC1pdmI0MS0xOToyMDE0MDkwNjAwNTg0OTppMzg2LXJhbmRj
b25maWctcjMtMDkwNTo6CjA6MToxIGFsbF9nb29kOmJhZDphbGxfYmFkIGJvb3RzChtbMTsz
NW0yMDE0LTA5LTA2IDAwOjU4OjU5IFJFUEVBVCBDT1VOVDogMjAgICMgL2MvYm9vdC1iaXNl
Y3QvbGludXgvb2JqLWJpc2VjdC8ucmVwZWF0G1swbQoKQmlzZWN0aW5nOiAxOCByZXZpc2lv
bnMgbGVmdCB0byB0ZXN0IGFmdGVyIHRoaXMgKHJvdWdobHkgNSBzdGVwcykKWzE2Y2QxOTJj
MjEwMDA4NWFhNmNlMDRlYzE4NmZlNjIzNDZhM2IxNzNdIE1lcmdlICdkcm0vZHJtLW1zdC1k
ZWxsLTMwLWhhY2tzJyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0MDkwNTIxMzgKcnVubmlu
ZyAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3Qt
YmlzZWN0L2xpbnV4L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUv
a3ZtL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4
Ni0yMDE0MDkwNTIxMzg6MTZjZDE5MmMyMTAwMDg1YWE2Y2UwNGVjMTg2ZmU2MjM0NmEzYjE3
MzpiaXNlY3QtbGludXgKCjIwMTQtMDktMDYgMDA6NTg6NTkgMTZjZDE5MmMyMTAwMDg1YWE2
Y2UwNGVjMTg2ZmU2MjM0NmEzYjE3MyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8g
L2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS0xNmNk
MTkyYzIxMDAwODVhYTZjZTA0ZWMxODZmZTYyMzQ2YTNiMTczCkNoZWNrIGZvciBrZXJuZWwg
aW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS8xNmNkMTkyYzIxMDAwODVhYTZj
ZTA0ZWMxODZmZTYyMzQ2YTNiMTczCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS0xNmNkMTkyYzIx
MDAwODVhYTZjZTA0ZWMxODZmZTYyMzQ2YTNiMTczCndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9yb2FtLWkzODYvaTM4Ni1yYW5kY29uZmln
LXIzLTA5MDUtMTZjZDE5MmMyMTAwMDg1YWE2Y2UwNGVjMTg2ZmU2MjM0NmEzYjE3MwprZXJu
ZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvMTZjZDE5MmMyMTAwMDg1YWE2
Y2UwNGVjMTg2ZmU2MjM0NmEzYjE3My92bWxpbnV6LTMuMTcuMC1yYzMtMDEwMDgtZzE2Y2Qx
OTIKCjIwMTQtMDktMDYgMDE6Mjc6NTkgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLi4JMi4JMTAJ
MTYJMTkJMjAgU1VDQ0VTUwoKQmlzZWN0aW5nOiA3IHJldmlzaW9ucyBsZWZ0IHRvIHRlc3Qg
YWZ0ZXIgdGhpcyAocm91Z2hseSA0IHN0ZXBzKQpbMzFjMDEwYjEzYzkzZTZhN2U4NTUzYmU5
YjFkODg1YjYxZGY0MzRiNF0gTWVyZ2UgJ2RybS1pbnRlbC90b3BpYy9jb3JlLXN0dWZmJyBp
bnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0MDkwNTIxMzgKcnVubmluZyAvYy9rZXJuZWwtdGVz
dHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29i
ai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYtcmFuZGNv
bmZpZy1yMy0wOTA1L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDkwNTIxMzg6
MzFjMDEwYjEzYzkzZTZhN2U4NTUzYmU5YjFkODg1YjYxZGY0MzRiNDpiaXNlY3QtbGludXgK
CjIwMTQtMDktMDYgMDE6MzI6MDAgMzFjMDEwYjEzYzkzZTZhN2U4NTUzYmU5YjFkODg1YjYx
ZGY0MzRiNCBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS0zMWMwMTBiMTNjOTNlNmE3ZTg1
NTNiZTliMWQ4ODViNjFkZjQzNGI0CkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2
LXJhbmRjb25maWctcjMtMDkwNS8zMWMwMTBiMTNjOTNlNmE3ZTg1NTNiZTliMWQ4ODViNjFk
ZjQzNGI0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1x
dWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS0zMWMwMTBiMTNjOTNlNmE3ZTg1NTNiZTli
MWQ4ODViNjFkZjQzNGI0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0
cy9idWlsZC1xdWV1ZS9yb2FtLWkzODYvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUtMzFjMDEw
YjEzYzkzZTZhN2U4NTUzYmU5YjFkODg1YjYxZGY0MzRiNAprZXJuZWw6IC9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXIzLTA5MDUvMzFjMDEwYjEzYzkzZTZhN2U4NTUzYmU5YjFkODg1YjYx
ZGY0MzRiNC92bWxpbnV6LTMuMTcuMC1yYzMtMDEwMTAtZzMxYzAxMGIKCjIwMTQtMDktMDYg
MDE6NTA6MDAgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgCTEgVEVTVCBGQUlMVVJFClsgICAgMS43
MDUxMDldIFtkcm1dIHJhZGVvbiBrZXJuZWwgbW9kZXNldHRpbmcgZW5hYmxlZC4KWyAgICAx
LjcwNjc3Ml0gW1RUTV0gWm9uZSAga2VybmVsOiBBdmFpbGFibGUgZ3JhcGhpY3MgbWVtb3J5
OiAxMzQ4NzQga2lCClsgICAgMS43MDc1OTFdIFtUVE1dIEluaXRpYWxpemluZyBwb29sIGFs
bG9jYXRvcgpbICAgIDEuNzA4NTYyXSBJTkZPOiB0cnlpbmcgdG8gcmVnaXN0ZXIgbm9uLXN0
YXRpYyBrZXkuClsgICAgMS43MDkxNjddIHRoZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRzIGxv
Y2tkZXAgYW5ub3RhdGlvbi4KWyAgICAxLjcwOTg0OF0gdHVybmluZyBvZmYgdGhlIGxvY2tp
bmcgY29ycmVjdG5lc3MgdmFsaWRhdG9yLgpbICAgIDEuNzEwNTEzXSBDUFU6IDEgUElEOiAx
IENvbW06IHN3YXBwZXIvMCBOb3QgdGFpbnRlZCAzLjE3LjAtcmMzLTAxMDEwLWczMWMwMTBi
ICMyClsgICAgMS43MTE0MzJdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0
NDBGWCArIFBJSVgsIDE5OTYpLCBCSU9TIDEuNy41LTIwMTQwNTMxXzA4MzAzMC1nYW5kYWxm
IDA0LzAxLzIwMTQKWyAgICAxLjcxMjE2MF0gIDAwMDAwMDAwIDAwMDAwMDAwIGQxYzQ5YzA4
IGNjMTlhZGNkIGNjYjkyY2UwIGQxYzQ5YzdjIGNiNDdiNzcxIGNjNGExZTFjClsgICAgMS43
MTIxNjBdICAwOTUwYjIwNSBkMWM0MDAwMCBkMWM0OWM5MCBjYjQ3OWZjNiBkMWM0MDAwMCA1
NDJjODE2YSBkMWM0MDAwMCA1NDJjODE2YQpbICAgIDEuNzEyMTYwXSAgMDAwMDAwMDUgMDFj
NDAwMDAgMDAwMDAwMDAgZDFkM2IwNDggZDFkM2IwNDggMDAwMDAwMDAgY2NiNzQ5MTggZDFj
NDA1ZDAKWyAgICAxLjcxMjE2MF0gQ2FsbCBUcmFjZToKWyAgICAxLjcxMjE2MF0gIFs8Y2Mx
OWFkY2Q+XSBkdW1wX3N0YWNrKzB4NDgvMHg2MApbICAgIDEuNzEyMTYwXSAgWzxjYjQ3Yjc3
MT5dIF9fbG9ja19hY3F1aXJlKzB4MWMyMS8weDFkYTAKWyAgICAxLjcxMjE2MF0gIFs8Y2I0
NzlmYzY+XSA/IF9fbG9ja19hY3F1aXJlKzB4NDc2LzB4MWRhMApbICAgIDEuNzEyMTYwXSAg
WzxjYjQ3OGVjNj5dID8gX19sb2NrX2lzX2hlbGQrMHg0Ni8weDYwClsgICAgMS43MTIxNjBd
ICBbPGNiNDdjMTQxPl0gbG9ja19hY3F1aXJlKzB4OTEvMHhjMApbICAgIDEuNzEyMTYwXSAg
WzxjYmE1ZmE1MT5dID8gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjcxMjE2
MF0gIFs8Y2MxYThjM2M+XSBfX3d3X211dGV4X2xvY2srMHg2Yy8weDc4MApbICAgIDEuNzEy
MTYwXSAgWzxjYmE1ZmE1MT5dID8gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAx
LjcxMjE2MF0gIFs8Y2JhNWZhNTE+XSA/IGRybV9tb2Rlc2V0X2xvY2srMHgzMS8weGYwClsg
ICAgMS43MTIxNjBdICBbPGNiYTVmYTUxPl0gPyBkcm1fbW9kZXNldF9sb2NrKzB4MzEvMHhm
MApbICAgIDEuNzEyMTYwXSAgWzxjYmE1ZmE1MT5dIGRybV9tb2Rlc2V0X2xvY2srMHgzMS8w
eGYwClsgICAgMS43MTIxNjBdICBbPGNiYTVmY2U0Pl0gZHJtX21vZGVzZXRfbG9ja19hbGxf
Y3J0Y3MrMHgzNC8weDUwClsgICAgMS43MTIxNjBdICBbPGNiYTVmZGE0Pl0gX19kcm1fbW9k
ZXNldF9sb2NrX2FsbCsweGE0LzB4ZTAKWyAgICAxLjcxMjE2MF0gIFs8Y2JhNWZkZWE+XSBk
cm1fbW9kZXNldF9sb2NrX2FsbCsweGEvMHgzMApbICAgIDEuNzEyMTYwXSAgWzxjYmE1MTJl
Yj5dIGRybV9lbmNvZGVyX2luaXQrMHgxYi8weGUwClsgICAgMS43MTIxNjBdICBbPGNiNTBl
ZTQ4Pl0gPyBrbWVtX2NhY2hlX2FsbG9jKzB4OTgvMHgxOTAKWyAgICAxLjcxMjE2MF0gIFs8
Y2JiNjg1NTE+XSA/IGNpcnJ1c19tb2Rlc2V0X2luaXQrMHhlMS8weDFjMApbICAgIDEuNzEy
MTYwXSAgWzxjYmI2ODU3Nz5dIGNpcnJ1c19tb2Rlc2V0X2luaXQrMHgxMDcvMHgxYzAKWyAg
ICAxLjcxMjE2MF0gIFs8Y2JiNjc2MTc+XSBjaXJydXNfZHJpdmVyX2xvYWQrMHg1Ny8weDEy
MApbICAgIDEuNzEyMTYwXSAgWzxjYmE0YzgxZT5dIGRybV9kZXZfcmVnaXN0ZXIrMHg5ZS8w
eDEwMApbICAgIDEuNzEyMTYwXSAgWzxjYmE0ZGY2MT5dIGRybV9nZXRfcGNpX2RldisweDkx
LzB4MWMwClsgICAgMS43MTIxNjBdICBbPGNiNDc4MjhiPl0gPyB0cmFjZV9oYXJkaXJxc19v
bisweGIvMHgxMApbICAgIDEuNzEyMTYwXSAgWzxjYzFhOGIxOD5dID8gbXV0ZXhfdW5sb2Nr
KzB4OC8weDEwClsgICAgMS43MTIxNjBdICBbPGNiYjY4NzljPl0gY2lycnVzX3BjaV9wcm9i
ZSsweGFjLzB4ZjAKWyAgICAxLjcxMjE2MF0gIFs8Y2I5MTNlZDc+XSBwY2lfZGV2aWNlX3By
b2JlKzB4NzcvMHhlMApbICAgIDEuNzEyMTYwXSAgWzxjYjU3ZmZmMD5dID8gc3lzZnNfY3Jl
YXRlX2xpbmsrMHgyMC8weDQwClsgICAgMS43MTIxNjBdICBbPGNiYmM0ZTEzPl0gZHJpdmVy
X3Byb2JlX2RldmljZSsweDczLzB4MjMwClsgICAgMS43MTIxNjBdICBbPGNiOTEzZTMyPl0g
PyBwY2lfbWF0Y2hfZGV2aWNlKzB4YzIvMHhmMApbICAgIDEuNzEyMTYwXSAgWzxjYmJjNTBi
MT5dIF9fZHJpdmVyX2F0dGFjaCsweDkxLzB4YTAKWyAgICAxLjcxMjE2MF0gIFs8Y2JiYzUw
MjA+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDUwLzB4NTAKWyAgICAxLjcxMjE2MF0gIFs8Y2Ji
YzM3MWY+XSBidXNfZm9yX2VhY2hfZGV2KzB4NGYvMHg4MApbICAgIDEuNzEyMTYwXSAgWzxj
YmJjNTE3OT5dIGRyaXZlcl9hdHRhY2grMHgxOS8weDIwClsgICAgMS43MTIxNjBdICBbPGNi
YmM1MDIwPl0gPyBfX2RldmljZV9hdHRhY2grMHg1MC8weDUwClsgICAgMS43MTIxNjBdICBb
PGNiYmM0MDM3Pl0gYnVzX2FkZF9kcml2ZXIrMHgxMzcvMHgxZjAKWyAgICAxLjcxMjE2MF0g
IFs8Y2M2ZTA2ZmE+XSA/IG1nYWcyMDBfaW5pdCsweDIyLzB4MjIKWyAgICAxLjcxMjE2MF0g
IFs8Y2M2ZTA2ZmE+XSA/IG1nYWcyMDBfaW5pdCsweDIyLzB4MjIKWyAgICAxLjcxMjE2MF0g
IFs8Y2JiYzU3ZTQ+XSBkcml2ZXJfcmVnaXN0ZXIrMHg1NC8weGUwClsgICAgMS43MTIxNjBd
ICBbPGNiOTE0MTM1Pl0gX19wY2lfcmVnaXN0ZXJfZHJpdmVyKzB4NDUvMHg1MApbICAgIDEu
NzEyMTYwXSAgWzxjYmE0ZTE3YT5dIGRybV9wY2lfaW5pdCsweGVhLzB4MTEwClsgICAgMS43
MTIxNjBdICBbPGNiNDc4MjhiPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHgxMApbICAg
IDEuNzEyMTYwXSAgWzxjYzZlMDZmYT5dID8gbWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAg
IDEuNzEyMTYwXSAgWzxjYzZlMDcxYT5dIGNpcnJ1c19pbml0KzB4MjAvMHgyMgpbICAgIDEu
NzMyMDMwXSAgWzxjYzZiNGM5Mj5dIGRvX29uZV9pbml0Y2FsbCsweDE2YS8weDE3OQpbICAg
IDEuNzMyMDMwXSAgWzxjYjQ1NTAwMD5dID8gcGFyc2VfYXJncysweDFlMC8weDNlMApbICAg
IDEuNzMyMDMwXSAgWzxjYzZiNGQ4ZT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZWQvMHgx
NmEKWyAgICAxLjczMjAzMF0gIFs8Y2MxOTUxYmI+XSBrZXJuZWxfaW5pdCsweGIvMHhlMApb
ICAgIDEuNzMyMDMwXSAgWzxjYzFhYzBlMT5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgy
MS8weDMwClsgICAgMS43MzIwMzBdICBbPGNjMTk1MWIwPl0gPyByZXN0X2luaXQrMHgxMjAv
MHgxMjAKWyAgICAxLjczNDgyN10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxM
IHBvaW50ZXIgZGVyZWZlcmVuY2UgYXQgICAobnVsbCkKWyAgICAxLjczNTcyMF0gSVA6IFs8
Y2MxYThjY2E+XSBfX3d3X211dGV4X2xvY2srMHhmYS8weDc4MApbICAgIDEuNzM2MzY5XSAq
cGRwdCA9IDAwMDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAg
MS43MzcxMDVdIE9vcHM6IDAwMDIgWyMxXSBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAgMS43
Mzc3MDldIENQVTogMSBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTcu
MC1yYzMtMDEwMTAtZzMxYzAxMGIgIzIKWyAgICAxLjczODYyMF0gSGFyZHdhcmUgbmFtZTog
UUVNVSBTdGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS43LjUtMjAx
NDA1MzFfMDgzMDMwLWdhbmRhbGYgMDQvMDEvMjAxNApbICAgIDEuNzM4ODEzXSB0YXNrOiBk
MWM0MDAwMCB0aTogZDFjNDgwMDAgdGFzay50aTogZDFjNDgwMDAKWyAgICAxLjczODgxM10g
RUlQOiAwMDYwOls8Y2MxYThjY2E+XSBFRkxBR1M6IDAwMDEwMDgyIENQVTogMQpbICAgIDEu
NzM4ODEzXSBFSVAgaXMgYXQgX193d19tdXRleF9sb2NrKzB4ZmEvMHg3ODAKWyAgICAxLjcz
ODgxM10gRUFYOiAwMDAwMDAwMCBFQlg6IGNiMjVmNjgwIEVDWDogZDFkM2IwMzQgRURYOiBk
MWM0OWNkYwpbICAgIDEuNzM4ODEzXSBFU0k6IGQxZDNiMDEwIEVESTogZDFkM2IwMTQgRUJQ
OiBkMWM0OWNmOCBFU1A6IGQxYzQ5Y2I0ClsgICAgMS43Mzg4MTNdICBEUzogMDA3YiBFUzog
MDA3YiBGUzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAgIDEuNzQ0MDIzXSBDUjA6IDgw
MDUwMDNiIENSMjogMDAwMDAwMDAgQ1IzOiAwYzc2MDAwMCBDUjQ6IDAwMDAwNmIwClsgICAg
MS43NDQwMjNdIFN0YWNrOgpbICAgIDEuNzQ0MDIzXSAgMDAwMDAwMDAgMDAwMDAwMDEgY2Iy
NWY2OTggY2JhNWZhNTEgY2JhNWZhNTEgZDFkM2IwNDggMDAwMDAwMDEgZDFjNDAwMDAKWyAg
ICAxLjc0NDAyM10gIGNiMjVmNjgwIDAwMDAwMjQ2IGQxZDNiMDM0IDAwMDAwMDAwIDExMTEx
MTExIGQxYzQ5Y2RjIGNiMjVmNjgwIGQxZDNiMDEwClsgICAgMS43NDQwMjNdICBjYjI1ZjY4
MCBkMWM0OWQwYyBjYmE1ZmE1MSBkMWQzYjAwMCBkMWQzYTQwMCBjYjI1ZjY4MCBkMWM0OWQy
MCBjYmE1ZmNlNApbICAgIDEuNzQ0MDIzXSBDYWxsIFRyYWNlOgpbICAgIDEuNzQ0MDIzXSAg
WzxjYmE1ZmE1MT5dID8gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjc0NDAy
M10gIFs8Y2JhNWZhNTE+XSA/IGRybV9tb2Rlc2V0X2xvY2srMHgzMS8weGYwClsgICAgMS43
NDQwMjNdICBbPGNiYTVmYTUxPl0gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAx
Ljc0NDAyM10gIFs8Y2JhNWZjZTQ+XSBkcm1fbW9kZXNldF9sb2NrX2FsbF9jcnRjcysweDM0
LzB4NTAKWyAgICAxLjc0NDAyM10gIFs8Y2JhNWZkYTQ+XSBfX2RybV9tb2Rlc2V0X2xvY2tf
YWxsKzB4YTQvMHhlMApbICAgIDEuNzQ0MDIzXSAgWzxjYmE1ZmRlYT5dIGRybV9tb2Rlc2V0
X2xvY2tfYWxsKzB4YS8weDMwClsgICAgMS43NDQwMjNdICBbPGNiYTUxMmViPl0gZHJtX2Vu
Y29kZXJfaW5pdCsweDFiLzB4ZTAKWyAgICAxLjc0NDAyM10gIFs8Y2I1MGVlNDg+XSA/IGtt
ZW1fY2FjaGVfYWxsb2MrMHg5OC8weDE5MApbICAgIDEuNzQ0MDIzXSAgWzxjYmI2ODU1MT5d
ID8gY2lycnVzX21vZGVzZXRfaW5pdCsweGUxLzB4MWMwClsgICAgMS43NDQwMjNdICBbPGNi
YjY4NTc3Pl0gY2lycnVzX21vZGVzZXRfaW5pdCsweDEwNy8weDFjMApbICAgIDEuNzQ0MDIz
XSAgWzxjYmI2NzYxNz5dIGNpcnJ1c19kcml2ZXJfbG9hZCsweDU3LzB4MTIwClsgICAgMS43
NDQwMjNdICBbPGNiYTRjODFlPl0gZHJtX2Rldl9yZWdpc3RlcisweDllLzB4MTAwClsgICAg
MS43NDQwMjNdICBbPGNiYTRkZjYxPl0gZHJtX2dldF9wY2lfZGV2KzB4OTEvMHgxYzAKWyAg
ICAxLjc0NDAyM10gIFs8Y2I0NzgyOGI+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weDEw
ClsgICAgMS43NDQwMjNdICBbPGNjMWE4YjE4Pl0gPyBtdXRleF91bmxvY2srMHg4LzB4MTAK
WyAgICAxLjc0NDAyM10gIFs8Y2JiNjg3OWM+XSBjaXJydXNfcGNpX3Byb2JlKzB4YWMvMHhm
MApbICAgIDEuNzQ0MDIzXSAgWzxjYjkxM2VkNz5dIHBjaV9kZXZpY2VfcHJvYmUrMHg3Ny8w
eGUwClsgICAgMS43NDQwMjNdICBbPGNiNTdmZmYwPl0gPyBzeXNmc19jcmVhdGVfbGluaysw
eDIwLzB4NDAKWyAgICAxLjc0NDAyM10gIFs8Y2JiYzRlMTM+XSBkcml2ZXJfcHJvYmVfZGV2
aWNlKzB4NzMvMHgyMzAKWyAgICAxLjc0NDAyM10gIFs8Y2I5MTNlMzI+XSA/IHBjaV9tYXRj
aF9kZXZpY2UrMHhjMi8weGYwClsgICAgMS43NDQwMjNdICBbPGNiYmM1MGIxPl0gX19kcml2
ZXJfYXR0YWNoKzB4OTEvMHhhMApbICAgIDEuNzQ0MDIzXSAgWzxjYmJjNTAyMD5dID8gX19k
ZXZpY2VfYXR0YWNoKzB4NTAvMHg1MApbICAgIDEuNzQ0MDIzXSAgWzxjYmJjMzcxZj5dIGJ1
c19mb3JfZWFjaF9kZXYrMHg0Zi8weDgwClsgICAgMS43NDQwMjNdICBbPGNiYmM1MTc5Pl0g
ZHJpdmVyX2F0dGFjaCsweDE5LzB4MjAKWyAgICAxLjc0NDAyM10gIFs8Y2JiYzUwMjA+XSA/
IF9fZGV2aWNlX2F0dGFjaCsweDUwLzB4NTAKWyAgICAxLjc0NDAyM10gIFs8Y2JiYzQwMzc+
XSBidXNfYWRkX2RyaXZlcisweDEzNy8weDFmMApbICAgIDEuNzQ0MDIzXSAgWzxjYzZlMDZm
YT5dID8gbWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAgIDEuNzQ0MDIzXSAgWzxjYzZlMDZm
YT5dID8gbWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAgIDEuNzQ0MDIzXSAgWzxjYmJjNTdl
ND5dIGRyaXZlcl9yZWdpc3RlcisweDU0LzB4ZTAKWyAgICAxLjc0NDAyM10gIFs8Y2I5MTQx
MzU+XSBfX3BjaV9yZWdpc3Rlcl9kcml2ZXIrMHg0NS8weDUwClsgICAgMS43NDQwMjNdICBb
PGNiYTRlMTdhPl0gZHJtX3BjaV9pbml0KzB4ZWEvMHgxMTAKWyAgICAxLjc0NDAyM10gIFs8
Y2I0NzgyOGI+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weDEwClsgICAgMS43NDQwMjNd
ICBbPGNjNmUwNmZhPl0gPyBtZ2FnMjAwX2luaXQrMHgyMi8weDIyClsgICAgMS43NDQwMjNd
ICBbPGNjNmUwNzFhPl0gY2lycnVzX2luaXQrMHgyMC8weDIyClsgICAgMS43NDQwMjNdICBb
PGNjNmI0YzkyPl0gZG9fb25lX2luaXRjYWxsKzB4MTZhLzB4MTc5ClsgICAgMS43NDQwMjNd
ICBbPGNiNDU1MDAwPl0gPyBwYXJzZV9hcmdzKzB4MWUwLzB4M2UwClsgICAgMS43NDQwMjNd
ICBbPGNjNmI0ZDhlPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhlZC8weDE2YQpbICAgIDEu
NzQ0MDIzXSAgWzxjYzE5NTFiYj5dIGtlcm5lbF9pbml0KzB4Yi8weGUwClsgICAgMS43NDQw
MjNdICBbPGNjMWFjMGUxPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAg
ICAxLjc0NDAyM10gIFs8Y2MxOTUxYjA+XSA/IHJlc3RfaW5pdCsweDEyMC8weDEyMApbICAg
IDEuNzQ0MDIzXSBDb2RlOiA1NSBlNCA4OSBmMCBlOCAxOCBjMiAyYyBmZiA4YiA0NSBkOCA4
ZCA1NSBlNCA4YiA0OCAwNCA4OSBmMCBlOCA0OCBjNCAyYyBmZiA4YiA0NiAyOCA4ZCA0ZSAy
NCA4ZCA1NSBlNCA4OSA1NiAyOCA4OSA0ZCBlNCA4OSA0NSBlOCA8ODk+IDEwIDhiIDQ1IGQ4
IDg5IDRkIGQ0IDg5IDQ1IGVjIDhkIDc0IDI2IDAwIDhkIGJjIDI3IDAwIDAwIDAwClsgICAg
MS43NDQwMjNdIEVJUDogWzxjYzFhOGNjYT5dIF9fd3dfbXV0ZXhfbG9jaysweGZhLzB4Nzgw
IFNTOkVTUCAwMDY4OmQxYzQ5Y2I0ClsgICAgMS43NDQwMjNdIENSMjogMDAwMDAwMDAwMDAw
MDAwMApbICAgIDEuNzQ0MDIzXSAtLS1bIGVuZCB0cmFjZSA4ODg5MTIwMDE3N2JiODgzIF0t
LS0KWyAgICAxLjc0NDAyM10gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4
Y2VwdGlvbgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzMxYzAxMGIxM2M5M2U2
YTdlODU1M2JlOWIxZDg4NWI2MWRmNDM0YjQvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDE6MjAx
NDA5MDYwMTUwMDU6aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFu
ZGNvbmZpZy1yMy0wOTA1LzMxYzAxMGIxM2M5M2U2YTdlODU1M2JlOWIxZDg4NWI2MWRmNDM0
YjQvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMDI6MjAxNDA5MDYwMTUwMDU6aTM4Ni1yYW5kY29u
ZmlnLXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzMxYzAxMGIx
M2M5M2U2YTdlODU1M2JlOWIxZDg4NWI2MWRmNDM0YjQvZG1lc2ctcXVhbnRhbC1pdmI0MS0x
MTY6MjAxNDA5MDYwMTUwMTA6aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDU6Ogova2VybmVsL2kz
ODYtcmFuZGNvbmZpZy1yMy0wOTA1LzMxYzAxMGIxM2M5M2U2YTdlODU1M2JlOWIxZDg4NWI2
MWRmNDM0YjQvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMzoyMDE0MDkwNjAxNTAwNDppMzg2LXJh
bmRjb25maWctcjMtMDkwNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvMzFj
MDEwYjEzYzkzZTZhN2U4NTUzYmU5YjFkODg1YjYxZGY0MzRiNC9kbWVzZy1xdWFudGFsLWl2
YjQxLTQyOjIwMTQwOTA2MDE1MDA0OmkzODYtcmFuZGNvbmZpZy1yMy0wOTA1OjoKL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS8zMWMwMTBiMTNjOTNlNmE3ZTg1NTNiZTliMWQ4
ODViNjFkZjQzNGI0L2RtZXNnLXF1YW50YWwtaXZiNDEtNDY6MjAxNDA5MDYwMTUwMDk6aTM4
Ni1yYW5kY29uZmlnLXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1
LzMxYzAxMGIxM2M5M2U2YTdlODU1M2JlOWIxZDg4NWI2MWRmNDM0YjQvZG1lc2ctcXVhbnRh
bC1pdmI0MS00OToyMDE0MDkwNjAxNTAxMDppMzg2LXJhbmRjb25maWctcjMtMDkwNTo6Ci9r
ZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvMzFjMDEwYjEzYzkzZTZhN2U4NTUzYmU5
YjFkODg1YjYxZGY0MzRiNC9kbWVzZy1xdWFudGFsLWl2YjQxLTUyOjIwMTQwOTA2MDE1MDA0
OmkzODYtcmFuZGNvbmZpZy1yMy0wOTA1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMt
MDkwNS8zMWMwMTBiMTNjOTNlNmE3ZTg1NTNiZTliMWQ4ODViNjFkZjQzNGI0L2RtZXNnLXF1
YW50YWwtaXZiNDEtNjA6MjAxNDA5MDYwMTUwMDQ6aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDU6
Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzMxYzAxMGIxM2M5M2U2YTdlODU1
M2JlOWIxZDg4NWI2MWRmNDM0YjQvZG1lc2ctcXVhbnRhbC1pdmI0MS02MToyMDE0MDkwNjAx
NTAwNTppMzg2LXJhbmRjb25maWctcjMtMDkwNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmln
LXIzLTA5MDUvMzFjMDEwYjEzYzkzZTZhN2U4NTUzYmU5YjFkODg1YjYxZGY0MzRiNC9kbWVz
Zy1xdWFudGFsLWl2YjQxLTY0OjIwMTQwOTA2MDE1MDA5OmkzODYtcmFuZGNvbmZpZy1yMy0w
OTA1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS8zMWMwMTBiMTNjOTNlNmE3
ZTg1NTNiZTliMWQ4ODViNjFkZjQzNGI0L2RtZXNnLXF1YW50YWwtaXZiNDEtNjY6MjAxNDA5
MDYwMTUwMDU6aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFuZGNv
bmZpZy1yMy0wOTA1LzMxYzAxMGIxM2M5M2U2YTdlODU1M2JlOWIxZDg4NWI2MWRmNDM0YjQv
ZG1lc2ctcXVhbnRhbC1pdmI0MS02NzoyMDE0MDkwNjAxNTAxMDppMzg2LXJhbmRjb25maWct
cjMtMDkwNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvMzFjMDEwYjEzYzkz
ZTZhN2U4NTUzYmU5YjFkODg1YjYxZGY0MzRiNC9kbWVzZy1xdWFudGFsLWl2YjQxLTc0OjIw
MTQwOTA2MDE1MDA1OmkzODYtcmFuZGNvbmZpZy1yMy0wOTA1OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjMtMDkwNS8zMWMwMTBiMTNjOTNlNmE3ZTg1NTNiZTliMWQ4ODViNjFkZjQz
NGI0L2RtZXNnLXF1YW50YWwtaXZiNDEtNzg6MjAxNDA5MDYwMTUwMDQ6aTM4Ni1yYW5kY29u
ZmlnLXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzMxYzAxMGIx
M2M5M2U2YTdlODU1M2JlOWIxZDg4NWI2MWRmNDM0YjQvZG1lc2ctcXVhbnRhbC1pdmI0MS04
NDoyMDE0MDkwNjAxNTAwNTppMzg2LXJhbmRjb25maWctcjMtMDkwNTo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXIzLTA5MDUvMzFjMDEwYjEzYzkzZTZhN2U4NTUzYmU5YjFkODg1YjYx
ZGY0MzRiNC9kbWVzZy1xdWFudGFsLWl2YjQxLTg6MjAxNDA5MDYwMTUwMDQ6aTM4Ni1yYW5k
Y29uZmlnLXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzMxYzAx
MGIxM2M5M2U2YTdlODU1M2JlOWIxZDg4NWI2MWRmNDM0YjQvZG1lc2ctcXVhbnRhbC1pdmI0
MS05NDoyMDE0MDkwNjAxNTAwNDppMzg2LXJhbmRjb25maWctcjMtMDkwNTo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvMzFjMDEwYjEzYzkzZTZhN2U4NTUzYmU5YjFkODg1
YjYxZGY0MzRiNC9kbWVzZy15b2N0by12cC0zNjoyMDE0MDkwNjAxNTAxNTppMzg2LXJhbmRj
b25maWctcjMtMDkwNTozLjE3LjAtcmMzLTAxMDEwLWczMWMwMTBiOjIKMDoxOToyMCBhbGxf
Z29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7MzVtMjAxNC0wOS0wNiAwMTo1MDozMSBSRVBF
QVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QvLnJlcGVh
dBtbMG0KCmxpbmVhci1iaXNlY3Q6IGJhZCBicmFuY2ggbWF5IGJlIGRybS1pbnRlbC90b3Bp
Yy9jb3JlLXN0dWZmCmxpbmVhci1iaXNlY3Q6IGhhbmRsZSBvdmVyIHRvIGdpdCBiaXNlY3QK
bGluZWFyLWJpc2VjdDogZ2l0IGJpc2VjdCBzdGFydCAzMWMwMTBiMTNjOTNlNmE3ZTg1NTNi
ZTliMWQ4ODViNjFkZjQzNGI0IDE2Y2QxOTJjMjEwMDA4NWFhNmNlMDRlYzE4NmZlNjIzNDZh
M2IxNzMgLS0KUHJldmlvdXMgSEVBRCBwb3NpdGlvbiB3YXMgMzFjMDEwYi4uLiBNZXJnZSAn
ZHJtLWludGVsL3RvcGljL2NvcmUtc3R1ZmYnIGludG8gZGV2ZWwtcm9hbS1pMzg2LTIwMTQw
OTA1MjEzOApIRUFEIGlzIG5vdyBhdCBmY2IyMTMzLi4uIE1lcmdlICdqYmFybmVzL2FzeW5j
LWZiLXByb2JlJyBpbnRvIGRldmVsLXJvYW0taTM4Ni0yMDE0MDUzMDAyMDEKQmlzZWN0aW5n
OiAwIHJldmlzaW9ucyBsZWZ0IHRvIHRlc3QgYWZ0ZXIgdGhpcyAocm91Z2hseSAwIHN0ZXBz
KQpbNGUzOTZmYzIwZGI5NmMwYWY3MTA2MDFmMDgxZmZiNDFiMGZlNjExY10gZHJtOiBEcm9w
IG1vZGVzZXQgbG9ja2luZyBmcm9tIGNydGMgaW5pdCBmdW5jdGlvbgpsaW5lYXItYmlzZWN0
OiBnaXQgYmlzZWN0IHJ1biAvYy9rZXJuZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWls
dXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xpbnV4L29iai1iaXNlY3QKcnVubmluZyAvYy9rZXJu
ZWwtdGVzdHMvYmlzZWN0LXRlc3QtYm9vdC1mYWlsdXJlLnNoIC9jL2Jvb3QtYmlzZWN0L2xp
bnV4L29iai1iaXNlY3QKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1yMy0wOTA1L2xpbnV4LWRldmVsOmRldmVsLXJvYW0taTM4Ni0yMDE0MDkw
NTIxMzg6NGUzOTZmYzIwZGI5NmMwYWY3MTA2MDFmMDgxZmZiNDFiMGZlNjExYzpiaXNlY3Qt
bGludXgKCjIwMTQtMDktMDYgMDE6NTA6NTYgNGUzOTZmYzIwZGI5NmMwYWY3MTA2MDFmMDgx
ZmZiNDFiMGZlNjExYyBjb21waWxpbmcKUXVldWVkIGJ1aWxkIHRhc2sgdG8gL2tidWlsZC10
ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS00ZTM5NmZjMjBkYjk2
YzBhZjcxMDYwMWYwODFmZmI0MWIwZmU2MTFjCkNoZWNrIGZvciBrZXJuZWwgaW4gL2tlcm5l
bC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS80ZTM5NmZjMjBkYjk2YzBhZjcxMDYwMWYwODFm
ZmI0MWIwZmU2MTFjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9i
dWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS00ZTM5NmZjMjBkYjk2YzBhZjcx
MDYwMWYwODFmZmI0MWIwZmU2MTFjCndhaXRpbmcgZm9yIGNvbXBsZXRpb24gb2YgL2tidWls
ZC10ZXN0cy9idWlsZC1xdWV1ZS9yb2FtLWkzODYvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUt
NGUzOTZmYzIwZGI5NmMwYWY3MTA2MDFmMDgxZmZiNDFiMGZlNjExYwprZXJuZWw6IC9rZXJu
ZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvNGUzOTZmYzIwZGI5NmMwYWY3MTA2MDFmMDgx
ZmZiNDFiMGZlNjExYy92bWxpbnV6LTMuMTcuMC1yYzItMDAyMjEtZzRlMzk2ZmMKCjIwMTQt
MDktMDYgMDI6MTQ6NTYgZGV0ZWN0aW5nIGJvb3Qgc3RhdGUgLiBURVNUIEZBSUxVUkUKWyAg
ICA2LjYzOTA1MV0gW2RybV0gcmFkZW9uIGtlcm5lbCBtb2Rlc2V0dGluZyBlbmFibGVkLgpb
ICAgIDYuNjQ0NTgwXSBbVFRNXSBab25lICBrZXJuZWw6IEF2YWlsYWJsZSBncmFwaGljcyBt
ZW1vcnk6IDE0NTc1MiBraUIKWyAgICA2LjY0NTQ0MF0gW1RUTV0gSW5pdGlhbGl6aW5nIHBv
b2wgYWxsb2NhdG9yClsgICAgNi42NDYzNzNdIElORk86IHRyeWluZyB0byByZWdpc3RlciBu
b24tc3RhdGljIGtleS4KWyAgICA2LjY0ODAxNl0gdGhlIGNvZGUgaXMgZmluZSBidXQgbmVl
ZHMgbG9ja2RlcCBhbm5vdGF0aW9uLgpbICAgIDYuNjQ4MDE2XSB0dXJuaW5nIG9mZiB0aGUg
bG9ja2luZyBjb3JyZWN0bmVzcyB2YWxpZGF0b3IuClsgICAgNi42NDgwMTZdIENQVTogMCBQ
SUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTcuMC1yYzItMDAyMjEtZzRl
Mzk2ZmMgIzUKWyAgICA2LjY0ODAxNl0gSGFyZHdhcmUgbmFtZTogQm9jaHMgQm9jaHMsIEJJ
T1MgQm9jaHMgMDEvMDEvMjAxMQpbICAgIDYuNjQ4MDE2XSAgMDAwMDAwMDAgMDAwMDAwMDAg
ZDM0NTFjMDggZDA3OTgxZmQgZDExOGY1MzAgZDM0NTFjN2MgY2ZhN2IzNDEgZDBhOWVhM2MK
WyAgICA2LjY0ODAxNl0gIDA5MTBiYzA1IGQzNDQ4MDAwIGQzNDUxYzkwIGNmYTc5Yjk2IGQz
NDQ4MDAwIDQ0MmYwMTdlIGQzNDQ4MDAwIDQ0MmYwMTdlClsgICAgNi42NDgwMTZdICAwMDAw
MDAwNSAwMTQ0ODAwMCAwMDAwMDAwMCBkMjZiMDA0OCBkMjZiMDA0OCAwMDAwMDAwMCBkMTE1
YTgzMCBkMzQ0ODVkMApbICAgIDYuNjQ4MDE2XSBDYWxsIFRyYWNlOgpbICAgIDYuNjQ4MDE2
XSAgWzxkMDc5ODFmZD5dIGR1bXBfc3RhY2srMHg0OC8weDYwClsgICAgNi42NDgwMTZdICBb
PGNmYTdiMzQxPl0gX19sb2NrX2FjcXVpcmUrMHgxYzIxLzB4MWRhMApbICAgIDYuNjQ4MDE2
XSAgWzxjZmE3OWI5Nj5dID8gX19sb2NrX2FjcXVpcmUrMHg0NzYvMHgxZGEwClsgICAgNi42
NDgwMTZdICBbPGNmYTc4YTk2Pl0gPyBfX2xvY2tfaXNfaGVsZCsweDQ2LzB4NjAKWyAgICA2
LjY0ODAxNl0gIFs8Y2ZhN2JkMTE+XSBsb2NrX2FjcXVpcmUrMHg5MS8weGMwClsgICAgNi42
NDgwMTZdICBbPGQwMDVlNTMxPl0gPyBkcm1fbW9kZXNldF9sb2NrKzB4MzEvMHhmMApbICAg
IDYuNjQ4MDE2XSAgWzxkMDdhNjA3Yz5dIF9fd3dfbXV0ZXhfbG9jaysweDZjLzB4NzgwClsg
ICAgNi42NDgwMTZdICBbPGQwMDVlNTMxPl0gPyBkcm1fbW9kZXNldF9sb2NrKzB4MzEvMHhm
MApbICAgIDYuNjQ4MDE2XSAgWzxkMDA1ZTUzMT5dID8gZHJtX21vZGVzZXRfbG9jaysweDMx
LzB4ZjAKWyAgICA2LjY0ODAxNl0gIFs8ZDAwNWU1MzE+XSA/IGRybV9tb2Rlc2V0X2xvY2sr
MHgzMS8weGYwClsgICAgNi42NDgwMTZdICBbPGQwMDVlNTMxPl0gZHJtX21vZGVzZXRfbG9j
aysweDMxLzB4ZjAKWyAgICA2LjY0ODAxNl0gIFs8ZDAwNWU3YzQ+XSBkcm1fbW9kZXNldF9s
b2NrX2FsbF9jcnRjcysweDM0LzB4NTAKWyAgICA2LjY0ODAxNl0gIFs8ZDAwNWU4ODQ+XSBf
X2RybV9tb2Rlc2V0X2xvY2tfYWxsKzB4YTQvMHhlMApbICAgIDYuNjQ4MDE2XSAgWzxkMDA1
ZThjYT5dIGRybV9tb2Rlc2V0X2xvY2tfYWxsKzB4YS8weDMwClsgICAgNi42NDgwMTZdICBb
PGQwMDUwMjJiPl0gZHJtX2VuY29kZXJfaW5pdCsweDFiLzB4ZTAKWyAgICA2LjY0ODAxNl0g
IFs8Y2ZiMGVhMDg+XSA/IGttZW1fY2FjaGVfYWxsb2MrMHg5OC8weDE5MApbICAgIDYuNjQ4
MDE2XSAgWzxkMDE2NmQ4MT5dID8gY2lycnVzX21vZGVzZXRfaW5pdCsweGUxLzB4MWMwClsg
ICAgNi42NDgwMTZdICBbPGQwMTY2ZGE3Pl0gY2lycnVzX21vZGVzZXRfaW5pdCsweDEwNy8w
eDFjMApbICAgIDYuNjQ4MDE2XSAgWzxkMDE2NWU0Nz5dIGNpcnJ1c19kcml2ZXJfbG9hZCsw
eDU3LzB4MTIwClsgICAgNi42NDgwMTZdICBbPGQwMDRiNzVlPl0gZHJtX2Rldl9yZWdpc3Rl
cisweDllLzB4MTAwClsgICAgNi42NDgwMTZdICBbPGQwMDRjZWExPl0gZHJtX2dldF9wY2lf
ZGV2KzB4OTEvMHgxYzAKWyAgICA2LjY0ODAxNl0gIFs8Y2ZhNzdlNWI+XSA/IHRyYWNlX2hh
cmRpcnFzX29uKzB4Yi8weDEwClsgICAgNi42NDgwMTZdICBbPGQwN2E1ZjU4Pl0gPyBtdXRl
eF91bmxvY2srMHg4LzB4MTAKWyAgICA2LjY0ODAxNl0gIFs8ZDAxNjZmY2M+XSBjaXJydXNf
cGNpX3Byb2JlKzB4YWMvMHhmMApbICAgIDYuNjQ4MDE2XSAgWzxjZmYxMzMzNz5dIHBjaV9k
ZXZpY2VfcHJvYmUrMHg3Ny8weGUwClsgICAgNi42NDgwMTZdICBbPGNmYjdmYmIwPl0gPyBz
eXNmc19jcmVhdGVfbGluaysweDIwLzB4NDAKWyAgICA2LjY0ODAxNl0gIFs8ZDAxYzM2NzM+
XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4NzMvMHgyMzAKWyAgICA2LjY0ODAxNl0gIFs8Y2Zm
MTMyOTI+XSA/IHBjaV9tYXRjaF9kZXZpY2UrMHhjMi8weGYwClsgICAgNi42NDgwMTZdICBb
PGQwMWMzOTExPl0gX19kcml2ZXJfYXR0YWNoKzB4OTEvMHhhMApbICAgIDYuNjQ4MDE2XSAg
WzxkMDFjMzg4MD5dID8gX19kZXZpY2VfYXR0YWNoKzB4NTAvMHg1MApbICAgIDYuNjQ4MDE2
XSAgWzxkMDFjMWY3Zj5dIGJ1c19mb3JfZWFjaF9kZXYrMHg0Zi8weDgwClsgICAgNi42NDgw
MTZdICBbPGQwMWMzOWQ5Pl0gZHJpdmVyX2F0dGFjaCsweDE5LzB4MjAKWyAgICA2LjY0ODAx
Nl0gIFs8ZDAxYzM4ODA+XSA/IF9fZGV2aWNlX2F0dGFjaCsweDUwLzB4NTAKWyAgICA2LjY0
ODAxNl0gIFs8ZDAxYzI4OTc+XSBidXNfYWRkX2RyaXZlcisweDEzNy8weDFmMApbICAgIDYu
NjQ4MDE2XSAgWzxkMGNkYjZlNj5dID8gbWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAgIDYu
NjQ4MDE2XSAgWzxkMGNkYjZlNj5dID8gbWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAgIDYu
NjQ4MDE2XSAgWzxkMDFjNDA0ND5dIGRyaXZlcl9yZWdpc3RlcisweDU0LzB4ZTAKWyAgICA2
LjY0ODAxNl0gIFs8Y2ZmMTM1OTU+XSBfX3BjaV9yZWdpc3Rlcl9kcml2ZXIrMHg0NS8weDUw
ClsgICAgNi42NDgwMTZdICBbPGQwMDRkMGJhPl0gZHJtX3BjaV9pbml0KzB4ZWEvMHgxMTAK
WyAgICA2LjY0ODAxNl0gIFs8Y2ZhNzdlNWI+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8w
eDEwClsgICAgNi42NDgwMTZdICBbPGQwY2RiNmU2Pl0gPyBtZ2FnMjAwX2luaXQrMHgyMi8w
eDIyClsgICAgNi42NDgwMTZdICBbPGQwY2RiNzA2Pl0gY2lycnVzX2luaXQrMHgyMC8weDIy
ClsgICAgNi42NDgwMTZdICBbPGQwY2FmYzkyPl0gZG9fb25lX2luaXRjYWxsKzB4MTZhLzB4
MTc5ClsgICAgNi42NDgwMTZdICBbPGNmYTU0ZjAwPl0gPyBwYXJzZV9hcmdzKzB4MTUwLzB4
M2UwClsgICAgNi42NDgwMTZdICBbPGQwY2FmZDhlPl0ga2VybmVsX2luaXRfZnJlZWFibGUr
MHhlZC8weDE2YQpbICAgIDYuNjQ4MDE2XSAgWzxkMDc5MjVkYj5dIGtlcm5lbF9pbml0KzB4
Yi8weGUwClsgICAgNi42NDgwMTZdICBbPGQwN2E5NTIxPl0gcmV0X2Zyb21fa2VybmVsX3Ro
cmVhZCsweDIxLzB4MzAKWyAgICA2LjY0ODAxNl0gIFs8ZDA3OTI1ZDA+XSA/IHJlc3RfaW5p
dCsweDEyMC8weDEyMApbICAgIDYuNzM0OTY2XSBCVUc6IHVuYWJsZSB0byBoYW5kbGUga2Vy
bmVsIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSBhdCAgIChudWxsKQpbICAgIDYuNzM1ODI0
XSBJUDogWzxkMDdhNjEwYT5dIF9fd3dfbXV0ZXhfbG9jaysweGZhLzB4NzgwClsgICAgNi43
MzY0NjldICpwZHB0ID0gMDAwMDAwMDAwMDAwMDAwMCAqcGRlID0gZjAwMGZmNTNmMDAwZmY1
MyAKWyAgICA2LjczODk0Ml0gT29wczogMDAwMiBbIzFdIFNNUCBERUJVR19QQUdFQUxMT0MK
WyAgICA2LjczODk0Ml0gQ1BVOiAwIFBJRDogMSBDb21tOiBzd2FwcGVyLzAgTm90IHRhaW50
ZWQgMy4xNy4wLXJjMi0wMDIyMS1nNGUzOTZmYyAjNQpbICAgIDYuNzM4OTQyXSBIYXJkd2Fy
ZSBuYW1lOiBCb2NocyBCb2NocywgQklPUyBCb2NocyAwMS8wMS8yMDExClsgICAgNi43Mzg5
NDJdIHRhc2s6IGQzNDQ4MDAwIHRpOiBkMzQ1MDAwMCB0YXNrLnRpOiBkMzQ1MDAwMApbICAg
IDYuNzM4OTQyXSBFSVA6IDAwNjA6WzxkMDdhNjEwYT5dIEVGTEFHUzogMDAwMTAwODIgQ1BV
OiAwClsgICAgNi43Mzg5NDJdIEVJUCBpcyBhdCBfX3d3X211dGV4X2xvY2srMHhmYS8weDc4
MApbICAgIDYuNzM4OTQyXSBFQVg6IDAwMDAwMDAwIEVCWDogZDI1MzBiNDAgRUNYOiBkMjZi
MDAzNCBFRFg6IGQzNDUxY2RjClsgICAgNi43Mzg5NDJdIEVTSTogZDI2YjAwMTAgRURJOiBk
MjZiMDAxNCBFQlA6IGQzNDUxY2Y4IEVTUDogZDM0NTFjYjQKWyAgICA2LjczODk0Ml0gIERT
OiAwMDdiIEVTOiAwMDdiIEZTOiAwMGQ4IEdTOiAwMGUwIFNTOiAwMDY4ClsgICAgNi43Mzg5
NDJdIENSMDogODAwNTAwMzMgQ1IyOiAwMDAwMDAwMCBDUjM6IDEwZDViMDAwIENSNDogMDAw
NDA2YjAKWyAgICA2LjczODk0Ml0gU3RhY2s6ClsgICAgNi43Mzg5NDJdICAwMDAwMDAwMCAw
MDAwMDAwMSBkMjUzMGI1OCBkMDA1ZTUzMSBkMDA1ZTUzMSBkMjZiMDA0OCAwMDAwMDAwMSBk
MzQ0ODAwMApbICAgIDYuNzM4OTQyXSAgZDI1MzBiNDAgMDAwMDAyNDYgZDI2YjAwMzQgMDAw
MDAwMDAgMTExMTExMTEgZDM0NTFjZGMgZDI1MzBiNDAgZDI2YjAwMTAKWyAgICA2LjczODk0
Ml0gIGQyNTMwYjQwIGQzNDUxZDBjIGQwMDVlNTMxIGQyNmIwMDAwIGQzNTMzNDAwIGQyNTMw
YjQwIGQzNDUxZDIwIGQwMDVlN2M0ClsgICAgNi43Mzg5NDJdIENhbGwgVHJhY2U6ClsgICAg
Ni43Mzg5NDJdICBbPGQwMDVlNTMxPl0gPyBkcm1fbW9kZXNldF9sb2NrKzB4MzEvMHhmMApb
ICAgIDYuNzM4OTQyXSAgWzxkMDA1ZTUzMT5dID8gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4
ZjAKWyAgICA2LjczODk0Ml0gIFs8ZDAwNWU1MzE+XSBkcm1fbW9kZXNldF9sb2NrKzB4MzEv
MHhmMApbICAgIDYuNzM4OTQyXSAgWzxkMDA1ZTdjND5dIGRybV9tb2Rlc2V0X2xvY2tfYWxs
X2NydGNzKzB4MzQvMHg1MApbICAgIDYuNzM4OTQyXSAgWzxkMDA1ZTg4ND5dIF9fZHJtX21v
ZGVzZXRfbG9ja19hbGwrMHhhNC8weGUwClsgICAgNi43Mzg5NDJdICBbPGQwMDVlOGNhPl0g
ZHJtX21vZGVzZXRfbG9ja19hbGwrMHhhLzB4MzAKWyAgICA2LjczODk0Ml0gIFs8ZDAwNTAy
MmI+XSBkcm1fZW5jb2Rlcl9pbml0KzB4MWIvMHhlMApbICAgIDYuNzM4OTQyXSAgWzxjZmIw
ZWEwOD5dID8ga21lbV9jYWNoZV9hbGxvYysweDk4LzB4MTkwClsgICAgNi43Mzg5NDJdICBb
PGQwMTY2ZDgxPl0gPyBjaXJydXNfbW9kZXNldF9pbml0KzB4ZTEvMHgxYzAKWyAgICA2Ljcz
ODk0Ml0gIFs8ZDAxNjZkYTc+XSBjaXJydXNfbW9kZXNldF9pbml0KzB4MTA3LzB4MWMwClsg
ICAgNi43Mzg5NDJdICBbPGQwMTY1ZTQ3Pl0gY2lycnVzX2RyaXZlcl9sb2FkKzB4NTcvMHgx
MjAKWyAgICA2LjczODk0Ml0gIFs8ZDAwNGI3NWU+XSBkcm1fZGV2X3JlZ2lzdGVyKzB4OWUv
MHgxMDAKWyAgICA2LjczODk0Ml0gIFs8ZDAwNGNlYTE+XSBkcm1fZ2V0X3BjaV9kZXYrMHg5
MS8weDFjMApbICAgIDYuNzM4OTQyXSAgWzxjZmE3N2U1Yj5dID8gdHJhY2VfaGFyZGlycXNf
b24rMHhiLzB4MTAKWyAgICA2LjczODk0Ml0gIFs8ZDA3YTVmNTg+XSA/IG11dGV4X3VubG9j
aysweDgvMHgxMApbICAgIDYuNzM4OTQyXSAgWzxkMDE2NmZjYz5dIGNpcnJ1c19wY2lfcHJv
YmUrMHhhYy8weGYwClsgICAgNi43Mzg5NDJdICBbPGNmZjEzMzM3Pl0gcGNpX2RldmljZV9w
cm9iZSsweDc3LzB4ZTAKWyAgICA2LjczODk0Ml0gIFs8Y2ZiN2ZiYjA+XSA/IHN5c2ZzX2Ny
ZWF0ZV9saW5rKzB4MjAvMHg0MApbICAgIDYuNzM4OTQyXSAgWzxkMDFjMzY3Mz5dIGRyaXZl
cl9wcm9iZV9kZXZpY2UrMHg3My8weDIzMApbICAgIDYuNzM4OTQyXSAgWzxjZmYxMzI5Mj5d
ID8gcGNpX21hdGNoX2RldmljZSsweGMyLzB4ZjAKWyAgICA2LjczODk0Ml0gIFs8ZDAxYzM5
MTE+XSBfX2RyaXZlcl9hdHRhY2grMHg5MS8weGEwClsgICAgNi43Mzg5NDJdICBbPGQwMWMz
ODgwPl0gPyBfX2RldmljZV9hdHRhY2grMHg1MC8weDUwClsgICAgNi43Mzg5NDJdICBbPGQw
MWMxZjdmPl0gYnVzX2Zvcl9lYWNoX2RldisweDRmLzB4ODAKWyAgICA2LjczODk0Ml0gIFs8
ZDAxYzM5ZDk+XSBkcml2ZXJfYXR0YWNoKzB4MTkvMHgyMApbICAgIDYuNzM4OTQyXSAgWzxk
MDFjMzg4MD5dID8gX19kZXZpY2VfYXR0YWNoKzB4NTAvMHg1MApbICAgIDYuNzM4OTQyXSAg
WzxkMDFjMjg5Nz5dIGJ1c19hZGRfZHJpdmVyKzB4MTM3LzB4MWYwClsgICAgNi43Mzg5NDJd
ICBbPGQwY2RiNmU2Pl0gPyBtZ2FnMjAwX2luaXQrMHgyMi8weDIyClsgICAgNi43Mzg5NDJd
ICBbPGQwY2RiNmU2Pl0gPyBtZ2FnMjAwX2luaXQrMHgyMi8weDIyClsgICAgNi43Mzg5NDJd
ICBbPGQwMWM0MDQ0Pl0gZHJpdmVyX3JlZ2lzdGVyKzB4NTQvMHhlMApbICAgIDYuNzM4OTQy
XSAgWzxjZmYxMzU5NT5dIF9fcGNpX3JlZ2lzdGVyX2RyaXZlcisweDQ1LzB4NTAKWyAgICA2
LjczODk0Ml0gIFs8ZDAwNGQwYmE+XSBkcm1fcGNpX2luaXQrMHhlYS8weDExMApbICAgIDYu
NzM4OTQyXSAgWzxjZmE3N2U1Yj5dID8gdHJhY2VfaGFyZGlycXNfb24rMHhiLzB4MTAKWyAg
ICA2LjczODk0Ml0gIFs8ZDBjZGI2ZTY+XSA/IG1nYWcyMDBfaW5pdCsweDIyLzB4MjIKWyAg
ICA2LjczODk0Ml0gIFs8ZDBjZGI3MDY+XSBjaXJydXNfaW5pdCsweDIwLzB4MjIKWyAgICA2
LjczODk0Ml0gIFs8ZDBjYWZjOTI+XSBkb19vbmVfaW5pdGNhbGwrMHgxNmEvMHgxNzkKWyAg
ICA2LjczODk0Ml0gIFs8Y2ZhNTRmMDA+XSA/IHBhcnNlX2FyZ3MrMHgxNTAvMHgzZTAKWyAg
ICA2LjczODk0Ml0gIFs8ZDBjYWZkOGU+XSBrZXJuZWxfaW5pdF9mcmVlYWJsZSsweGVkLzB4
MTZhClsgICAgNi43Mzg5NDJdICBbPGQwNzkyNWRiPl0ga2VybmVsX2luaXQrMHhiLzB4ZTAK
WyAgICA2LjczODk0Ml0gIFs8ZDA3YTk1MjE+XSByZXRfZnJvbV9rZXJuZWxfdGhyZWFkKzB4
MjEvMHgzMApbICAgIDYuNzM4OTQyXSAgWzxkMDc5MjVkMD5dID8gcmVzdF9pbml0KzB4MTIw
LzB4MTIwClsgICAgNi43Mzg5NDJdIENvZGU6IDU1IGU0IDg5IGYwIGU4IGE4IGU5IDJjIGZm
IDhiIDQ1IGQ4IDhkIDU1IGU0IDhiIDQ4IDA0IDg5IGYwIGU4IGQ4IGViIDJjIGZmIDhiIDQ2
IDI4IDhkIDRlIDI0IDhkIDU1IGU0IDg5IDU2IDI4IDg5IDRkIGU0IDg5IDQ1IGU4IDw4OT4g
MTAgOGIgNDUgZDggODkgNGQgZDQgODkgNDUgZWMgOGQgNzQgMjYgMDAgOGQgYmMgMjcgMDAg
MDAgMDAKWyAgICA2LjczODk0Ml0gRUlQOiBbPGQwN2E2MTBhPl0gX193d19tdXRleF9sb2Nr
KzB4ZmEvMHg3ODAgU1M6RVNQIDAwNjg6ZDM0NTFjYjQKWyAgICA2LjczODk0Ml0gQ1IyOiAw
MDAwMDAwMDAwMDAwMDAwClsgICAgNi43Mzg5NDJdIC0tLVsgZW5kIHRyYWNlIGNiMmUyZjBk
OWNmY2MxNzYgXS0tLQpbICAgIDYuNzM4OTQyXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2lu
ZzogRmF0YWwgZXhjZXB0aW9uCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvNGUz
OTZmYzIwZGI5NmMwYWY3MTA2MDFmMDgxZmZiNDFiMGZlNjExYy9kbWVzZy15b2N0by1rYnVp
bGQtMTE6MjAxNDA5MDYwMjEzMTA6aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDU6My4xNy4wLXJj
Mi0wMDIyMS1nNGUzOTZmYzo1Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvNGUz
OTZmYzIwZGI5NmMwYWY3MTA2MDFmMDgxZmZiNDFiMGZlNjExYy9kbWVzZy15b2N0by1rYnVp
bGQtMToyMDE0MDkwNjAyMTMwOTppMzg2LXJhbmRjb25maWctcjMtMDkwNTozLjE3LjAtcmMy
LTAwMjIxLWc0ZTM5NmZjOjUKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS80ZTM5
NmZjMjBkYjk2YzBhZjcxMDYwMWYwODFmZmI0MWIwZmU2MTFjL2RtZXNnLXlvY3RvLWtidWls
ZC0yOjIwMTQwOTA2MDIxMzA3OmkzODYtcmFuZGNvbmZpZy1yMy0wOTA1OjMuMTcuMC1yYzIt
MDAyMjEtZzRlMzk2ZmM6NQova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzRlMzk2
ZmMyMGRiOTZjMGFmNzEwNjAxZjA4MWZmYjQxYjBmZTYxMWMvZG1lc2cteW9jdG8ta2J1aWxk
LTMxOjIwMTQwOTA2MDIxMzA4OmkzODYtcmFuZGNvbmZpZy1yMy0wOTA1OjMuMTcuMC1yYzIt
MDAyMjEtZzRlMzk2ZmM6NQowOjQ6NCBhbGxfZ29vZDpiYWQ6YWxsX2JhZCBib290cwobWzE7
MzVtMjAxNC0wOS0wNiAwMjoxNToyOCBSRVBFQVQgQ09VTlQ6IDIwICAjIC9jL2Jvb3QtYmlz
ZWN0L2xpbnV4L29iai1iaXNlY3QvLnJlcGVhdBtbMG0KCjRlMzk2ZmMyMGRiOTZjMGFmNzEw
NjAxZjA4MWZmYjQxYjBmZTYxMWMgaXMgdGhlIGZpcnN0IGJhZCBjb21taXQKY29tbWl0IDRl
Mzk2ZmMyMGRiOTZjMGFmNzEwNjAxZjA4MWZmYjQxYjBmZTYxMWMKQXV0aG9yOiBEYW5pZWwg
VmV0dGVyIDxkYW5pZWwudmV0dGVyQGZmd2xsLmNoPgpEYXRlOiAgIEZyaSBTZXAgNSAxNDoy
Nzo0MSAyMDE0ICswMjAwCgogICAgZHJtOiBEcm9wIG1vZGVzZXQgbG9ja2luZyBmcm9tIGNy
dGMgaW5pdCBmdW5jdGlvbgogICAgCiAgICBBdCBkcml2ZXIgaW5pdCBubyBvbmUgY2FuIGFj
Y2VzcyBtb2Rlc2V0IG9iamVjdHMgYW5kIHdlJ3JlCiAgICBzaW5nbGUtdGhyZWFkZWQuIFNv
IGxvY2tpbmcgaXMganVzdCBjYXJnby1jdWx0aW5nIGhlcmUuIFdvcnNlLCB3aXRoCiAgICB0
aGUgbmV3IHd3IG11dGV4ZXMgYW5kIHd3IG11dGV4IHNsb3dwYXRoIGRlYnVnZ2luZyB0aGUg
bXV0ZXhfbG9jawogICAgbWlnaHQgYWN0dWFsbHkgZmFpbCwgYW5kIHdlIGRvbid0IGhhdmUg
dGhlIGZ1bGwtYmxvd24gd3cgcmVjb3ZlcnkKICAgIGRhbmNlLgogICAgCiAgICBXaGljaCB0
aGVuIGxlYWRzIHRvIGZpcmV3b3JrcyB3aGVuIHdlIHRyeSB0byB1bmxvY2sgdGhlIG5vdC1s
b2NrZWQKICAgIGNydGMgbG9jay4KICAgIAogICAgQW4gYXVkaXQgb2YgYWxsIHRoZSBmdW5j
dGlvbnMgY2FsbGVkIGZyb20gaGVyZSBzaG93cyB0aGF0IG5vbmUgb2YgdGhlbQogICAgY29u
dGFpbiBsb2NraW5nIGNoZWNrcywgc28gdGhlcmUncyBhbHNvIG5vIHJlYXNvbiB0byBrZWVw
IHRoZSBsb2NraW5nCiAgICBhcm91bmQganVzdCBmb3IgY29uc2lzdGVuY3kgb2YgY2FsbGVy
IGNvbnRleHRzLiBCZXNpZGVzIHRoYXQgSSBoYXZlCiAgICB0aGUgcnVsZSAoYXQgbGVhc3Qg
aW4gaTkxNSkgdGhhdCBzdWNoIHBsYWNlcyB3aGVyZSB3ZSB0YWtlIGxvY2tzIGp1c3QKICAg
IHRvIHNpbXBsaWZ5IGxvY2tpbmcgY2hlY2tzIGFuZCBub3QgZm9yIGNvcnJlY3RuZXNzIGFs
d2F5cyByZXF1aXJlIGEKICAgIGNvbW1lbnQuCiAgICAKICAgIFRoaXMgcmVncmVzc2lvbiB3
YXMgaW50cm9kdWNlZCBpbgogICAgCiAgICBjb21taXQgNTFmZDM3MWJiYWY5NDAxOGExMjIz
YjRlMmNmMjBiOTg4MGZkOTJkNAogICAgQXV0aG9yOiBSb2IgQ2xhcmsgPHJvYmRjbGFya0Bn
bWFpbC5jb20+CiAgICBEYXRlOiAgIFR1ZSBOb3YgMTkgMTI6MTA6MTIgMjAxMyAtMDUwMAog
ICAgCiAgICAgICAgZHJtOiBjb252ZXJ0IGNydGMgYW5kIGNvbm5lY3Rpb25fbXV0ZXggdG8g
d3dfbXV0ZXggKHY1KQogICAgCiAgICBCdWd6aWxsYTogaHR0cHM6Ly9idWd6aWxsYS5rZXJu
ZWwub3JnL3Nob3dfYnVnLmNnaT9pZD04MzM0MQogICAgQ2M6IFJvYiBDbGFyayA8cm9iZGNs
YXJrQGdtYWlsLmNvbT4KICAgIENjOiB0aGVsbHN0cm9tQHZtd2FyZS5jb20KICAgIENjOiBt
YWFydGVuLmxhbmtob3JzdEBjYW5vbmljYWwuY29tCiAgICBDYzogc3RhYmxlQHZnZXIua2Vy
bmVsLm9yZwogICAgU2lnbmVkLW9mZi1ieTogRGFuaWVsIFZldHRlciA8ZGFuaWVsLnZldHRl
ckBpbnRlbC5jb20+Cgo6MDQwMDAwIDA0MDAwMCA5MmYzM2UyZTMxNzU5MjhmNmQ0YjA3ZjY1
MjJjZGMzNDVjNjNjZmRiIDk0Mzg3NTI3ZTA5MjEwMjljNDU0MTY5NDA4ZmYwZTZmMzcxYjU0
ODQgTQlkcml2ZXJzCmJpc2VjdCBydW4gc3VjY2VzcwpQcmV2aW91cyBIRUFEIHBvc2l0aW9u
IHdhcyA0ZTM5NmZjLi4uIGRybTogRHJvcCBtb2Rlc2V0IGxvY2tpbmcgZnJvbSBjcnRjIGlu
aXQgZnVuY3Rpb24KSEVBRCBpcyBub3cgYXQgNWM1NTFiNS4uLiBkcm0vaTkxNS9oZG1pOiBF
bmFibGUgcGlwZSBwaXhlbCByZXBsaWNhdGlvbiBmb3IgU0QgaW50ZXJsYWNlZCBtb2Rlcwps
cyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIzLTA5
MDUvbGludXgtZGV2ZWw6ZGV2ZWwtcm9hbS1pMzg2LTIwMTQwOTA1MjEzODo1YzU1MWI1MDFh
YTg2MzdlODQ0ZWE4NWVhZWExMGY0Zjc1YWZmNzE2OmJpc2VjdC1saW51eAoKMjAxNC0wOS0w
NiAwMjoxNToyOSA1YzU1MWI1MDFhYTg2MzdlODQ0ZWE4NWVhZWExMGY0Zjc1YWZmNzE2IGNv
bXBpbGluZwpRdWV1ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVl
L2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LTVjNTUxYjUwMWFhODYzN2U4NDRlYTg1ZWFlYTEw
ZjRmNzVhZmY3MTYKQ2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1yMy0wOTA1LzVjNTUxYjUwMWFhODYzN2U4NDRlYTg1ZWFlYTEwZjRmNzVhZmY3MTYKd2Fp
dGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYt
cmFuZGNvbmZpZy1yMy0wOTA1LTVjNTUxYjUwMWFhODYzN2U4NDRlYTg1ZWFlYTEwZjRmNzVh
ZmY3MTYKd2FpdGluZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1
ZXVlL3JvYW0taTM4Ni9pMzg2LXJhbmRjb25maWctcjMtMDkwNS01YzU1MWI1MDFhYTg2Mzdl
ODQ0ZWE4NWVhZWExMGY0Zjc1YWZmNzE2Cmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25m
aWctcjMtMDkwNS81YzU1MWI1MDFhYTg2MzdlODQ0ZWE4NWVhZWExMGY0Zjc1YWZmNzE2L3Zt
bGludXotMy4xNy4wLXJjMi0wMDIyMC1nNWM1NTFiNQoKMjAxNC0wOS0wNiAwMjo1MDoyOSBk
ZXRlY3RpbmcgYm9vdCBzdGF0ZSAJMwkxOAk1NAk1Nwk1OS4uLi4uLi4uLi4uLi4uCTYwIFNV
Q0NFU1MKClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDVjNTUxYjUuLi4gZHJtL2k5MTUv
aGRtaTogRW5hYmxlIHBpcGUgcGl4ZWwgcmVwbGljYXRpb24gZm9yIFNEIGludGVybGFjZWQg
bW9kZXMKSEVBRCBpcyBub3cgYXQgNWEyYWE2NC4uLiAwZGF5IGhlYWQgZ3VhcmQgZm9yICdk
ZXZlbC1yb2FtLWkzODYtMjAxNDA5MDUyMTM4JwpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1x
dWV1ZS9rdm0vaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvbGludXgtZGV2ZWw6ZGV2ZWwtcm9h
bS1pMzg2LTIwMTQwOTA1MjEzODo1YTJhYTY0ZDRlYWZkYWVmMjc4ZmY0OTUwMjVjNTlhNWNk
OTZlYWZiOmJpc2VjdC1saW51eAogVEVTVCBGQUlMVVJFClsgICAgMS44NDgxMTFdIFtkcm1d
IHJhZGVvbiBrZXJuZWwgbW9kZXNldHRpbmcgZW5hYmxlZC4KWyAgICAxLjg0OTc5MF0gW1RU
TV0gWm9uZSAga2VybmVsOiBBdmFpbGFibGUgZ3JhcGhpY3MgbWVtb3J5OiAxMzQ4NzQga2lC
ClsgICAgMS44NTA1MzNdIFtUVE1dIEluaXRpYWxpemluZyBwb29sIGFsbG9jYXRvcgpbICAg
IDEuODUxMzg2XSBJTkZPOiB0cnlpbmcgdG8gcmVnaXN0ZXIgbm9uLXN0YXRpYyBrZXkuClsg
ICAgMS44NTE5ODddIHRoZSBjb2RlIGlzIGZpbmUgYnV0IG5lZWRzIGxvY2tkZXAgYW5ub3Rh
dGlvbi4KWyAgICAxLjg1MjAyMF0gdHVybmluZyBvZmYgdGhlIGxvY2tpbmcgY29ycmVjdG5l
c3MgdmFsaWRhdG9yLgpbICAgIDEuODUyMDIwXSBDUFU6IDAgUElEOiAxIENvbW06IHN3YXBw
ZXIvMCBOb3QgdGFpbnRlZCAzLjE3LjAtcmMzLTAxMTgwLWc1YTJhYTY0ICMxMDMwClsgICAg
MS44NTIwMjBdIEhhcmR3YXJlIG5hbWU6IFFFTVUgU3RhbmRhcmQgUEMgKGk0NDBGWCArIFBJ
SVgsIDE5OTYpLCBCSU9TIDEuNy41LTIwMTQwNTMxXzA4MzAzMC1nYW5kYWxmIDA0LzAxLzIw
MTQKWyAgICAxLjg1MjAyMF0gIDAwMDAwMDAwIDAwMDAwMDAwIGQxYzQ5YzA4IGNjOTlhZTlk
IGNkMzk4ZmY4IGQxYzQ5YzdjIGNiYzdiNzcxIGNjY2ExZTI0ClsgICAgMS44NTIwMjBdICAw
OTUwYjIwNSBkMWM0MDAwMCBkMWM0OWM5MCBjYmM3OWZjNiBkMWM0MDAwMCA1NDJjODE2YSBk
MWM0MDAwMCA1NDJjODE2YQpbICAgIDEuODUyMDIwXSAgMDAwMDAwMDUgMDFjNDAwMDAgMDAw
MDAwMDAgYzAwMTk4NDggYzAwMTk4NDggMDAwMDAwMDAgY2QzNzQ5MTggZDFjNDA1ZDAKWyAg
ICAxLjg1MjAyMF0gQ2FsbCBUcmFjZToKWyAgICAxLjg1MjAyMF0gIFs8Y2M5OWFlOWQ+XSBk
dW1wX3N0YWNrKzB4NDgvMHg2MApbICAgIDEuODUyMDIwXSAgWzxjYmM3Yjc3MT5dIF9fbG9j
a19hY3F1aXJlKzB4MWMyMS8weDFkYTAKWyAgICAxLjg1MjAyMF0gIFs8Y2JjNzlmYzY+XSA/
IF9fbG9ja19hY3F1aXJlKzB4NDc2LzB4MWRhMApbICAgIDEuODUyMDIwXSAgWzxjYmM3OGVj
Nj5dID8gX19sb2NrX2lzX2hlbGQrMHg0Ni8weDYwClsgICAgMS44NTIwMjBdICBbPGNiYzdj
MTQxPl0gbG9ja19hY3F1aXJlKzB4OTEvMHhjMApbICAgIDEuODUyMDIwXSAgWzxjYzI1ZmE1
MT5dID8gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjg1MjAyMF0gIFs8Y2M5
YThkMGM+XSBfX3d3X211dGV4X2xvY2srMHg2Yy8weDc4MApbICAgIDEuODUyMDIwXSAgWzxj
YzI1ZmE1MT5dID8gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjg1MjAyMF0g
IFs8Y2MyNWZhNTE+XSA/IGRybV9tb2Rlc2V0X2xvY2srMHgzMS8weGYwClsgICAgMS44NTIw
MjBdICBbPGNjMjVmYTUxPl0gPyBkcm1fbW9kZXNldF9sb2NrKzB4MzEvMHhmMApbICAgIDEu
ODUyMDIwXSAgWzxjYzI1ZmE1MT5dIGRybV9tb2Rlc2V0X2xvY2srMHgzMS8weGYwClsgICAg
MS44NTIwMjBdICBbPGNjMjVmY2U0Pl0gZHJtX21vZGVzZXRfbG9ja19hbGxfY3J0Y3MrMHgz
NC8weDUwClsgICAgMS44NTIwMjBdICBbPGNjMjVmZGE0Pl0gX19kcm1fbW9kZXNldF9sb2Nr
X2FsbCsweGE0LzB4ZTAKWyAgICAxLjg1MjAyMF0gIFs8Y2MyNWZkZWE+XSBkcm1fbW9kZXNl
dF9sb2NrX2FsbCsweGEvMHgzMApbICAgIDEuODUyMDIwXSAgWzxjYzI1MTJlYj5dIGRybV9l
bmNvZGVyX2luaXQrMHgxYi8weGUwClsgICAgMS44NTIwMjBdICBbPGNiZDBlZTQ4Pl0gPyBr
bWVtX2NhY2hlX2FsbG9jKzB4OTgvMHgxOTAKWyAgICAxLjg1MjAyMF0gIFs8Y2MzNjg1NTE+
XSA/IGNpcnJ1c19tb2Rlc2V0X2luaXQrMHhlMS8weDFjMApbICAgIDEuODUyMDIwXSAgWzxj
YzM2ODU3Nz5dIGNpcnJ1c19tb2Rlc2V0X2luaXQrMHgxMDcvMHgxYzAKWyAgICAxLjg1MjAy
MF0gIFs8Y2MzNjc2MTc+XSBjaXJydXNfZHJpdmVyX2xvYWQrMHg1Ny8weDEyMApbICAgIDEu
ODUyMDIwXSAgWzxjYzI0YzgxZT5dIGRybV9kZXZfcmVnaXN0ZXIrMHg5ZS8weDEwMApbICAg
IDEuODUyMDIwXSAgWzxjYzI0ZGY2MT5dIGRybV9nZXRfcGNpX2RldisweDkxLzB4MWMwClsg
ICAgMS44NTIwMjBdICBbPGNiYzc4MjhiPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHgx
MApbICAgIDEuODUyMDIwXSAgWzxjYzlhOGJlOD5dID8gbXV0ZXhfdW5sb2NrKzB4OC8weDEw
ClsgICAgMS44NTIwMjBdICBbPGNjMzY4NzljPl0gY2lycnVzX3BjaV9wcm9iZSsweGFjLzB4
ZjAKWyAgICAxLjg1MjAyMF0gIFs8Y2MxMTNlZDc+XSBwY2lfZGV2aWNlX3Byb2JlKzB4Nzcv
MHhlMApbICAgIDEuODUyMDIwXSAgWzxjYmQ3ZmZmMD5dID8gc3lzZnNfY3JlYXRlX2xpbmsr
MHgyMC8weDQwClsgICAgMS44NTIwMjBdICBbPGNjM2M0ZTEzPl0gZHJpdmVyX3Byb2JlX2Rl
dmljZSsweDczLzB4MjMwClsgICAgMS44NTIwMjBdICBbPGNjMTEzZTMyPl0gPyBwY2lfbWF0
Y2hfZGV2aWNlKzB4YzIvMHhmMApbICAgIDEuODUyMDIwXSAgWzxjYzNjNTBiMT5dIF9fZHJp
dmVyX2F0dGFjaCsweDkxLzB4YTAKWyAgICAxLjg1MjAyMF0gIFs8Y2MzYzUwMjA+XSA/IF9f
ZGV2aWNlX2F0dGFjaCsweDUwLzB4NTAKWyAgICAxLjg1MjAyMF0gIFs8Y2MzYzM3MWY+XSBi
dXNfZm9yX2VhY2hfZGV2KzB4NGYvMHg4MApbICAgIDEuODUyMDIwXSAgWzxjYzNjNTE3OT5d
IGRyaXZlcl9hdHRhY2grMHgxOS8weDIwClsgICAgMS44NTIwMjBdICBbPGNjM2M1MDIwPl0g
PyBfX2RldmljZV9hdHRhY2grMHg1MC8weDUwClsgICAgMS44NTIwMjBdICBbPGNjM2M0MDM3
Pl0gYnVzX2FkZF9kcml2ZXIrMHgxMzcvMHgxZjAKWyAgICAxLjg1MjAyMF0gIFs8Y2NlZTA2
ZmE+XSA/IG1nYWcyMDBfaW5pdCsweDIyLzB4MjIKWyAgICAxLjg1MjAyMF0gIFs8Y2NlZTA2
ZmE+XSA/IG1nYWcyMDBfaW5pdCsweDIyLzB4MjIKWyAgICAxLjg1MjAyMF0gIFs8Y2MzYzU3
ZTQ+XSBkcml2ZXJfcmVnaXN0ZXIrMHg1NC8weGUwClsgICAgMS44NTIwMjBdICBbPGNjMTE0
MTM1Pl0gX19wY2lfcmVnaXN0ZXJfZHJpdmVyKzB4NDUvMHg1MApbICAgIDEuODUyMDIwXSAg
WzxjYzI0ZTE3YT5dIGRybV9wY2lfaW5pdCsweGVhLzB4MTEwClsgICAgMS44NTIwMjBdICBb
PGNiYzc4MjhiPl0gPyB0cmFjZV9oYXJkaXJxc19vbisweGIvMHgxMApbICAgIDEuODUyMDIw
XSAgWzxjY2VlMDZmYT5dID8gbWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAgIDEuODUyMDIw
XSAgWzxjY2VlMDcxYT5dIGNpcnJ1c19pbml0KzB4MjAvMHgyMgpbICAgIDEuODUyMDIwXSAg
WzxjY2ViNGM5Mj5dIGRvX29uZV9pbml0Y2FsbCsweDE2YS8weDE3OQpbICAgIDEuODUyMDIw
XSAgWzxjYmM1NTAwMD5dID8gcGFyc2VfYXJncysweDFlMC8weDNlMApbICAgIDEuODUyMDIw
XSAgWzxjY2ViNGQ4ZT5dIGtlcm5lbF9pbml0X2ZyZWVhYmxlKzB4ZWQvMHgxNmEKWyAgICAx
Ljg1MjAyMF0gIFs8Y2M5OTUyOGI+XSBrZXJuZWxfaW5pdCsweGIvMHhlMApbICAgIDEuODUy
MDIwXSAgWzxjYzlhYzFhMT5dIHJldF9mcm9tX2tlcm5lbF90aHJlYWQrMHgyMS8weDMwClsg
ICAgMS44NTIwMjBdICBbPGNjOTk1MjgwPl0gPyByZXN0X2luaXQrMHgxMjAvMHgxMjAKWyAg
ICAxLjg4Nzg0N10gQlVHOiB1bmFibGUgdG8gaGFuZGxlIGtlcm5lbCBOVUxMIHBvaW50ZXIg
ZGVyZWZlcmVuY2UgYXQgICAobnVsbCkKWyAgICAxLjg4ODczMl0gSVA6IFs8Y2M5YThkOWE+
XSBfX3d3X211dGV4X2xvY2srMHhmYS8weDc4MApbICAgIDEuODg5NDA1XSAqcGRwdCA9IDAw
MDAwMDAwMDAwMDAwMDAgKnBkZSA9IGYwMDBmZjUzZjAwMGZmNTMgClsgICAgMS44OTAxMjBd
IE9vcHM6IDAwMDIgWyMxXSBTTVAgREVCVUdfUEFHRUFMTE9DClsgICAgMS44OTA2OTRdIENQ
VTogMCBQSUQ6IDEgQ29tbTogc3dhcHBlci8wIE5vdCB0YWludGVkIDMuMTcuMC1yYzMtMDEx
ODAtZzVhMmFhNjQgIzEwMzAKWyAgICAxLjg5MTYwNV0gSGFyZHdhcmUgbmFtZTogUUVNVSBT
dGFuZGFyZCBQQyAoaTQ0MEZYICsgUElJWCwgMTk5NiksIEJJT1MgMS43LjUtMjAxNDA1MzFf
MDgzMDMwLWdhbmRhbGYgMDQvMDEvMjAxNApbICAgIDEuODkxODI0XSB0YXNrOiBkMWM0MDAw
MCB0aTogZDFjNDgwMDAgdGFzay50aTogZDFjNDgwMDAKWyAgICAxLjg5MTgyNF0gRUlQOiAw
MDYwOls8Y2M5YThkOWE+XSBFRkxBR1M6IDAwMDEwMDgyIENQVTogMApbICAgIDEuODkxODI0
XSBFSVAgaXMgYXQgX193d19tdXRleF9sb2NrKzB4ZmEvMHg3ODAKWyAgICAxLjg5MTgyNF0g
RUFYOiAwMDAwMDAwMCBFQlg6IGNhYTVmZWMwIEVDWDogYzAwMTk4MzQgRURYOiBkMWM0OWNk
YwpbICAgIDEuODkxODI0XSBFU0k6IGMwMDE5ODEwIEVESTogYzAwMTk4MTQgRUJQOiBkMWM0
OWNmOCBFU1A6IGQxYzQ5Y2I0ClsgICAgMS44OTE4MjRdICBEUzogMDA3YiBFUzogMDA3YiBG
UzogMDBkOCBHUzogMDBlMCBTUzogMDA2OApbICAgIDEuODkxODI0XSBDUjA6IDgwMDUwMDNi
IENSMjogMDAwMDAwMDAgQ1IzOiAwY2Y2MDAwMCBDUjQ6IDAwMDAwNmIwClsgICAgMS44OTE4
MjRdIFN0YWNrOgpbICAgIDEuODkxODI0XSAgMDAwMDAwMDAgMDAwMDAwMDEgY2FhNWZlZDgg
Y2MyNWZhNTEgY2MyNWZhNTEgYzAwMTk4NDggMDAwMDAwMDEgZDFjNDAwMDAKWyAgICAxLjg5
MTgyNF0gIGNhYTVmZWMwIDAwMDAwMjQ2IGMwMDE5ODM0IDAwMDAwMDAwIDExMTExMTExIGQx
YzQ5Y2RjIGNhYTVmZWMwIGMwMDE5ODEwClsgICAgMS44OTE4MjRdICBjYWE1ZmVjMCBkMWM0
OWQwYyBjYzI1ZmE1MSBjMDAxOTgwMCBjMDAxOGMwMCBjYWE1ZmVjMCBkMWM0OWQyMCBjYzI1
ZmNlNApbICAgIDEuODkxODI0XSBDYWxsIFRyYWNlOgpbICAgIDEuODkxODI0XSAgWzxjYzI1
ZmE1MT5dID8gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjg5MTgyNF0gIFs8
Y2MyNWZhNTE+XSA/IGRybV9tb2Rlc2V0X2xvY2srMHgzMS8weGYwClsgICAgMS44OTE4MjRd
ICBbPGNjMjVmYTUxPl0gZHJtX21vZGVzZXRfbG9jaysweDMxLzB4ZjAKWyAgICAxLjg5MTgy
NF0gIFs8Y2MyNWZjZTQ+XSBkcm1fbW9kZXNldF9sb2NrX2FsbF9jcnRjcysweDM0LzB4NTAK
WyAgICAxLjg5MTgyNF0gIFs8Y2MyNWZkYTQ+XSBfX2RybV9tb2Rlc2V0X2xvY2tfYWxsKzB4
YTQvMHhlMApbICAgIDEuODkxODI0XSAgWzxjYzI1ZmRlYT5dIGRybV9tb2Rlc2V0X2xvY2tf
YWxsKzB4YS8weDMwClsgICAgMS44OTE4MjRdICBbPGNjMjUxMmViPl0gZHJtX2VuY29kZXJf
aW5pdCsweDFiLzB4ZTAKWyAgICAxLjg5MTgyNF0gIFs8Y2JkMGVlNDg+XSA/IGttZW1fY2Fj
aGVfYWxsb2MrMHg5OC8weDE5MApbICAgIDEuODkxODI0XSAgWzxjYzM2ODU1MT5dID8gY2ly
cnVzX21vZGVzZXRfaW5pdCsweGUxLzB4MWMwClsgICAgMS44OTE4MjRdICBbPGNjMzY4NTc3
Pl0gY2lycnVzX21vZGVzZXRfaW5pdCsweDEwNy8weDFjMApbICAgIDEuODkxODI0XSAgWzxj
YzM2NzYxNz5dIGNpcnJ1c19kcml2ZXJfbG9hZCsweDU3LzB4MTIwClsgICAgMS44OTE4MjRd
ICBbPGNjMjRjODFlPl0gZHJtX2Rldl9yZWdpc3RlcisweDllLzB4MTAwClsgICAgMS44OTE4
MjRdICBbPGNjMjRkZjYxPl0gZHJtX2dldF9wY2lfZGV2KzB4OTEvMHgxYzAKWyAgICAxLjg5
MTgyNF0gIFs8Y2JjNzgyOGI+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weDEwClsgICAg
MS44OTE4MjRdICBbPGNjOWE4YmU4Pl0gPyBtdXRleF91bmxvY2srMHg4LzB4MTAKWyAgICAx
Ljg5MTgyNF0gIFs8Y2MzNjg3OWM+XSBjaXJydXNfcGNpX3Byb2JlKzB4YWMvMHhmMApbICAg
IDEuODkxODI0XSAgWzxjYzExM2VkNz5dIHBjaV9kZXZpY2VfcHJvYmUrMHg3Ny8weGUwClsg
ICAgMS44OTE4MjRdICBbPGNiZDdmZmYwPl0gPyBzeXNmc19jcmVhdGVfbGluaysweDIwLzB4
NDAKWyAgICAxLjg5MTgyNF0gIFs8Y2MzYzRlMTM+XSBkcml2ZXJfcHJvYmVfZGV2aWNlKzB4
NzMvMHgyMzAKWyAgICAxLjg5MTgyNF0gIFs8Y2MxMTNlMzI+XSA/IHBjaV9tYXRjaF9kZXZp
Y2UrMHhjMi8weGYwClsgICAgMS44OTE4MjRdICBbPGNjM2M1MGIxPl0gX19kcml2ZXJfYXR0
YWNoKzB4OTEvMHhhMApbICAgIDEuODkxODI0XSAgWzxjYzNjNTAyMD5dID8gX19kZXZpY2Vf
YXR0YWNoKzB4NTAvMHg1MApbICAgIDEuODkxODI0XSAgWzxjYzNjMzcxZj5dIGJ1c19mb3Jf
ZWFjaF9kZXYrMHg0Zi8weDgwClsgICAgMS44OTE4MjRdICBbPGNjM2M1MTc5Pl0gZHJpdmVy
X2F0dGFjaCsweDE5LzB4MjAKWyAgICAxLjg5MTgyNF0gIFs8Y2MzYzUwMjA+XSA/IF9fZGV2
aWNlX2F0dGFjaCsweDUwLzB4NTAKWyAgICAxLjg5MTgyNF0gIFs8Y2MzYzQwMzc+XSBidXNf
YWRkX2RyaXZlcisweDEzNy8weDFmMApbICAgIDEuODkxODI0XSAgWzxjY2VlMDZmYT5dID8g
bWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAgIDEuODkxODI0XSAgWzxjY2VlMDZmYT5dID8g
bWdhZzIwMF9pbml0KzB4MjIvMHgyMgpbICAgIDEuODkxODI0XSAgWzxjYzNjNTdlND5dIGRy
aXZlcl9yZWdpc3RlcisweDU0LzB4ZTAKWyAgICAxLjg5MTgyNF0gIFs8Y2MxMTQxMzU+XSBf
X3BjaV9yZWdpc3Rlcl9kcml2ZXIrMHg0NS8weDUwClsgICAgMS44OTE4MjRdICBbPGNjMjRl
MTdhPl0gZHJtX3BjaV9pbml0KzB4ZWEvMHgxMTAKWyAgICAxLjg5MTgyNF0gIFs8Y2JjNzgy
OGI+XSA/IHRyYWNlX2hhcmRpcnFzX29uKzB4Yi8weDEwClsgICAgMS44OTE4MjRdICBbPGNj
ZWUwNmZhPl0gPyBtZ2FnMjAwX2luaXQrMHgyMi8weDIyClsgICAgMS44OTE4MjRdICBbPGNj
ZWUwNzFhPl0gY2lycnVzX2luaXQrMHgyMC8weDIyClsgICAgMS44OTE4MjRdICBbPGNjZWI0
YzkyPl0gZG9fb25lX2luaXRjYWxsKzB4MTZhLzB4MTc5ClsgICAgMS44OTE4MjRdICBbPGNi
YzU1MDAwPl0gPyBwYXJzZV9hcmdzKzB4MWUwLzB4M2UwClsgICAgMS44OTE4MjRdICBbPGNj
ZWI0ZDhlPl0ga2VybmVsX2luaXRfZnJlZWFibGUrMHhlZC8weDE2YQpbICAgIDEuODkxODI0
XSAgWzxjYzk5NTI4Yj5dIGtlcm5lbF9pbml0KzB4Yi8weGUwClsgICAgMS44OTE4MjRdICBb
PGNjOWFjMWExPl0gcmV0X2Zyb21fa2VybmVsX3RocmVhZCsweDIxLzB4MzAKWyAgICAxLjg5
MTgyNF0gIFs8Y2M5OTUyODA+XSA/IHJlc3RfaW5pdCsweDEyMC8weDEyMApbICAgIDEuODkx
ODI0XSBDb2RlOiA1NSBlNCA4OSBmMCBlOCA0OCBjMSAyYyBmZiA4YiA0NSBkOCA4ZCA1NSBl
NCA4YiA0OCAwNCA4OSBmMCBlOCA3OCBjMyAyYyBmZiA4YiA0NiAyOCA4ZCA0ZSAyNCA4ZCA1
NSBlNCA4OSA1NiAyOCA4OSA0ZCBlNCA4OSA0NSBlOCA8ODk+IDEwIDhiIDQ1IGQ4IDg5IDRk
IGQ0IDg5IDQ1IGVjIDhkIDc0IDI2IDAwIDhkIGJjIDI3IDAwIDAwIDAwClsgICAgMS44OTE4
MjRdIEVJUDogWzxjYzlhOGQ5YT5dIF9fd3dfbXV0ZXhfbG9jaysweGZhLzB4NzgwIFNTOkVT
UCAwMDY4OmQxYzQ5Y2I0ClsgICAgMS44OTE4MjRdIENSMjogMDAwMDAwMDAwMDAwMDAwMApb
ICAgIDEuODkxODI0XSAtLS1bIGVuZCB0cmFjZSA2NjVkMmY5MDAxYmU5MThjIF0tLS0KWyAg
ICAxLjg5MTgyNF0gS2VybmVsIHBhbmljIC0gbm90IHN5bmNpbmc6IEZhdGFsIGV4Y2VwdGlv
bgova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzVhMmFhNjRkNGVhZmRhZWYyNzhm
ZjQ5NTAyNWM1OWE1Y2Q5NmVhZmIvZG1lc2ctcXVhbnRhbC1pdmI0MS0xMjU6MjAxNDA5MDUy
MjAzMDU6aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZp
Zy1yMy0wOTA1LzVhMmFhNjRkNGVhZmRhZWYyNzhmZjQ5NTAyNWM1OWE1Y2Q5NmVhZmIvZG1l
c2ctcXVhbnRhbC1pdmI0MS01MToyMDE0MDkwNTIyMDMwNTppMzg2LXJhbmRjb25maWctcjMt
MDkwNTo6Ci9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvNWEyYWE2NGQ0ZWFmZGFl
ZjI3OGZmNDk1MDI1YzU5YTVjZDk2ZWFmYi9kbWVzZy1xdWFudGFsLWl2YjQxLTY1OjIwMTQw
OTA1MjIwMzA1OmkzODYtcmFuZGNvbmZpZy1yMy0wOTA1OjoKL2tlcm5lbC9pMzg2LXJhbmRj
b25maWctcjMtMDkwNS81YTJhYTY0ZDRlYWZkYWVmMjc4ZmY0OTUwMjVjNTlhNWNkOTZlYWZi
L2RtZXNnLXF1YW50YWwtaXZiNDEtNTM6MjAxNDA5MDUyMjAzMDU6aTM4Ni1yYW5kY29uZmln
LXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzVhMmFhNjRkNGVh
ZmRhZWYyNzhmZjQ5NTAyNWM1OWE1Y2Q5NmVhZmIvZG1lc2cteW9jdG8tdnAtNTc6MjAxNDA5
MDUyMTU4NTI6aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDU6My4xNy4wLXJjMy0wMTE4MC1nNWEy
YWE2NDoxMDMwCi9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvNWEyYWE2NGQ0ZWFm
ZGFlZjI3OGZmNDk1MDI1YzU5YTVjZDk2ZWFmYi9kbWVzZy1xdWFudGFsLWl2YjQxLTc3OjIw
MTQwOTA1MjIwMzA1OmkzODYtcmFuZGNvbmZpZy1yMy0wOTA1OjoKL2tlcm5lbC9pMzg2LXJh
bmRjb25maWctcjMtMDkwNS81YTJhYTY0ZDRlYWZkYWVmMjc4ZmY0OTUwMjVjNTlhNWNkOTZl
YWZiL2RtZXNnLXF1YW50YWwtaXZiNDEtOTc6MjAxNDA5MDUyMjAzMDU6aTM4Ni1yYW5kY29u
ZmlnLXIzLTA5MDU6Ogova2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1LzVhMmFhNjRk
NGVhZmRhZWYyNzhmZjQ5NTAyNWM1OWE1Y2Q5NmVhZmIvZG1lc2ctcXVhbnRhbC1pdmI0MS0y
NjoyMDE0MDkwNTIyMDMwNTppMzg2LXJhbmRjb25maWctcjMtMDkwNTo6Ci9rZXJuZWwvaTM4
Ni1yYW5kY29uZmlnLXIzLTA5MDUvNWEyYWE2NGQ0ZWFmZGFlZjI3OGZmNDk1MDI1YzU5YTVj
ZDk2ZWFmYi9kbWVzZy1xdWFudGFsLWl2YjQxLTQzOjIwMTQwOTA1MjIwMzA1OmkzODYtcmFu
ZGNvbmZpZy1yMy0wOTA1OjoKL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS81YTJh
YTY0ZDRlYWZkYWVmMjc4ZmY0OTUwMjVjNTlhNWNkOTZlYWZiL2RtZXNnLXF1YW50YWwtaXZi
NDEtNzoyMDE0MDkwNTIyMDMwNTppMzg2LXJhbmRjb25maWctcjMtMDkwNTo6Ci9rZXJuZWwv
aTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvNWEyYWE2NGQ0ZWFmZGFlZjI3OGZmNDk1MDI1YzU5
YTVjZDk2ZWFmYi9kbWVzZy1xdWFudGFsLWl2YjQxLTExNjoyMDE0MDkwNTIyMDMwNTppMzg2
LXJhbmRjb25maWctcjMtMDkwNTo6CjA6MTE6MTEgYWxsX2dvb2Q6YmFkOmFsbF9iYWQgYm9v
dHMKCkhFQUQgaXMgbm93IGF0IDVhMmFhNjQgMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwt
cm9hbS1pMzg2LTIwMTQwOTA1MjEzOCcKCj09PT09PT09PSBsaW51cy9tYXN0ZXIgPT09PT09
PT09CkZyb20gZ2l0Oi8vZ2l0bWlycm9yL2xpbnVzCiAgIGI3ZmVjZTEuLmZiNzYyMzQgIG1h
c3RlciAgICAgLT4gbGludXMvbWFzdGVyClByZXZpb3VzIEhFQUQgcG9zaXRpb24gd2FzIDVh
MmFhNjQuLi4gMGRheSBoZWFkIGd1YXJkIGZvciAnZGV2ZWwtcm9hbS1pMzg2LTIwMTQwOTA1
MjEzOCcKSEVBRCBpcyBub3cgYXQgZmI3NjIzNC4uLiBNZXJnZSBicmFuY2ggJ2Zvci1saW51
cycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2dl
ZXJ0L2xpbnV4LW02OGsKbHMgLWEgL2tidWlsZC10ZXN0cy9ydW4tcXVldWUva3ZtL2kzODYt
cmFuZGNvbmZpZy1yMy0wOTA1L2xpbnVzOm1hc3RlcjpmYjc2MjM0MGU1NTYzODMzMjQwNzU2
MDM5NmFlYTM4MGI3YWY5Y2JmOmJpc2VjdC1saW51eAoKMjAxNC0wOS0wNiAwMzowMDo0NiBm
Yjc2MjM0MGU1NTYzODMzMjQwNzU2MDM5NmFlYTM4MGI3YWY5Y2JmIGNvbXBpbGluZwpRdWV1
ZWQgYnVpbGQgdGFzayB0byAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNv
bmZpZy1yMy0wOTA1LWZiNzYyMzQwZTU1NjM4MzMyNDA3NTYwMzk2YWVhMzgwYjdhZjljYmYK
Q2hlY2sgZm9yIGtlcm5lbCBpbiAva2VybmVsL2kzODYtcmFuZGNvbmZpZy1yMy0wOTA1L2Zi
NzYyMzQwZTU1NjM4MzMyNDA3NTYwMzk2YWVhMzgwYjdhZjljYmYKd2FpdGluZyBmb3IgY29t
cGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL2kzODYtcmFuZGNvbmZpZy1y
My0wOTA1LWZiNzYyMzQwZTU1NjM4MzMyNDA3NTYwMzk2YWVhMzgwYjdhZjljYmYKd2FpdGlu
ZyBmb3IgY29tcGxldGlvbiBvZiAva2J1aWxkLXRlc3RzL2J1aWxkLXF1ZXVlL3JvYW0taTM4
Ni9pMzg2LXJhbmRjb25maWctcjMtMDkwNS1mYjc2MjM0MGU1NTYzODMzMjQwNzU2MDM5NmFl
YTM4MGI3YWY5Y2JmCmtlcm5lbDogL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS9m
Yjc2MjM0MGU1NTYzODMzMjQwNzU2MDM5NmFlYTM4MGI3YWY5Y2JmL3ZtbGludXotMy4xNy4w
LXJjMy0wMDEwNC1nZmI3NjIzNAoKMjAxNC0wOS0wNiAwMzowODo0OCBkZXRlY3RpbmcgYm9v
dCBzdGF0ZSAJNTguCTU5Lgk2MCBTVUNDRVNTCgoKPT09PT09PT09IG5leHQvbWFzdGVyID09
PT09PT09PQpGcm9tIGdpdDovL2dpdG1pcnJvci9uZXh0CiArIDU2ZGFjNzYuLi44NzI0YjA3
IGFrcG0gICAgICAgLT4gbmV4dC9ha3BtICAoZm9yY2VkIHVwZGF0ZSkKICsgOGY0ZmE5OC4u
LjRiMzQyMzggYWtwbS1iYXNlICAtPiBuZXh0L2FrcG0tYmFzZSAgKGZvcmNlZCB1cGRhdGUp
CiArIDlhZTQzNjMuLi45MmQ4OGNiIG1hc3RlciAgICAgLT4gbmV4dC9tYXN0ZXIgIChmb3Jj
ZWQgdXBkYXRlKQogICA3NTA1Y2VhLi5iN2ZlY2UxICBzdGFibGUgICAgIC0+IG5leHQvc3Rh
YmxlCkZyb20gZ2l0Oi8vZ2l0bWlycm9yL25leHQKICogW25ldyB0YWddICAgICAgICAgbmV4
dC0yMDE0MDkwNCAtPiBuZXh0LTIwMTQwOTA0CiAqIFtuZXcgdGFnXSAgICAgICAgIG5leHQt
MjAxNDA5MDUgLT4gbmV4dC0yMDE0MDkwNQpQcmV2aW91cyBIRUFEIHBvc2l0aW9uIHdhcyBm
Yjc2MjM0Li4uIE1lcmdlIGJyYW5jaCAnZm9yLWxpbnVzJyBvZiBnaXQ6Ly9naXQua2VybmVs
Lm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvZ2VlcnQvbGludXgtbTY4awpIRUFEIGlz
IG5vdyBhdCA5MmQ4OGNiLi4uIEFkZCBsaW51eC1uZXh0IHNwZWNpZmljIGZpbGVzIGZvciAy
MDE0MDkwNQpscyAtYSAva2J1aWxkLXRlc3RzL3J1bi1xdWV1ZS9rdm0vaTM4Ni1yYW5kY29u
ZmlnLXIzLTA5MDUvbmV4dDptYXN0ZXI6OTJkODhjYjA2OGE1ZGM2NmQ1M2VmMDE3OTk5YjI0
MTliMTI1Zjc2NDpiaXNlY3QtbGludXgKCjIwMTQtMDktMDYgMDM6MTE6MzkgOTJkODhjYjA2
OGE1ZGM2NmQ1M2VmMDE3OTk5YjI0MTliMTI1Zjc2NCBjb21waWxpbmcKUXVldWVkIGJ1aWxk
IHRhc2sgdG8gL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMt
MDkwNS05MmQ4OGNiMDY4YTVkYzY2ZDUzZWYwMTc5OTliMjQxOWIxMjVmNzY0CkNoZWNrIGZv
ciBrZXJuZWwgaW4gL2tlcm5lbC9pMzg2LXJhbmRjb25maWctcjMtMDkwNS85MmQ4OGNiMDY4
YTVkYzY2ZDUzZWYwMTc5OTliMjQxOWIxMjVmNzY0CndhaXRpbmcgZm9yIGNvbXBsZXRpb24g
b2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9pMzg2LXJhbmRjb25maWctcjMtMDkwNS05
MmQ4OGNiMDY4YTVkYzY2ZDUzZWYwMTc5OTliMjQxOWIxMjVmNzY0CndhaXRpbmcgZm9yIGNv
bXBsZXRpb24gb2YgL2tidWlsZC10ZXN0cy9idWlsZC1xdWV1ZS9yb2FtLWkzODYvaTM4Ni1y
YW5kY29uZmlnLXIzLTA5MDUtOTJkODhjYjA2OGE1ZGM2NmQ1M2VmMDE3OTk5YjI0MTliMTI1
Zjc2NAprZXJuZWw6IC9rZXJuZWwvaTM4Ni1yYW5kY29uZmlnLXIzLTA5MDUvOTJkODhjYjA2
OGE1ZGM2NmQ1M2VmMDE3OTk5YjI0MTliMTI1Zjc2NC92bWxpbnV6LTMuMTcuMC1yYzMtbmV4
dC0yMDE0MDkwNQoKMjAxNC0wOS0wNiAwNDowNjozOSBkZXRlY3RpbmcgYm9vdCBzdGF0ZSAu
CTU4Li4uLi4uLi4uLi4uLi4uLi4JNjAgU1VDQ0VTUwoK

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.17.0-rc2-00221-g4e396fc"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.17.0-rc2 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
# CONFIG_SWAP is not set
# CONFIG_SYSVIPC is not set
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_CROSS_MEMORY_ATTACH is not set
# CONFIG_FHANDLE is not set
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
# CONFIG_IRQ_DOMAIN_DEBUG is not set
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_BSD_PROCESS_ACCT is not set
CONFIG_TASKSTATS=y
# CONFIG_TASK_DELAY_ACCT is not set
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_RCU_NOCB_CPU is not set
CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=17
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_CHECKPOINT_RESTORE is not set
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_RD_LZ4 is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_EXPERT=y
CONFIG_UID16=y
# CONFIG_SGETMASK_SYSCALL is not set
# CONFIG_SYSFS_SYSCALL is not set
# CONFIG_SYSCTL_SYSCALL is not set
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
# CONFIG_EPOLL is not set
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
# CONFIG_SHMEM is not set
CONFIG_AIO=y
CONFIG_PCI_QUIRKS=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_TRUSTED_KEYRING=y
# CONFIG_PROFILING is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_JUMP_LABEL=y
# CONFIG_UPROBES is not set
# CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CC_STACKPROTECTOR=y
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_CC_STACKPROTECTOR_NONE is not set
CONFIG_CC_STACKPROTECTOR_REGULAR=y
# CONFIG_CC_STACKPROTECTOR_STRONG is not set
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_REL=y
CONFIG_CLONE_BACKWARDS=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_OLD_SIGACTION=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_CMDLINE_PARSER is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
# CONFIG_IOSCHED_CFQ is not set
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PADATA=y
CONFIG_UNINLINE_SPIN_UNLOCK=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUE_RWLOCK=y
CONFIG_QUEUE_RWLOCK=y
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_BIGSMP=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_INTEL_LPSS=y
# CONFIG_X86_32_IRIS is not set
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_PARAVIRT_SPINLOCKS is not set
# CONFIG_XEN is not set
CONFIG_KVM_GUEST=y
# CONFIG_KVM_DEBUG_FS is not set
# CONFIG_LGUEST_GUEST is not set
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_L1_CACHE_SHIFT=5
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_CYRIX_32=y
# CONFIG_CPU_SUP_AMD is not set
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
CONFIG_DMI=y
CONFIG_NR_CPUS=32
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
# CONFIG_X86_MCE is not set
CONFIG_VM86=y
CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX32=y
# CONFIG_TOSHIBA is not set
CONFIG_I8K=y
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE_INTEL_EARLY is not set
# CONFIG_MICROCODE_AMD_EARLY is not set
CONFIG_X86_MSR=y
# CONFIG_X86_CPUID is not set
# CONFIG_NOHIGHMEM is not set
# CONFIG_HIGHMEM4G is not set
CONFIG_HIGHMEM64G=y
CONFIG_VMSPLIT_3G=y
# CONFIG_VMSPLIT_2G is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
CONFIG_X86_PAE=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
# CONFIG_NUMA is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
# CONFIG_BOUNCE is not set
CONFIG_NEED_BOUNCE_POOL=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_TRANSPARENT_HUGEPAGE=y
# CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not set
CONFIG_TRANSPARENT_HUGEPAGE_MADVISE=y
# CONFIG_CLEANCACHE is not set
# CONFIG_CMA is not set
# CONFIG_ZPOOL is not set
CONFIG_ZBUD=y
CONFIG_ZSMALLOC=y
CONFIG_PGTABLE_MAPPING=y
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_HIGHPTE=y
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
# CONFIG_X86_PAT is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_X86_SMAP is not set
CONFIG_EFI=y
# CONFIG_EFI_STUB is not set
# CONFIG_SECCOMP is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
# CONFIG_KEXEC is not set
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x20000000
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
# CONFIG_PM_DEBUG is not set
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_AC=y
# CONFIG_ACPI_BATTERY is not set
# CONFIG_ACPI_BUTTON is not set
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_IPMI is not set
CONFIG_ACPI_HOTPLUG_CPU=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_DEBUG=y
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=y
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_EINJ=y
# CONFIG_ACPI_APEI_ERST_DEBUG is not set
CONFIG_SFI=y
CONFIG_X86_APM_BOOT=y
CONFIG_APM=y
CONFIG_APM_IGNORE_USER_SUSPEND=y
# CONFIG_APM_DO_ENABLE is not set
# CONFIG_APM_CPU_IDLE is not set
# CONFIG_APM_DISPLAY_BLANK is not set
CONFIG_APM_ALLOW_INTS=y

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_CPU_IDLE_GOV_MENU is not set
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_PCIEPORTBUS is not set
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_DEBUG is not set
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
CONFIG_PCI_ATS=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y

#
# PCI host controller drivers
#
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_ALIX=y
CONFIG_NET5501=y
CONFIG_GEOS=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS=y
# CONFIG_RAPIDIO_DMA_ENGINE is not set
# CONFIG_RAPIDIO_DEBUG is not set
CONFIG_RAPIDIO_ENUM_BASIC=y

#
# RapidIO Switch drivers
#
# CONFIG_RAPIDIO_TSI57X is not set
CONFIG_RAPIDIO_CPS_XX=y
CONFIG_RAPIDIO_TSI568=y
CONFIG_RAPIDIO_CPS_GEN2=y
# CONFIG_X86_SYSFB is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_COREDUMP=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_IOSF_MBI=y
CONFIG_PMC_ATOM=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=y
CONFIG_NET_KEY=y
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=y
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IP_TUNNEL=y
CONFIG_NET_IPGRE=y
# CONFIG_NET_IPGRE_BROADCAST is not set
# CONFIG_IP_MROUTE is not set
CONFIG_SYN_COOKIES=y
# CONFIG_NET_IPVTI is not set
# CONFIG_NET_UDP_TUNNEL is not set
CONFIG_INET_AH=y
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
CONFIG_INET_XFRM_MODE_TUNNEL=y
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_INET_UDP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
# CONFIG_TCP_CONG_LP is not set
# CONFIG_TCP_CONG_VENO is not set
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
# CONFIG_IPV6 is not set
# CONFIG_NETLABEL is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
# CONFIG_BRIDGE_NETFILTER is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_ACCT=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_LOG_COMMON=y
CONFIG_NF_CONNTRACK_MARK=y
# CONFIG_NF_CONNTRACK_SECMARK is not set
# CONFIG_NF_CONNTRACK_PROCFS is not set
# CONFIG_NF_CONNTRACK_EVENTS is not set
# CONFIG_NF_CONNTRACK_TIMEOUT is not set
# CONFIG_NF_CONNTRACK_TIMESTAMP is not set
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
# CONFIG_NF_CT_PROTO_UDPLITE is not set
CONFIG_NF_CONNTRACK_AMANDA=y
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
CONFIG_NF_CONNTRACK_SNMP=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NF_CT_NETLINK_TIMEOUT=y
CONFIG_NF_CT_NETLINK_HELPER=y
CONFIG_NETFILTER_NETLINK_QUEUE_CT=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_NF_NAT_PROTO_DCCP=y
CONFIG_NF_NAT_PROTO_SCTP=y
CONFIG_NF_NAT_AMANDA=y
# CONFIG_NF_NAT_FTP is not set
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_SIP=y
CONFIG_NF_NAT_TFTP=y
CONFIG_NETFILTER_SYNPROXY=y
CONFIG_NF_TABLES=y
CONFIG_NFT_EXTHDR=y
CONFIG_NFT_META=y
CONFIG_NFT_CT=y
CONFIG_NFT_RBTREE=y
# CONFIG_NFT_HASH is not set
CONFIG_NFT_COUNTER=y
CONFIG_NFT_LOG=y
CONFIG_NFT_LIMIT=y
# CONFIG_NFT_NAT is not set
CONFIG_NFT_QUEUE=y
CONFIG_NFT_REJECT=y
# CONFIG_NFT_COMPAT is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
# CONFIG_NETFILTER_XT_TARGET_AUDIT is not set
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=y
# CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
# CONFIG_NETFILTER_XT_TARGET_DSCP is not set
CONFIG_NETFILTER_XT_TARGET_HL=y
CONFIG_NETFILTER_XT_TARGET_HMARK=y
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NETMAP=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
CONFIG_NETFILTER_XT_TARGET_REDIRECT=y
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_TPROXY=y
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_BPF=y
CONFIG_NETFILTER_XT_MATCH_CGROUP=y
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
# CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
# CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=y
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_CPU=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ECN=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_HL=y
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=y
# CONFIG_NETFILTER_XT_MATCH_IPVS is not set
CONFIG_NETFILTER_XT_MATCH_L2TP=y
CONFIG_NETFILTER_XT_MATCH_LENGTH=y
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
# CONFIG_NETFILTER_XT_MATCH_MAC is not set
CONFIG_NETFILTER_XT_MATCH_MARK=y
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=y
CONFIG_NETFILTER_XT_MATCH_NFACCT=y
CONFIG_NETFILTER_XT_MATCH_OSF=y
# CONFIG_NETFILTER_XT_MATCH_OWNER is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
CONFIG_NETFILTER_XT_MATCH_QUOTA=y
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
CONFIG_NETFILTER_XT_MATCH_REALM=y
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
# CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
# CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
CONFIG_NETFILTER_XT_MATCH_TIME=y
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
# CONFIG_IP_SET is not set
CONFIG_IP_VS=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
# CONFIG_IP_VS_PROTO_AH_ESP is not set
# CONFIG_IP_VS_PROTO_ESP is not set
# CONFIG_IP_VS_PROTO_AH is not set
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
CONFIG_IP_VS_WRR=y
# CONFIG_IP_VS_LC is not set
# CONFIG_IP_VS_WLC is not set
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS application helper
#
# CONFIG_IP_VS_NFCT is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=y
CONFIG_NF_TABLES_IPV4=y
# CONFIG_NFT_CHAIN_ROUTE_IPV4 is not set
CONFIG_NFT_REJECT_IPV4=y
CONFIG_NF_TABLES_ARP=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_AH=y
# CONFIG_IP_NF_MATCH_ECN is not set
CONFIG_IP_NF_MATCH_RPFILTER=y
# CONFIG_IP_NF_MATCH_TTL is not set
# CONFIG_IP_NF_FILTER is not set
CONFIG_IP_NF_TARGET_SYNPROXY=y
CONFIG_NF_NAT_IPV4=y
# CONFIG_IP_NF_TARGET_MASQUERADE is not set
CONFIG_IP_NF_TARGET_NETMAP=y
CONFIG_IP_NF_TARGET_REDIRECT=y
CONFIG_NF_NAT_SNMP_BASIC=y
CONFIG_NF_NAT_PROTO_GRE=y
CONFIG_NF_NAT_PPTP=y
# CONFIG_NF_NAT_H323 is not set
CONFIG_IP_NF_MANGLE=y
CONFIG_IP_NF_TARGET_CLUSTERIP=y
CONFIG_IP_NF_TARGET_ECN=y
# CONFIG_IP_NF_TARGET_TTL is not set
# CONFIG_IP_NF_RAW is not set
# CONFIG_IP_NF_SECURITY is not set
CONFIG_IP_NF_ARPTABLES=y
# CONFIG_IP_NF_ARPFILTER is not set
CONFIG_IP_NF_ARP_MANGLE=y
CONFIG_NF_TABLES_BRIDGE=y
# CONFIG_NFT_BRIDGE_META is not set
CONFIG_NF_LOG_BRIDGE=y
CONFIG_BRIDGE_NF_EBTABLES=y
# CONFIG_BRIDGE_EBT_BROUTE is not set
CONFIG_BRIDGE_EBT_T_FILTER=y
CONFIG_BRIDGE_EBT_T_NAT=y
CONFIG_BRIDGE_EBT_802_3=y
CONFIG_BRIDGE_EBT_AMONG=y
# CONFIG_BRIDGE_EBT_ARP is not set
CONFIG_BRIDGE_EBT_IP=y
CONFIG_BRIDGE_EBT_LIMIT=y
CONFIG_BRIDGE_EBT_MARK=y
# CONFIG_BRIDGE_EBT_PKTTYPE is not set
CONFIG_BRIDGE_EBT_STP=y
CONFIG_BRIDGE_EBT_VLAN=y
CONFIG_BRIDGE_EBT_ARPREPLY=y
CONFIG_BRIDGE_EBT_DNAT=y
CONFIG_BRIDGE_EBT_MARK_T=y
CONFIG_BRIDGE_EBT_REDIRECT=y
# CONFIG_BRIDGE_EBT_SNAT is not set
CONFIG_BRIDGE_EBT_LOG=y
# CONFIG_BRIDGE_EBT_NFLOG is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_OBJCNT=y
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1 is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=y
# CONFIG_ATM_CLIP is not set
CONFIG_ATM_LANE=y
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=y
# CONFIG_ATM_BR2684_IPFILTER is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
# CONFIG_BRIDGE_VLAN_FILTERING is not set
CONFIG_VLAN_8021Q=y
# CONFIG_VLAN_8021Q_GVRP is not set
# CONFIG_VLAN_8021Q_MVRP is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
# CONFIG_DEV_APPLETALK is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
CONFIG_PHONET=y
CONFIG_IEEE802154=y
CONFIG_MAC802154=y
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
# CONFIG_NET_SCH_CBQ is not set
# CONFIG_NET_SCH_HTB is not set
CONFIG_NET_SCH_HFSC=y
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=y
CONFIG_NET_SCH_MULTIQ=y
# CONFIG_NET_SCH_RED is not set
# CONFIG_NET_SCH_SFB is not set
CONFIG_NET_SCH_SFQ=y
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
CONFIG_NET_SCH_GRED=y
CONFIG_NET_SCH_DSMARK=y
CONFIG_NET_SCH_NETEM=y
CONFIG_NET_SCH_DRR=y
CONFIG_NET_SCH_MQPRIO=y
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
CONFIG_NET_SCH_FQ_CODEL=y
CONFIG_NET_SCH_FQ=y
# CONFIG_NET_SCH_HHF is not set
CONFIG_NET_SCH_PIE=y
# CONFIG_NET_SCH_INGRESS is not set
# CONFIG_NET_SCH_PLUG is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
# CONFIG_NET_CLS_ROUTE4 is not set
CONFIG_NET_CLS_FW=y
CONFIG_NET_CLS_U32=y
# CONFIG_CLS_U32_PERF is not set
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=y
# CONFIG_NET_CLS_RSVP6 is not set
CONFIG_NET_CLS_FLOW=y
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=y
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=y
CONFIG_NET_ACT_IPT=y
CONFIG_NET_ACT_NAT=y
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_ACT_CSUM=y
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
# CONFIG_DCB is not set
# CONFIG_DNS_RESOLVER is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=y
# CONFIG_OPENVSWITCH_GRE is not set
CONFIG_VSOCKETS=y
# CONFIG_NETLINK_MMAP is not set
CONFIG_NETLINK_DIAG=y
CONFIG_NET_MPLS_GSO=y
CONFIG_HSR=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
CONFIG_IRDA=y

#
# IrDA protocols
#
CONFIG_IRLAN=y
# CONFIG_IRCOMM is not set
CONFIG_IRDA_ULTRA=y

#
# IrDA options
#
# CONFIG_IRDA_CACHE_LAST_LSAP is not set
CONFIG_IRDA_FAST_RR=y
CONFIG_IRDA_DEBUG=y

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
# CONFIG_IRTTY_SIR is not set

#
# Dongle support
#

#
# FIR device drivers
#
CONFIG_NSC_FIR=y
# CONFIG_WINBOND_FIR is not set
# CONFIG_TOSHIBA_FIR is not set
# CONFIG_SMC_IRCC_FIR is not set
# CONFIG_ALI_FIR is not set
# CONFIG_VLSI_FIR is not set
# CONFIG_VIA_FIR is not set
CONFIG_BT=y
# CONFIG_BT_RFCOMM is not set
CONFIG_BT_BNEP=y
# CONFIG_BT_BNEP_MC_FILTER is not set
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_HIDP=y

#
# Bluetooth device drivers
#
# CONFIG_BT_HCIUART is not set
# CONFIG_BT_HCIVHCI is not set
CONFIG_BT_MRVL=y
# CONFIG_AF_RXRPC is not set
CONFIG_WIRELESS=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_REG_DEBUG is not set
CONFIG_CFG80211_CERTIFICATION_ONUS=y
CONFIG_CFG80211_REG_CELLULAR_HINTS=y
# CONFIG_CFG80211_REG_RELAX_NO_IR is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
# CONFIG_LIB80211 is not set
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
CONFIG_MAC80211_MESH=y
# CONFIG_MAC80211_LEDS is not set
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_MESSAGE_TRACING=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_NOINLINE is not set
# CONFIG_MAC80211_VERBOSE_DEBUG is not set
# CONFIG_MAC80211_MLME_DEBUG is not set
CONFIG_MAC80211_STA_DEBUG=y
CONFIG_MAC80211_HT_DEBUG=y
# CONFIG_MAC80211_IBSS_DEBUG is not set
# CONFIG_MAC80211_PS_DEBUG is not set
# CONFIG_MAC80211_MPL_DEBUG is not set
CONFIG_MAC80211_MPATH_DEBUG=y
# CONFIG_MAC80211_MHWMP_DEBUG is not set
# CONFIG_MAC80211_MESH_SYNC_DEBUG is not set
CONFIG_MAC80211_MESH_CSA_DEBUG=y
# CONFIG_MAC80211_MESH_PS_DEBUG is not set
CONFIG_MAC80211_TDLS_DEBUG=y
# CONFIG_MAC80211_DEBUG_COUNTERS is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_INPUT=y
CONFIG_RFKILL_REGULATOR=y
CONFIG_RFKILL_GPIO=y
CONFIG_NET_9P=y
# CONFIG_NET_9P_VIRTIO is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
# CONFIG_CAIF_NETDEV is not set
# CONFIG_CAIF_USB is not set
# CONFIG_CEPH_LIB is not set
CONFIG_NFC=y
# CONFIG_NFC_DIGITAL is not set
CONFIG_NFC_NCI=y
# CONFIG_NFC_NCI_SPI is not set
# CONFIG_NFC_HCI is not set

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_SIM is not set
CONFIG_NFC_MRVL=y
# CONFIG_NFC_ST21NFCB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
# CONFIG_UEVENT_HELPER is not set
# CONFIG_DEVTMPFS is not set
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_MMIO=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_FENCE_TRACE=y

#
# Bus devices
#
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_MTD is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
CONFIG_PARPORT_PC_FIFO=y
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_NULL_BLK is not set
CONFIG_BLK_DEV_FD=y
# CONFIG_PARIDE is not set
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_ZRAM is not set
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_NVME=y
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_HD=y
# CONFIG_BLK_DEV_RBD is not set
CONFIG_BLK_DEV_RSXX=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_DUMMY_IRQ=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_SGI_IOC4 is not set
CONFIG_TIFM_CORE=y
CONFIG_TIFM_7XX1=y
# CONFIG_ICS932S401 is not set
# CONFIG_ENCLOSURE_SERVICES is not set
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
# CONFIG_CS5535_CLOCK_EVENT_SRC is not set
CONFIG_HP_ILO=y
CONFIG_APDS9802ALS=y
CONFIG_ISL29003=y
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_SENSORS_BH1780 is not set
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
# CONFIG_TI_DAC7512 is not set
# CONFIG_VMWARE_BALLOON is not set
# CONFIG_BMP085_I2C is not set
# CONFIG_BMP085_SPI is not set
CONFIG_PCH_PHUB=y
CONFIG_USB_SWITCH_FSA9480=y
CONFIG_LATTICE_ECP3_CONFIG=y
# CONFIG_SRAM is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
# CONFIG_EEPROM_AT24 is not set
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_EEPROM_93XX46=y
# CONFIG_CB710_CORE is not set

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_INTEL_MEI=y
CONFIG_INTEL_MEI_ME=y
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_VMWARE_VMCI is not set

#
# Intel MIC Bus Driver
#

#
# Intel MIC Host Driver
#

#
# Intel MIC Card Driver
#
CONFIG_ECHO=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# CONFIG_SCSI_OSD_INITIATOR is not set
# CONFIG_ATA is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
CONFIG_FUSION_SAS=y
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
CONFIG_I2O_BLOCK=y
CONFIG_I2O_SCSI=y
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
# CONFIG_NETDEVICES is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TC3589X is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_CROS_EC is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
CONFIG_MOUSE_SERIAL=y
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
CONFIG_MOUSE_CYAPA=y
# CONFIG_MOUSE_VSXXXAA is not set
CONFIG_MOUSE_GPIO=y
CONFIG_MOUSE_SYNAPTICS_I2C=y
# CONFIG_MOUSE_SYNAPTICS_USB is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_SERIAL_WACOM4=y
# CONFIG_INPUT_TOUCHSCREEN is not set
CONFIG_INPUT_MISC=y
CONFIG_INPUT_88PM860X_ONKEY=y
# CONFIG_INPUT_88PM80X_ONKEY is not set
# CONFIG_INPUT_AD714X is not set
CONFIG_INPUT_BMA150=y
CONFIG_INPUT_MC13783_PWRBUTTON=y
CONFIG_INPUT_MMA8450=y
CONFIG_INPUT_MPU3050=y
CONFIG_INPUT_APANEL=y
CONFIG_INPUT_GP2A=y
CONFIG_INPUT_GPIO_BEEPER=y
CONFIG_INPUT_GPIO_TILT_POLLED=y
CONFIG_INPUT_WISTRON_BTNS=y
CONFIG_INPUT_ATLAS_BTNS=y
# CONFIG_INPUT_ATI_REMOTE2 is not set
# CONFIG_INPUT_KEYSPAN_REMOTE is not set
# CONFIG_INPUT_KXTJ9 is not set
# CONFIG_INPUT_POWERMATE is not set
# CONFIG_INPUT_YEALINK is not set
# CONFIG_INPUT_CM109 is not set
# CONFIG_INPUT_RETU_PWRBUTTON is not set
CONFIG_INPUT_TWL6040_VIBRA=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_PWM_BEEPER=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y
CONFIG_INPUT_DA9052_ONKEY=y
# CONFIG_INPUT_DA9055_ONKEY is not set
CONFIG_INPUT_WM831X_ON=y
CONFIG_INPUT_ADXL34X=y
# CONFIG_INPUT_ADXL34X_I2C is not set
# CONFIG_INPUT_ADXL34X_SPI is not set
# CONFIG_INPUT_CMA3000 is not set
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=y
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_TTY=y
# CONFIG_VT is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_TRACE_SINK is not set
CONFIG_DEVKMEM=y

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
# CONFIG_SERIAL_8250_DW is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_MEN_Z135 is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
# CONFIG_VIRTIO_CONSOLE is not set
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
CONFIG_IPMI_SI=y
CONFIG_IPMI_SI_PROBE_DEFAULTS=y
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
CONFIG_SONYPI=y
# CONFIG_MWAVE is not set
CONFIG_SCx200_GPIO=y
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_RAW_DRIVER is not set
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=y
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
CONFIG_TCG_TIS_I2C_ATMEL=y
CONFIG_TCG_TIS_I2C_INFINEON=y
# CONFIG_TCG_TIS_I2C_NUVOTON is not set
CONFIG_TCG_NSC=y
CONFIG_TCG_ATMEL=y
# CONFIG_TCG_INFINEON is not set
CONFIG_TCG_ST33_I2C=y
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y

#
# I2C support
#
CONFIG_I2C=y
# CONFIG_ACPI_I2C_OPREGION is not set
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
CONFIG_I2C_MUX_PCA9541=y
CONFIG_I2C_MUX_PCA954x=y
CONFIG_I2C_MUX_PINCTRL=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
CONFIG_I2C_ISCH=y
# CONFIG_I2C_ISMT is not set
CONFIG_I2C_PIIX4=y
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_NFORCE2_S4985=y
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
CONFIG_I2C_SIS96X=y
CONFIG_I2C_VIA=y
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
CONFIG_I2C_SCMI=y

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_CBUS_GPIO=y
CONFIG_I2C_DESIGNWARE_CORE=y
CONFIG_I2C_DESIGNWARE_PLATFORM=y
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
# CONFIG_I2C_GPIO is not set
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_PARPORT is not set
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_CROS_EC_TUNNEL is not set
CONFIG_SCx200_ACB=y
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_ALTERA=y
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_OC_TINY=y
# CONFIG_SPI_PXA2XX is not set
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
CONFIG_SPI_TOPCLIFF_PCH=y
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y
# CONFIG_SPMI is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set
# CONFIG_NTP_PPS is not set

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=y
# CONFIG_PPS_CLIENT_LDISC is not set
CONFIG_PPS_CLIENT_PARPORT=y
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=y
CONFIG_PINCTRL=y

#
# Pin controllers
#
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_BAYTRAIL=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_DEVRES=y
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_DA9052=y
CONFIG_GPIO_DA9055=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO drivers:
#
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_F7188X=y
CONFIG_GPIO_SCH311X=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
CONFIG_GPIO_VX855=y
# CONFIG_GPIO_LYNXPOINT is not set

#
# I2C GPIO expanders:
#
CONFIG_GPIO_ARIZONA=y
CONFIG_GPIO_LP3943=y
CONFIG_GPIO_MAX7300=y
CONFIG_GPIO_MAX732X=y
# CONFIG_GPIO_MAX732X_IRQ is not set
CONFIG_GPIO_PCA953X=y
# CONFIG_GPIO_PCA953X_IRQ is not set
CONFIG_GPIO_PCF857X=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_TC3589X is not set
# CONFIG_GPIO_TPS65912 is not set
# CONFIG_GPIO_TWL6040 is not set
CONFIG_GPIO_WM831X=y
# CONFIG_GPIO_WM8350 is not set
# CONFIG_GPIO_WM8994 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
CONFIG_GPIO_CS5535=y
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_AMD8111=y
# CONFIG_GPIO_INTEL_MID is not set
CONFIG_GPIO_PCH=y
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_TIMBERDALE is not set
# CONFIG_GPIO_RDC321X is not set

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# LPC GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_GPIO_JANZ_TTL=y
# CONFIG_GPIO_TPS6586X is not set
CONFIG_GPIO_TPS65910=y

#
# USB GPIO expanders:
#
CONFIG_W1=y
# CONFIG_W1_CON is not set

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2482=y
CONFIG_W1_MASTER_DS1WM=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
# CONFIG_W1_SLAVE_DS2408 is not set
# CONFIG_W1_SLAVE_DS2413 is not set
CONFIG_W1_SLAVE_DS2406=y
CONFIG_W1_SLAVE_DS2423=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
# CONFIG_W1_SLAVE_DS2433_CRC is not set
# CONFIG_W1_SLAVE_DS2760 is not set
CONFIG_W1_SLAVE_DS2780=y
CONFIG_W1_SLAVE_DS2781=y
CONFIG_W1_SLAVE_DS28E04=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
CONFIG_PDA_POWER=y
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_WM8350_POWER=y
# CONFIG_TEST_POWER is not set
CONFIG_BATTERY_88PM860X=y
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_SBS=y
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
CONFIG_BATTERY_MAX17040=y
CONFIG_BATTERY_MAX17042=y
CONFIG_CHARGER_88PM860X=y
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
CONFIG_CHARGER_GPIO=y
CONFIG_CHARGER_MANAGER=y
# CONFIG_CHARGER_MAX14577 is not set
CONFIG_CHARGER_MAX8998=y
CONFIG_CHARGER_BQ2415X=y
# CONFIG_CHARGER_BQ24190 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_SMB347 is not set
CONFIG_CHARGER_TPS65090=y
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
CONFIG_SENSORS_AD7314=y
# CONFIG_SENSORS_AD7414 is not set
CONFIG_SENSORS_AD7418=y
CONFIG_SENSORS_ADM1021=y
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
CONFIG_SENSORS_ADM1031=y
CONFIG_SENSORS_ADM9240=y
CONFIG_SENSORS_ADT7X10=y
CONFIG_SENSORS_ADT7310=y
CONFIG_SENSORS_ADT7410=y
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
CONFIG_SENSORS_ASC7621=y
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_APPLESMC=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
CONFIG_SENSORS_DS620=y
CONFIG_SENSORS_DS1621=y
CONFIG_SENSORS_DA9052_ADC=y
CONFIG_SENSORS_DA9055=y
# CONFIG_SENSORS_I5K_AMB is not set
CONFIG_SENSORS_F71805F=y
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
CONFIG_SENSORS_MC13783_ADC=y
CONFIG_SENSORS_FSCHMD=y
CONFIG_SENSORS_GL518SM=y
CONFIG_SENSORS_GL520SM=y
CONFIG_SENSORS_G760A=y
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_IBMAEM is not set
CONFIG_SENSORS_IBMPEX=y
CONFIG_SENSORS_CORETEMP=y
CONFIG_SENSORS_IT87=y
# CONFIG_SENSORS_JC42 is not set
CONFIG_SENSORS_POWR1220=y
CONFIG_SENSORS_LINEAGE=y
CONFIG_SENSORS_LTC2945=y
# CONFIG_SENSORS_LTC4151 is not set
CONFIG_SENSORS_LTC4215=y
CONFIG_SENSORS_LTC4222=y
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_MAX1111=y
CONFIG_SENSORS_MAX16065=y
CONFIG_SENSORS_MAX1619=y
CONFIG_SENSORS_MAX1668=y
CONFIG_SENSORS_MAX197=y
CONFIG_SENSORS_MAX6639=y
# CONFIG_SENSORS_MAX6642 is not set
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MAX6697=y
CONFIG_SENSORS_HTU21=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_ADCXX=y
CONFIG_SENSORS_LM63=y
CONFIG_SENSORS_LM70=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
CONFIG_SENSORS_LM80=y
CONFIG_SENSORS_LM83=y
# CONFIG_SENSORS_LM85 is not set
CONFIG_SENSORS_LM87=y
CONFIG_SENSORS_LM90=y
CONFIG_SENSORS_LM92=y
CONFIG_SENSORS_LM93=y
CONFIG_SENSORS_LM95234=y
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_LM95245 is not set
# CONFIG_SENSORS_PC87360 is not set
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_NCT6683=y
# CONFIG_SENSORS_NCT6775 is not set
CONFIG_SENSORS_PCF8591=y
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT15 is not set
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=y
# CONFIG_SENSORS_DME1737 is not set
CONFIG_SENSORS_EMC1403=y
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
CONFIG_SENSORS_SMSC47M1=y
CONFIG_SENSORS_SMSC47M192=y
CONFIG_SENSORS_SMSC47B397=y
CONFIG_SENSORS_SCH56XX_COMMON=y
CONFIG_SENSORS_SCH5627=y
CONFIG_SENSORS_SCH5636=y
# CONFIG_SENSORS_SMM665 is not set
CONFIG_SENSORS_ADC128D818=y
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=y
# CONFIG_SENSORS_ADS7871 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_INA209 is not set
CONFIG_SENSORS_INA2XX=y
CONFIG_SENSORS_THMC50=y
CONFIG_SENSORS_TMP102=y
CONFIG_SENSORS_TMP103=y
# CONFIG_SENSORS_TMP401 is not set
CONFIG_SENSORS_TMP421=y
CONFIG_SENSORS_VIA_CPUTEMP=y
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
CONFIG_SENSORS_VT8231=y
CONFIG_SENSORS_W83781D=y
CONFIG_SENSORS_W83791D=y
# CONFIG_SENSORS_W83792D is not set
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
CONFIG_SENSORS_W83627HF=y
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_WM8350 is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=y
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_HWMON is not set
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_GOV_STEP_WISE is not set
# CONFIG_THERMAL_GOV_USER_SPACE is not set
CONFIG_THERMAL_EMULATION=y
# CONFIG_ACPI_INT3403_THERMAL is not set
CONFIG_INTEL_SOC_DTS_THERMAL=y

#
# Texas Instruments thermal drivers
#
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
CONFIG_WATCHDOG_NOWAYOUT=y

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=y
# CONFIG_DA9055_WATCHDOG is not set
CONFIG_WM831X_WATCHDOG=y
CONFIG_WM8350_WATCHDOG=y
CONFIG_XILINX_WATCHDOG=y
CONFIG_DW_WATCHDOG=y
# CONFIG_RETU_WATCHDOG is not set
CONFIG_ACQUIRE_WDT=y
CONFIG_ADVANTECH_WDT=y
CONFIG_ALIM1535_WDT=y
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
# CONFIG_SP5100_TCO is not set
CONFIG_GEODE_WDT=y
CONFIG_SBC_FITPC2_WATCHDOG=y
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=y
CONFIG_IBMASR=y
CONFIG_WAFER_WDT=y
# CONFIG_I6300ESB_WDT is not set
CONFIG_IE6XX_WDT=y
# CONFIG_ITCO_WDT is not set
CONFIG_IT8712F_WDT=y
CONFIG_IT87_WDT=y
CONFIG_HP_WATCHDOG=y
CONFIG_HPWDT_NMI_DECODING=y
CONFIG_SC1200_WDT=y
# CONFIG_SCx200_WDT is not set
CONFIG_PC87413_WDT=y
# CONFIG_NV_TCO is not set
# CONFIG_60XX_WDT is not set
CONFIG_SBC8360_WDT=y
# CONFIG_SBC7240_WDT is not set
CONFIG_CPU5_WDT=y
CONFIG_SMSC_SCH311X_WDT=y
CONFIG_SMSC37B787_WDT=y
# CONFIG_VIA_WDT is not set
CONFIG_W83627HF_WDT=y
CONFIG_W83877F_WDT=y
# CONFIG_W83977F_WDT is not set
CONFIG_MACHZ_WDT=y
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_MEN_A21_WDT=y

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=y
CONFIG_WDTPCI=y
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
# CONFIG_SSB_SILENT is not set
CONFIG_SSB_DEBUG=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_CS5535=y
CONFIG_MFD_AS3711=y
# CONFIG_PMIC_ADP5520 is not set
CONFIG_MFD_AAT2870_CORE=y
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_AXP20X is not set
CONFIG_MFD_CROS_EC=y
CONFIG_MFD_CROS_EC_I2C=y
# CONFIG_PMIC_DA903X is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_MFD_DA9055=y
# CONFIG_MFD_DA9063 is not set
CONFIG_MFD_MC13XXX=y
# CONFIG_MFD_MC13XXX_SPI is not set
CONFIG_MFD_MC13XXX_I2C=y
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
CONFIG_LPC_ICH=y
CONFIG_LPC_SCH=y
# CONFIG_INTEL_SOC_PMIC is not set
CONFIG_MFD_JANZ_CMODIO=y
# CONFIG_MFD_KEMPLD is not set
CONFIG_MFD_88PM800=y
# CONFIG_MFD_88PM805 is not set
CONFIG_MFD_88PM860X=y
CONFIG_MFD_MAX14577=y
# CONFIG_MFD_MAX77686 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
CONFIG_MFD_MAX8998=y
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_RETU=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_RDC321X=y
CONFIG_MFD_RTSX_PCI=y
# CONFIG_MFD_RC5T583 is not set
CONFIG_MFD_SEC_CORE=y
CONFIG_MFD_SI476X_CORE=y
CONFIG_MFD_SM501=y
# CONFIG_MFD_SM501_GPIO is not set
CONFIG_MFD_SMSC=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
# CONFIG_MFD_SYSCON is not set
CONFIG_MFD_TI_AM335X_TSCADC=y
CONFIG_MFD_LP3943=y
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_PALMAS is not set
CONFIG_TPS6105X=y
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65090=y
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65218 is not set
CONFIG_MFD_TPS6586X=y
CONFIG_MFD_TPS65910=y
CONFIG_MFD_TPS65912=y
# CONFIG_MFD_TPS65912_I2C is not set
CONFIG_MFD_TPS65912_SPI=y
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
CONFIG_TWL6040_CORE=y
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
CONFIG_MFD_TIMBERDALE=y
CONFIG_MFD_TC3589X=y
# CONFIG_MFD_TMIO is not set
CONFIG_MFD_VX855=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=y
# CONFIG_MFD_ARIZONA_SPI is not set
CONFIG_MFD_WM5102=y
# CONFIG_MFD_WM5110 is not set
# CONFIG_MFD_WM8997 is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
# CONFIG_MFD_WM831X_I2C is not set
CONFIG_MFD_WM831X_SPI=y
CONFIG_MFD_WM8350=y
CONFIG_MFD_WM8350_I2C=y
CONFIG_MFD_WM8994=y
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_FIXED_VOLTAGE=y
CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
CONFIG_REGULATOR_USERSPACE_CONSUMER=y
CONFIG_REGULATOR_88PM800=y
CONFIG_REGULATOR_88PM8607=y
CONFIG_REGULATOR_ACT8865=y
CONFIG_REGULATOR_AD5398=y
CONFIG_REGULATOR_AAT2870=y
CONFIG_REGULATOR_AS3711=y
# CONFIG_REGULATOR_DA9052 is not set
CONFIG_REGULATOR_DA9055=y
CONFIG_REGULATOR_DA9210=y
# CONFIG_REGULATOR_DA9211 is not set
CONFIG_REGULATOR_FAN53555=y
CONFIG_REGULATOR_GPIO=y
CONFIG_REGULATOR_ISL6271A=y
# CONFIG_REGULATOR_LP3971 is not set
CONFIG_REGULATOR_LP3972=y
# CONFIG_REGULATOR_LP872X is not set
# CONFIG_REGULATOR_LP8755 is not set
CONFIG_REGULATOR_LTC3589=y
CONFIG_REGULATOR_MAX14577=y
CONFIG_REGULATOR_MAX1586=y
CONFIG_REGULATOR_MAX8649=y
CONFIG_REGULATOR_MAX8660=y
CONFIG_REGULATOR_MAX8952=y
CONFIG_REGULATOR_MAX8973=y
CONFIG_REGULATOR_MAX8998=y
CONFIG_REGULATOR_MC13XXX_CORE=y
CONFIG_REGULATOR_MC13783=y
CONFIG_REGULATOR_MC13892=y
CONFIG_REGULATOR_PFUZE100=y
CONFIG_REGULATOR_S2MPA01=y
CONFIG_REGULATOR_S2MPS11=y
CONFIG_REGULATOR_S5M8767=y
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=y
CONFIG_REGULATOR_TPS62360=y
CONFIG_REGULATOR_TPS65023=y
CONFIG_REGULATOR_TPS6507X=y
CONFIG_REGULATOR_TPS65090=y
CONFIG_REGULATOR_TPS65217=y
CONFIG_REGULATOR_TPS6524X=y
CONFIG_REGULATOR_TPS6586X=y
# CONFIG_REGULATOR_TPS65910 is not set
# CONFIG_REGULATOR_TPS65912 is not set
CONFIG_REGULATOR_WM831X=y
CONFIG_REGULATOR_WM8350=y
# CONFIG_REGULATOR_WM8994 is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set

#
# Direct Rendering Manager
#
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_KMS_FB_HELPER=y
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
CONFIG_DRM_TTM=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I2C_NXP_TDA998X=y
CONFIG_DRM_PTN3460=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_UMS is not set
# CONFIG_DRM_NOUVEAU is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_DRM_VMWGFX=y
# CONFIG_DRM_VMWGFX_FBCON is not set
CONFIG_DRM_GMA500=y
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_DRM_QXL=y
CONFIG_DRM_BOCHS=y

#
# Frame buffer Devices
#
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_CMDLINE=y
CONFIG_FB_DDC=y
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
CONFIG_FB_FOREIGN_ENDIAN=y
# CONFIG_FB_BOTH_ENDIAN is not set
# CONFIG_FB_BIG_ENDIAN is not set
CONFIG_FB_LITTLE_ENDIAN=y
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
CONFIG_FB_CYBER2000=y
# CONFIG_FB_CYBER2000_DDC is not set
# CONFIG_FB_ARC is not set
CONFIG_FB_ASILIANT=y
CONFIG_FB_IMSTT=y
# CONFIG_FB_VGA16 is not set
CONFIG_FB_UVESA=y
# CONFIG_FB_VESA is not set
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_OPENCORES=y
CONFIG_FB_S1D13XXX=y
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I740=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_MATROX=y
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
CONFIG_FB_MATROX_MAVEN=y
CONFIG_FB_RADEON=y
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=y
# CONFIG_FB_ATY_CT is not set
CONFIG_FB_ATY_GX=y
# CONFIG_FB_ATY_BACKLIGHT is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
CONFIG_FB_SIS=y
CONFIG_FB_SIS_300=y
# CONFIG_FB_SIS_315 is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
# CONFIG_FB_3DFX_I2C is not set
CONFIG_FB_VOODOO1=y
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
CONFIG_FB_PM3=y
# CONFIG_FB_CARMINE is not set
CONFIG_FB_GEODE=y
CONFIG_FB_GEODE_LX=y
CONFIG_FB_GEODE_GX=y
# CONFIG_FB_GEODE_GX1 is not set
CONFIG_FB_SM501=y
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=y
CONFIG_FB_AUO_K190X=y
# CONFIG_FB_AUO_K1900 is not set
# CONFIG_FB_AUO_K1901 is not set
CONFIG_FB_SIMPLE=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_L4F00242T03 is not set
CONFIG_LCD_LMS283GF05=y
CONFIG_LCD_LTV350QV=y
CONFIG_LCD_ILI922X=y
CONFIG_LCD_ILI9320=y
CONFIG_LCD_TDO24M=y
CONFIG_LCD_VGG2432A4=y
CONFIG_LCD_PLATFORM=y
CONFIG_LCD_S6E63M0=y
CONFIG_LCD_LD9040=y
CONFIG_LCD_AMS369FG06=y
CONFIG_LCD_LMS501KF03=y
# CONFIG_LCD_HX8357 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_DA9052=y
CONFIG_BACKLIGHT_APPLE=y
# CONFIG_BACKLIGHT_SAHARA is not set
CONFIG_BACKLIGHT_WM831X=y
# CONFIG_BACKLIGHT_ADP8860 is not set
CONFIG_BACKLIGHT_ADP8870=y
# CONFIG_BACKLIGHT_88PM860X is not set
# CONFIG_BACKLIGHT_AAT2870 is not set
CONFIG_BACKLIGHT_LM3630A=y
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=y
# CONFIG_BACKLIGHT_OT200 is not set
CONFIG_BACKLIGHT_TPS65217=y
CONFIG_BACKLIGHT_AS3711=y
CONFIG_BACKLIGHT_GPIO=y
CONFIG_BACKLIGHT_LV5207LP=y
CONFIG_BACKLIGHT_BD6107=y
CONFIG_VGASTATE=y
CONFIG_HDMI=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
# CONFIG_SOUND_OSS_CORE is not set
# CONFIG_SND is not set
# CONFIG_SOUND_PRIME is not set

#
# HID support
#
CONFIG_HID=y
# CONFIG_HID_BATTERY_STRENGTH is not set
CONFIG_HIDRAW=y
# CONFIG_UHID is not set
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
CONFIG_HID_ACRUX=y
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_AUREAL=y
CONFIG_HID_BELKIN=y
CONFIG_HID_CHERRY=y
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=y
# CONFIG_DRAGONRISE_FF is not set
CONFIG_HID_EMS_FF=y
# CONFIG_HID_ELECOM is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_KEYTOUCH is not set
CONFIG_HID_KYE=y
CONFIG_HID_UCLOGIC=y
CONFIG_HID_WALTOP=y
CONFIG_HID_GYRATION=y
# CONFIG_HID_ICADE is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=y
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=y
# CONFIG_HID_MULTITOUCH is not set
CONFIG_HID_ORTEK=y
# CONFIG_HID_PANTHERLORD is not set
CONFIG_HID_PETALYNX=y
# CONFIG_HID_PICOLCD is not set
CONFIG_HID_PRIMAX=y
CONFIG_HID_SAITEK=y
CONFIG_HID_SAMSUNG=y
CONFIG_HID_SPEEDLINK=y
CONFIG_HID_STEELSERIES=y
CONFIG_HID_SUNPLUS=y
CONFIG_HID_RMI=y
CONFIG_HID_GREENASIA=y
CONFIG_GREENASIA_FF=y
# CONFIG_HID_SMARTJOYPLUS is not set
CONFIG_HID_TIVO=y
CONFIG_HID_TOPSEED=y
# CONFIG_HID_THINGM is not set
CONFIG_HID_THRUSTMASTER=y
# CONFIG_THRUSTMASTER_FF is not set
CONFIG_HID_WACOM=y
CONFIG_HID_WIIMOTE=y
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=y
CONFIG_ZEROPLUS_FF=y
CONFIG_HID_ZYDACRON=y
# CONFIG_HID_SENSOR_HUB is not set

#
# I2C HID support
#
CONFIG_I2C_HID=y
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set

#
# USB port drivers
#

#
# USB Physical Layer drivers
#
# CONFIG_USB_PHY is not set
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_SAMSUNG_USB2PHY is not set
# CONFIG_SAMSUNG_USB3PHY is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_TAHVO_USB is not set
# CONFIG_USB_GADGET is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
CONFIG_LEDS_88PM860X=y
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_LM3642=y
CONFIG_LEDS_NET48XX=y
CONFIG_LEDS_WRAP=y
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
CONFIG_LEDS_LP3944=y
CONFIG_LEDS_LP55XX_COMMON=y
CONFIG_LEDS_LP5521=y
# CONFIG_LEDS_LP5523 is not set
CONFIG_LEDS_LP5562=y
CONFIG_LEDS_LP8501=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
# CONFIG_LEDS_PCA963X is not set
CONFIG_LEDS_WM831X_STATUS=y
# CONFIG_LEDS_WM8350 is not set
# CONFIG_LEDS_DA9052 is not set
CONFIG_LEDS_DAC124S085=y
# CONFIG_LEDS_PWM is not set
CONFIG_LEDS_REGULATOR=y
CONFIG_LEDS_BD2802=y
# CONFIG_LEDS_INTEL_SS4200 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_MC13783=y
CONFIG_LEDS_TCA6507=y
# CONFIG_LEDS_LM355x is not set
CONFIG_LEDS_OT200=y

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
# CONFIG_LEDS_BLINKM is not set

#
# LED Triggers
#
# CONFIG_LEDS_TRIGGERS is not set
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_AMSO1100 is not set
CONFIG_INFINIBAND_NES=y
CONFIG_INFINIBAND_NES_DEBUG=y
CONFIG_INFINIBAND_SRP=y
CONFIG_INFINIBAND_ISER=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_MM_EDAC=y
# CONFIG_EDAC_GHES is not set
CONFIG_EDAC_AMD76X=y
CONFIG_EDAC_E7XXX=y
# CONFIG_EDAC_E752X is not set
CONFIG_EDAC_I82875P=y
CONFIG_EDAC_I82975X=y
# CONFIG_EDAC_I3000 is not set
CONFIG_EDAC_I3200=y
# CONFIG_EDAC_IE31200 is not set
CONFIG_EDAC_X38=y
# CONFIG_EDAC_I5400 is not set
CONFIG_EDAC_I82860=y
CONFIG_EDAC_R82600=y
# CONFIG_EDAC_I5000 is not set
CONFIG_EDAC_I5100=y
CONFIG_EDAC_I7300=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
CONFIG_RTC_SYSTOHC=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
CONFIG_RTC_DEBUG=y

#
# RTC interfaces
#
# CONFIG_RTC_INTF_SYSFS is not set
# CONFIG_RTC_INTF_PROC is not set
# CONFIG_RTC_INTF_DEV is not set
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
# CONFIG_RTC_DRV_88PM80X is not set
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8998=y
CONFIG_RTC_DRV_RS5C372=y
CONFIG_RTC_DRV_ISL1208=y
CONFIG_RTC_DRV_ISL12022=y
CONFIG_RTC_DRV_ISL12057=y
CONFIG_RTC_DRV_X1205=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_PCF8523=y
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF85063=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=y
# CONFIG_RTC_DRV_TPS6586X is not set
CONFIG_RTC_DRV_TPS65910=y
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
# CONFIG_RTC_DRV_RX8581 is not set
CONFIG_RTC_DRV_RX8025=y
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y
CONFIG_RTC_DRV_S5M=y

#
# SPI RTC drivers
#
CONFIG_RTC_DRV_M41T93=y
CONFIG_RTC_DRV_M41T94=y
CONFIG_RTC_DRV_DS1305=y
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
CONFIG_RTC_DRV_DS1390=y
CONFIG_RTC_DRV_MAX6902=y
CONFIG_RTC_DRV_R9701=y
CONFIG_RTC_DRV_RS5C348=y
CONFIG_RTC_DRV_DS3234=y
CONFIG_RTC_DRV_PCF2123=y
CONFIG_RTC_DRV_RX4581=y
CONFIG_RTC_DRV_MCP795=y

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
CONFIG_RTC_DRV_DS1553=y
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DS2404=y
CONFIG_RTC_DRV_DA9052=y
CONFIG_RTC_DRV_DA9055=y
CONFIG_RTC_DRV_EFI=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
CONFIG_RTC_DRV_M48T35=y
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
CONFIG_RTC_DRV_BQ4802=y
CONFIG_RTC_DRV_RP5C01=y
CONFIG_RTC_DRV_V3020=y
CONFIG_RTC_DRV_WM831X=y
CONFIG_RTC_DRV_WM8350=y

#
# on-CPU RTC drivers
#
CONFIG_RTC_DRV_MC13XXX=y
# CONFIG_RTC_DRV_XGENE is not set

#
# HID Sensor RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_DMEM_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
CONFIG_UIO_PCI_GENERIC=y
CONFIG_UIO_NETX=y
CONFIG_UIO_MF624=y
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y

#
# Virtio drivers
#
# CONFIG_VIRTIO_PCI is not set
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
# CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES is not set

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_SLICOSS is not set
# CONFIG_PANEL is not set
CONFIG_RTS5208=y
# CONFIG_RTS5208_DEBUG is not set
CONFIG_FB_XGI=y
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
CONFIG_STAGING_MEDIA=y

#
# Android
#
# CONFIG_ANDROID is not set
CONFIG_XILLYBUS=y
# CONFIG_DGNC is not set
# CONFIG_DGAP is not set
CONFIG_GS_FPGABOOT=y
# CONFIG_X86_PLATFORM_DEVICES is not set
# CONFIG_CHROME_PLATFORMS is not set

#
# SOC (System On Chip) specific Drivers
#
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_WM831X is not set
CONFIG_COMMON_CLK_SI5351=y
CONFIG_COMMON_CLK_S2MPS11=y
CONFIG_CLK_TWL6040=y

#
# Hardware Spinlock drivers
#

#
# Clock Source drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_SH_TIMER_CMT is not set
# CONFIG_SH_TIMER_MTU2 is not set
# CONFIG_SH_TIMER_TMU is not set
# CONFIG_EM_TIMER_STI is not set
CONFIG_MAILBOX=y
CONFIG_IOMMU_SUPPORT=y

#
# Remoteproc drivers
#
# CONFIG_STE_MODEM_RPROC is not set

#
# Rpmsg drivers
#
# CONFIG_PM_DEVFREQ is not set
CONFIG_EXTCON=y

#
# Extcon Device Drivers
#
CONFIG_EXTCON_GPIO=y
# CONFIG_EXTCON_MAX14577 is not set
CONFIG_EXTCON_SM5502=y
# CONFIG_MEMORY is not set
# CONFIG_IIO is not set
CONFIG_NTB=y
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
CONFIG_VMIVME_7805=y

#
# VME Device Drivers
#
CONFIG_VME_USER=y
CONFIG_VME_PIO2=y
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
CONFIG_PWM_LP3943=y
CONFIG_PWM_LPSS=y
CONFIG_IPACK_BUS=y
CONFIG_BOARD_TPCI200=y
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_RESET_CONTROLLER is not set
# CONFIG_FMC is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
CONFIG_BCM_KONA_USB2_PHY=y
CONFIG_PHY_ST_SPEAR1310_MIPHY=y
CONFIG_PHY_ST_SPEAR1340_MIPHY=y
# CONFIG_POWERCAP is not set
CONFIG_MCB=y
CONFIG_MCB_PCI=y
CONFIG_RAS=y
CONFIG_THUNDERBOLT=y

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
CONFIG_GOOGLE_SMI=y
CONFIG_GOOGLE_MEMCONSOLE=y

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
CONFIG_UEFI_CPER=y

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
CONFIG_EXT2_FS=y
# CONFIG_EXT2_FS_XATTR is not set
# CONFIG_EXT2_FS_XIP is not set
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
# CONFIG_EXT3_FS_XATTR is not set
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_POSIX_ACL=y
# CONFIG_EXT4_FS_SECURITY is not set
CONFIG_EXT4_DEBUG=y
CONFIG_JBD=y
CONFIG_JBD_DEBUG=y
CONFIG_JBD2=y
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=y
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
CONFIG_XFS_DEBUG=y
CONFIG_GFS2_FS=y
CONFIG_BTRFS_FS=y
# CONFIG_BTRFS_FS_POSIX_ACL is not set
CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
CONFIG_BTRFS_FS_RUN_SANITY_TESTS=y
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
CONFIG_NILFS2_FS=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
# CONFIG_FANOTIFY is not set
# CONFIG_QUOTA is not set
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
# CONFIG_NTFS_DEBUG is not set
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
# CONFIG_HFSPLUS_FS_POSIX_ACL is not set
CONFIG_BEFS_FS=y
CONFIG_BEFS_DEBUG=y
# CONFIG_BFS_FS is not set
CONFIG_EFS_FS=y
# CONFIG_LOGFS is not set
CONFIG_CRAMFS=y
# CONFIG_SQUASHFS is not set
CONFIG_VXFS_FS=y
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=y
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=y
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
CONFIG_PSTORE=y
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_RAM=y
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_F2FS_FS=y
CONFIG_F2FS_STAT_FS=y
# CONFIG_F2FS_FS_XATTR is not set
CONFIG_F2FS_CHECK_FS=y
CONFIG_EFIVAR_FS=y
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
CONFIG_NLS_CODEPAGE_855=y
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
CONFIG_NLS_CODEPAGE_865=y
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=y
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
# CONFIG_NLS_ASCII is not set
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_2=y
# CONFIG_NLS_ISO8859_3 is not set
CONFIG_NLS_ISO8859_4=y
CONFIG_NLS_ISO8859_5=y
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
CONFIG_NLS_ISO8859_9=y
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_MAC_ROMAN=y
CONFIG_NLS_MAC_CELTIC=y
# CONFIG_NLS_MAC_CENTEURO is not set
# CONFIG_NLS_MAC_CROATIAN is not set
CONFIG_NLS_MAC_CYRILLIC=y
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
# CONFIG_NLS_MAC_ICELAND is not set
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
CONFIG_NLS_MAC_TURKISH=y
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_DYNAMIC_DEBUG is not set

#
# Compile-time checks and compiler options
#
# CONFIG_DEBUG_INFO is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_STRIP_ASM_SYMS=y
CONFIG_READABLE_ASM=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_DEBUG_KERNEL=y

#
# Memory Debugging
#
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_STACK_USAGE=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_VMACACHE is not set
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_PER_CPU_MAPS=y
# CONFIG_DEBUG_HIGHMEM is not set
CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
# CONFIG_DEBUG_SHIRQ is not set

#
# Debug Lockups and Hangs
#
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_PANIC_TIMEOUT=0
# CONFIG_SCHED_DEBUG is not set
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
CONFIG_DEBUG_LOCKDEP=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_LIST is not set
CONFIG_DEBUG_PI_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_DEBUG_NOTIFIERS=y
CONFIG_DEBUG_CREDENTIALS=y

#
# RCU Debugging
#
CONFIG_PROVE_RCU=y
# CONFIG_PROVE_RCU_REPEATEDLY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST=y
# CONFIG_RCU_TORTURE_TEST_RUNNABLE is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
CONFIG_RCU_CPU_STALL_INFO=y
# CONFIG_RCU_TRACE is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_PM_NOTIFIER_ERROR_INJECT=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
CONFIG_FAIL_PAGE_ALLOC=y
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAULT_INJECTION_STACKTRACE_FILTER is not set
# CONFIG_LATENCYTOP is not set
CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACING_SUPPORT=y
# CONFIG_FTRACE is not set

#
# Runtime Testing
#
CONFIG_LKDTM=y
CONFIG_TEST_LIST_SORT=y
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_TEST_STRING_HELPERS=y
CONFIG_TEST_KSTRTOX=y
# CONFIG_TEST_RHASHTABLE is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
CONFIG_BUILD_DOCSRC=y
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_TEST_FIRMWARE is not set
# CONFIG_TEST_UDELAY is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
CONFIG_DEBUG_TLBFLUSH=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
# CONFIG_DEBUG_BOOT_PARAMS is not set
# CONFIG_CPA_DEBUG is not set
# CONFIG_OPTIMIZE_INLINING is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
# CONFIG_X86_DEBUG_STATIC_CPU_HAS is not set

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_PERSISTENT_KEYRINGS is not set
# CONFIG_TRUSTED_KEYS is not set
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX=y
CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX_VALUE=19
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
# CONFIG_SECURITY_APPARMOR_HASH is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_YAMA_STACKED is not set
CONFIG_INTEGRITY=y
# CONFIG_INTEGRITY_SIGNATURE is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
# CONFIG_IMA_NG_TEMPLATE is not set
CONFIG_IMA_SIG_TEMPLATE=y
CONFIG_IMA_DEFAULT_TEMPLATE="ima-sig"
# CONFIG_IMA_DEFAULT_HASH_SHA1 is not set
CONFIG_IMA_DEFAULT_HASH_SHA256=y
# CONFIG_IMA_DEFAULT_HASH_SHA512 is not set
# CONFIG_IMA_DEFAULT_HASH_WP512 is not set
CONFIG_IMA_DEFAULT_HASH="sha256"
# CONFIG_IMA_APPRAISE is not set
CONFIG_EVM=y

#
# EVM options
#
# CONFIG_EVM_ATTR_FSUUID is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_YAMA is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_XOR_BLOCKS=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_PCRYPT=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
# CONFIG_CRYPTO_CMAC is not set
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_CRC32=y
# CONFIG_CRYPTO_CRC32_PCLMUL is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
# CONFIG_CRYPTO_MICHAEL_MIC is not set
# CONFIG_CRYPTO_RMD128 is not set
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_BLOWFISH_COMMON=y
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAST_COMMON=y
# CONFIG_CRYPTO_CAST5 is not set
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SALSA20=y
CONFIG_CRYPTO_SALSA20_586=y
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
# CONFIG_CRYPTO_TEA is not set
CONFIG_CRYPTO_TWOFISH=y
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set
# CONFIG_CRYPTO_LZ4 is not set
CONFIG_CRYPTO_LZ4HC=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
# CONFIG_CRYPTO_DRBG_MENU is not set
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
# CONFIG_CRYPTO_USER_API_SKCIPHER is not set
CONFIG_CRYPTO_HASH_INFO=y
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_PUBLIC_KEY_ALGO_RSA=y
CONFIG_HAVE_KVM=y
# CONFIG_VIRTUALIZATION is not set
# CONFIG_BINARY_PRINTF is not set

#
# Library routines
#
CONFIG_RAID6_PQ=y
CONFIG_BITREVERSE=y
CONFIG_RATIONAL=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
# CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
CONFIG_RANDOM32_SELFTEST=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4HC_COMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=y
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_INTERVAL_TREE=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CLZ_TAB=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
CONFIG_MPILIB=y
CONFIG_UCS2_STRING=y
CONFIG_ARCH_HAS_SG_CHAIN=y

--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--6c2NcOVqGQ03X4Wi--
