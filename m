Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab3F1VXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:23:22 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34138 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab3F1VXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:23:21 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: David Daney <david.daney@cavium.com>, James Hogan <james.hogan@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>, Oleg Nesterov <oleg@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        <linux-mips@linux-mips.org>, <stable@vger.kernel.org>
Subject: [PATCH v4] MIPS: Reduce _NSIG from 128 to 127 to avoid BUG_ON
Date: Fri, 28 Jun 2013 22:22:42 +0100
Message-ID: <1372454562-1513-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_28_22_23_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MIPS has 128 signals, the highest of which has the number 128 (they
start from 1). The following command causes get_signal_to_deliver() to
pass this signal number straight through to do_group_exit() as the exit
code:

  strace sleep 10 & sleep 1 && kill -128 `pidof sleep`

However do_group_exit() checks for the core dump bit (0x80) in the exit
code which matches in this particular case and the kernel panics:

  BUG_ON(exit_code & 0x80); /* core dumps don't get here */

Lets avoid this by changing the ABI by reducing the number of signals to
127 (so that the maximum signal number is 127). This is not the final
solution, since signal 127 also has its own share of problems, but it's
impact should be fairly minimal since Glibc already incorrectly sets
[__]SIGRTMAX to 127. uClibc used to set it to 128 so it's conceivable
that programs built against uClibc which intentionally use RT signals
from the top (SIGRTMAX-n, n>=0) would need an updated uClibc (and a
rebuild if it's crazy enough to use __SIGRTMAX).

Note that the signals man page seems to make clear that signals should
be referred to from SIGRTMIN, and it seems unlikely that any portable
program would ever need to use 96 RT signals:

  "programs should never refer to real-time signals using hard-coded
  numbers, but instead should always refer to real-time signals using
  the notation SIGRTMIN+n, and include suitable (run-time) checks that
  SIGRTMIN+n does not exceed SIGRTMAX."

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: David Daney <david.daney@cavium.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: linux-mips@linux-mips.org
Cc: stable@vger.kernel.org
---
Thanks for all the feedback on the patches.

This is a resend of v2 with tweaks to the commit message:
* add David Daney's Acked-by
* cc stable
* make clear it's not the final solution
* uClibc *used to* set __SIGRTMAX to 128 but is now fixed to match glibc
  (thanks Denys)

 arch/mips/include/uapi/asm/signal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/include/uapi/asm/signal.h b/arch/mips/include/uapi/asm/signal.h
index addb9f5..40e944d 100644
--- a/arch/mips/include/uapi/asm/signal.h
+++ b/arch/mips/include/uapi/asm/signal.h
@@ -11,9 +11,9 @@
 
 #include <linux/types.h>
 
-#define _NSIG		128
+#define _NSIG		127
 #define _NSIG_BPW	(sizeof(unsigned long) * 8)
-#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
+#define _NSIG_WORDS	((_NSIG + _NSIG_BPW - 1) / _NSIG_BPW)
 
 typedef struct {
 	unsigned long sig[_NSIG_WORDS];
-- 
1.8.1.2


