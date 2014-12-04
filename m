Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbaLDP5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:57:40 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:35216 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479AbaLDP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:35 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 6/9] KVM: cpuid: mask more bits in leaf 0xd and subleaves
Date: Thu,  4 Dec 2014 16:57:11 +0100
Message-Id: <1417708634-24333-7-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- EAX=0Dh, ECX=1: output registers ECX/EDX are reserved.

- EAX=0Dh, ECX>1: output register ECX bit 0 is clear for all the CPUID
leaves we support, because variable "supported" comes from XCR0 and not
XSS.  Bits above 0 are reserved, so ECX is overall zero.  Output register
EDX is reserved.

Source: Intel Architecture Instruction Set Extensions Programming
Reference, ref. number 319433-022

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2f7bc2de9915..644bfe828ce1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -482,8 +482,14 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 					entry[i].ebx =
 						xstate_required_size(supported,
 								     true);
-			} else if (entry[i].eax == 0 || !(supported & mask))
-				continue;
+			} else {
+				if (entry[i].eax == 0 || !(supported & mask))
+					continue;
+				if (WARN_ON_ONCE(entry[i].ecx & 1))
+					continue;
+			}
+			entry[i].ecx = 0;
+			entry[i].edx = 0;
 			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
-- 
1.8.3.1


