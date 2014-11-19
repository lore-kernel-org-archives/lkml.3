Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204AbaKSRg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:36:27 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37898 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaKSRg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:36:26 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: namit@cs.technion.ac.il
Subject: [PATCH] KVM: emulate: remove duplicated limit check
Date: Wed, 19 Nov 2014 18:36:19 +0100
Message-Id: <1416418579-12093-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check on the higher limit of the segment, and the check on the
maximum accessible size, is the same for both expand-up and
expand-down segments.  Only the computation of "lim" varies.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/emulate.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 43a5b432d06f..f62209e7ad84 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -654,20 +654,15 @@ static __always_inline int __linearize(struct x86_emulate_ctxt *ctxt,
 		if (!fetch && (desc.type & 8) && !(desc.type & 2))
 			goto bad;
 		lim = desc_limit_scaled(&desc);
-		if ((desc.type & 8) || !(desc.type & 4)) {
-			/* expand-up segment */
-			if (addr.ea > lim)
-				goto bad;
-			*max_size = min_t(u64, ~0u, (u64)lim + 1 - addr.ea);
-		} else {
+		if (!(desc.type & 8) && (desc.type & 4)) {
 			/* expand-down segment */
 			if (addr.ea <= lim)
 				goto bad;
 			lim = desc.d ? 0xffffffff : 0xffff;
-			if (addr.ea > lim)
-				goto bad;
-			*max_size = min_t(u64, ~0u, (u64)lim + 1 - addr.ea);
 		}
+		if (addr.ea > lim)
+			goto bad;
+		*max_size = min_t(u64, ~0u, (u64)lim + 1 - addr.ea);
 		if (size > *max_size)
 			goto bad;
 		la &= (u32)-1;
-- 
1.8.3.1

