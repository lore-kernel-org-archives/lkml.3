Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab3D2EoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 00:44:19 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:39468 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab3D2EoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 00:44:17 -0400
Subject: [PATCH] powerpc/rtas_flash: Fix bad memory access
To: linuxppc-dev@ozlabs.org
From: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: benh@kernel.crashing.org, paulus@samba.org, linux-kernel@vger.kernel.org
Date: Mon, 29 Apr 2013 10:13:56 +0530
Message-ID: <20130429044334.6828.34295.stgit@hegdevasant.in.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042904-3864-0000-0000-000007E8D0D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use kmem_cache_alloc() to allocate memory to hold the new firmware
which will be flashed. kmem_cache_alloc() calls rtas_block_ctor() to
set memory to NULL. But these constructor is called only for newly
allocated slabs.

If we run below command multiple time without rebooting, allocator may
allocate memory from the area which was free'd by kmem_cache_free and
it will not call constructor. In this situation we may hit kernel oops.

dd if=<fw image> of=/proc/ppc64/rtas/firmware_flash bs=4096


oops message:
-------------
[ 1602.399755] Oops: Kernel access of bad area, sig: 11 [#1]
[ 1602.399772] SMP NR_CPUS=1024 NUMA pSeries
[ 1602.399779] Modules linked in: rtas_flash nfsd lockd auth_rpcgss nfs_acl sunrpc fuse loop dm_mod sg ipv6 ses enclosure ehea ehci_pci ohci_hcd ehci_hcd usbcore sd_mod usb_common crc_t10dif scsi_dh_alua scsi_dh_emc scsi_dh_hp_sw scsi_dh_rdac scsi_dh ipr libata scsi_mod
[ 1602.399817] NIP: d00000000a170b9c LR: d00000000a170b64 CTR: c00000000079cd58
[ 1602.399823] REGS: c0000003b9937930 TRAP: 0300   Not tainted  (3.9.0-rc4-0.27-ppc64)
[ 1602.399828] MSR: 8000000000009032 <SF,EE,ME,IR,DR,RI>  CR: 22000428  XER: 20000000
[ 1602.399841] SOFTE: 1
[ 1602.399844] CFAR: c000000000005f24
[ 1602.399848] DAR: 8c2625a820631fef, DSISR: 40000000
[ 1602.399852] TASK = c0000003b4520760[3655] 'dd' THREAD: c0000003b9934000 CPU: 3
GPR00: 8c2625a820631fe7 c0000003b9937bb0 d00000000a179f28 d00000000a171f08
GPR04: 0000000010040000 0000000000001000 c0000003b9937df0 c0000003b5fb2080
GPR08: c0000003b58f7200 d00000000a179f28 c0000003b40058d4 c00000000079cd58
GPR12: d00000000a171450 c000000007f40900 0000000000000005 0000000010178d20
GPR16: 00000000100cb9d8 000000000000001d 0000000000000000 000000001003ffff
GPR20: 0000000000000001 0000000000000000 00003fffa0b50d30 000000001001f010
GPR24: 0000000010020888 0000000010040000 d00000000a171f08 d00000000a172808
GPR28: 0000000000001000 0000000010040000 c0000003b4005880 8c2625a820631fe7
[ 1602.399924] NIP [d00000000a170b9c] .rtas_flash_write+0x7c/0x1e8 [rtas_flash]
[ 1602.399930] LR [d00000000a170b64] .rtas_flash_write+0x44/0x1e8 [rtas_flash]
[ 1602.399934] Call Trace:
[ 1602.399939] [c0000003b9937bb0] [d00000000a170b64] .rtas_flash_write+0x44/0x1e8 [rtas_flash] (unreliable)
[ 1602.399948] [c0000003b9937c60] [c000000000282830] .proc_reg_write+0x90/0xe0
[ 1602.399955] [c0000003b9937ce0] [c0000000001ff374] .vfs_write+0x114/0x238
[ 1602.399961] [c0000003b9937d80] [c0000000001ff5d8] .SyS_write+0x70/0xe8
[ 1602.399968] [c0000003b9937e30] [c000000000009cdc] syscall_exit+0x0/0xa0
[ 1602.399973] Instruction dump:
[ 1602.399977] eb698010 801b0028 2f80dcd6 419e00a4 2fbc0000 419e009c ebfb0030 2fbf0000
[ 1602.399989] 409e0010 480000d8 60000000 7c1f0378 <e81f0008> 2fa00000 409efff4 e81f0000
[ 1602.400012] ---[ end trace b4136d115dc31dac ]---
[ 1602.402178]
[ 1602.402185] Sending IPI to other CPUs
[ 1602.403329] IPI complete

This patch uses kmem_cache_zalloc() instead of kmem_cache_alloc() to
allocate memory, which makes sure memory is set to 0 before using.
Also removes rtas_block_ctor(), which is no longer required.

Signed-off-by: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/rtas_flash.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/rtas_flash.c b/arch/powerpc/kernel/rtas_flash.c
index 0a08c3b..d61a94c 100644
--- a/arch/powerpc/kernel/rtas_flash.c
+++ b/arch/powerpc/kernel/rtas_flash.c
@@ -286,12 +286,6 @@ static ssize_t rtas_flash_read(struct file *file, char __user *buf,
 	return simple_read_from_buffer(buf, count, ppos, msg, strlen(msg));
 }
 
-/* constructor for flash_block_cache */
-void rtas_block_ctor(void *ptr)
-{
-	memset(ptr, 0, RTAS_BLK_SIZE);
-}
-
 /* We could be much more efficient here.  But to keep this function
  * simple we allocate a page to the block list no matter how small the
  * count is.  If the system is low on memory it will be just as well
@@ -316,7 +310,7 @@ static ssize_t rtas_flash_write(struct file *file, const char __user *buffer,
 	 * proc file
 	 */
 	if (uf->flist == NULL) {
-		uf->flist = kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
+		uf->flist = kmem_cache_zalloc(flash_block_cache, GFP_KERNEL);
 		if (!uf->flist)
 			return -ENOMEM;
 	}
@@ -327,7 +321,7 @@ static ssize_t rtas_flash_write(struct file *file, const char __user *buffer,
 	next_free = fl->num_blocks;
 	if (next_free == FLASH_BLOCKS_PER_NODE) {
 		/* Need to allocate another block_list */
-		fl->next = kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
+		fl->next = kmem_cache_zalloc(flash_block_cache, GFP_KERNEL);
 		if (!fl->next)
 			return -ENOMEM;
 		fl = fl->next;
@@ -336,7 +330,7 @@ static ssize_t rtas_flash_write(struct file *file, const char __user *buffer,
 
 	if (count > RTAS_BLK_SIZE)
 		count = RTAS_BLK_SIZE;
-	p = kmem_cache_alloc(flash_block_cache, GFP_KERNEL);
+	p = kmem_cache_zalloc(flash_block_cache, GFP_KERNEL);
 	if (!p)
 		return -ENOMEM;
 	
@@ -789,7 +783,7 @@ static int __init rtas_flash_init(void)
 
 	flash_block_cache = kmem_cache_create("rtas_flash_cache",
 				RTAS_BLK_SIZE, RTAS_BLK_SIZE, 0,
-				rtas_block_ctor);
+				NULL);
 	if (!flash_block_cache) {
 		printk(KERN_ERR "%s: failed to create block cache\n",
 				__func__);

