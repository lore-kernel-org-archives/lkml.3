Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbaJDAny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:43:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44721 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755024AbaJCVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PATCH 3.16 042/357] arm/arm64: KVM: Complete WFI/WFE instructions
Date: Fri,  3 Oct 2014 14:27:08 -0700
Message-Id: <20141003212934.726049384@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kvm/handle_exit.c   |    2 ++
 arch/arm64/kvm/handle_exit.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/arm/kvm/handle_exit.c
+++ b/arch/arm/kvm/handle_exit.c
@@ -93,6 +93,8 @@ static int kvm_handle_wfx(struct kvm_vcp
 	else
 		kvm_vcpu_block(vcpu);
 
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+
 	return 1;
 }
 
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -66,6 +66,8 @@ static int kvm_handle_wfx(struct kvm_vcp
 	else
 		kvm_vcpu_block(vcpu);
 
+	kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
+
 	return 1;
 }
 


