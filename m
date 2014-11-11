Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaKKL5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:57:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799AbaKKLJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 050/170] KVM: x86: Improve thread safety in pit
Date: Tue, 11 Nov 2014 11:06:49 +0000
Message-Id: <1415704129-12709-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit 2febc839133280d5a5e8e1179c94ea674489dae2 upstream.

There's a race condition in the PIT emulation code in KVM.  In
__kvm_migrate_pit_timer the pit_timer object is accessed without
synchronization.  If the race condition occurs at the wrong time this
can crash the host kernel.

This fixes CVE-2014-3611.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/i8254.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 518d86471b76..298781d4cfb4 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -262,8 +262,10 @@ void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
 		return;
 
 	timer = &pit->pit_state.timer;
+	mutex_lock(&pit->pit_state.lock);
 	if (hrtimer_cancel(timer))
 		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
+	mutex_unlock(&pit->pit_state.lock);
 }
 
 static void destroy_pit_timer(struct kvm_pit *pit)
-- 
2.1.0

