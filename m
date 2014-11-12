Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaKLB0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:26:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaKLB0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:26:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.17 130/319] KVM: x86: Improve thread safety in pit
Date: Wed, 12 Nov 2014 10:14:28 +0900
Message-Id: <20141112011014.113378355@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/i8254.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -262,8 +262,10 @@ void __kvm_migrate_pit_timer(struct kvm_
 		return;
 
 	timer = &pit->pit_state.timer;
+	mutex_lock(&pit->pit_state.lock);
 	if (hrtimer_cancel(timer))
 		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
+	mutex_unlock(&pit->pit_state.lock);
 }
 
 static void destroy_pit_timer(struct kvm_pit *pit)


