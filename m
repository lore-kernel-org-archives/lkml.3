Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaLCLo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:44:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbaLCL1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nathan Lynch <nathan_lynch@mentor.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 037/101] ARM: 8198/1: make kuser helpers depend on MMU
Date: Wed,  3 Dec 2014 12:25:59 +0100
Message-Id: <d8149279a2ec936d50ab54e51b803477fefc55dd.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nathan Lynch <nathan_lynch@mentor.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 08b964ff3c51b10aaf2e6ba639f40054c09f0f7a upstream.

The kuser helpers page is not set up on non-MMU systems, so it does
not make sense to allow CONFIG_KUSER_HELPERS to be enabled when
CONFIG_MMU=n.  Allowing it to be set on !MMU results in an oops in
set_tls (used in execve and the arm_syscall trap handler):

Unhandled exception: IPSR = 00000005 LR = fffffff1
CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc1-00041-ga30465a #216
task: 8b838000 ti: 8b82a000 task.ti: 8b82a000
PC is at flush_thread+0x32/0x40
LR is at flush_thread+0x21/0x40
pc : [<8f00157a>]    lr : [<8f001569>]    psr: 4100000b
sp : 8b82be20  ip : 00000000  fp : 8b83c000
r10: 00000001  r9 : 88018c84  r8 : 8bb85000
r7 : 8b838000  r6 : 00000000  r5 : 8bb77400  r4 : 8b82a000
r3 : ffff0ff0  r2 : 8b82a000  r1 : 00000000  r0 : 88020354
xPSR: 4100000b
CPU: 0 PID: 1 Comm: swapper Not tainted 3.18.0-rc1-00041-ga30465a #216
[<8f002bc1>] (unwind_backtrace) from [<8f002033>] (show_stack+0xb/0xc)
[<8f002033>] (show_stack) from [<8f00265b>] (__invalid_entry+0x4b/0x4c)

As best I can tell this issue existed for the set_tls ARM syscall
before commit fbfb872f5f41 "ARM: 8148/1: flush TLS and thumbee
register state during exec" consolidated the TLS manipulation code
into the set_tls helper function, but now that we're using it to flush
register state during execve, !MMU users encounter the oops at the
first exec.

Prevent CONFIG_MMU=n configurations from enabling
CONFIG_KUSER_HELPERS.

Fixes: fbfb872f5f41 (ARM: 8148/1: flush TLS and thumbee register state during exec)

Signed-off-by: Nathan Lynch <nathan_lynch@mentor.com>
Reported-by: Stefan Agner <stefan@agner.ch>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index b3b1b883bd08..426f531754ec 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -798,6 +798,7 @@ config NEED_KUSER_HELPERS
 
 config KUSER_HELPERS
 	bool "Enable kuser helpers in vector page" if !NEED_KUSER_HELPERS
+	depends on MMU
 	default y
 	help
 	  Warning: disabling this option may break user programs.
-- 
2.1.3

