Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935002AbaKLD6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 22:58:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277AbaKLBZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:25:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.17 126/319] KVM: x86: Decoding guest instructions which cross page boundary may fail
Date: Wed, 12 Nov 2014 10:14:24 +0900
Message-Id: <20141112011013.493463962@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Amit <namit@cs.technion.ac.il>

commit 08da44aedba0f493e10695fa334348a7a4f72eb3 upstream.

Once an instruction crosses a page boundary, the size read from the second page
disregards the common case that part of the operand resides on the first page.
As a result, fetch of long insturctions may fail, and thereby cause the
decoding to fail as well.

Fixes: 5cfc7e0f5e5e1adf998df94f8e36edaf5d30d38e
Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -773,8 +773,10 @@ static int __do_insn_fetch_bytes(struct
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


