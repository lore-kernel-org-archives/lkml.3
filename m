Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175AbbA2JGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:06:11 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44859 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759895AbbA2JGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:06:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 012/176] powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()
Date: Wed, 28 Jan 2015 15:27:22 +0100
Message-Id: <c6fdf6dc5e74d008ca8db8c4f7a579a94186c85f.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cd32e2dcc9de6c27ecbbfc0e2079fb64b42bad5f upstream.

We have some code in udbg_uart_getc_poll() that tries to protect
against a NULL udbg_uart_in, but gets it all wrong.

Found with the LLVM static analyzer (scan-build).

Fixes: 309257484cc1 ("powerpc: Cleanup udbg_16550 and add support for LPC PIO-only UARTs")
Signed-off-by: Anton Blanchard <anton@samba.org>
[mpe: Add some newlines for readability while we're here]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/kernel/udbg_16550.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/udbg_16550.c b/arch/powerpc/kernel/udbg_16550.c
index 75702e207b29..f7089fcfaa5d 100644
--- a/arch/powerpc/kernel/udbg_16550.c
+++ b/arch/powerpc/kernel/udbg_16550.c
@@ -69,8 +69,12 @@ static void udbg_uart_putc(char c)
 
 static int udbg_uart_getc_poll(void)
 {
-	if (!udbg_uart_in || !(udbg_uart_in(UART_LSR) & LSR_DR))
+	if (!udbg_uart_in)
+		return -1;
+
+	if (!(udbg_uart_in(UART_LSR) & LSR_DR))
 		return udbg_uart_in(UART_RBR);
+
 	return -1;
 }
 
-- 
2.2.2

