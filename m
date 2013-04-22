Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932350Ab3DVOsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:48:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51441 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754438Ab3DVO3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:29:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andy Honig" <ahonig@google.com>,
        "Marcelo Tosatti" <mtosatti@redhat.com>
Date: Mon, 22 Apr 2013 15:25:59 +0100
Message-ID: <lsq.1366640759.822685429@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [73/75] KVM: Fix bounds checking in ioapic indirect register
 reads (CVE-2013-1798)
In-Reply-To: <lsq.1366640759.151900666@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.44-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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

