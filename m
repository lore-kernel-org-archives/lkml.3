Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934163AbbA1EVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:21:17 -0500
Received: from mail.kernel.org ([198.145.29.136]:39495 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933188AbbA1EVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:21:12 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Honig <ahonig@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 079/177] KVM: x86: Improve thread safety in pit
Date: Wed, 28 Jan 2015 12:08:44 +0800
Message-Id: <1422418236-12852-157-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Honig <ahonig@google.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 2febc839133280d5a5e8e1179c94ea674489dae2 upstream.

There's a race condition in the PIT emulation code in KVM.  In
__kvm_migrate_pit_timer the pit_timer object is accessed without
synchronization.  If the race condition occurs at the wrong time this
can crash the host kernel.

This fixes CVE-2014-3611.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/x86/kvm/i8254.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index d68f99d..db336f9 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -263,8 +263,10 @@ void __kvm_migrate_pit_timer(struct kvm_vcpu *vcpu)
 		return;
 
 	timer = &pit->pit_state.pit_timer.timer;
+	mutex_lock(&pit->pit_state.lock);
 	if (hrtimer_cancel(timer))
 		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
+	mutex_unlock(&pit->pit_state.lock);
 }
 
 static void destroy_pit_timer(struct kvm_pit *pit)
-- 
1.9.1

