Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3IKE5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab3IKE4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:48 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=sskSDooUz-gA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Dj1Wfo5368kA:10 a=eJfxgxciAAAA:8 a=ag1SF4gXAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=Z4Rwk6OoAAAA:8 a=6KJvHg_63jLTsBrnDioA:9 a=W39ifWXXhksA:10 a=1TSTQ8KKaH4A:10 a=dGJ0OcVc7YAA:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042933.227500216@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Russ Anderson <rja@sgi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [244/251] drivers/base/memory.c: fix show_mem_removable() to handle missing
 sections
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0244-drivers-base-memory.c-fix-show_mem_removable-to-hand.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russ Anderson <rja@sgi.com>

[ Upstream commit 21ea9f5ace3a7317cc3ba1fbc749758021a83136 ]

"cat /sys/devices/system/memory/memory*/removable" crashed the system.

The problem is that show_mem_removable() is passing a
bad pfn to is_mem_section_removable(), which causes

    if (!node_online(page_to_nid(page)))

to blow up.  Why is it passing in a bad pfn?

The reason is that show_mem_removable() will loop sections_per_block
times.  sections_per_block is 16, but mem->section_count is 8,
indicating holes in this memory block.  Checking that the memory section
is present before checking to see if the memory section is removable
fixes the problem.

   harp5-sys:~ # cat /sys/devices/system/memory/memory*/removable
   0
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   1
   BUG: unable to handle kernel paging request at ffffea00c3200000
   IP: [<ffffffff81117ed1>] is_pageblock_removable_nolock+0x1/0x90
   PGD 83ffd4067 PUD 37bdfce067 PMD 0
   Oops: 0000 [#1] SMP
   Modules linked in: autofs4 binfmt_misc rdma_ucm rdma_cm iw_cm ib_addr ib_srp scsi_transport_srp scsi_tgt ib_ipoib ib_cm ib_uverbs ib_umad iw_cxgb3 cxgb3 mdio mlx4_en mlx4_ib ib_sa mlx4_core ib_mthca ib_mad ib_core fuse nls_iso8859_1 nls_cp437 vfat fat joydev loop hid_generic usbhid hid hwperf(O) numatools(O) dm_mod iTCO_wdt ipv6 iTCO_vendor_support igb i2c_i801 ioatdma i2c_algo_bit ehci_pci pcspkr lpc_ich i2c_core ehci_hcd ptp sg mfd_core dca rtc_cmos pps_core mperf button xhci_hcd sd_mod crc_t10dif usbcore usb_common scsi_dh_emc scsi_dh_hp_sw scsi_dh_alua scsi_dh_rdac scsi_dh gru(O) xvma(O) xfs crc32c libcrc32c thermal sata_nv processor piix mptsas mptscsih scsi_transport_sas mptbase megaraid_sas fan thermal_sys hwmon ext3 jbd ata_piix ahci libahci libata scsi_mod
   CPU: 4 PID: 5991 Comm: cat Tainted: G           O 3.11.0-rc5-rja-uv+ #10
   Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013
   task: ffff88081f034580 ti: ffff880820022000 task.ti: ffff880820022000
   RIP: 0010:[<ffffffff81117ed1>]  [<ffffffff81117ed1>] is_pageblock_removable_nolock+0x1/0x90
   RSP: 0018:ffff880820023df8  EFLAGS: 00010287
   RAX: 0000000000040000 RBX: ffffea00c3200000 RCX: 0000000000000004
   RDX: ffffea00c30b0000 RSI: 00000000001c0000 RDI: ffffea00c3200000
   RBP: ffff880820023e38 R08: 0000000000000000 R09: 0000000000000001
   R10: 0000000000000000 R11: 0000000000000001 R12: ffffea00c33c0000
   R13: 0000160000000000 R14: 6db6db6db6db6db7 R15: 0000000000000001
   FS:  00007ffff7fb2700(0000) GS:ffff88083fc80000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: ffffea00c3200000 CR3: 000000081b954000 CR4: 00000000000407e0
   Call Trace:
     show_mem_removable+0x41/0x70
     dev_attr_show+0x2a/0x60
     sysfs_read_file+0xf7/0x1c0
     vfs_read+0xc8/0x130
     SyS_read+0x5d/0xa0
     system_call_fastpath+0x16/0x1b

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/base/memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 7dda4f7..d63a06b 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -154,6 +154,8 @@ static ssize_t show_mem_removable(struct device *dev,
 		container_of(dev, struct memory_block, dev);
 
 	for (i = 0; i < sections_per_block; i++) {
+		if (!present_section_nr(mem->start_section_nr + i))
+			continue;
 		pfn = section_nr_to_pfn(mem->start_section_nr + i);
 		ret &= is_mem_section_removable(pfn, PAGES_PER_SECTION);
 	}
-- 
1.7.10.4


