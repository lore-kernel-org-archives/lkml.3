Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbbA2DDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:03:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47005 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759357AbbA2Chj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:39 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 027/139] KVM: s390: flush CPU on load control
Date: Wed, 28 Jan 2015 14:19:30 -0800
Message-Id: <1422483682-15393-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 2dca485f8740208604543c3960be31a5dd3ea603 upstream.

some control register changes will flush some aspects of the CPU, e.g.
POP explicitely mentions that for CR9-CR11 "TLBs may be cleared".
Instead of trying to be clever and only flush on specific CRs, let
play safe and flush on all lctl(g) as future machines might define
new bits in CRs. Load control intercept should not happen that often.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kvm/priv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 2440602..8821ac8 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -688,7 +688,7 @@ int kvm_s390_handle_lctl(struct kvm_vcpu *vcpu)
 			break;
 		reg = (reg + 1) % 16;
 	} while (1);
-
+	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	return 0;
 }
 
@@ -725,7 +725,7 @@ static int handle_lctlg(struct kvm_vcpu *vcpu)
 			break;
 		reg = (reg + 1) % 16;
 	} while (1);
-
+	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	return 0;
 }
 
-- 
1.9.1

