Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbaFXQXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:23:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbaFXPye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, Sanjay Lal <sanjayl@kymasys.com>
Subject: [PATCH 3.14 38/68] MIPS: KVM: Allocate at least 16KB for exception handlers
Date: Tue, 24 Jun 2014 11:50:57 -0400
Message-Id: <20140624154725.644406717@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hogan <james.hogan@imgtec.com>

commit 7006e2dfda9adfa40251093604db76d7e44263b3 upstream.

Each MIPS KVM guest has its own copy of the KVM exception vector. This
contains the TLB refill exception handler at offset 0x000, the general
exception handler at offset 0x180, and interrupt exception handlers at
offset 0x200 in case Cause_IV=1. A common handler is copied to offset
0x2000 and offset 0x3000 is used for temporarily storing k1 during entry
from guest.

However the amount of memory allocated for this purpose is calculated as
0x200 rounded up to the next page boundary, which is insufficient if 4KB
pages are in use. This can lead to the common handler at offset 0x2000
being overwritten and infinitely recursive exceptions on the next exit
from the guest.

Increase the minimum size from 0x200 to 0x4000 to cover the full use of
the page.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>
Cc: kvm@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: Sanjay Lal <sanjayl@kymasys.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kvm/kvm_mips.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -304,7 +304,7 @@ struct kvm_vcpu *kvm_arch_vcpu_create(st
 	if (cpu_has_veic || cpu_has_vint) {
 		size = 0x200 + VECTORSPACING * 64;
 	} else {
-		size = 0x200;
+		size = 0x4000;
 	}
 
 	/* Save Linux EBASE */


