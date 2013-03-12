Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933493Ab3CLUR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 16:17:29 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:42359 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab3CLUR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 16:17:28 -0400
From: Artem Savkov <artem.savkov@gmail.com>
To: ben@decadent.org.uk, tmhikaru@gmail.com
Cc: akpm@linux-foundation.org, zhenzhong.duan@oracle.com,
        linux-kernel@vger.kernel.org, Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] dmi_scan: proper buf type in dmi_present()
Date: Wed, 13 Mar 2013 00:17:07 +0400
Message-Id: <1363119427-4371-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

buf needs to be unsigned in dmi_present(), otherwise dmi_base calculation
doesn't work properly leading to a wraparound during dmi_ioremap:

[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at arch/x86/mm/ioremap.c:524 __early_ioremap+0x85/0x18a()
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 3.9.0-rc2-next-20130312 #283
[    0.000000] Call Trace:
[    0.000000]  [<c1036992>] warn_slowpath_common+0x72/0xa0
[    0.000000]  [<c19cc176>] ? __early_ioremap+0x85/0x18a
[    0.000000]  [<c19cc176>] ? __early_ioremap+0x85/0x18a
[    0.000000]  [<c10369e2>] warn_slowpath_null+0x22/0x30
[    0.000000]  [<c19cc176>] __early_ioremap+0x85/0x18a
[    0.000000]  [<c19cc1ed>] ? __early_ioremap+0xfc/0x18a
[    0.000000]  [<c19cc412>] early_ioremap+0xd/0xf
[    0.000000]  [<c19fbba9>] dmi_present+0xf5/0x22a
[    0.000000]  [<c19fbd9d>] dmi_scan_machine+0xbf/0x11c
[    0.000000]  [<c19bd781>] setup_arch+0x4db/0xca0
[    0.000000]  [<c168105c>] ? printk+0x3d/0x3f
[    0.000000]  [<c19ba763>] start_kernel+0x7b/0x329
[    0.000000]  [<c19ba361>] i386_start_kernel+0x137/0x13a
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] DMI not present or invalid.

Introduced in "dmi_scan: refactor dmi_scan_machine(), {smbios,dmi}_present()"

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/firmware/dmi_scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 3439f59..40e940d 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -410,7 +410,7 @@ static void __init dmi_dump_ids(void)
 	printk(KERN_CONT "\n");
 }
 
-static int __init dmi_present(const char *buf)
+static int __init dmi_present(const u8 *buf)
 {
 	int smbios_ver;
 
-- 
1.8.1.5

