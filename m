Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab3BCPNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:13:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab3BCO4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:25 -0500
Message-Id: <20130203144649.281157905@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Andrew Cooper <andrew.cooper3@citrix.com>,
        Frediano Ziglio <frediano.ziglio@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 059/128] xen: Fix stack corruption in xen_failsafe_callback for 32bit PVOPS
 guests.
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Cooper <andrew.cooper3@citrix.com>

commit 9174adbee4a9a49d0139f5d71969852b36720809 upstream.

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
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/entry_32.S |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 88b725a..cf8639b 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1084,7 +1084,6 @@ ENTRY(xen_failsafe_callback)
 	lea 16(%esp),%esp
 	CFI_ADJUST_CFA_OFFSET -16
 	jz 5f
-	addl $16,%esp
 	jmp iret_exc
 5:	pushl_cfi $-1 /* orig_ax = -1 => not a system call */
 	SAVE_ALL


