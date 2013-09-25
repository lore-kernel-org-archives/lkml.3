Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab3IYBI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 21:08:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab3IYAQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [ 051/110] x86/mce: Pay no attention to F bit in MCACOD when parsing UC errors
Date: Tue, 24 Sep 2013 17:14:49 -0700
Message-Id: <20130925001328.939215987@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit 0ca06c0857aee11911f91621db14498496f2c2cd upstream.

The 0x1000 bit of the MCACOD field of machine check MCi_STATUS
registers is only defined for corrected errors (where it means
that hardware may be filtering errors see SDM section 15.9.2.1).

For uncorrected errors it may, or may not be set - so we should mask
it out when checking for the architecturaly defined recoverable
error signatures (see SDM 15.9.3.1 and 15.9.3.2)

Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/mce.h |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -32,11 +32,20 @@
 #define MCI_STATUS_PCC   (1ULL<<57)  /* processor context corrupt */
 #define MCI_STATUS_S	 (1ULL<<56)  /* Signaled machine check */
 #define MCI_STATUS_AR	 (1ULL<<55)  /* Action required */
-#define MCACOD		  0xffff     /* MCA Error Code */
+
+/*
+ * Note that the full MCACOD field of IA32_MCi_STATUS MSR is
+ * bits 15:0.  But bit 12 is the 'F' bit, defined for corrected
+ * errors to indicate that errors are being filtered by hardware.
+ * We should mask out bit 12 when looking for specific signatures
+ * of uncorrected errors - so the F bit is deliberately skipped
+ * in this #define.
+ */
+#define MCACOD		  0xefff     /* MCA Error Code */
 
 /* Architecturally defined codes from SDM Vol. 3B Chapter 15 */
 #define MCACOD_SCRUB	0x00C0	/* 0xC0-0xCF Memory Scrubbing */
-#define MCACOD_SCRUBMSK	0xfff0
+#define MCACOD_SCRUBMSK	0xeff0	/* Skip bit 12 ('F' bit) */
 #define MCACOD_L3WB	0x017A	/* L3 Explicit Writeback */
 #define MCACOD_DATA	0x0134	/* Data Load */
 #define MCACOD_INSTR	0x0150	/* Instruction Fetch */


