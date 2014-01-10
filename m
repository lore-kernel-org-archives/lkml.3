Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803AbaAJHVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 02:21:21 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:49027 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaAJHVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 02:21:17 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Paul Mackerras <paulus@samba.org>,
        Alexander Graf <agraf@suse.de>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH] PPC: KVM: fix VCPU run for HV KVM
Date: Fri, 10 Jan 2014 18:21:07 +1100
Message-Id: <1389338467-26303-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.8.4.rc4
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011007-1396-0000-0000-000004201E46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When write to MMIO happens and there is an ioeventfd for that and
is handled successfully, ioeventfd_write() returns 0 (success) and
kvmppc_handle_store() returns EMULATE_DONE. Then kvmppc_emulate_mmio()
converts EMULATE_DONE to RESUME_GUEST_NV and this broke from the loop.

This adds handling of RESUME_GUEST_NV in kvmppc_vcpu_run_hv().

Cc: Michael S. Tsirkin <mst@redhat.com>
Suggested-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---

This definitely needs a better commit message. Please, help.
ps. it seems like ioeventfd never worked on ppc64. hm.

---
 arch/powerpc/kvm/book3s_hv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 072287f..24f363f 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1569,7 +1569,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_run *run, struct kvm_vcpu *vcpu)
 				vcpu->arch.fault_dar, vcpu->arch.fault_dsisr);
 			srcu_read_unlock(&vcpu->kvm->srcu, srcu_idx);
 		}
-	} while (r == RESUME_GUEST);
+	} while ((r == RESUME_GUEST_NV) || (r == RESUME_GUEST));
 
  out:
 	vcpu->arch.state = KVMPPC_VCPU_NOTREADY;
-- 
1.8.4.rc4

