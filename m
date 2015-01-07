Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbbAGRcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:32:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56193 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbbAGRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:31:30 -0500
From: Suman Anna <s-anna@ti.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Felipe Balbi <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [RFC PATCH 0/3] of_platform_depopulate crash fixes
Date: Wed, 7 Jan 2015 11:30:51 -0600
Message-ID: <1420651854-17768-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, Rob,

I ran into two different kernel crashes when trying to use of_platform_depopulate()
in my out-of-tree PRU remoteproc platform driver. The crashes are seen when the
child nodes created in my driver do get supplied with some platform data (provided
through auxdata), and have IOMEM resources of their own.
 
Patches 1 and 2 have fixed the issues for me, and I would like to know if this
is indeed the right approach to be taken, these touch both the OF and platform
core.

1. release_resource crash

[   81.510769] Unable to handle kernel NULL pointer dereference at virtual address 00000018
[   81.519270] pgd = de4a0000
[   81.522115] [00000018] *pgd=9e4c5831, *pte=00000000, *ppte=00000000
[   81.528688] Internal error: Oops: 17 [#1] SMP ARM
[   81.533600] Modules linked in: pruss_remoteproc(-) remoteproc virtio_ring virtio [last unloaded: virtio_rpmsg_bus]
[   81.544451] CPU: 0 PID: 78 Comm: rmmod Not tainted 3.19.0-rc3-00024-g05af4a776de5 #330
[   81.552714] Hardware name: Generic AM33XX (Flattened Device Tree)
[   81.559074] task: de519140 ti: de4f0000 task.ti: de4f0000
[   81.564724] PC is at release_resource+0x14/0x7c
[   81.569452] LR is at release_resource+0x10/0x7c
[   81.574181] pc : [<c00429c4>]    lr : [<c00429c0>]    psr: 60000013
[   81.574181] sp : de4f1ec0  ip : 00000000  fp : 00000000
[   81.586163] r10: 00000000  r9 : de4f0000  r8 : c000e904
[   81.591615] r7 : 00000081  r6 : c04d673c  r5 : de52ac00  r4 : de4aec40
[   81.598427] r3 : 00000000  r2 : 00000000  r1 : ffffffff  r0 : c0923530
[   81.605241] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[   81.612688] Control: 10c5387d  Table: 9e4a0019  DAC: 00000015
[   81.618684] Process rmmod (pid: 78, stack limit = 0xde4f0240)
[   81.624680] Stack: (0xde4f1ec0 to 0xde4f2000)
[   81.629231] 1ec0: 00000000 00000001 de52ac00 c03a083c c094a7d0 de52ac00 00000000 c03a0b78
[   81.637770] 1ee0: de52ac10 c04d67b8 00000000 c039b7e0 de1100c0 de4ae370 de12cc10 de12cc00
[   81.646308] 1f00: c0915564 c04d6724 de12cc10 bf01f154 de12cc10 bf02135c de12cc44 c03a0714
[   81.654846] 1f20: c03a06fc de12cc10 bf02135c c039ec8c bf02135c de12cc10 bf02135c c039f494
[   81.663384] 1f40: bf02135c be854be8 00000880 c039eb14 bf021480 c00b4198 c0164bc0 73757270
[   81.671922] 1f60: 65725f73 65746f6d 636f7270 00000000 00000001 de519140 c000e7d0 00000001
[   81.680460] 1f80: 10c5387d c0083074 000195dc 73757270 65725f73 0000e85c 000195dc 73757270
[   81.688998] 1fa0: 65725f73 c000e740 000195dc 73757270 be854be8 00000880 be854be8 00000880
[   81.697536] 1fc0: 000195dc 73757270 65725f73 00000081 000aa7f8 00000000 0000d1b0 00000000
[   81.706075] 1fe0: be854be0 be854bd0 00019368 b6f39bc0 60000010 be854be8 00000000 00000000
[   81.714630] [<c00429c4>] (release_resource) from [<c03a083c>] (platform_device_del+0x6c/0x9c)
[   81.723537] [<c03a083c>] (platform_device_del) from [<c03a0b78>] (platform_device_unregister+0xc/0x18)
[   81.733268] [<c03a0b78>] (platform_device_unregister) from [<c04d67b8>] (of_platform_device_destroy+0x7c/0x88)
[   81.743727] [<c04d67b8>] (of_platform_device_destroy) from [<c039b7e0>] (device_for_each_child+0x34/0x74)
[   81.753720] [<c039b7e0>] (device_for_each_child) from [<c04d6724>] (of_platform_depopulate+0x2c/0x44)
[   81.763359] [<c04d6724>] (of_platform_depopulate) from [<bf01f154>] (pruss_remove+0x28/0x58 [pruss_remoteproc])
[   81.773900] [<bf01f154>] (pruss_remove [pruss_remoteproc]) from [<c03a0714>] (platform_drv_remove+0x18/0x30)
[   81.784163] [<c03a0714>] (platform_drv_remove) from [<c039ec8c>] (__device_release_driver+0x70/0xc4)
[   81.793701] [<c039ec8c>] (__device_release_driver) from [<c039f494>] (driver_detach+0xb4/0xb8)
[   81.802693] [<c039f494>] (driver_detach) from [<c039eb14>] (bus_remove_driver+0x4c/0x90)
[   81.811154] [<c039eb14>] (bus_remove_driver) from [<c00b4198>] (SyS_delete_module+0x118/0x1e0)
[   81.820157] [<c00b4198>] (SyS_delete_module) from [<c000e740>] (ret_fast_syscall+0x0/0x48)
[   81.828788] Code: e1a04000 e59f0068 eb164f84 e5943010 (e5932018)
[   81.835241] ---[ end trace 753a834bdbc86894 ]---
Segmentation fault

There seems to be similar signatures seen before [1][2], and in some cases, the drivers
used of_device_unregister in a loop in their remove. These all should migrate to
of_platform_depopulate, but so far haven't seen any that did supply platform data.

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/274412.html
[2] http://www.spinics.net/lists/linux-usb/msg107171.html

2. platform_data kfree crash

After fixing the first one, ran into the second crash, and this is due to the fact that
platform_data is never allocated in the OF device registration path.

[  156.281310] Unable to handle kernel paging request at virtual address e1e4d4a4
[  156.288853] pgd = de4f0000
[  156.291676] [e1e4d4a4] *pgd=00000000
[  156.295420] Internal error: Oops: 5 [#1] SMP ARM
[  156.300241] Modules linked in: pruss_remoteproc(-) remoteproc virtio_ring virtio [last unloaded: virtio_rpmsg_bus]
[  156.311091] CPU: 0 PID: 77 Comm: rmmod Not tainted 3.19.0-rc3-00025-gf09d6429f7c5 #336
[  156.319354] Hardware name: Generic AM33XX (Flattened Device Tree)
[  156.325714] task: de4fb180 ti: de56a000 task.ti: de56a000
[  156.331360] PC is at kfree+0x50/0x15c
[  156.335181] LR is at kfree+0x34/0x15c
[  156.339003] pc : [<c013925c>]    lr : [<c0139240>]    psr: 20000093
[  156.339003] sp : de56be80  ip : 00000000  fp : 00000000
[  156.350985] r10: a0000013  r9 : de56a000  r8 : c039b5dc
[  156.356437] r7 : c097977c  r6 : c03a0b38  r5 : bf021470  r4 : de521c10
[  156.363249] r3 : 023dc4a4  r2 : dfa71000  r1 : e1e4d4a4  r0 : c0139240
[  156.370063] Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment user
[  156.377601] Control: 10c5387d  Table: 9e4f0019  DAC: 00000015
[  156.383597] Process rmmod (pid: 77, stack limit = 0xde56a240)
[  156.389594] Stack: (0xde56be80 to 0xde56c000)
[  156.394145] be80: 00000000 de521c10 de521c10 de4ae440 de521c18 c039b5dc 00000000 c03a0b38
[  156.402683] bea0: de521c18 c039b748 de521c34 c094a4f0 de485fc0 c03128ac 00000000 de1100dc
[  156.411221] bec0: de56bef0 de4ae470 00000001 c05c98c8 00000010 00000000 00000000 c04d6858
[  156.419759] bee0: 00000081 c000e904 00000000 c039b7ec de1100c0 00000000 de12cc10 de12cc00
[  156.428298] bf00: c0915564 c04d6840 de12cc10 bf01f154 de12cc10 bf02135c de12cc44 c03a0714
[  156.436836] bf20: c03a06fc de12cc10 bf02135c c039ec8c bf02135c de12cc10 bf02135c c039f494
[  156.445374] bf40: bf02135c bec3dbe8 00000880 c039eb14 bf021480 c00b4198 c0164bc0 73757270
[  156.453912] bf60: 65725f73 65746f6d 636f7270 00000000 00000001 de4fb180 c000e7d0 00000001
[  156.462450] bf80: 10c5387d c0083074 000195dc 73757270 65725f73 0000e85c 000195dc 73757270
[  156.470988] bfa0: 65725f73 c000e740 000195dc 73757270 bec3dbe8 00000880 bec3dbe8 00000880
[  156.479526] bfc0: 000195dc 73757270 65725f73 00000081 000aa7f8 00000000 0000d1b0 00000000
[  156.488065] bfe0: bec3dbe0 bec3dbd0 00019368 b6ef8bc0 60000010 bec3dbe8 2e676572 495f3043
[  156.496622] [<c013925c>] (kfree) from [<c03a0b38>] (platform_device_release+0x18/0x3c)
[  156.504903] [<c03a0b38>] (platform_device_release) from [<c039b748>] (device_release+0x2c/0x90)
[  156.513996] [<c039b748>] (device_release) from [<c03128ac>] (kobject_release+0x48/0x7c)
[  156.522361] [<c03128ac>] (kobject_release) from [<c05c98c8>] (klist_next+0xb0/0x12c)
[  156.530452] [<c05c98c8>] (klist_next) from [<c039b7ec>] (device_for_each_child+0x40/0x74)
[  156.539003] [<c039b7ec>] (device_for_each_child) from [<c04d6840>] (of_platform_depopulate+0x2c/0x44)
[  156.548644] [<c04d6840>] (of_platform_depopulate) from [<bf01f154>] (pruss_remove+0x28/0x58 [pruss_remoteproc])
[  156.559185] [<bf01f154>] (pruss_remove [pruss_remoteproc]) from [<c03a0714>] (platform_drv_remove+0x18/0x30)
[  156.569449] [<c03a0714>] (platform_drv_remove) from [<c039ec8c>] (__device_release_driver+0x70/0xc4)
[  156.578986] [<c039ec8c>] (__device_release_driver) from [<c039f494>] (driver_detach+0xb4/0xb8)
[  156.587980] [<c039f494>] (driver_detach) from [<c039eb14>] (bus_remove_driver+0x4c/0x90)
[  156.596441] [<c039eb14>] (bus_remove_driver) from [<c00b4198>] (SyS_delete_module+0x118/0x1e0)
[  156.605445] [<c00b4198>] (SyS_delete_module) from [<c000e740>] (ret_fast_syscall+0x0/0x48)
[  156.614075] Code: e0833183 e5922000 e1a03103 e0821003 (e7920003)
[  156.620441] ---[ end trace 8d15970ad8371606 ]---

Also, while trying to reproduce the same with the OF unittest, I noticed that the
of_platform_populate tests are not really being executed completely, the last
patch enables all the of_selftest_platform_populate test code to execute, this
does expose some additional WARN_ONs while running the test. I was able to
reproduce the pdata kfree crash with some changes, but wasn't able to convert
the current reg properties into IOMEM resources. 

Following are the complete logs taken from running my tests on BeagleBone Black
with 3.19-rc3 + my driver,
release_resource crash       : http://slexy.org/view/s29B8Wntji
platform data kfree crash    : http://slexy.org/view/s2mUgd09gm
OF UnitTest with just Patch3 : http://slexy.org/view/s21xz88p6P

regards
Suman

Suman Anna (3):
  of/device: manage resources similar to platform_device_add
  core: platform: fix an invalid kfree during of_platform_depopulate
  of/unittest: fix trailing semi-colons on conditional selftest

 drivers/base/platform.c |  2 ++
 drivers/of/device.c     | 38 +++++++++++++++++++++++++++++++++++++-
 drivers/of/unittest.c   |  4 ++--
 3 files changed, 41 insertions(+), 3 deletions(-)

-- 
2.2.1

