Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaHTLUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:20:11 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:50335 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaHTLUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:20:07 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: namit@cs.technion.ac.il
Subject: [PATCH] KVM: x86: do not check CS.DPL against RPL during task switch
Date: Wed, 20 Aug 2014 13:20:00 +0200
Message-Id: <1408533600-17585-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts the check added by commit 5045b468037d (KVM: x86: check CS.DPL
against RPL during task switch, 2014-05-15).  Although the CS.DPL=CS.RPL
check is mentioned in table 7-1 of the SDM as causing a #TSS exception,
it is not mentioned in table 6-6 that lists "invalid TSS conditions"
which cause #TSS exceptions. In fact it causes some tests to fail, which
pass on bare-metal.

Keep the rest of the commit, since we will find new uses for it in 3.18.

Reported-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index ef117b842334..03954f7900f5 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1491,9 +1491,6 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 			goto exception;
 		break;
 	case VCPU_SREG_CS:
-		if (in_task_switch && rpl != dpl)
-			goto exception;
-
 		if (!(seg_desc.type & 8))
 			goto exception;
 
-- 
1.8.3.1

