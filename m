Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbbALTPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:15:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57347 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbbALSFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 018/216] KVM: s390: flush CPU on load control
Date: Mon, 12 Jan 2015 18:02:15 +0000
Message-Id: <1421085933-32536-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/s390/kvm/priv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index f89c1cd67751..9f41229df1aa 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -800,7 +800,7 @@ int kvm_s390_handle_lctl(struct kvm_vcpu *vcpu)
 			break;
 		reg = (reg + 1) % 16;
 	} while (1);
-
+	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	return 0;
 }
 
@@ -872,7 +872,7 @@ static int handle_lctlg(struct kvm_vcpu *vcpu)
 			break;
 		reg = (reg + 1) % 16;
 	} while (1);
-
+	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 	return 0;
 }
 
-- 
2.1.4

