Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457Ab3HUIPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:15:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:8397 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab3HUIPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:15:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,926,1367996400"; 
   d="scan'208";a="390739942"
Subject: [PATCH V2] reboot: perform warm/cold reset correctly for CF9 type
From: Li Fei <fei.li@intel.com>
To: hpa@zytor.com, mingo@redhat.com
Cc: tglx@linutronix.de, chuansheng.liu@intel.com, x86@kernel.org,
        akpm@linux-foundation.org, holt@sgi.com, rmk+kernel@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, fei.li@intel.com
In-Reply-To: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1377049949.18357.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Aug 2013 16:13:57 +0800
Message-ID: <1377072837.24556.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation for reboot type CF9 and CF9_COND,
warm and cold reset are not differentiated, and both are
performed by writing 0x06 to port 0xCF9 as warm reset. It's not
correct.

This commit will differentiate warm and cold reset, and perform
them correctly as below:
For warm reset, write 0x06 to port 0xCF9;
For cold reset, write 0x0E to port 0xCF9.

From: Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
---
 arch/x86/kernel/reboot.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 563ed91..ca42f63 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -511,10 +511,13 @@ static void native_machine_emergency_restart(void)
 
 		case BOOT_CF9_COND:
 			if (port_cf9_safe) {
-				u8 cf9 = inb(0xcf9) & ~6;
+				u8 reboot_code = reboot_mode == REBOOT_WARM ?
+					0x06 : 0x0E;
+				u8 cf9 = inb(0xcf9) & ~reboot_code;
 				outb(cf9|2, 0xcf9); /* Request hard reset */
 				udelay(50);
-				outb(cf9|6, 0xcf9); /* Actually do the reset */
+				/* Actually do the reset */
+				outb(cf9|reboot_code, 0xcf9);
 				udelay(50);
 			}
 			reboot_type = BOOT_KBD;
-- 
1.7.4.1



