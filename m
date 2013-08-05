Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3HEE73 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 00:59:29 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:47111 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3HEE71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 00:59:27 -0400
Message-ID: <51FF3127.5030206@linux.vnet.ibm.com>
Date: Mon, 05 Aug 2013 12:59:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH] KVM: MMU: fix check the reserved bits on the gpte of L2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080504-2000-0000-0000-00000D2DB7DE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code always uses arch.mmu to check the reserved bits on guest gpte
which is valid only for L1 guest, we should use arch.nested_mmu instead when
we translate gva to gpa for the L2 guest

Fix it by using @mmu instead since it is adapted to the current mmu mode
automatically

The bug can be triggered when nested npt is used and L1 guest and L2 guest
use different mmu mode

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/paging_tmpl.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7769699..3a75828 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -218,8 +218,7 @@ retry_walk:
 		if (unlikely(!is_present_gpte(pte)))
 			goto error;

-		if (unlikely(is_rsvd_bits_set(&vcpu->arch.mmu, pte,
-					      walker->level))) {
+		if (unlikely(is_rsvd_bits_set(mmu, pte, walker->level))) {
 			errcode |= PFERR_RSVD_MASK | PFERR_PRESENT_MASK;
 			goto error;
 		}
-- 
1.8.1.4

