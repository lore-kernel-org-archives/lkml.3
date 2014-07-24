Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804AbaGXLyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:54:18 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:18211 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaGXLyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:54:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQCAIDy0FOERCABjGdsb2JhbABZhDfQbgGBDBYQAQEBJz2EBAEFJ1IQUVcZiEK5VYZXF45nZAcWhDAFimOoXWmBAw
X-IPAS-Result: AlQCAIDy0FOERCABjGdsb2JhbABZhDfQbgGBDBYQAQEBJz2EBAEFJ1IQUVcZiEK5VYZXF45nZAcWhDAFimOoXWmBAw
X-IronPort-AV: E=Sophos;i="5.01,723,1400014800"; 
   d="scan'208";a="116773270"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, nadav.amit@gmail.com,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 1/2] KVM: x86: Setting rflags.rf during rep-string emulation
Date: Thu, 24 Jul 2014 14:51:23 +0300
Message-Id: <1406202684-5226-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406202684-5226-1-git-send-email-namit@cs.technion.ac.il>
References: <53CD080A.1000400@redhat.com>
 <1406202684-5226-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates RF for rep-string emulation.  The flag is set upon the first
iteration, and cleared after the last (if emulated). It is intended to make
sure that if a trap (in future data/io #DB emulation) or interrupt is delivered
to the guest during the rep-string instruction, RF will be set correctly. RF
affects whether instruction breakpoint in the guest is masked.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8d41556..57743ed 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -4683,7 +4683,10 @@ special_insn:
 			goto done;
 	}
 
-	ctxt->eflags &= ~EFLG_RF;
+	if (ctxt->rep_prefix && (ctxt->d & String))
+		ctxt->eflags |= EFLG_RF;
+	else
+		ctxt->eflags &= ~EFLG_RF;
 
 	if (ctxt->execute) {
 		if (ctxt->d & Fastop) {
@@ -4824,6 +4827,7 @@ writeback:
 			}
 			goto done; /* skip rip writeback */
 		}
+		ctxt->eflags &= ~EFLG_RF;
 	}
 
 	ctxt->eip = ctxt->_eip;
-- 
1.9.1

