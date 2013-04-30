Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088Ab3D3JuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:50:14 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:36383 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759864Ab3D3JuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:50:11 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] edac: Don't give write permission to read-only file
To: mchehab@redhat.com
Cc: arozansk@redhat.com, gregkh@linuxfoundation.org, bp@alien8.de,
        balbi@ti.com, linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Tue, 30 Apr 2013 15:17:16 +0530
Message-ID: <20130430094716.3179.67212.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043009-8878-0000-0000-000006E85699
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following warning on boot:

------------[ cut here ]------------
WARNING: at drivers/base/core.c:575 device_create_file+0x9a/0xa0()
Hardware name:  -[8737R2A]-
Write permission without 'store'
Modules linked in: sb_edac(+) edac_core i2c_i801 i2c_core lpc_ich mfd_core
shpchp wmi ioatdma dca mlx4_core be2net ext4 mbcache jbd2 sd_mod crc_t10dif
aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul mpt2sas
scsi_transport_sas raid_class dm_mirror dm_region_hash dm_log dm_mod
Pid: 599, comm: modprobe Tainted: G        W    3.9.0-56847d8 #1
Call Trace:
 [<ffffffff8105865f>] warn_slowpath_common+0x7f/0xc0
 [<ffffffff81058756>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff813b496a>] device_create_file+0x9a/0xa0
 [<ffffffffa02508ce>] edac_create_csrow_object+0xfe/0x180 [edac_core]
 [<ffffffffa02509ea>] edac_create_csrow_objects+0x9a/0x190 [edac_core]
 [<ffffffffa0250d48>] edac_create_sysfs_mci_device+0x268/0x2d0 [edac_core]
 [<ffffffffa024df6c>] edac_mc_add_mc+0xfc/0x230 [edac_core]
 [<ffffffffa0265e29>] sbridge_register_mci+0x1d9/0x270 [sb_edac]
 [<ffffffffa0265fa0>] sbridge_probe+0xe0/0x18c [sb_edac]
 [<ffffffff812ddcce>] local_pci_probe+0x4e/0x90
 [<ffffffff812ddde1>] __pci_device_probe+0xd1/0xe0
 [<ffffffff813c5193>] ? pm_runtime_barrier+0x73/0xe0
 [<ffffffff812df122>] ? pci_dev_get+0x22/0x30
 [<ffffffff812df16a>] pci_device_probe+0x3a/0x60
 [<ffffffff815bf9c0>] ? _raw_spin_unlock_irq+0x30/0x50
 [<ffffffff813b7f2c>] really_probe+0x6c/0x320
 [<ffffffff813b8227>] driver_probe_device+0x47/0xa0
 [<ffffffff813b832b>] __driver_attach+0xab/0xb0
 [<ffffffff813b8280>] ? driver_probe_device+0xa0/0xa0
 [<ffffffff813b8280>] ? driver_probe_device+0xa0/0xa0
 [<ffffffff813b5fb4>] bus_for_each_dev+0x94/0xb0
 [<ffffffff813b7bee>] driver_attach+0x1e/0x20
 [<ffffffff813b75c0>] bus_add_driver+0x200/0x280
 [<ffffffffa0269000>] ? 0xffffffffa0268fff
 [<ffffffff813b88d4>] driver_register+0x74/0x160
 [<ffffffffa0269000>] ? 0xffffffffa0268fff
 [<ffffffff812df274>] __pci_register_driver+0x64/0x70
 [<ffffffffa0269036>] sbridge_init+0x36/0x62 [sb_edac]
 [<ffffffff81002132>] do_one_initcall+0x132/0x1c0
 [<ffffffff810d4844>] do_init_module+0x44/0x1b0
 [<ffffffff810d6dd9>] load_module+0x569/0x6c0
 [<ffffffff812cbea0>] ? ddebug_dyndbg_boot_param_cb+0x60/0x60
 [<ffffffff810d3780>] ? module_sect_show+0x30/0x30
 [<ffffffff810d7096>] sys_init_module+0x96/0xc0
 [<ffffffff815c9819>] system_call_fastpath+0x16/0x1b
---[ end trace 1ad1039fa2c3d483 ]---

Drilling down, this is related to dynamic channel ce_count attribute files
sporting a S_IWUSR mode without a ->store() function. Looking around, it
appears that they aren't supposed to have a ->store() function. So remove
the bogus write permission to get rid of the warning.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/edac/edac_mc_sysfs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 5899a76..769d92e 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -327,17 +327,17 @@ static struct device_attribute *dynamic_csrow_dimm_attr[] = {
 };
 
 /* possible dynamic channel ce_count attribute files */
-DEVICE_CHANNEL(ch0_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch0_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 0);
-DEVICE_CHANNEL(ch1_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch1_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 1);
-DEVICE_CHANNEL(ch2_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch2_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 2);
-DEVICE_CHANNEL(ch3_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch3_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 3);
-DEVICE_CHANNEL(ch4_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch4_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 4);
-DEVICE_CHANNEL(ch5_ce_count, S_IRUGO | S_IWUSR,
+DEVICE_CHANNEL(ch5_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 5);
 
 /* Total possible dynamic ce_count attribute file table */

