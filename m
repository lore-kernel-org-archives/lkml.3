Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbaI3Vzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:55:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaI3Vhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 087/103] arm/arm64: KVM: Complete WFI/WFE instructions
Date: Tue, 30 Sep 2014 14:31:32 -0700
Message-Id: <1412112708-27356-88-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Dall <christoffer.dall@linaro.org>

commit 05e0127f9e362b36aa35f17b1a3d52bca9322a3a upstream.

The architecture specifies that when the processor wakes up from a WFE
or WFI instruction, the instruction is considered complete, however we
currrently return to EL1 (or EL0) at the WFI/WFE instruction itself.

While most guests may not be affected by this because their local
exception handler performs an exception returning setting the event bit
or with an interrupt pending, some guests like UEFI will get wedged due
this little mishap.

Simply skip the instruction when we have completed the emulation.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/kvm/handle_exit.c   | 2 ++
 arch/arm64/kvm/handle_exit.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/kvm/handle_exit.c b/arch/arm/kvm/handle_exit.c
index a920790..77793ff 100644
--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -91,6 +91,8 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	else
 		kvm_vcpu_block(vcpu);
 
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+
 	return 1;
 }
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 8da5606..950b954 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -65,6 +65,8 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	else
 		kvm_vcpu_block(vcpu);
 
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+
 	return 1;
 }
 
-- 
1.9.1

