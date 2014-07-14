Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaGNLkK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:40:10 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:60478 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaGNLj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:39:26 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 18/19] KVM: x86: ensure emulator fetches do not span multiple pages
Date: Mon, 14 Jul 2014 13:38:42 +0200
Message-Id: <1405337923-4776-19-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
References: <1405337923-4776-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the CS base is not page-aligned, the linear address of the code could
get close to the page boundary (e.g. 0x...ffe) even if the EIP value is
not.  So we need to first linearize the address, and only then compute
the number of valid bytes that can be fetched.

This happens relatively often when executing real mode code.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c16314807756..6a1d60956d63 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -711,14 +711,18 @@ static int segmented_read_std(struct x86_emulate_ctxt *ctxt,
 static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 {
 	int rc;
-	int size;
+	unsigned size;
 	unsigned long linear;
 	int cur_size = ctxt->fetch.end - ctxt->fetch.data;
 	struct segmented_address addr = { .seg = VCPU_SREG_CS,
 					   .ea = ctxt->eip + cur_size };
 
-	size = min(15UL ^ cur_size,
-		   PAGE_SIZE - offset_in_page(addr.ea));
+	size = 15UL ^ cur_size;
+	rc = __linearize(ctxt, addr, size, false, true, &linear);
+	if (unlikely(rc != X86EMUL_CONTINUE))
+		return rc;
+
+	size = min_t(unsigned, size, PAGE_SIZE - offset_in_page(linear));
 
 	/*
 	 * One instruction can only straddle two pages,
@@ -728,9 +732,6 @@ static int __do_insn_fetch_bytes(struct x86_emulate_ctxt *ctxt, int op_size)
 	 */
 	if (unlikely(size < op_size))
 		return X86EMUL_UNHANDLEABLE;
-	rc = __linearize(ctxt, addr, size, false, true, &linear);
-	if (unlikely(rc != X86EMUL_CONTINUE))
-		return rc;
 	rc = ctxt->ops->fetch(ctxt, linear, ctxt->fetch.end,
 			      size, &ctxt->exception);
 	if (unlikely(rc != X86EMUL_CONTINUE))
-- 
1.8.3.1


