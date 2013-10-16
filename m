Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761581Ab3JPRqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 13:46:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35542 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761291Ab3JPRpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:45:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mischa Jonker <mjonker@synopsys.com>,
        Vineet Gupta <vgupta@synopsys.com>
Subject: [ 17/69] ARC: Handle zero-overhead-loop in unaligned access handler
Date: Wed, 16 Oct 2013 10:44:26 -0700
Message-Id: <20131016174314.982289638@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mischa Jonker <mjonker@synopsys.com>

commit c11eb222fd7d4db91196121dbf854178505d2751 upstream.

If a load or store is the last instruction in a zero-overhead-loop, and
it's misaligned, the loop would execute only once.

This fixes that problem.

Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/unaligned.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/arc/kernel/unaligned.c
+++ b/arch/arc/kernel/unaligned.c
@@ -233,6 +233,12 @@ int misaligned_fixup(unsigned long addre
 		regs->status32 &= ~STATUS_DE_MASK;
 	} else {
 		regs->ret += state.instr_len;
+
+		/* handle zero-overhead-loop */
+		if ((regs->ret == regs->lp_end) && (regs->lp_count)) {
+			regs->ret = regs->lp_start;
+			regs->lp_count--;
+		}
 	}
 
 	return 0;


