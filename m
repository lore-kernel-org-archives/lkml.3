Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaCYRVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:21:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbaCYRU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:20:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 75/81] kvm: x86: fix emulator buffer overflow (CVE-2014-0049)
Date: Tue, 25 Mar 2014 10:16:28 -0700
Message-Id: <1395767794-5012-76-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Honig <ahonig@google.com>

commit a08d3b3b99efd509133946056531cdf8f3a0c09b upstream.

The problem occurs when the guest performs a pusha with the stack
address pointing to an mmio address (or an invalid guest physical
address) to start with, but then extending into an ordinary guest
physical address.  When doing repeated emulated pushes
emulator_read_write sets mmio_needed to 1 on the first one.  On a
later push when the stack points to regular memory,
mmio_nr_fragments is set to 0, but mmio_is_needed is not set to 0.

As a result, KVM exits to userspace, and then returns to
complete_emulated_mmio.  In complete_emulated_mmio
vcpu->mmio_cur_fragment is incremented.  The termination condition of
vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments is never achieved.
The code bounces back and fourth to userspace incrementing
mmio_cur_fragment past it's buffer.  If the guest does nothing else it
eventually leads to a a crash on a memcpy from invalid memory address.

However if a guest code can cause the vm to be destroyed in another
vcpu with excellent timing, then kvm_clear_async_pf_completion_queue
can be used by the guest to control the data that's pointed to by the
call to cancel_work_item, which can be used to gain execution.

Fixes: f78146b0f9230765c6315b2e14f56112513389ad
Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf8c370..6d5a54c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5888,7 +5888,7 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 		frag->len -= len;
 	}
 
-	if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
+	if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed = 0;
 		if (vcpu->mmio_is_write)
 			return 1;
-- 
1.8.3.2

