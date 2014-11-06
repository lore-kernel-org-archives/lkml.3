Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaKFXBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:01:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaKFWmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:38 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 098/162] KVM: x86: Improve thread safety in pit
Date: Thu,  6 Nov 2014 14:36:02 -0800
Message-Id: <1415313426-9622-99-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/i8254.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 518d864..298781d 100644
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
1.9.1

