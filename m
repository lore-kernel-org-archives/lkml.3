Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858AbaBEUob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:44:31 -0500
Received: from mail.windriver.com ([147.11.1.11]:55069 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbaBEUGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:23 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Andy Honig <ahonig@google.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 116/213] KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)
Date: Wed, 5 Feb 2014 15:01:11 -0500
Message-ID: <1391630568-49251-117-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Honig <ahonig@google.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 virt/kvm/ioapic.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 3500dee9cf2b..57afcdaa2863 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -72,9 +72,12 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
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
1.8.5.2

