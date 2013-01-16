Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab3APQFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:05:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab3APQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:09 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nathan Williams <nathan@traverse.com.au>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 120/222] mtd cs553x_nand: Initialise ecc.strength before nand_scan()
Date: Wed, 16 Jan 2013 13:55:20 -0200
Message-Id: <1358351822-7675-121-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Williams <nathan@traverse.com.au>

commit d1f3b65d2d6fdb4bf0edd4b67e86e191af48daee upstream.

Loading cs553x_nand with Hynix H27U1G8F2BTR NAND flash causes this bug:

kernel BUG at drivers/mtd/nand/nand_base.c:3345!
invalid opcode: 0000 [#1]
Modules linked in: cs553x_nand(+) vfat fat usb_storage ehci_hcd usbcore usb_comr
Pid: 436, comm: modprobe Not tainted 3.6.7 #1
EIP: 0060:[<c118d205>] EFLAGS: 00010296 CPU: 0
EIP is at nand_scan_tail+0x64c/0x69c
EAX: 00000034 EBX: cea6ed98 ECX: 00000000 EDX: 00000000
ESI: cea6ec00 EDI: cea6ec00 EBP: 20000000 ESP: cdd17e48
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
CR0: 8005003b CR2: 0804e119 CR3: 0d850000 CR4: 00000090
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
Process modprobe (pid: 436, ti=cdd16000 task=cdd1c320 task.ti=cdd16000)
Stack:
 c12e962c c118f7ef 00000003 cea6ed98 d014b25c 20000000 fffff007 00000001
 00000000 cdd53b00 d014b000 c1001021 cdd53b00 d01493c0 cdd53b00 cdd53b00
 d01493c0 c1047f83 d014b4a0 00000000 cdd17f9c ce4be454 cdd17f48 cdd1c320
Call Trace:
 [<c118f7ef>] ? nand_scan+0x1b/0x4d
 [<d014b25c>] ? init_module+0x25c/0x2de [cs553x_nand]
 [<d014b000>] ? 0xd014afff
 [<c1001021>] ? do_one_initcall+0x21/0x111
 [<c1047f83>] ? sys_init_module+0xe4/0x1261
 [<c1031207>] ? task_work_run+0x36/0x43
 [<c1265ced>] ? syscall_call+0x7/0xb
Code: fa ff ff c7 86 d8 00 00 00 01 00 00 00 e9 5f fc ff ff 68 f8 26 2e c1 e8 a7
EIP: [<c118d205>] nand_scan_tail+0x64c/0x69c SS:ESP 0068:cdd17e48

Initialising ecc.strength before the call to nand_scan() fixes this.

Signed-off-by: Nathan Williams <nathan@traverse.com.au>
Acked-by: Brian Norris <computersforpeace@gmail.com>
Acked-by: Mike Dunn <mikedunn@newsguy.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mtd/nand/cs553x_nand.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/cs553x_nand.c b/drivers/mtd/nand/cs553x_nand.c
index adb6c3e..2cdeab8 100644
--- a/drivers/mtd/nand/cs553x_nand.c
+++ b/drivers/mtd/nand/cs553x_nand.c
@@ -237,6 +237,7 @@ static int __init cs553x_init_one(int cs, int mmio, unsigned long adr)
 	this->ecc.hwctl  = cs_enable_hwecc;
 	this->ecc.calculate = cs_calculate_ecc;
 	this->ecc.correct  = nand_correct_data;
+	this->ecc.strength = 1;
 
 	/* Enable the following for a flash based bad block table */
 	this->bbt_options = NAND_BBT_USE_FLASH;
@@ -247,8 +248,6 @@ static int __init cs553x_init_one(int cs, int mmio, unsigned long adr)
 		goto out_ior;
 	}
 
-	this->ecc.strength = 1;
-
 	new_mtd->name = kasprintf(GFP_KERNEL, "cs553x_nand_cs%d", cs);
 
 	cs553x_mtd[cs] = new_mtd;
-- 
1.7.9.5

