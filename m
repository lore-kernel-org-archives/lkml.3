Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaLEWpy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:45:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53737 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaLEWpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 010/122] MIPS: tlbex: Fix potential HTW race on TLBL/M/S handlers
Date: Fri,  5 Dec 2014 14:43:04 -0800
Message-Id: <20141205223307.055708941@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>

commit 070e76cb3ffe43f6855492e77c96680c562598f0 upstream.

There is a potential race when probing the TLB in TLBL/M/S exception
handlers for a matching entry. Between the time we hit a TLBL/S/M
exception and the time we get to execute the TLBP instruction, the
HTW may have replaced the TLB entry we are interested in hence the TLB
probe may fail. However, in the existing handlers, we never checked the
status of the TLBP (ie check the result in the C0/Index register). We
fix this by adding such a check when the core implements the HTW. If
we couldn't find a matching entry, we return back and try again.

Signed-off-by: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8599/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/tlbex.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -1872,8 +1872,16 @@ build_r4000_tlbchange_handler_head(u32 *
 	uasm_l_smp_pgtable_change(l, *p);
 #endif
 	iPTE_LW(p, wr.r1, wr.r2); /* get even pte */
-	if (!m4kc_tlbp_war())
+	if (!m4kc_tlbp_war()) {
 		build_tlb_probe_entry(p);
+		if (cpu_has_htw) {
+			/* race condition happens, leaving */
+			uasm_i_ehb(p);
+			uasm_i_mfc0(p, wr.r3, C0_INDEX);
+			uasm_il_bltz(p, r, wr.r3, label_leave);
+			uasm_i_nop(p);
+		}
+	}
 	return wr;
 }
 


