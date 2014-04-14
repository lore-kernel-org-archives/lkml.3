Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaDNXz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 19:55:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42067 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaDNXz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 19:55:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Eric Piel <eric.piel@tremplin-utc.net>,
        Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: BUG: using __this_cpu_write() in preemptible [00000000] code: systemd-udevd/497
Date: Tue, 15 Apr 2014 00:55:50 +0100
Message-ID: <87mwfn4gah.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc'ing both lis3lv02d and ACPI maintainers)

Since commit 188a81409ff7de1c5aae947a96356ddd8ff4aaa3 ("percpu: add
preemption checks to __this_cpu ops") I've been seeing the following:

[   10.485588] hp_accel: hardware type HPB64xx found
[   10.485772] BUG: using __this_cpu_write() in preemptible [00000000] code: systemd-udevd/497
[   10.485777] caller is __this_cpu_preempt_check+0x13/0x20
[   10.485781] CPU: 3 PID: 497 Comm: systemd-udevd Tainted: G        W     3.15.0-rc1 #9
[   10.485783] Hardware name: Hewlett-Packard HP EliteBook 8470p/179B, BIOS 68ICF Ver. F.02 04/27/2012
[   10.485785]  ffffffff81a14db5 ffff88022c80b8e0 ffffffff81604ba4 0000000000000003
[   10.485789]  ffff88022c80b908 ffffffff81313431 0000000000000000 0000000000000032
[   10.485793]  00000000000003e8 ffff88022c80b918 ffffffff81313473 ffff88022c80b928
[   10.485796] Call Trace:
[   10.485802]  [<ffffffff81604ba4>] dump_stack+0x4e/0x7a
[   10.485805]  [<ffffffff81313431>] check_preemption_disabled+0xe1/0xf0
[   10.485808]  [<ffffffff81313473>] __this_cpu_preempt_check+0x13/0x20
[   10.485813]  [<ffffffff810e4eb8>] touch_nmi_watchdog+0x28/0x40
[   10.485817]  [<ffffffff81369c29>] acpi_os_stall+0x37/0x40
[   10.485822]  [<ffffffff813843e2>] acpi_ex_system_do_stall+0x39/0x3d
[   10.485825]  [<ffffffff81381138>] acpi_ex_opcode_1A_0T_0R+0x72/0xa3
[   10.485829]  [<ffffffff81379a5d>] acpi_ds_exec_end_op+0xd0/0x3e8
[   10.485833]  [<ffffffff8138b118>] acpi_ps_parse_loop+0x51d/0x576
[   10.485836]  [<ffffffff8138bbc4>] acpi_ps_parse_aml+0x98/0x289
[   10.485839]  [<ffffffff8138c41e>] acpi_ps_execute_method+0x1c1/0x26c
[   10.485843]  [<ffffffff81386dcd>] acpi_ns_evaluate+0x1c1/0x258
[   10.485846]  [<ffffffff8138960d>] acpi_evaluate_object+0x126/0x22f
[   10.485850]  [<ffffffff810a4492>] ? wake_up_klogd+0x52/0x70
[   10.485853]  [<ffffffff8136a520>] acpi_evaluate_integer+0x34/0x52
[   10.485858]  [<ffffffffa01671e9>] lis3lv02d_acpi_read+0x59/0x70 [hp_accel]
[   10.485863]  [<ffffffffa014e426>] lis3lv02d_init_device+0x26/0xc00 [lis3lv02d]
[   10.485866]  [<ffffffff8138dc93>] ? acpi_walk_resources+0x77/0x8d
[   10.485870]  [<ffffffffa0167265>] ? lis3lv02d_dmi_matched+0x35/0x40 [hp_accel]
[   10.485874]  [<ffffffffa0167381>] lis3lv02d_add+0xe1/0x1d0 [hp_accel]
[   10.485878]  [<ffffffff8136d83f>] acpi_device_probe+0x41/0xee
[   10.485882]  [<ffffffff813eba1d>] driver_probe_device+0xfd/0x240
[   10.485886]  [<ffffffff813ebc33>] __driver_attach+0x93/0xa0
[   10.485889]  [<ffffffff813ebba0>] ? __device_attach+0x40/0x40
[   10.485893]  [<ffffffff813e9b93>] bus_for_each_dev+0x63/0xa0
[   10.485897]  [<ffffffff813eb4ae>] driver_attach+0x1e/0x20
[   10.485900]  [<ffffffff813eb0e8>] bus_add_driver+0x178/0x230
[   10.485904]  [<ffffffffa001d000>] ? 0xffffffffa001cfff
[   10.485908]  [<ffffffff813ec264>] driver_register+0x64/0xf0
[   10.485911]  [<ffffffffa001d000>] ? 0xffffffffa001cfff
[   10.485915]  [<ffffffff8136e081>] acpi_bus_register_driver+0x3b/0x43
[   10.485919]  [<ffffffffa001d010>] lis3lv02d_driver_init+0x10/0x1000 [hp_accel]
[   10.485923]  [<ffffffff81000352>] do_one_initcall+0x112/0x160
[   10.485927]  [<ffffffff8103c763>] ? set_memory_nx+0x43/0x50
[   10.485932]  [<ffffffff810c79f0>] load_module+0x1b20/0x22f0
[   10.485936]  [<ffffffff810c4860>] ? ref_module+0x120/0x120
[   10.485940]  [<ffffffff810c4b6a>] ? copy_module_from_fd.isra.46+0x10a/0x160
[   10.485944]  [<ffffffff810c82ee>] SyS_finit_module+0x7e/0x80
[   10.485949]  [<ffffffff81614356>] system_call_fastpath+0x1a/0x1f

Before this BUG, I also have the following, which doesn't seem related
(but I may be wrong):

[    1.868407] software IO TLB [mem 0xb4e1e000-0xb8e1e000] (64MB) mapped at [ffff8800b4e1e000-ffff8800b8e1dfff]
[    1.868703] resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff reserved
[    1.868705] ------------[ cut here ]------------
[    1.868709] WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x2d3/0x380()
[    1.868710] Info: mapping multiple BARs. Your kernel is fine.
[    1.868711] Modules linked in:
[    1.868715] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1 #9
[    1.868716] Hardware name: Hewlett-Packard HP EliteBook 8470p/179B, BIOS 68ICF Ver. F.02 04/27/2012
[    1.868717]  0000000000000009 ffff8802330fdb68 ffffffff81604ba4 ffff8802330fdbb0
[    1.868720]  ffff8802330fdba0 ffffffff8104b05d ffffc90010e88000 00000000fed16000
[    1.868722]  ffffc90010e88000 ffffc90010e88000 0000000000006000 ffff8802330fdc00
[    1.868724] Call Trace:
[    1.868729]  [<ffffffff81604ba4>] dump_stack+0x4e/0x7a
[    1.868733]  [<ffffffff8104b05d>] warn_slowpath_common+0x7d/0xa0
[    1.868735]  [<ffffffff8104b0cc>] warn_slowpath_fmt+0x4c/0x50
[    1.868738]  [<ffffffff8105210c>] ? iomem_map_sanity_check+0xac/0xe0
[    1.868740]  [<ffffffff81039ce3>] __ioremap_caller+0x2d3/0x380
[    1.868742]  [<ffffffff81039da7>] ioremap_nocache+0x17/0x20
[    1.868745]  [<ffffffff8101eb15>] snb_uncore_imc_init_box+0x65/0x90
[    1.868748]  [<ffffffff810218f6>] uncore_pci_probe+0xd6/0x1c0
[    1.868751]  [<ffffffff81335ea5>] local_pci_probe+0x45/0xa0
[    1.868754]  [<ffffffff81337145>] ? pci_match_device+0xc5/0xd0
[    1.868756]  [<ffffffff81337269>] pci_device_probe+0xd9/0x130
[    1.868760]  [<ffffffff813eba1d>] driver_probe_device+0xfd/0x240
[    1.868763]  [<ffffffff813ebc33>] __driver_attach+0x93/0xa0
[    1.868765]  [<ffffffff813ebba0>] ? __device_attach+0x40/0x40
[    1.868768]  [<ffffffff813e9b93>] bus_for_each_dev+0x63/0xa0
[    1.868770]  [<ffffffff813eb4ae>] driver_attach+0x1e/0x20
[    1.868773]  [<ffffffff813eb0e8>] bus_add_driver+0x178/0x230
[    1.868776]  [<ffffffff81cf80c9>] ? uncore_types_init+0x1a7/0x1a7
[    1.868779]  [<ffffffff813ec264>] driver_register+0x64/0xf0
[    1.868781]  [<ffffffff81cf80c9>] ? uncore_types_init+0x1a7/0x1a7
[    1.868783]  [<ffffffff8133582c>] __pci_register_driver+0x4c/0x50
[    1.868786]  [<ffffffff81cf823e>] intel_uncore_init+0x175/0x42b
[    1.868788]  [<ffffffff81cf80c9>] ? uncore_types_init+0x1a7/0x1a7
[    1.868791]  [<ffffffff81000352>] do_one_initcall+0x112/0x160
[    1.868795]  [<ffffffff8106bbb8>] ? parse_args+0x1e8/0x320
[    1.868797]  [<ffffffff81cef01f>] kernel_init_freeable+0x168/0x1ed
[    1.868799]  [<ffffffff81cee83d>] ? do_early_param+0x88/0x88
[    1.868802]  [<ffffffff815fce10>] ? rest_init+0x90/0x90
[    1.868804]  [<ffffffff815fce1e>] kernel_init+0xe/0xf0
[    1.868808]  [<ffffffff816142ac>] ret_from_fork+0x7c/0xb0
[    1.868810]  [<ffffffff815fce10>] ? rest_init+0x90/0x90
[    1.868815] ---[ end trace bb08bccc68a8cd3b ]---

Cheers,
-- 
Luis
