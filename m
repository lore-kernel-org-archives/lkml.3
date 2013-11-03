Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3KCKTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 05:19:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33286 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab3KCKTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 05:19:48 -0500
Date: Sun, 3 Nov 2013 02:19:22 -0800
From: "tip-bot for Luck, Tony" <tipbot@zytor.com>
Message-ID: <tip-0841c04d65937ad2808f59c43cb54a92473c8f0e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tony.luck@intel.com, tglx@linutronix.de, gong.chen@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tony.luck@intel.com, gong.chen@linux.intel.com
In-Reply-To: <27d82dbff5be1025bf18ab88498632d36c2fcf3c.1383331440.git.tony.luck@intel.com>
References: <27d82dbff5be1025bf18ab88498632d36c2fcf3c.1383331440.git.tony.luck@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] dmi:
  Avoid unaligned memory access in save_mem_devices()
Git-Commit-ID: 0841c04d65937ad2808f59c43cb54a92473c8f0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 03 Nov 2013 02:19:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0841c04d65937ad2808f59c43cb54a92473c8f0e
Gitweb:     http://git.kernel.org/tip/0841c04d65937ad2808f59c43cb54a92473c8f0e
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Fri, 1 Nov 2013 13:59:52 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 3 Nov 2013 10:40:12 +0100

dmi: Avoid unaligned memory access in save_mem_devices()

Firmware is not required to maintain alignment of SMBIOS
entries, so we should take care accessing fields within these
structures. Use "get_unaligned()" to avoid problems.

[ Found on ia64 (which grumbles about unaligned access) ]

Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Link: http://lkml.kernel.org/r/27d82dbff5be1025bf18ab88498632d36c2fcf3c.1383331440.git.tony.luck@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/firmware/dmi_scan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 59579a7..c7e81ff 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -8,6 +8,7 @@
 #include <linux/bootmem.h>
 #include <linux/random.h>
 #include <asm/dmi.h>
+#include <asm/unaligned.h>
 
 /*
  * DMI stands for "Desktop Management Interface".  It is part
@@ -347,7 +348,7 @@ static void __init save_mem_devices(const struct dmi_header *dm, void *v)
 		pr_warn(FW_BUG "Too many DIMM entries in SMBIOS table\n");
 		return;
 	}
-	dmi_memdev[nr].handle = dm->handle;
+	dmi_memdev[nr].handle = get_unaligned(&dm->handle);
 	dmi_memdev[nr].device = dmi_string(dm, d[0x10]);
 	dmi_memdev[nr].bank = dmi_string(dm, d[0x11]);
 	nr++;
