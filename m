Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994AbaCDUY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:24:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41645 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757138AbaCDUFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:05:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Honig <ahonig@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 3.10 44/97] kvm: x86: fix emulator buffer overflow (CVE-2014-0049)
Date: Tue,  4 Mar 2014 12:03:57 -0800
Message-Id: <20140304200347.484903499@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200345.895517495@linuxfoundation.org>
References: <20140304200345.895517495@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5982,7 +5982,7 @@ static int complete_emulated_mmio(struct
 		frag->len -= len;
 	}
 
-	if (vcpu->mmio_cur_fragment == vcpu->mmio_nr_fragments) {
+	if (vcpu->mmio_cur_fragment >= vcpu->mmio_nr_fragments) {
 		vcpu->mmio_needed = 0;
 		if (vcpu->mmio_is_write)
 			return 1;


