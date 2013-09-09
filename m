Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3IIBy2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 21:54:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:36433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab3IIBy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 21:54:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,866,1371106800"; 
   d="scan'208";a="375275362"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Li, Fei" <fei.li@intel.com>
CC: Ingo Molnar <mingo@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "holt@sgi.com" <holt@sgi.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
Thread-Topic: [PATCH] reboot: perform warm/cold reset correctly for CF9 type
Thread-Index: AQHOqMwMAskXY8tJs0y2IazJpvSaQZm8qavw
Date: Mon, 9 Sep 2013 01:53:30 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B19084@SHSMSX101.ccr.corp.intel.com>
References: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130821072940.GB27495@gmail.com>
 <69b80c44-3245-4393-b6e9-4d8a7f3d3c66@email.android.com>
 <BEC9F67575FA1E429CA7CF5AE9BE3634012ED68C@SHSMSX104.ccr.corp.intel.com>
 <7233d29e-ea01-4eb6-8018-b9c8e3730a30@email.android.com>
 <BEC9F67575FA1E429CA7CF5AE9BE3634012EDD40@SHSMSX104.ccr.corp.intel.com>
 <52261DC8.4070307@zytor.com>
In-Reply-To: <52261DC8.4070307@zytor.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r891sXE3016685

Hello hpa,

> I could be wrong and the cold/warm reset values in CF9 end up having
> exactly the same function as the magic BIOS signature does; if so, then
> I would like to be told so explicitly, ideally with an explanation about
> how it works on the hw level (or a pointer to relevant documentation,
> Intel internal docs are fine.)
The Intel link is here for SandyBridge platform:
https://houston.fm.intel.com/wiki/doku.php?id=svwiki:projects:sandybridge:testplans:reset:start
And we have one internal baytrail platform doc refered it also.

> 
> Finally, again, does this solve a real problem?
Yes, we already have the 0xCF9 rebooting function, why not support the COLD/WARM reset both?
Thanks.


For safety and compatibility, we prepared the below patch, do you think is it making sense?



From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] X86, reboot: supporting COLD reset thru 0xcf9 port

Current X86 rebooting function supports the platform reset thru
port 0xcf9, but currently it hardcoded only for WARM reset that
writing 0x6 into port 0xcf9.

Here we added the support the COLD reset that writing 0xe thru
port 0xcf9, and the actual reset type is determined by reboot_mode
variable.

Also for safety and compatibility, we will set the default reboot
mode as WARM reset for several Apple MacBooks.

Signed-off-by: Li Fei <fei.li@intel.com>
Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 arch/x86/kernel/reboot.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 563ed91..b4a1cb4 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -116,6 +116,12 @@ static int __init set_pci_reboot(const struct dmi_system_id *d)
 {
        if (reboot_type != BOOT_CF9) {
                reboot_type = BOOT_CF9;
+
+               /* The default reboot_mode value is COLD reset(0) for X86 platform,
+                * here for safety and compatibility, we set the default reboot
+                * mode as WARM reset for several Apple MacBooks.
+               */
+               reboot_mode = REBOOT_WARM;
                pr_info("%s series board detected. Selecting %s-method for reboots.\n",
                        "PCI", d->ident);
        }
@@ -511,10 +517,20 @@ static void native_machine_emergency_restart(void)
 
                case BOOT_CF9_COND:
                        if (port_cf9_safe) {
-                               u8 cf9 = inb(0xcf9) & ~6;
+                               u8 reboot_val;
+                               u8 cf9;
+
+                               if (reboot_mode == REBOOT_WARM)
+                                       reboot_val = 0x6;
+                               else
+                                       reboot_val = 0xe;
+
+                               cf9 = inb(0xcf9) & ~reboot_val;
                                outb(cf9|2, 0xcf9); /* Request hard reset */
                                udelay(50);
-                               outb(cf9|6, 0xcf9); /* Actually do the reset */
+
+                               /* Actually do the reset */
+                               outb(cf9|reboot_val, 0xcf9);
                                udelay(50);
                        }
                        reboot_type = BOOT_KBD;
-- 
1.7.0.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
