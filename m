Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbaHJNmv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 09:42:51 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:65029 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaHJNmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 09:42:50 -0400
Message-ID: <1407678135.9689.4.camel@debian>
Subject: kill the current thread if MCG_STATUS_RIPV is not set
From: Chen Yucong <slaoub@gmail.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 10 Aug 2014 21:42:15 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony Luck,

According to the x86 ASDM vol.3A 15.9.3.2, we can find that
Recoverable-not-continuable SRAR Error (RIPV=0, EIPV=x) includes the
following two cases:
  -IA32_MCG_STATUS.RIPV= 0, IA32_MCG_STATUS.EIPV=0, or
  -IA32_MCG_STATUS.RIPV= 0, IA32_MCG_STATUS.EIPV=1.

For the first case, the MCE handler will directly panic the kernel
according the item of severities[]:

/* Neither return not error IP -- no chance to recover -> PANIC */
MCESEV(
       PANIC, "Neither restart nor error IP",
       MCGMASK(MCG_STATUS_RIPV|MCG_STATUS_EIPV, 0)
       ),

For the second case, the MCE handler should directly kill the current
thread according to the ASDM vol.3A 15.9.3.2:

The current executing thread cannot be continued. System software must
terminate the interrupted stream of execution and provide a new stream
of execution on return from the machine check handler for the affected
logical processor.

But the fact is that the MCE handler does not kill the current thread,
but rather to further handling(invoke memory_failure() by TIF_MCE_NOTIFY
).

I think I have been confused by the gap between documentation and source
code. Perhaps there may need a small fix.

thx!
cyc


Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c
b/arch/x86/kernel/cpu/mcheck/mce.c
index bd9ccda..3394494 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1055,9 +1055,12 @@ void do_machine_check(struct pt_regs *regs, long
error_code)
 
 	/*
 	 * When no restart IP might need to kill or panic.
-	 * Assume the worst for now, but if we find the
-	 * severity is MCE_AR_SEVERITY we have other options.
+	 * This indicates that the error is detected at the instruction
+	 * pointer saved on the stack for this machine check exception
+	 * and restarting execution with the interrupted context is not
+	 * possible.(ASDM vol.3A 15.9.3.2)
 	 */
+
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
 		kill_it = 1;
 
@@ -1154,12 +1157,13 @@ void do_machine_check(struct pt_regs *regs, long
error_code)
 	if (cfg->tolerant < 3) {
 		if (no_way_out)
 			mce_panic("Fatal machine check on current CPU", &m, msg);
-		if (worst == MCE_AR_SEVERITY) {
+
+		if (kill_it) {
+			force_sig(SIGBUS, current);
+		} else if (worst == MCE_AR_SEVERITY) {
 			/* schedule action before return to userland */
 			mce_save_info(m.addr, m.mcgstatus & MCG_STATUS_RIPV);
 			set_thread_flag(TIF_MCE_NOTIFY);
-		} else if (kill_it) {
-			force_sig(SIGBUS, current);
 		}
 	}
 
-- 
1.7.10.4



