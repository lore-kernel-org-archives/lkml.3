Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbaJCWiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:38:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbaJCWeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:34:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joachim Eastwood <manabian@gmail.com>,
        Nathan Lynch <nathan_lynch@mentor.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 3.14 117/238] ARM: 8178/1: fix set_tls for !CONFIG_KUSER_HELPERS
Date: Fri,  3 Oct 2014 14:30:32 -0700
Message-Id: <20141003212917.418068664@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Lynch <nathan_lynch@mentor.com>

commit 9cc6d9e5daaa147a9a3e31557efcb331989e77be upstream.

Joachim Eastwood reports that commit fbfb872f5f41 "ARM: 8148/1: flush
TLS and thumbee register state during exec" causes a boot-time crash
on a Cortex-M4 nommu system:

Freeing unused kernel memory: 68K (281e5000 - 281f6000)
Unhandled exception: IPSR = 00000005 LR = fffffff1
CPU: 0 PID: 1 Comm: swapper Not tainted 3.17.0-rc6-00313-gd2205fa30aa7 #191
task: 29834000 ti: 29832000 task.ti: 29832000
PC is at flush_thread+0x2e/0x40
LR is at flush_thread+0x21/0x40
pc : [<2800954a>] lr : [<2800953d>] psr: 4100000b
sp : 29833d60 ip : 00000000 fp : 00000001
r10: 00003cf8 r9 : 29b1f000 r8 : 00000000
r7 : 29b0bc00 r6 : 29834000 r5 : 29832000 r4 : 29832000
r3 : ffff0ff0 r2 : 29832000 r1 : 00000000 r0 : 282121f0
xPSR: 4100000b
CPU: 0 PID: 1 Comm: swapper Not tainted 3.17.0-rc6-00313-gd2205fa30aa7 #191
[<2800afa5>] (unwind_backtrace) from [<2800a327>] (show_stack+0xb/0xc)
[<2800a327>] (show_stack) from [<2800a963>] (__invalid_entry+0x4b/0x4c)

The problem is that set_tls is attempting to clear the TLS location in
the kernel-user helper page, which isn't set up on V7M.

Fix this by guarding the write to the kuser helper page with
a CONFIG_KUSER_HELPERS ifdef.

Fixes: fbfb872f5f41 ARM: 8148/1: flush TLS and thumbee register state during exec

Reported-by: Joachim Eastwood <manabian@gmail.com>
Tested-by: Joachim Eastwood <manabian@gmail.com>
Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/tls.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -81,6 +81,7 @@ static inline void set_tls(unsigned long
 			asm("mcr p15, 0, %0, c13, c0, 3"
 			    : : "r" (val));
 		} else {
+#ifdef CONFIG_KUSER_HELPERS
 			/*
 			 * User space must never try to access this
 			 * directly.  Expect your app to break
@@ -89,6 +90,7 @@ static inline void set_tls(unsigned long
 			 * entry-armv.S for details)
 			 */
 			*((unsigned int *)0xffff0ff0) = val;
+#endif
 		}
 
 	}


