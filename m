Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933178AbaJXPIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 11:08:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933122AbaJXPH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 11:07:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Nadav Amit <namit@cs.technion.ac.il>, stable@vger.kernel.org
Subject: [PATCH 09/14] KVM: x86: Decoding guest instructions which cross page boundary may fail
Date: Fri, 24 Oct 2014 17:07:20 +0200
Message-Id: <1414163245-18555-10-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nadav Amit <namit@cs.technion.ac.il>

Once an instruction crosses a page boundary, the size read from the second page
disregards the common case that part of the operand resides on the first page.
As a result, fetch of long insturctions may fail, and thereby cause the
decoding to fail as well.

Cc: stable@vger.kernel.org
Fixes: 5cfc7e0f5e5e1adf998df94f8e36edaf5d30d38e
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c0deaff8d9f0..02c8ea804aaf 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -778,8 +778,10 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 static __always_inline int do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt,
 					       unsigned size)
 {
-	if (unlikely(ctxt->fetch.end - ctxt->fetch.ptr < size))
-		return __do_insn_fetch_bytes(ctxt, size);
+	unsigned done_size = ctxt->fetch.end - ctxt->fetch.ptr;
+
+	if (unlikely(done_size < size))
+		return __do_insn_fetch_bytes(ctxt, size - done_size);
 	else
 		return X86EMUL_CONTINUE;
 }
-- 
1.8.3.1


