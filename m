Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433AbaKRO4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:56:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932143AbaKROJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:51 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Honig <ahonig@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 104/206] KVM: x86: Improve thread safety in pit
Date: Tue, 18 Nov 2014 15:07:39 +0100
Message-Id: <5671c6a9229edd1b1587b4ea1014d540a7e74797.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Honig <ahonig@google.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 2febc839133280d5a5e8e1179c94ea674489dae2 upstream.

There's a race condition in the PIT emulation code in KVM.  In
__kvm_migrate_pit_timer the pit_timer object is accessed without
synchronization.  If the race condition occurs at the wrong time this
can crash the host kernel.

This fixes CVE-2014-3611.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

