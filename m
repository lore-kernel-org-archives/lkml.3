Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaJ0A6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:58:10 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:43358 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbaJ0A6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:58:07 -0400
From: Chen Yucong <slaoub@gmail.com>
To: bp@alien8.de
Cc: tony.luck@intel.com, ak@linux.intel.com, aravind.gopalakrishnan@amd.com,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen Yucong <slaoub@gmail.com>
Subject: [PATCH 2/2] x86, mce: support memory error recovery for both UCNA and Deferred error in machine_check_poll
Date: Mon, 27 Oct 2014 08:56:22 +0800
Message-Id: <1414371382-15491-3-git-send-email-slaoub@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
References: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uncorrected no action required (UCNA) - is a UCR error that is not
signaled via a machine check exception and, instead, is reported to
system software as a corrected machine check error. UCNA errors indicate
that some data in the system is corrupted, but the data has not been
consumed and the processor state is valid and you may continue execution
on this processor. UCNA errors require no action from system software
to continue execution. Note that UCNA errors are supported by the
processor only when IA32_MCG_CAP[24] (MCG_SER_P) is set.
                                           -- Intel SDM Volume 3B

Deferred errors are errors that cannot be corrected by hardware, but
do not cause an immediate interruption in program flow, loss of data
integrity, or corruption of processor state. These errors indicate
that data has been corrupted but not consumed. Hardware writes information
to the status and address registers in the corresponding bank that
identifies the source of the error if deferred errors are enabled for
logging. Deferred errors are not reported via machine check exceptions;
they can be seen by polling the MCi_STATUS registers.
                                            -- ADM64 APM Volume 2

Above two items, both UCNA and Deferred errors belong to detected
errors, but they can't be corrected by hardware, and this is very
similar to Software Recoverable Action Optional (SRAO) errors.
Therefore, we can take some actions that have been used for handling
SRAO errors to handle UCNA and Deferred errors.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   55 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index fdc422e..7439077 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -575,6 +575,47 @@ static void mce_read_aux(struct mce *m, int i)
 	}
 }
 
+static bool mem_deferred_error(struct mce *m)
+{
+	int severity;
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+
+	m->mcgstatus |= (MCG_STATUS_MCIP|MCG_STATUS_RIPV);
+	severity = mce_severity(m, mca_cfg.tolerant, NULL);
+
+	if (c->x86_vendor == X86_VENDOR_AMD) {
+		/*
+		 * AMD BKDGs - Machine Check Error Codes
+		 *
+		 * Bit 8 of ErrCode[15:0] of MCi_STATUS is used for indicating
+		 * a memory-specific error. Note that this field encodes info-
+		 * rmation about memory-hierarchy level involved in the error.
+		 */
+		if (severity == MCE_DEFERRED_SEVERITY)
+			return  (m->status & 0xff00) == BIT(8);
+	} else if (c->x86_vendor == X86_VENDOR_INTEL) {
+		/*
+		 * Intel SDM Volume 3B - 15.9.2 Compound Error Codes
+		 *
+		 * Bit 7 of the MCACOD field of IA32_MCi_STATUS is used for
+		 * indicating a memory error. Bit 8 is used for indicating a
+		 * cache hierarchy error. The combination of bit 2 and bit 3
+		 * is used for indicating a `generic' cache hierarchy error
+		 * But we can't just blindly check the above bits, because if
+		 * bit 11 is set, then it is a bus/interconnect error - and
+		 * either way the above bits just gives more detail on what
+		 * bus/interconnect error happened. Note that bit 12 can be
+		 * ignored, as it's the "filter" bit.
+		 */
+		if (severity == MCE_UCNA_SEVERITY)
+			return (m->status & 0xef80) == BIT(7) ||
+			       (m->status & 0xef00) == BIT(8) ||
+			       (m->status & 0xeffc) == 0xc;
+	}
+
+	return false;
+}
+
 DEFINE_PER_CPU(unsigned, mce_poll_count);
 
 /*
@@ -630,6 +671,16 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 
 		if (!(flags & MCP_TIMESTAMP))
 			m.tsc = 0;
+
+		/*
+		 * In the cases where we don't have a valid address after all,
+		 * do not add it into the ring buffer.
+		 */
+		if (mem_deferred_error(&m) && (m.status & MCI_STATUS_ADDRV)) {
+			mce_ring_add(m.addr >> PAGE_SHIFT);
+			mce_schedule_work();
+		}
+
 		/*
 		 * Don't get the IP here because it's unlikely to
 		 * have anything to do with the actual error location.
@@ -1098,8 +1149,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		severity = mce_severity(&m, cfg->tolerant, NULL);
 
 		/*
-		 * When machine check was for corrected handler don't touch,
-		 * unless we're panicing.
+		 * When machine check was for corrected/deferred handler don't
+		 * touch, unless we're panicing.
 		 */
 		if ((severity == MCE_KEEP_SEVERITY ||
 		     severity == MCE_UCNA_SEVERITY) && !no_way_out)
-- 
1.7.10.4

