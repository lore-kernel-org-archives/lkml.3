Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789Ab3ILRqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:46:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577Ab3ILRpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: [ 23/23] Revert "KVM: X86 emulator: fix source operand decoding for 8bit mov[zs]x instructions"
Date: Thu, 12 Sep 2013 10:45:19 -0700
Message-Id: <20130912174454.257621999@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 5b5b30580218eae22609989546bac6e44d0eda6e, which was
commit 660696d1d16a71e15549ce1bf74953be1592bcd3 upstream.

Paul Gortmaker <paul.gortmaker@windriver.com> writes:

[this patch] introduces the following:

arch/x86/kvm/emulate.c: In function ‘decode_operand’:
arch/x86/kvm/emulate.c:3974:4: warning: passing argument 1 of ‘decode_register’ makes integer from pointer
+without a cast [enabled by default]
arch/x86/kvm/emulate.c:789:14: note: expected ‘u8’ but argument is of type ‘struct x86_emulate_ctxt *’
arch/x86/kvm/emulate.c:3974:4: warning: passing argument 2 of ‘decode_register’ makes pointer from integer
+without a cast [enabled by default]
arch/x86/kvm/emulate.c:789:14: note: expected ‘long unsigned int *’ but argument is of type ‘u8’

Based on the severity of the warnings above, I'm reasonably sure there will
be some kind of runtime regressions due to this, but I stopped to investigate
the warnings as soon as I saw them, before any run time testing.

It happens because mainline v3.7-rc1~113^2~40 (dd856efafe60) does this:

-static void *decode_register(u8 modrm_reg, unsigned long *regs,
+static void *decode_register(struct x86_emulate_ctxt *ctxt, u8 modrm_reg,

Since 660696d1d16a71e1 was only applied to stable 3.4, 3.8, and 3.9 -- and
the prerequisite above is in 3.7+, the issue should be limited to 3.4.44+

Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/emulate.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3737,10 +3737,6 @@ static int decode_operand(struct x86_emu
 		break;
 	case OpMem8:
 		ctxt->memop.bytes = 1;
-		if (ctxt->memop.type == OP_REG) {
-			ctxt->memop.addr.reg = decode_register(ctxt, ctxt->modrm_rm, 1);
-			fetch_register_operand(&ctxt->memop);
-		}
 		goto mem_common;
 	case OpMem16:
 		ctxt->memop.bytes = 2;


