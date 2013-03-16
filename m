Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab3CPSaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 14:30:04 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49546 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3CPS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 14:29:59 -0400
Message-ID: <5144BA1E.7000203@gmail.com>
Date: Sat, 16 Mar 2013 22:29:50 +0400
From: Lijo Antony <lijo.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: airlied@linux.ie, bskeggs@redhat.com
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [3.9.0-rc2] nouveau deadlock when HDMI TV is connected
Content-Type: multipart/mixed;
 boundary="------------060109090507040008020506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060109090507040008020506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

This is a Dell Inspiron N5110 laptop with Optimus mess.
Until 3.9.0-rc1, tv connected throuh HDMI was not getting detected. But 
in 3.9.0-rc2, when I connect HDMI cable, I get this,


=============================================
[ INFO: possible recursive locking detected ]
3.9.0-rc2 #22 Not tainted
---------------------------------------------
kworker/0:1/54 is trying to acquire lock:
  (&dmac->lock){+.+...}, at: [<ffffffffa05fffb3>] evo_wait+0x43/0xf0 
[nouveau]

but task is already holding lock:
  (&dmac->lock){+.+...}, at: [<ffffffffa05fffb3>] evo_wait+0x43/0xf0 
[nouveau]

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&dmac->lock);
   lock(&dmac->lock);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

5 locks held by kworker/0:1/54:
  #0:  (events){.+.+.+}, at: [<ffffffff8106e311>] 
process_one_work+0x171/0x4c0
  #1:  ((&nv_connector->hpd_work)){+.+.+.}, at: [<ffffffff8106e311>] 
process_one_work+0x171/0x4c0
  #2:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffffa022ee2a>] 
drm_modeset_lock_all+0x2a/0x70 [drm]
  #3:  (&crtc->mutex){+.+.+.}, at: [<ffffffffa022ee54>] 
drm_modeset_lock_all+0x54/0x70 [drm]
  #4:  (&dmac->lock){+.+...}, at: [<ffffffffa05fffb3>] 
evo_wait+0x43/0xf0 [nouveau]

stack backtrace:
Pid: 54, comm: kworker/0:1 Not tainted 3.9.0-rc2 #22
Call Trace:
  [<ffffffff810b71e5>] __lock_acquire+0x715/0x1be0
  [<ffffffffa056361c>] ? dcb_table+0x1ac/0x2a0 [nouveau]
  [<ffffffff810b8c31>] lock_acquire+0xa1/0x130
  [<ffffffffa05fffb3>] ? evo_wait+0x43/0xf0 [nouveau]
  [<ffffffff816aac59>] ? mutex_lock_nested+0x299/0x340
  [<ffffffff816aaa09>] mutex_lock_nested+0x49/0x340
  [<ffffffffa05fffb3>] ? evo_wait+0x43/0xf0 [nouveau]
  [<ffffffff810b954f>] ? mark_held_locks+0xaf/0x110
  [<ffffffffa05fffb3>] evo_wait+0x43/0xf0 [nouveau]
  [<ffffffffa0602a63>] nv50_display_flip_next+0x713/0x7a0 [nouveau]
  [<ffffffff816ab95e>] ? mutex_unlock+0xe/0x10
  [<ffffffffa0600097>] ? evo_kick+0x37/0x40 [nouveau]
  [<ffffffffa0602cee>] nv50_crtc_commit+0x10e/0x230 [nouveau]
  [<ffffffffa0158125>] drm_crtc_helper_set_mode+0x365/0x510 [drm_kms_helper]
  [<ffffffffa015953e>] drm_crtc_helper_set_config+0xa4e/0xb70 
[drm_kms_helper]
  [<ffffffffa022fe71>] drm_mode_set_config_internal+0x31/0x70 [drm]
  [<ffffffffa0157621>] drm_fb_helper_set_par+0x71/0xf0 [drm_kms_helper]
  [<ffffffffa022eaa2>] ? drm_modeset_unlock_all+0x52/0x60 [drm]
  [<ffffffffa0157581>] drm_fb_helper_hotplug_event+0x81/0xb0 
[drm_kms_helper]
  [<ffffffffa05e964c>] nouveau_fbcon_output_poll_changed+0x1c/0x20 [nouveau]
  [<ffffffffa0157bbb>] drm_kms_helper_hotplug_event+0x2b/0x40 
[drm_kms_helper]
  [<ffffffffa0158ada>] drm_helper_hpd_irq_event+0x12a/0x140 [drm_kms_helper]
  [<ffffffffa05ec323>] nouveau_connector_hotplug_work+0x93/0x100 [nouveau]
  [<ffffffff8106e371>] process_one_work+0x1d1/0x4c0
  [<ffffffff8106e311>] ? process_one_work+0x171/0x4c0
  [<ffffffff8106fd0f>] worker_thread+0x10f/0x380
  [<ffffffff8106fc00>] ? busy_worker_rebind_fn+0xb0/0xb0
  [<ffffffff8107aaca>] kthread+0xea/0xf0
  [<ffffffff8107a9e0>] ? kthread_create_on_node+0x160/0x160
  [<ffffffff816b80ac>] ret_from_fork+0x7c/0xb0
  [<ffffffff8107a9e0>] ? kthread_create_on_node+0x160/0x160




This is consistent and git bisect pointed at,

65b5f42e2a9eb9c8383fb67698bf8c27657f8c14 is the first bad commit
commit 65b5f42e2a9eb9c8383fb67698bf8c27657f8c14
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Feb 20 16:47:44 2013 +1000

     drm/nve0/graph: some random reg moved on kepler

     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

:040000 040000 9658d1fd413b8797fe06fb2ca8ce681d4dbbedb0 
c5b38586625718fc78c0eb062af3baa201fe2e7f M      drivers



65b5f42e2a9eb9c8383fb67698bf8c27657f8c14
commit 65b5f42e2a9eb9c8383fb67698bf8c27657f8c14
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Wed Feb 20 16:47:44 2013 +1000

     drm/nve0/graph: some random reg moved on kepler

     Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

diff --git a/drivers/gpu/drm/nouveau/core/engine/graph/nve0.c 
b/drivers/gpu/drm/nouveau/core/engine/graph/nve0.c
index 61cec0f..4857f91 100644
--- a/drivers/gpu/drm/nouveau/core/engine/graph/nve0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/nve0.c
@@ -350,7 +350,7 @@ nve0_graph_init_gpc_0(struct nvc0_graph_priv *priv)
                 nv_wr32(priv, GPC_UNIT(gpc, 0x0918), magicgpc918);
         }

-       nv_wr32(priv, GPC_BCAST(0x1bd4), magicgpc918);
+       nv_wr32(priv, GPC_BCAST(0x3fd4), magicgpc918);
         nv_wr32(priv, GPC_BCAST(0x08ac), nv_rd32(priv, 0x100800));
  }


But looking at 65b5f42e2a9eb9c8383fb67698bf8c27657f8c14, it looks I 
might have done some mistake in bisecting. I will try again later. 
Please let me know, if you need more info.

-lijo

git bisect log
--------------
# bad: [f6161aa153581da4a3867a2d1a7caf4be19b6ec9] Linux 3.9-rc2
git bisect bad f6161aa153581da4a3867a2d1a7caf4be19b6ec9
# good: [6dbe51c251a327e012439c4772097a13df43c5b8] Linux 3.9-rc1
git bisect good 6dbe51c251a327e012439c4772097a13df43c5b8
# good: [f40ebd6bcbbd0d30591f42dc16be52b5086a366b] drm/i915: Turn off 
hsync and vsync on ADPA when disabling crt
git bisect good f40ebd6bcbbd0d30591f42dc16be52b5086a366b
# bad: [2cc79544bd0aabb4b3cf467ead5df526d9134c64] Merge branch 
'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into 
drm-next
git bisect bad 2cc79544bd0aabb4b3cf467ead5df526d9134c64
# bad: [f6853faa85793bf23b46787e4039824d275453c2] drm/nouveau: Fix typo 
in init_idx_addr_latched().
git bisect bad f6853faa85793bf23b46787e4039824d275453c2
# bad: [650e1203c11354ba84d69ba445abc0efcfe3890a] drm/nouveau: Disable 
AGP on PowerPC again.
git bisect bad 650e1203c11354ba84d69ba445abc0efcfe3890a
# bad: [65b5f42e2a9eb9c8383fb67698bf8c27657f8c14] drm/nve0/graph: some 
random reg moved on kepler
git bisect bad 65b5f42e2a9eb9c8383fb67698bf8c27657f8c14

lijo@pluto:~/linux/linux$ lspci
00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor 
Family DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core 
Processor Family PCI Express Root Port (rev 09)
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core 
Processor Family Integrated Graphics Controller (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series 
Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset 
Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 1 (rev b5)
00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 2 (rev b5)
00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 4 (rev b5)
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 5 (rev b5)
00:1c.7 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset 
Family PCI Express Root Port 8 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset 
Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation HM67 Express Chipset Family LPC 
Controller (rev 05)
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset 
Family 6 port SATA AHCI Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family 
SMBus Controller (rev 05)
01:00.0 VGA compatible controller: NVIDIA Corporation GF108 [GeForce GT 
540M] (rev a1)
01:00.1 Audio device: NVIDIA Corporation GF108 High Definition Audio 
Controller (rev a1)
05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 05)
09:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)
0b:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host 
Controller (rev 04)



--------------060109090507040008020506
Content-Type: text/x-log;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc2 (lijo@pluto) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-2ubuntu1) ) #22 SMP Sat Mar 16 11:25:11 GST 2013
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.9.0-rc2 root=UUID=99546192-52d8-49bd-a5a8-2ba47a41d542 ro
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000ca4e3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ca4e4000-0x00000000ca526fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000ca527000-0x00000000ca791fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ca792000-0x00000000ca966fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ca967000-0x00000000caba6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000caba7000-0x00000000cad67fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000cad68000-0x00000000cafacfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cafad000-0x00000000cafbafff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cafbb000-0x00000000cafe7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cafe8000-0x00000000caffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000cb800000-0x00000000cf9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000012fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: Dell Inc. Inspiron N5110/0FXK2Y, BIOS A06 05/26/2011
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x12fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F00000000 write-back
[    0.000000]   1 base 100000000 mask FC0000000 write-back
[    0.000000]   2 base 0CB800000 mask FFF800000 uncachable
[    0.000000]   3 base 0CC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   5 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   6 base 12FE00000 mask FFFE00000 uncachable
[    0.000000]   7 base 130000000 mask FF0000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 4GB, type WB
[    0.000000] reg 1, base: 4GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3256MB, range: 8MB, type UC
[    0.000000] reg 3, base: 3264MB, range: 64MB, type UC
[    0.000000] reg 4, base: 3328MB, range: 256MB, type UC
[    0.000000] reg 5, base: 3584MB, range: 512MB, type UC
[    0.000000] reg 6, base: 4862MB, range: 2MB, type UC
[    0.000000] reg 7, base: 4864MB, range: 256MB, type UC
[    0.000000] total RAM covered: 4022M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 16M 	num_reg: 8  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 128MB, type WB
[    0.000000] reg 3, base: 3200MB, range: 64MB, type WB
[    0.000000] reg 4, base: 3256MB, range: 8MB, type UC
[    0.000000] reg 5, base: 4GB, range: 512MB, type WB
[    0.000000] reg 6, base: 4608MB, range: 256MB, type WB
[    0.000000] reg 7, base: 4862MB, range: 2MB, type UC
[    0.000000] e820: update [mem 0xcb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcaba7 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd220-0x000fd22f] mapped at [ffff8800000fd220]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x026fb000, 0x026fbfff] PGTABLE
[    0.000000] BRK [0x026fc000, 0x026fcfff] PGTABLE
[    0.000000] BRK [0x026fd000, 0x026fdfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12fc00000-0x12fdfffff]
[    0.000000]  [mem 0x12fc00000-0x12fdfffff] page 2M
[    0.000000] BRK [0x026fe000, 0x026fefff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x12c000000-0x12fbfffff]
[    0.000000]  [mem 0x12c000000-0x12fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x12bffffff]
[    0.000000]  [mem 0x100000000-0x12bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40200000-0xca4e3fff]
[    0.000000]  [mem 0x40200000-0xca3fffff] page 2M
[    0.000000]  [mem 0xca400000-0xca4e3fff] page 4k
[    0.000000] BRK [0x026ff000, 0x026fffff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xca527000-0xca791fff]
[    0.000000]  [mem 0xca527000-0xca791fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xca967000-0xcaba6fff]
[    0.000000]  [mem 0xca967000-0xcaba6fff] page 4k
[    0.000000] RAMDISK: [mem 0x37988000-0x37cbbfff]
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02   DELL)
[    0.000000] ACPI: XSDT 00000000cafad080 0007C (v01 DELL    WN09    01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000cafb6c58 000F4 (v04   DELL     WN09 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000cafad188 09ACE (v02   DELL     WN09 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cafe3f80 00040
[    0.000000] ACPI: APIC 00000000cafb6d50 00072 (v03   DELL     WN09 01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 00000000cafb6dc8 0003C (v01   DELL     WN09 01072009 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000cafb6e08 004B0 (v01 TrmRef PtidDevc 00001000 INTL 20091112)
[    0.000000] ACPI: SLIC 00000000cafb72b8 00176 (v01 DELL    WN09    01072009 AMI  00010013)
[    0.000000] ACPI: HPET 00000000cafb7430 00038 (v01   DELL     WN09 01072009 AMI. 00000004)
[    0.000000] ACPI: SSDT 00000000cafb7468 00780 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000cafb7be8 00996 (v01  PmRef    CpuPm 00003000 INTL 20051117)
[    0.000000] ACPI: SSDT 00000000cafb8580 00D80 (v01  SgRef   SgTabl 00001000 INTL 20091112)
[    0.000000] ACPI: SSDT 00000000cafb9300 01821 (v01 OptRef  OptTabl 00001000 INTL 20091112)
[    0.000000] ACPI: OSFR 00000000cafbab28 00086 (v01 DELL    M08     07DB051A ASL  00000061)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0004bfffff] PMD -> [ffff88012b400000-ffff88012f3fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x12fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xca4e3fff]
[    0.000000]   node   0: [mem 0xca527000-0xca791fff]
[    0.000000]   node   0: [mem 0xca967000-0xcaba6fff]
[    0.000000]   node   0: [mem 0x100000000-0x12fdfffff]
[    0.000000] On node 0 totalpages: 1024811
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 156 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12887 pages used for memmap
[    0.000000]   DMA32 zone: 824719 pages, LIFO batch:31
[    0.000000]   Normal zone: 3064 pages used for memmap
[    0.000000]   Normal zone: 196096 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
[    0.000000] PM: Registered nosave memory: 00000000ca4e4000 - 00000000ca527000
[    0.000000] PM: Registered nosave memory: 00000000ca792000 - 00000000ca967000
[    0.000000] PM: Registered nosave memory: 00000000caba7000 - 00000000cad68000
[    0.000000] PM: Registered nosave memory: 00000000cad68000 - 00000000cafad000
[    0.000000] PM: Registered nosave memory: 00000000cafad000 - 00000000cafbb000
[    0.000000] PM: Registered nosave memory: 00000000cafbb000 - 00000000cafe8000
[    0.000000] PM: Registered nosave memory: 00000000cafe8000 - 00000000cb000000
[    0.000000] PM: Registered nosave memory: 00000000cb000000 - 00000000cb800000
[    0.000000] PM: Registered nosave memory: 00000000cb800000 - 00000000cfa00000
[    0.000000] PM: Registered nosave memory: 00000000cfa00000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed04000
[    0.000000] PM: Registered nosave memory: 00000000fed04000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] e820: [mem 0xcfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88012fa00000 s87744 r8192 d22848 u524288
[    0.000000] pcpu-alloc: s87744 r8192 d22848 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1008640
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.9.0-rc2 root=UUID=99546192-52d8-49bd-a5a8-2ba47a41d542 ro
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 3933240k/4978688k available (6888k kernel code, 879444k absent, 166004k reserved, 6329k data, 1116k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	CONFIG_RCU_FANOUT set to non-default value of 32
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2294.860 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 4589.72 BogoMIPS (lpj=9179440)
[    0.000012] pid_max: default: 32768 minimum: 301
[    0.000105] Security Framework initialized
[    0.000126] AppArmor: AppArmor initialized
[    0.000153] Mount-cache hash table entries: 256
[    0.000884] Initializing cgroup subsys cpuacct
[    0.000898] Initializing cgroup subsys devices
[    0.000903] Initializing cgroup subsys freezer
[    0.000922] Initializing cgroup subsys blkio
[    0.000927] Initializing cgroup subsys perf_event
[    0.000990] CPU: Physical Processor ID: 0
[    0.000994] CPU: Processor Core ID: 0
[    0.001001] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.001001] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.001012] mce: CPU supports 7 MCE banks
[    0.001026] CPU0: Thermal monitoring enabled (TM1)
[    0.001043] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.001043] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.001043] tlb_flushall_shift: 5
[    0.001235] Freeing SMP alternatives: 20k freed
[    0.002553] ACPI: Core revision 20130117
[    0.015997] ACPI: All ACPI Tables successfully acquired
[    0.025577] ftrace: allocating 24271 entries in 95 pages
[    0.038665] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.078337] smpboot: CPU0: Intel(R) Core(TM) i5-2410M CPU @ 2.30GHz (fam: 06, model: 2a, stepping: 07)
[    0.078353] TSC deadline timer enabled
[    0.078373] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.078386] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.078398] ... version:                3
[    0.078401] ... bit width:              48
[    0.078404] ... generic registers:      4
[    0.078408] ... value mask:             0000ffffffffffff
[    0.078412] ... max period:             000000007fffffff
[    0.078416] ... fixed-purpose events:   3
[    0.078419] ... event mask:             000000070000000f
[    0.079777] SMP alternatives: lockdep: fixing up alternatives
[    0.093151] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.079797] smpboot: Booting Node   0, Processors  #1
[    0.093349] SMP alternatives: lockdep: fixing up alternatives
[    0.093356]  #2
[    0.106725] SMP alternatives: lockdep: fixing up alternatives
[    0.106735]  #3 OK
[    0.119909] Brought up 4 CPUs
[    0.119917] smpboot: Total of 4 processors activated (18358.88 BogoMIPS)
[    0.123838] devtmpfs: initialized
[    0.124179] EVM: security.selinux
[    0.124184] EVM: security.SMACK64
[    0.124187] EVM: security.capability
[    0.124269] PM: Registering ACPI NVS region [mem 0xca4e4000-0xca526fff] (274432 bytes)
[    0.124282] PM: Registering ACPI NVS region [mem 0xcad68000-0xcafacfff] (2379776 bytes)
[    0.124334] PM: Registering ACPI NVS region [mem 0xcafbb000-0xcafe7fff] (184320 bytes)
[    0.125582] regulator-dummy: no parameters
[    0.125670] RTC time: 16:06:58, date: 03/16/13
[    0.125823] NET: Registered protocol family 16
[    0.126056] ACPI: bus type PCI registered
[    0.126178] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.126186] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.136017] PCI: Using configuration type 1 for base access
[    0.137698] bio: create slab <bio-0> at 0
[    0.137879] ACPI: Added _OSI(Module Device)
[    0.137884] ACPI: Added _OSI(Processor Device)
[    0.137888] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.137893] ACPI: Added _OSI(Processor Aggregator Device)
[    0.143644] ACPI: EC: Look up EC in DSDT
[    0.149722] ACPI: Executed 1 blocks of module-level executable AML code
[    0.157030] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.164927] ACPI: SSDT 00000000cad51698 0064F (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.166428] ACPI: Dynamic OEM Table Load:
[    0.166434] ACPI: SSDT           (null) 0064F (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.166796] ACPI: SSDT 00000000cad52a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.168371] ACPI: Dynamic OEM Table Load:
[    0.168377] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.168525] ACPI: SSDT 00000000cad50d98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.170036] ACPI: Dynamic OEM Table Load:
[    0.170041] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.170949] ACPI: Interpreter enabled
[    0.170964] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.171002] ACPI: (supports S0 S1 S3 S4 S5)
[    0.171006] ACPI: Using IOAPIC for interrupt routing
[    0.171051] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.212753] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.213009] acpi PNP0A08:00: Requesting ACPI _OSC control (0x1d)
[    0.213208] acpi PNP0A08:00: ACPI _OSC control (0x1d) granted
[    0.213958] PCI host bridge to bus 0000:00
[    0.213965] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.213970] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.213975] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.213981] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.213986] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.213991] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.213997] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.214002] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.214007] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.214012] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.214018] pci_bus 0000:00: root bus resource [mem 0xcfa00000-0xfeafffff]
[    0.214023] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.214062] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.214329] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.214387] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.214504] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.214613] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
[    0.214631] pci 0000:00:02.0: reg 10: [mem 0xf6400000-0xf67fffff 64bit]
[    0.214641] pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.214648] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.214890] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.214931] pci 0000:00:16.0: reg 10: [mem 0xf7b0a000-0xf7b0a00f 64bit]
[    0.215069] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.215282] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.215318] pci 0000:00:1a.0: reg 10: [mem 0xf7b08000-0xf7b083ff]
[    0.215484] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.218682] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.218764] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.218795] pci 0000:00:1b.0: reg 10: [mem 0xf7b00000-0xf7b03fff 64bit]
[    0.218941] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.219061] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.219128] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.219280] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.219357] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.219423] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.219580] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.219662] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.219732] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.219885] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.219973] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.220039] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
[    0.220190] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.220281] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.220352] pci 0000:00:1c.7: [8086:1c1e] type 01 class 0x060400
[    0.220504] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.220605] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.220677] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.220713] pci 0000:00:1d.0: reg 10: [mem 0xf7b07000-0xf7b073ff]
[    0.220876] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.223632] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.223708] pci 0000:00:1f.0: [8086:1c4b] type 00 class 0x060100
[    0.223967] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.224008] pci 0000:00:1f.2: reg 10: [io  0xf0b0-0xf0b7]
[    0.224024] pci 0000:00:1f.2: reg 14: [io  0xf0a0-0xf0a3]
[    0.224039] pci 0000:00:1f.2: reg 18: [io  0xf090-0xf097]
[    0.224054] pci 0000:00:1f.2: reg 1c: [io  0xf080-0xf083]
[    0.224069] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.224086] pci 0000:00:1f.2: reg 24: [mem 0xf7b06000-0xf7b067ff]
[    0.224190] pci 0000:00:1f.2: PME# supported from D3hot
[    0.224357] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.224388] pci 0000:00:1f.3: reg 10: [mem 0xf7b05000-0xf7b050ff 64bit]
[    0.224431] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.224692] pci 0000:01:00.0: [10de:0df5] type 00 class 0x030000
[    0.224705] pci 0000:01:00.0: reg 10: [mem 0xf5000000-0xf5ffffff]
[    0.224717] pci 0000:01:00.0: reg 14: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.224730] pci 0000:01:00.0: reg 1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
[    0.224739] pci 0000:01:00.0: reg 24: [io  0xe000-0xe07f]
[    0.224748] pci 0000:01:00.0: reg 30: [mem 0xf6000000-0xf607ffff pref]
[    0.224823] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.224891] pci 0000:01:00.1: [10de:0bea] type 00 class 0x040300
[    0.224903] pci 0000:01:00.1: reg 10: [mem 0xf6080000-0xf6083fff]
[    0.225012] pci 0000:01:00.1: System wakeup disabled by ACPI
[    0.231680] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.231687] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.231690] pci 0000:00:01.0:   bridge window [mem 0xf5000000-0xf60fffff]
[    0.231696] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.231809] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
[    0.231967] pci 0000:05:00.0: [10ec:8136] type 00 class 0x020000
[    0.231997] pci 0000:05:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.232046] pci 0000:05:00.0: reg 18: [mem 0xf3204000-0xf3204fff 64bit pref]
[    0.232077] pci 0000:05:00.0: reg 20: [mem 0xf3200000-0xf3203fff 64bit pref]
[    0.232214] pci 0000:05:00.0: supports D1 D2
[    0.232216] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.232281] pci 0000:05:00.0: System wakeup disabled by ACPI
[    0.239659] pci 0000:00:1c.1: PCI bridge to [bus 05-06]
[    0.239690] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.239704] pci 0000:00:1c.1:   bridge window [mem 0xf3200000-0xf32fffff 64bit pref]
[    0.239847] pci 0000:09:00.0: [168c:002b] type 00 class 0x028000
[    0.239887] pci 0000:09:00.0: reg 10: [mem 0xf7a00000-0xf7a0ffff 64bit]
[    0.240081] pci 0000:09:00.0: supports D1
[    0.240082] pci 0000:09:00.0: PME# supported from D0 D1 D3hot
[    0.240140] pci 0000:09:00.0: System wakeup disabled by ACPI
[    0.247666] pci 0000:00:1c.3: PCI bridge to [bus 09-0a]
[    0.247702] pci 0000:00:1c.3:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.247855] pci 0000:0b:00.0: [1033:0194] type 00 class 0x0c0330
[    0.247894] pci 0000:0b:00.0: reg 10: [mem 0xf7900000-0xf7901fff 64bit]
[    0.248093] pci 0000:0b:00.0: PME# supported from D0 D3hot D3cold
[    0.248153] pci 0000:0b:00.0: System wakeup disabled by ACPI
[    0.248251] pci 0000:00:1c.4: PCI bridge to [bus 0b-0c]
[    0.248265] pci 0000:00:1c.4:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.248381] pci 0000:00:1c.7: PCI bridge to [bus 11-1f]
[    0.248390] pci 0000:00:1c.7:   bridge window [io  0xb000-0xcfff]
[    0.248396] pci 0000:00:1c.7:   bridge window [mem 0xf6800000-0xf78fffff]
[    0.248406] pci 0000:00:1c.7:   bridge window [mem 0xf2100000-0xf31fffff 64bit pref]
[    0.248453] pci_bus 0000:00: on NUMA node 0
[    0.250187] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.250297] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.250405] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.250511] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.250615] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.250721] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.250829] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.250934] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.251947] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.251961] acpi root: \_SB_.PCI0 notify handler is installed
[    0.252145] Found 1 acpi root devices
[    0.252520] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.252534] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
[    0.252542] vgaarb: loaded
[    0.252545] vgaarb: bridge control possible 0000:01:00.0
[    0.252549] vgaarb: no bridge control possible 0000:00:02.0
[    0.252817] SCSI subsystem initialized
[    0.252821] ACPI: bus type ATA registered
[    0.252912] libata version 3.00 loaded.
[    0.252945] ACPI: bus type USB registered
[    0.252977] usbcore: registered new interface driver usbfs
[    0.252995] usbcore: registered new interface driver hub
[    0.253037] usbcore: registered new device driver usb
[    0.253203] PCI: Using ACPI for IRQ routing
[    0.255218] PCI: pci_cache_line_size set to 64 bytes
[    0.255311] e820: reserve RAM buffer [mem 0x0009d400-0x0009ffff]
[    0.255313] e820: reserve RAM buffer [mem 0xca4e4000-0xcbffffff]
[    0.255316] e820: reserve RAM buffer [mem 0xca792000-0xcbffffff]
[    0.255318] e820: reserve RAM buffer [mem 0xcaba7000-0xcbffffff]
[    0.255321] e820: reserve RAM buffer [mem 0x12fe00000-0x12fffffff]
[    0.255659] NetLabel: Initializing
[    0.255664] NetLabel:  domain hash size = 128
[    0.255667] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.255708] NetLabel:  unlabeled traffic allowed by default
[    0.255808] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.255820] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.257832] Switching to clocksource hpet
[    0.277410] AppArmor: AppArmor Filesystem Enabled
[    0.277449] pnp: PnP ACPI init
[    0.277484] ACPI: bus type PNP registered
[    0.277529] pnp 00:00: [dma 4]
[    0.277585] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.277627] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    0.277769] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.277884] system 00:03: [io  0x0680-0x069f] has been reserved
[    0.277891] system 00:03: [io  0x1000-0x100f] has been reserved
[    0.277896] system 00:03: [io  0xffff] has been reserved
[    0.277901] system 00:03: [io  0xffff] has been reserved
[    0.277906] system 00:03: [io  0x0400-0x0453] has been reserved
[    0.277911] system 00:03: [io  0x0458-0x047f] has been reserved
[    0.277916] system 00:03: [io  0x0500-0x057f] has been reserved
[    0.277922] system 00:03: [io  0x164e-0x164f] has been reserved
[    0.277931] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.277985] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.278070] system 00:05: [io  0x0454-0x0457] has been reserved
[    0.278079] system 00:05: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.278128] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.278200] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.278208] system 00:07: [mem 0xfe800000-0xfe802fff] has been reserved
[    0.278216] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.278273] pnp 00:08: Plug and Play ACPI device, IDs DLL04b0 SYN0600 SYN0002 PNP0f13 (active)
[    0.278329] pnp 00:09: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.278781] system 00:0a: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.278787] system 00:0a: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.278793] system 00:0a: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.278799] system 00:0a: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.278805] system 00:0a: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.278810] system 00:0a: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.278816] system 00:0a: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.278821] system 00:0a: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.278827] system 00:0a: [mem 0xff000000-0xffffffff] has been reserved
[    0.278833] system 00:0a: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.278839] system 00:0a: [mem 0xcfa00000-0xcfa00fff] has been reserved
[    0.278847] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.279148] system 00:0b: [mem 0x20000000-0x201fffff] has been reserved
[    0.279155] system 00:0b: [mem 0x40000000-0x401fffff] has been reserved
[    0.279163] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.279234] pnp: PnP ACPI: found 12 devices
[    0.279238] ACPI: bus type PNP unregistered
[    0.287281] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.287289] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.287297] pci 0000:00:01.0:   bridge window [mem 0xf5000000-0xf60fffff]
[    0.287304] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.287313] pci 0000:00:1c.0: PCI bridge to [bus 03-04]
[    0.287335] pci 0000:00:1c.1: PCI bridge to [bus 05-06]
[    0.287342] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.287357] pci 0000:00:1c.1:   bridge window [mem 0xf3200000-0xf32fffff 64bit pref]
[    0.287371] pci 0000:00:1c.3: PCI bridge to [bus 09-0a]
[    0.287382] pci 0000:00:1c.3:   bridge window [mem 0xf7a00000-0xf7afffff]
[    0.287399] pci 0000:00:1c.4: PCI bridge to [bus 0b-0c]
[    0.287409] pci 0000:00:1c.4:   bridge window [mem 0xf7900000-0xf79fffff]
[    0.287427] pci 0000:00:1c.7: PCI bridge to [bus 11-1f]
[    0.287433] pci 0000:00:1c.7:   bridge window [io  0xb000-0xcfff]
[    0.287444] pci 0000:00:1c.7:   bridge window [mem 0xf6800000-0xf78fffff]
[    0.287453] pci 0000:00:1c.7:   bridge window [mem 0xf2100000-0xf31fffff 64bit pref]
[    0.287864] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.287867] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.287869] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.287871] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.287873] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.287875] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.287877] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.287879] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.287881] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.287883] pci_bus 0000:00: resource 13 [mem 0xcfa00000-0xfeafffff]
[    0.287885] pci_bus 0000:00: resource 14 [mem 0xfed40000-0xfed44fff]
[    0.287887] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.287889] pci_bus 0000:01: resource 1 [mem 0xf5000000-0xf60fffff]
[    0.287891] pci_bus 0000:01: resource 2 [mem 0xe0000000-0xf1ffffff 64bit pref]
[    0.287894] pci_bus 0000:05: resource 0 [io  0xd000-0xdfff]
[    0.287896] pci_bus 0000:05: resource 2 [mem 0xf3200000-0xf32fffff 64bit pref]
[    0.287898] pci_bus 0000:09: resource 1 [mem 0xf7a00000-0xf7afffff]
[    0.287900] pci_bus 0000:0b: resource 1 [mem 0xf7900000-0xf79fffff]
[    0.287902] pci_bus 0000:11: resource 0 [io  0xb000-0xcfff]
[    0.287904] pci_bus 0000:11: resource 1 [mem 0xf6800000-0xf78fffff]
[    0.287906] pci_bus 0000:11: resource 2 [mem 0xf2100000-0xf31fffff 64bit pref]
[    0.287968] NET: Registered protocol family 2
[    0.288311] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
[    0.288438] TCP bind hash table entries: 32768 (order: 9, 2097152 bytes)
[    0.290549] TCP: Hash tables configured (established 32768 bind 32768)
[    0.290605] TCP: reno registered
[    0.290621] UDP hash table entries: 2048 (order: 6, 327680 bytes)
[    0.290908] UDP-Lite hash table entries: 2048 (order: 6, 327680 bytes)
[    0.291325] NET: Registered protocol family 1
[    0.291347] pci 0000:00:02.0: Boot video device
[    0.529995] PCI: CLS 64 bytes, default 64
[    0.530144] Trying to unpack rootfs image as initramfs...
[    0.594089] Freeing initrd memory: 3280k freed
[    0.594630] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.594641] software IO TLB [mem 0xc64e4000-0xca4e4000] (64MB) mapped at [ffff8800c64e4000-ffff8800ca4e3fff]
[    0.595040] Scanning for low memory corruption every 60 seconds
[    0.595541] audit: initializing netlink socket (disabled)
[    0.595579] type=2000 audit(1363450018.576:1): initialized
[    0.622769] bounce pool size: 64 pages
[    0.622795] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.625697] VFS: Disk quotas dquot_6.5.2
[    0.625762] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.626716] fuse init (API version 7.21)
[    0.626876] msgmni has been set to 7688
[    0.627508] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.627596] io scheduler noop registered
[    0.627601] io scheduler deadline registered (default)
[    0.627683] io scheduler cfq registered
[    0.629750] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.629990] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.630192] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    0.630386] pcieport 0000:00:1c.3: irq 43 for MSI/MSI-X
[    0.630576] pcieport 0000:00:1c.4: irq 44 for MSI/MSI-X
[    0.630772] pcieport 0000:00:1c.7: irq 45 for MSI/MSI-X
[    0.630981] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.630992] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.630998] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    0.631005] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.631041] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.631051] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.631087] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.631093] pci 0000:05:00.0: Signaling PME through PCIe PME interrupt
[    0.631102] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.631136] pcieport 0000:00:1c.3: Signaling PME through PCIe PME interrupt
[    0.631142] pci 0000:09:00.0: Signaling PME through PCIe PME interrupt
[    0.631151] pcie_pme 0000:00:1c.3:pcie01: service driver pcie_pme loaded
[    0.631185] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.631191] pci 0000:0b:00.0: Signaling PME through PCIe PME interrupt
[    0.631200] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.631238] pcieport 0000:00:1c.7: Signaling PME through PCIe PME interrupt
[    0.631248] pcie_pme 0000:00:1c.7:pcie01: service driver pcie_pme loaded
[    0.631272] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.631428] pciehp 0000:00:1c.7:pcie04: HPC vendor_id 8086 device_id 1c1e ss_vid 1028 ss_did 4b0
[    0.631536] pciehp 0000:00:1c.7:pcie04: service driver pciehp loaded
[    0.631546] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.631693] intel_idle: MWAIT substates: 0x21120
[    0.631694] intel_idle: v0.4 model 0x2A
[    0.631696] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.631984] ACPI: AC Adapter [AC] (on-line)
[    0.632253] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    0.634136] ACPI: Lid Switch [LID0]
[    0.634201] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    0.634236] ACPI: Power Button [PWRB]
[    0.634294] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    0.634303] ACPI: Sleep Button [SBTN]
[    0.634361] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    0.634369] ACPI: Power Button [PWRF]
[    0.634491] ACPI: Requesting acpi_cpufreq
[    0.652717] thermal LNXTHERM:00: registered as thermal_zone0
[    0.652724] ACPI: Thermal Zone [THM] (61 C)
[    0.652788] GHES: HEST is not enabled!
[    0.652928] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.662106] Linux agpgart interface v0.103
[    0.664702] brd: module loaded
[    0.666257] loop: module loaded
[    0.666427] ahci 0000:00:1f.2: version 3.0
[    0.666606] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    0.666666] ahci: SSS flag set, parallel bus scan disabled
[    0.674312] ACPI: Battery Slot [BAT0] (battery present)
[    0.681699] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x31 impl SATA mode
[    0.681708] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst 
[    0.681719] ahci 0000:00:1f.2: setting latency timer to 64
[    0.698703] scsi0 : ahci
[    0.698941] scsi1 : ahci
[    0.699055] scsi2 : ahci
[    0.699168] scsi3 : ahci
[    0.699287] scsi4 : ahci
[    0.699400] scsi5 : ahci
[    0.699475] ata1: SATA max UDMA/133 abar m2048@0xf7b06000 port 0xf7b06100 irq 46
[    0.699481] ata2: DUMMY
[    0.699483] ata3: DUMMY
[    0.699486] ata4: DUMMY
[    0.699491] ata5: SATA max UDMA/133 abar m2048@0xf7b06000 port 0xf7b06300 irq 46
[    0.699498] ata6: SATA max UDMA/133 abar m2048@0xf7b06000 port 0xf7b06380 irq 46
[    0.700080] libphy: Fixed MDIO Bus: probed
[    0.700186] tun: Universal TUN/TAP device driver, 1.6
[    0.700190] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.700298] PPP generic driver version 2.4.2
[    0.700426] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.700432] ehci-pci: EHCI PCI platform driver
[    0.700551] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    0.700555] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.700641] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.700664] ehci-pci 0000:00:1a.0: debug port 2
[    0.704610] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.704636] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf7b08000
[    0.713660] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.713785] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.713791] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.713797] usb usb1: Product: EHCI Host Controller
[    0.713802] usb usb1: Manufacturer: Linux 3.9.0-rc2 ehci_hcd
[    0.713806] usb usb1: SerialNumber: 0000:00:1a.0
[    0.714291] hub 1-0:1.0: USB hub found
[    0.714319] hub 1-0:1.0: 2 ports detected
[    0.714810] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    0.714814] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.714827] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.714850] ehci-pci 0000:00:1d.0: debug port 2
[    0.718762] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.718785] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf7b07000
[    0.729644] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.729693] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.729699] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.729705] usb usb2: Product: EHCI Host Controller
[    0.729709] usb usb2: Manufacturer: Linux 3.9.0-rc2 ehci_hcd
[    0.729714] usb usb2: SerialNumber: 0000:00:1d.0
[    0.729945] hub 2-0:1.0: USB hub found
[    0.729954] hub 2-0:1.0: 2 ports detected
[    0.730139] ehci-platform: EHCI generic platform driver
[    0.730154] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.730184] uhci_hcd: USB Universal Host Controller Interface driver
[    0.730292] xhci_hcd 0000:0b:00.0: xHCI Host Controller
[    0.730304] xhci_hcd 0000:0b:00.0: new USB bus registered, assigned bus number 3
[    0.730478] xhci_hcd 0000:0b:00.0: irq 16, io mem 0xf7900000
[    0.730602] xhci_hcd 0000:0b:00.0: irq 47 for MSI/MSI-X
[    0.730612] xhci_hcd 0000:0b:00.0: irq 48 for MSI/MSI-X
[    0.730621] xhci_hcd 0000:0b:00.0: irq 49 for MSI/MSI-X
[    0.730630] xhci_hcd 0000:0b:00.0: irq 50 for MSI/MSI-X
[    0.730639] xhci_hcd 0000:0b:00.0: irq 51 for MSI/MSI-X
[    0.730807] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    0.730813] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.730819] usb usb3: Product: xHCI Host Controller
[    0.730823] usb usb3: Manufacturer: Linux 3.9.0-rc2 xhci_hcd
[    0.730828] usb usb3: SerialNumber: 0000:0b:00.0
[    0.730971] xHCI xhci_add_endpoint called for root hub
[    0.730973] xHCI xhci_check_bandwidth called for root hub
[    0.731015] hub 3-0:1.0: USB hub found
[    0.731053] hub 3-0:1.0: 2 ports detected
[    0.731209] xhci_hcd 0000:0b:00.0: xHCI Host Controller
[    0.731219] xhci_hcd 0000:0b:00.0: new USB bus registered, assigned bus number 4
[    0.733941] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    0.733947] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.733953] usb usb4: Product: xHCI Host Controller
[    0.733957] usb usb4: Manufacturer: Linux 3.9.0-rc2 xhci_hcd
[    0.733962] usb usb4: SerialNumber: 0000:0b:00.0
[    0.734100] xHCI xhci_add_endpoint called for root hub
[    0.734102] xHCI xhci_check_bandwidth called for root hub
[    0.734150] hub 4-0:1.0: USB hub found
[    0.734163] hub 4-0:1.0: 2 ports detected
[    0.734468] i8042: PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2] at 0x60,0x64 irq 1,12
[    0.737100] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.737143] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.737510] mousedev: PS/2 mouse device common for all mice
[    0.738115] rtc_cmos 00:04: RTC can wake from S4
[    0.738377] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.738418] rtc_cmos 00:04: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.738561] device-mapper: uevent: version 1.0.3
[    0.738708] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
[    0.738950] cpuidle: using governor ladder
[    0.739435] cpuidle: using governor menu
[    0.739439] EFI Variables Facility v0.08 2004-May-17
[    0.739528] TCP: cubic registered
[    0.739710] NET: Registered protocol family 10
[    0.740065] NET: Registered protocol family 17
[    0.740145] Key type dns_resolver registered
[    0.740596] PM: Hibernation image not present or could not be loaded.
[    0.740625] registered taskstats version 1
[    0.743800] Key type trusted registered
[    0.746581] Key type encrypted registered
[    0.750128]   Magic number: 5:943:135
[    0.750151] block ram0: hash matches
[    0.751007] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.751013] EDD information not available.
[    0.755505] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    1.017633] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.020582] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.021027] ata1.00: ATA-8: WDC WD5000BPVT-75HXZT1, 01.01A01, max UDMA/133
[    1.021053] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.024109] ata1.00: ACPI cmd 00/00:00:00:00:00:a0 (NOP) rejected by device (Stat=0x51 Err=0x04)
[    1.024556] ata1.00: configured for UDMA/133
[    1.025612] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.030231] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000BPVT-7 01.0 PQ: 0 ANSI: 5
[    1.030836] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.030845] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.031033] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.031048] sd 0:0:0:0: [sda] Write Protect is off
[    1.031054] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.031131] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.123155]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
[    1.125015] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.158326] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.158351] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.158864] hub 1-1:1.0: USB hub found
[    1.159045] hub 1-1:1.0: 6 ports detected
[    1.269505] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.349451] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.351698] ata5.00: ATAPI: HL-DT-STDVD+/-RW GT32N, A203, max UDMA/100
[    1.355257] ata5.00: configured for UDMA/100
[    1.360253] scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GT32N    A203 PQ: 0 ANSI: 5
[    1.364390] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.364401] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.364845] sr 4:0:0:0: Attached scsi CD-ROM sr0
[    1.365073] sr 4:0:0:0: Attached scsi generic sg1 type 5
[    1.402179] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.402210] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.402745] hub 2-1:1.0: USB hub found
[    1.402910] hub 2-1:1.0: 8 ports detected
[    1.477660] usb 1-1.4: new full-speed USB device number 3 using ehci-pci
[    1.570627] usb 1-1.4: New USB device found, idVendor=0cf3, idProduct=3002
[    1.570650] usb 1-1.4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.593394] tsc: Refined TSC clocksource calibration: 2294.787 MHz
[    1.593420] Switching to clocksource tsc
[    1.641577] usb 1-1.5: new high-speed USB device number 4 using ehci-pci
[    1.685291] ata6: SATA link down (SStatus 0 SControl 300)
[    1.686839] Freeing unused kernel memory: 1116k freed
[    1.686996] Write protecting the kernel read-only data: 12288k
[    1.690352] Freeing unused kernel memory: 1296k freed
[    1.693327] Freeing unused kernel memory: 1216k freed
[    1.717160] udevd[116]: starting version 175
[    1.785135] usb 1-1.5: New USB device found, idVendor=0c45, idProduct=6483
[    1.785149] usb 1-1.5: New USB device strings: Mfr=2, Product=1, SerialNumber=0
[    1.785160] usb 1-1.5: Product: Laptop_Integrated_Webcam_HD
[    1.785168] usb 1-1.5: Manufacturer: CNFA151H2820400001I2
[    1.828873] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.829436] r8169 0000:05:00.0: irq 52 for MSI/MSI-X
[    1.834402] r8169 0000:05:00.0 eth0: RTL8105e at 0xffffc90000020000, 18:03:73:64:43:86, XID 00a00000 IRQ 52
[    4.631606] EXT4-fs (sda6): INFO: recovery required on readonly filesystem
[    4.631614] EXT4-fs (sda6): write access will be enabled during recovery
[    5.456029] EXT4-fs (sda6): recovery complete
[    5.465125] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[   19.296060] Adding 4097020k swap on /dev/sda7.  Priority:-1 extents:1 across:4097020k 
[   20.009711] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro
[   20.538080] EXT4-fs (sda5): mounted filesystem with ordered data mode. Opts: (null)
[   20.701353] udevd[562]: starting version 175
[   21.002269] wmi: Mapper loaded
[   21.189614] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130117/utaddress-251)
[   21.189624] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   21.189628] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
[   21.189632] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 2 (20130117/utaddress-251)
[   21.189635] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   21.189637] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
[   21.189640] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 2 (20130117/utaddress-251)
[   21.189643] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   21.189644] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
[   21.189647] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \_SB_.PCI0.PEG0.PEGP.GPIO 2 (20130117/utaddress-251)
[   21.189650] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   21.189651] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   21.197638] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x14
[   21.200782] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x14
[   21.202739] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x14
[   21.204827] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x14
[   21.207329] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   21.328394] mei 0000:00:16.0: setting latency timer to 64
[   21.328537] mei 0000:00:16.0: irq 53 for MSI/MSI-X
[   21.384142] input: Dell WMI hotkeys as /devices/virtual/input/input5
[   21.474112] lp: driver loaded but no devices found
[   21.678280] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   21.780420] type=1400 audit(1363435639.770:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=769 comm="apparmor_parser"
[   21.780435] type=1400 audit(1363435639.770:3): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=662 comm="apparmor_parser"
[   21.780720] type=1400 audit(1363435639.770:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=769 comm="apparmor_parser"
[   21.780730] type=1400 audit(1363435639.770:5): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=662 comm="apparmor_parser"
[   21.780886] type=1400 audit(1363435639.770:6): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=769 comm="apparmor_parser"
[   21.780899] type=1400 audit(1363435639.770:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=662 comm="apparmor_parser"
[   21.913974] Bluetooth: Core ver 2.16
[   21.914004] NET: Registered protocol family 31
[   21.914007] Bluetooth: HCI device and connection manager initialized
[   21.914075] Bluetooth: HCI socket layer initialized
[   21.914081] Bluetooth: L2CAP socket layer initialized
[   21.914093] Bluetooth: SCO socket layer initialized
[   21.991626] usbcore: registered new interface driver btusb
[   22.548760] [drm] Initialized drm 1.1.0 20060810
[   22.771145] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input6
[   22.784119] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input7
[   23.307717] snd_hda_intel 0000:00:1b.0: irq 54 for MSI/MSI-X
[   23.856130] cfg80211: Calling CRDA to update world regulatory domain
[   23.862576] cfg80211: World regulatory domain updated:
[   23.862580] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   23.862582] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.862584] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   23.862586] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   23.862588] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.862589] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   23.944565] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   23.944875] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   23.945977] hda_intel: Disabling MSI
[   23.945988] hda-intel 0000:01:00.1: Handle VGA-switcheroo audio client
[   24.544979] [drm] Memory usable by graphics device = 2048M
[   24.545031] i915 0000:00:02.0: setting latency timer to 64
[   24.587924] i915 0000:00:02.0: irq 55 for MSI/MSI-X
[   24.587943] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   24.587944] [drm] Driver supports precise vblank timestamp query.
[   24.589683] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   24.589685] vgaarb: transferring owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
[   24.606466] [drm] Wrong MCH_SSKPD value: 0x16040307
[   24.606469] [drm] This can cause pipe underruns and display issues.
[   24.606470] [drm] Please upgrade your BIOS to fix this.
[   24.623552] fbcon: inteldrmfb (fb0) is primary device
[   25.001406] input: HDA NVidia HDMI/DP,pcm=9 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input10
[   25.001615] input: HDA NVidia HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input11
[   25.001762] input: HDA NVidia HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
[   25.001933] input: HDA NVidia HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input13
[   25.501149] Console: switching to colour frame buffer device 170x48
[   25.504113] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[   25.504115] i915 0000:00:02.0: registered panic notifier
[   25.504583] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
[   25.506261] acpi device:1b: registered as cooling_device4
[   25.506598] ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: no)
[   25.506971] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:19/LNXVIDEO:00/input/input14
[   25.508693] acpi device:3a: registered as cooling_device5
[   25.509030] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   25.509152] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:01/input/input15
[   25.509409] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   25.825228] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   27.056580] Bluetooth: Can't change to loading configuration err
[   27.056659] ath3k: probe of 1-1.4:1.0 failed with error -110
[   27.056724] usbcore: registered new interface driver ath3k
[   27.935833] ath: phy0: ASPM enabled: 0x42
[   27.935837] ath: EEPROM regdomain: 0x60
[   27.935838] ath: EEPROM indicates we should expect a direct regpair map
[   27.935840] ath: Country alpha2 being used: 00
[   27.935841] ath: Regpair used: 0x60
[   27.935843] cfg80211: Updating information on frequency 2412 MHz with regulatory rule:
[   27.935845] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935846] cfg80211: Updating information on frequency 2417 MHz with regulatory rule:
[   27.935848] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935849] cfg80211: Updating information on frequency 2422 MHz with regulatory rule:
[   27.935850] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935852] cfg80211: Updating information on frequency 2427 MHz with regulatory rule:
[   27.935853] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935854] cfg80211: Updating information on frequency 2432 MHz with regulatory rule:
[   27.935856] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935857] cfg80211: Updating information on frequency 2437 MHz with regulatory rule:
[   27.935858] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935859] cfg80211: Updating information on frequency 2442 MHz with regulatory rule:
[   27.935861] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935862] cfg80211: Updating information on frequency 2447 MHz with regulatory rule:
[   27.935863] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935864] cfg80211: Updating information on frequency 2452 MHz with regulatory rule:
[   27.935866] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935867] cfg80211: Updating information on frequency 2457 MHz with regulatory rule:
[   27.935868] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935870] cfg80211: Updating information on frequency 2462 MHz with regulatory rule:
[   27.935871] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935872] cfg80211: Updating information on frequency 2467 MHz with regulatory rule:
[   27.935874] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935875] cfg80211: Updating information on frequency 2472 MHz with regulatory rule:
[   27.935876] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.935877] cfg80211: Updating information on frequency 2484 MHz with regulatory rule:
[   27.935879] cfg80211: 2474000 KHz - 2494000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[   27.937711] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[   28.106998] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[   28.107947] ieee80211 phy0: Atheros AR9285 Rev:2 mem=0xffffc900046a0000, irq=19
[   28.170781] init: failsafe main process (959) killed by TERM signal
[   28.345438] type=1400 audit(1363435646.338:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1042 comm="apparmor_parser"
[   28.347880] type=1400 audit(1363435646.342:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1042 comm="apparmor_parser"
[   28.348110] type=1400 audit(1363435646.342:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1042 comm="apparmor_parser"
[   28.445029] type=1400 audit(1363435646.438:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-freerdp/freerdp-session-wrapper" pid=1040 comm="apparmor_parser"
[   28.445253] type=1400 audit(1363435646.438:12): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-uccsconfigure/uccsconfigure-session-wrapper" pid=1041 comm="apparmor_parser"
[   28.445290] type=1400 audit(1363435646.438:13): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-freerdp/freerdp-session-wrapper//chromium_browser" pid=1040 comm="apparmor_parser"
[   28.445495] type=1400 audit(1363435646.438:14): apparmor="STATUS" operation="profile_load" name="/usr/lib/x86_64-linux-gnu/lightdm-remote-session-uccsconfigure/uccsconfigure-session-wrapper//chromium_browser" pid=1041 comm="apparmor_parser"
[   28.445520] type=1400 audit(1363435646.438:15): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1039 comm="apparmor_parser"
[   28.445802] type=1400 audit(1363435646.438:16): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper//chromium_browser" pid=1039 comm="apparmor_parser"
[   28.525436] type=1400 audit(1363435646.518:17): apparmor="STATUS" operation="profile_load" name="/usr/lib/libvirt/virt-aa-helper" pid=1045 comm="apparmor_parser"
[   28.554384] r8169 0000:05:00.0 eth0: link down
[   28.554422] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   28.573214] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   28.576879] Bluetooth: RFCOMM TTY layer initialized
[   28.576901] Bluetooth: RFCOMM socket layer initialized
[   28.576903] Bluetooth: RFCOMM ver 1.11
[   28.597571] ppdev: user-space parallel port driver
[   28.658137] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   28.658141] Bluetooth: BNEP filters: protocol multicast
[   28.658151] Bluetooth: BNEP socket layer initialized
[   29.496305] cgroup: libvirtd (1246) created nested cgroup for controller "devices" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   29.496422] cgroup: libvirtd (1246) created nested cgroup for controller "blkio" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.
[   29.733799] init: plymouth-stop pre-start process (1434) terminated with status 1
[   30.515297] wlan0: authenticate with bc:f6:85:c4:64:44
[   30.538198] wlan0: send auth to bc:f6:85:c4:64:44 (try 1/3)
[   30.546538] wlan0: authenticated
[   30.550461] wlan0: associate with bc:f6:85:c4:64:44 (try 1/3)
[   30.554641] wlan0: RX AssocResp from bc:f6:85:c4:64:44 (capab=0x431 status=0 aid=1)
[   30.554910] wlan0: associated
[   30.554932] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   31.407947] MXM: GUID detected in BIOS
[   31.408216] VGA switcheroo: detected Optimus DSM method \_SB_.PCI0.PEG0.PEGP handle
[   31.408376] nouveau 0000:01:00.0: enabling device (0006 -> 0007)
[   31.409074] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0c1a80a1
[   31.409078] nouveau  [  DEVICE][0000:01:00.0] Chipset: GF108 (NVC1)
[   31.409080] nouveau  [  DEVICE][0000:01:00.0] Family : NVC0
[   31.411906] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
[   31.421636] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[   31.421640] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
[   31.421699] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[   31.421701] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
[   31.762826] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[   31.762830] nouveau  [   VBIOS][0000:01:00.0] using image from ACPI
[   31.762951] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[   31.762955] nouveau  [   VBIOS][0000:01:00.0] version 70.08.56.00.0a
[   31.763984] nouveau  [ DEVINIT][0000:01:00.0] adaptor not initialised
[   31.763987] nouveau  [   VBIOS][0000:01:00.0] running init tables
[   31.878458] nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
[   31.878463] nouveau  [     PFB][0000:01:00.0] RAM size: 512 MiB
[   31.878465] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
[   31.909139] nouveau  [  PTHERM][0000:01:00.0] FAN control: none / external
[   31.909148] nouveau  [  PTHERM][0000:01:00.0] Thermal management: disabled
[   31.909223] nouveau  [  PTHERM][0000:01:00.0] programmed thresholds [ 90(3), 95(3), 105(5), 135(5) ]
[   31.913512] vga_switcheroo: enabled
[   31.913970] [TTM] Zone  kernel: Available graphics memory: 1970084 kiB
[   31.913972] [TTM] Initializing pool allocator
[   31.913995] [TTM] Initializing DMA pool allocator
[   31.916229] nouveau  [     DRM] VRAM: 512 MiB
[   31.916240] nouveau  [     DRM] GART: 512 MiB
[   31.916245] nouveau  [     DRM] TMDS table version 2.0
[   31.916247] nouveau  [     DRM] DCB version 4.0
[   31.916250] nouveau  [     DRM] DCB outp 00: 02011300 00000000
[   31.916252] nouveau  [     DRM] DCB outp 01: 02022362 00020010
[   31.916254] nouveau  [     DRM] DCB conn 00: 00000040
[   31.916257] nouveau  [     DRM] DCB conn 01: 00000100
[   31.916259] nouveau  [     DRM] DCB conn 02: 00001261
[   31.918240] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   31.918244] [drm] No driver support for vblank timestamp query.
[   31.918259] nouveau  [     DRM] ACPI backlight interface available, not registering our own
[   31.918532] nouveau  [     DRM] 3 available performance level(s)
[   31.918536] nouveau  [     DRM] 0: core 50MHz shader 101MHz memory 135MHz voltage 850mV
[   31.918539] nouveau  [     DRM] 1: core 202MHz shader 405MHz memory 324MHz voltage 850mV
[   31.918542] nouveau  [     DRM] 3: core 600MHz shader 1200MHz memory 900MHz voltage 950mV
[   31.918544] nouveau  [     DRM] c: core 202MHz shader 405MHz memory 324MHz voltage 950mV
[   31.924360] nouveau  [     DRM] MM: using COPY1 for buffer copies
[   31.926493] nouveau 0000:01:00.0: No connectors reported connected with modes
[   31.926497] [drm] Cannot find any crtc or sizes - going 1024x768
[   31.961255] nouveau  [     DRM] allocated 1024x768 fb: 0x60000, bo ffff880118da2400
[   31.961424] nouveau 0000:01:00.0: fb1: nouveaufb frame buffer device
[   31.961430] [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 1
[  107.634890] 
[  107.634894] =============================================
[  107.634896] [ INFO: possible recursive locking detected ]
[  107.634897] 3.9.0-rc2 #22 Not tainted
[  107.634898] ---------------------------------------------
[  107.634900] kworker/0:1/54 is trying to acquire lock:
[  107.634901]  (&dmac->lock){+.+...}, at: [<ffffffffa05fffb3>] evo_wait+0x43/0xf0 [nouveau]
[  107.634923] 
[  107.634923] but task is already holding lock:
[  107.634924]  (&dmac->lock){+.+...}, at: [<ffffffffa05fffb3>] evo_wait+0x43/0xf0 [nouveau]
[  107.634937] 
[  107.634937] other info that might help us debug this:
[  107.634938]  Possible unsafe locking scenario:
[  107.634938] 
[  107.634940]        CPU0
[  107.634941]        ----
[  107.634941]   lock(&dmac->lock);
[  107.634943]   lock(&dmac->lock);
[  107.634945] 
[  107.634945]  *** DEADLOCK ***
[  107.634945] 
[  107.634946]  May be due to missing lock nesting notation
[  107.634946] 
[  107.634948] 5 locks held by kworker/0:1/54:
[  107.634949]  #0:  (events){.+.+.+}, at: [<ffffffff8106e311>] process_one_work+0x171/0x4c0
[  107.634954]  #1:  ((&nv_connector->hpd_work)){+.+.+.}, at: [<ffffffff8106e311>] process_one_work+0x171/0x4c0
[  107.634958]  #2:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffffa022ee2a>] drm_modeset_lock_all+0x2a/0x70 [drm]
[  107.634970]  #3:  (&crtc->mutex){+.+.+.}, at: [<ffffffffa022ee54>] drm_modeset_lock_all+0x54/0x70 [drm]
[  107.634978]  #4:  (&dmac->lock){+.+...}, at: [<ffffffffa05fffb3>] evo_wait+0x43/0xf0 [nouveau]
[  107.634990] 
[  107.634990] stack backtrace:
[  107.634992] Pid: 54, comm: kworker/0:1 Not tainted 3.9.0-rc2 #22
[  107.634994] Call Trace:
[  107.634998]  [<ffffffff810b71e5>] __lock_acquire+0x715/0x1be0
[  107.635006]  [<ffffffffa056361c>] ? dcb_table+0x1ac/0x2a0 [nouveau]
[  107.635008]  [<ffffffff810b8c31>] lock_acquire+0xa1/0x130
[  107.635019]  [<ffffffffa05fffb3>] ? evo_wait+0x43/0xf0 [nouveau]
[  107.635023]  [<ffffffff816aac59>] ? mutex_lock_nested+0x299/0x340
[  107.635026]  [<ffffffff816aaa09>] mutex_lock_nested+0x49/0x340
[  107.635036]  [<ffffffffa05fffb3>] ? evo_wait+0x43/0xf0 [nouveau]
[  107.635038]  [<ffffffff810b954f>] ? mark_held_locks+0xaf/0x110
[  107.635047]  [<ffffffffa05fffb3>] evo_wait+0x43/0xf0 [nouveau]
[  107.635056]  [<ffffffffa0602a63>] nv50_display_flip_next+0x713/0x7a0 [nouveau]
[  107.635059]  [<ffffffff816ab95e>] ? mutex_unlock+0xe/0x10
[  107.635068]  [<ffffffffa0600097>] ? evo_kick+0x37/0x40 [nouveau]
[  107.635077]  [<ffffffffa0602cee>] nv50_crtc_commit+0x10e/0x230 [nouveau]
[  107.635081]  [<ffffffffa0158125>] drm_crtc_helper_set_mode+0x365/0x510 [drm_kms_helper]
[  107.635085]  [<ffffffffa015953e>] drm_crtc_helper_set_config+0xa4e/0xb70 [drm_kms_helper]
[  107.635092]  [<ffffffffa022fe71>] drm_mode_set_config_internal+0x31/0x70 [drm]
[  107.635095]  [<ffffffffa0157621>] drm_fb_helper_set_par+0x71/0xf0 [drm_kms_helper]
[  107.635102]  [<ffffffffa022eaa2>] ? drm_modeset_unlock_all+0x52/0x60 [drm]
[  107.635105]  [<ffffffffa0157581>] drm_fb_helper_hotplug_event+0x81/0xb0 [drm_kms_helper]
[  107.635116]  [<ffffffffa05e964c>] nouveau_fbcon_output_poll_changed+0x1c/0x20 [nouveau]
[  107.635119]  [<ffffffffa0157bbb>] drm_kms_helper_hotplug_event+0x2b/0x40 [drm_kms_helper]
[  107.635122]  [<ffffffffa0158ada>] drm_helper_hpd_irq_event+0x12a/0x140 [drm_kms_helper]
[  107.635131]  [<ffffffffa05ec323>] nouveau_connector_hotplug_work+0x93/0x100 [nouveau]
[  107.635134]  [<ffffffff8106e371>] process_one_work+0x1d1/0x4c0
[  107.635135]  [<ffffffff8106e311>] ? process_one_work+0x171/0x4c0
[  107.635138]  [<ffffffff8106fd0f>] worker_thread+0x10f/0x380
[  107.635140]  [<ffffffff8106fc00>] ? busy_worker_rebind_fn+0xb0/0xb0
[  107.635142]  [<ffffffff8107aaca>] kthread+0xea/0xf0
[  107.635144]  [<ffffffff8107a9e0>] ? kthread_create_on_node+0x160/0x160
[  107.635147]  [<ffffffff816b80ac>] ret_from_fork+0x7c/0xb0
[  107.635148]  [<ffffffff8107a9e0>] ? kthread_create_on_node+0x160/0x160

--------------060109090507040008020506--
