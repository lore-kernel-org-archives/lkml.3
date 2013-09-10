Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3IJTwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:52:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43703 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IJTwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:52:05 -0400
Date: Tue, 10 Sep 2013 12:51:53 -0700
From: tip-bot for Li Fei <tipbot@zytor.com>
Message-ID: <tip-02020dae966ae71e8010ecbd04eb847ad0d53669@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, fei.li@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, fei.li@intel.com
In-Reply-To: <1377072837.24556.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1377072837.24556.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/reboot] reboot: Allow specifying warm/
 cold reset for CF9 boot type
Git-Commit-ID: 02020dae966ae71e8010ecbd04eb847ad0d53669
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 10 Sep 2013 12:51:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02020dae966ae71e8010ecbd04eb847ad0d53669
Gitweb:     http://git.kernel.org/tip/02020dae966ae71e8010ecbd04eb847ad0d53669
Author:     Li Fei <fei.li@intel.com>
AuthorDate: Wed, 21 Aug 2013 16:13:57 +0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 10 Sep 2013 08:56:02 -0700

reboot: Allow specifying warm/cold reset for CF9 boot type

In current implementation for reboot type CF9 and CF9_COND,
warm and cold reset are not differentiated, and both are
performed by writing 0x06 to port 0xCF9.

This commit will differentiate warm and cold reset:

For warm reset, write 0x06 to port 0xCF9;
For cold reset, write 0x0E to port 0xCF9.

[ hpa: This meaning of "cold" and "warm" reset is different from other
  reboot types use, where "warm" means "bypass BIOS POST".  It is also
  not entirely clear that it actually solves any actual problem.  However,
  it would seem fairly harmless to offer this additional option.

  Also note that we do not mask bit 3 in the "warm reset" case.  This
  preserves the behavior on existing systems, including ones quirked
  to use CF9.  It seems reasonable that on any system where the
  warm/cold distinction actually matters that bit 3 would be read as
  zero. ]

From: Liu Chuansheng <chuansheng.liu@intel.com>
Signed-off-by: Li Fei <fei.li@intel.com>
Link: http://lkml.kernel.org/r/1377072837.24556.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/reboot.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

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
