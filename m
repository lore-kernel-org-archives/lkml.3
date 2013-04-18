Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967176Ab3DRJ3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:29:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40165 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757556Ab3DRJR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrew Honig <ahonig@google.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 36/72] KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)
Date: Thu, 18 Apr 2013 10:16:21 +0100
Message-Id: <1366276617-3553-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Honig <ahonig@google.com>

commit a2c118bfab8bc6b8bb213abfc35201e441693d55 upstream.

If the guest specifies a IOAPIC_REG_SELECT with an invalid value and follows
that with a read of the IOAPIC_REG_WINDOW KVM does not properly validate
that request.  ioapic_read_indirect contains an
ASSERT(redir_index < IOAPIC_NUM_PINS), but the ASSERT has no effect in
non-debug builds.  In recent kernels this allows a guest to cause a kernel
oops by reading invalid memory.  In older kernels (pre-3.3) this allows a
guest to read from large ranges of host memory.

Tested: tested against apic unit tests.

Signed-off-by: Andrew Honig <ahonig@google.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 virt/kvm/ioapic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 26fd54d..fdb1faf 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -73,9 +73,12 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 			u32 redir_index = (ioapic->ioregsel - 0x10) >> 1;
 			u64 redir_content;
 
-			ASSERT(redir_index < IOAPIC_NUM_PINS);
+			if (redir_index < IOAPIC_NUM_PINS)
+				redir_content =
+					ioapic->redirtbl[redir_index].bits;
+			else
+				redir_content = ~0ULL;
 
-			redir_content = ioapic->redirtbl[redir_index].bits;
 			result = (ioapic->ioregsel & 0x1) ?
 			    (redir_content >> 32) & 0xffffffff :
 			    redir_content & 0xffffffff;
-- 
1.8.1.2

