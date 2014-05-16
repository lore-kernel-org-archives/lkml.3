Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbaEPSfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:35:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748AbaEPSfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:35:18 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 1/2] x86: insn decoder: create artificial 3rd byte for 2-byte VEX
Date: Fri, 16 May 2014 20:34:38 +0200
Message-Id: <1400265279-22503-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch, users need to do this to fetch vex.vvvv:

        if (insn->vex_prefix.nbytes == 2) {
                vex_vvvv = ((insn->vex_prefix.bytes[1] >> 3) & 0xf) ^ 0xf;
        }
        if (insn->vex_prefix.nbytes == 3) {
                vex_vvvv = ((insn->vex_prefix.bytes[2] >> 3) & 0xf) ^ 0xf;
        }

Make it so that insn->vex_prefix.bytes[2] always contains vex.wvvvvLpp bits.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/lib/insn.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
index 54fcffe..829ca4c 100644
--- a/arch/x86/lib/insn.c
+++ b/arch/x86/lib/insn.c
@@ -163,6 +163,12 @@ found:
 				/* VEX.W overrides opnd_size */
 				insn->opnd_bytes = 8;
 		} else {
+			/*
+			 * For VEX2, fake VEX3-like byte#2.
+			 * Makes it easier to decode vex.W, vex.vvvv,
+			 * vex.L and vex.pp. Masking with 0x7f sets vex.W == 0.
+			 */
+			insn->vex_prefix.bytes[2] = b2 & 0x7f;
 			insn->vex_prefix.nbytes = 2;
 			insn->next_byte += 2;
 		}
-- 
1.8.1.4

