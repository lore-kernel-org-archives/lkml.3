Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaHSUhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 16:37:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaHSUhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 16:37:43 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: [PATCH 5/9] KVM: VMX: clamp PLE window
Date: Tue, 19 Aug 2014 22:35:32 +0200
Message-Id: <1408480536-8240-6-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modifications could get unwanted values of PLE window. (low or negative)
Use ple_window and the maximal value that cannot overflow as bounds.

ple_window_max defaults to a very high value, but it would make sense to
set it to some fraction of the scheduler tick.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/vmx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 66259fd..e1192fb 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -144,6 +144,10 @@ module_param(ple_window_grow, int, S_IRUGO);
 static int ple_window_shrink = KVM_VMX_DEFAULT_PLE_WINDOW_SHRINK;
 module_param(ple_window_shrink, int, S_IRUGO);
 
+/* Default is to compute the maximum so we can never overflow. */
+static int ple_window_max = INT_MAX / KVM_VMX_DEFAULT_PLE_WINDOW_GROW;
+module_param(ple_window_max, int, S_IRUGO);
+
 extern const ulong vmx_return;
 
 #define NR_AUTOLOAD_MSRS 8
@@ -5704,7 +5708,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	else
 		new = old + ple_window_grow;
 
-	vmx->ple_window = new;
+	vmx->ple_window = min(new, ple_window_max);
 }
 
 static void shrink_ple_window(struct kvm_vcpu *vcpu)
@@ -5720,7 +5724,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	else
 		new = old - ple_window_shrink;
 
-	vmx->ple_window = new;
+	vmx->ple_window = max(new, ple_window);
 }
 
 /*
-- 
2.0.4

