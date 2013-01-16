Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3APMBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:01:20 -0500
Received: from smtp.citrix.com ([66.165.176.89]:6175 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab3APMBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:01:19 -0500
X-IronPort-AV: E=Sophos;i="4.84,478,1355097600"; 
   d="scan'208";a="3915568"
From: Andrew Cooper <andrew.cooper3@citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: Andrew Cooper <andrew.cooper3@citrix.com>,
        Frediano Ziglio <frediano.ziglio@citrix.com>, <stable@vger.kernel.org>,
        <oss-security@lists.openwall.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>, <xen-devel@lists.xen.org>,
        <security@xen.org>
Subject: [PATCH] xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS guests.
Date: Wed, 16 Jan 2013 12:00:55 +0000
Message-ID: <1358337655-26221-1-git-send-email-andrew.cooper3@citrix.com>
X-Mailer: git-send-email 1.7.2.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes CVE-2013-0190 / XSA-40

There has been an error on the xen_failsafe_callback path for failed
iret, which causes the stack pointer to be wrong when entering the
iret_exc error path.  This can result in the kernel crashing.

In the classic kernel case, the relevant code looked a little like:

        popl %eax      # Error code from hypervisor
        jz 5f
        addl $16,%esp
        jmp iret_exc   # Hypervisor said iret fault
5:      addl $16,%esp
                       # Hypervisor said segment selector fault

Here, there are two identical addls on either option of a branch which
appears to have been optimised by hoisting it above the jz, and
converting it to an lea, which leaves the flags register unaffected.

In the PVOPS case, the code looks like:

        popl_cfi %eax         # Error from the hypervisor
        lea 16(%esp),%esp     # Add $16 before choosing fault path
        CFI_ADJUST_CFA_OFFSET -16
        jz 5f
        addl $16,%esp         # Incorrectly adjust %esp again
        jmp iret_exc

It is possible unprivileged userspace applications to cause this
behaviour, for example by loading an LDT code selector, then changing
the code selector to be not-present.  At this point, there is a race
condition where it is possible for the hypervisor to return back to
userspace from an interrupt, fault on its own iret, and inject a
failsafe_callback into the kernel.

This bug has been present since the introduction of Xen PVOPS support
in commit 5ead97c84 (xen: Core Xen implementation), in 2.6.23.

Signed-off-by: Frediano Ziglio <frediano.ziglio@citrix.com>
Signed-off-by: Andrew Cooper <andrew.cooper3@citrix.com>
Cc: stable@vger.kernel.org

---
Cc: oss-security@lists.openwall.com
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: xen-devel@lists.xen.org
Cc: security@xen.org
---
 arch/x86/kernel/entry_32.S |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index ff84d54..6ed91d9 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1065,7 +1065,6 @@ ENTRY(xen_failsafe_callback)
 	lea 16(%esp),%esp
 	CFI_ADJUST_CFA_OFFSET -16
 	jz 5f
-	addl $16,%esp
 	jmp iret_exc
 5:	pushl_cfi $-1 /* orig_ax = -1 => not a system call */
 	SAVE_ALL
-- 
1.7.2.5

