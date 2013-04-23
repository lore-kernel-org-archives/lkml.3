Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab3DWVyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:54:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34226 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757690Ab3DWVyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:54:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andrew Honig <ahonig@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 09/26] KVM: Fix bounds checking in ioapic indirect register reads (CVE-2013-1798)
Date: Tue, 23 Apr 2013 14:53:49 -0700
Message-Id: <20130423215334.317728118@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215333.344045754@linuxfoundation.org>
References: <20130423215333.344045754@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/ioapic.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -73,9 +73,12 @@ static unsigned long ioapic_read_indirec
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


