Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaFBPeg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:34:36 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:51781 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbaFBPed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:34:33 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHFoQqBIofpkmBag
X-IPAS-Result: AusBADuZjFOERCABjGdsb2JhbABYxwcBgRMWDgEBASc8giYBBSdSEFFXGYhCzg+FLReNbmQHFoQqBIofpkmBag
X-IronPort-AV: E=Sophos;i="4.98,957,1392156000"; 
   d="scan'208";a="109853143"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 2/9] KVM: x86: Emulator ignores LDTR/TR extended base on LLDT/LTR
Date: Mon,  2 Jun 2014 18:34:04 +0300
Message-Id: <1401723251-8034-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
References: <1401723251-8034-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation ignores the LDTR/TR base high 32-bits on long-mode.
As a result the loaded segment descriptor may be incorrect.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/emulate.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8ec4a3e..136088f 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1422,6 +1422,7 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	ulong desc_addr;
 	int ret;
 	u16 dummy;
+	u32 base3 = 0;
 
 	memset(&seg_desc, 0, sizeof seg_desc);
 
@@ -1538,9 +1539,14 @@ static int __load_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 		ret = write_segment_descriptor(ctxt, selector, &seg_desc);
 		if (ret != X86EMUL_CONTINUE)
 			return ret;
+	} else if (ctxt->mode == X86EMUL_MODE_PROT64) {
+		ret = ctxt->ops->read_std(ctxt, desc_addr+8, &base3,
+				sizeof(base3), &ctxt->exception);
+		if (ret != X86EMUL_CONTINUE)
+			return ret;
 	}
 load:
-	ctxt->ops->set_segment(ctxt, selector, &seg_desc, 0, seg);
+	ctxt->ops->set_segment(ctxt, selector, &seg_desc, base3, seg);
 	return X86EMUL_CONTINUE;
 exception:
 	emulate_exception(ctxt, err_vec, err_code, true);
-- 
1.9.1

