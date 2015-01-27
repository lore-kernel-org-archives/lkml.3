Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759236AbbA0Mmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:42:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35047 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758453AbbA0MSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:18:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anton Blanchard <anton@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 042/126] powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()
Date: Tue, 27 Jan 2015 12:15:47 +0000
Message-Id: <1422361031-19364-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit cd32e2dcc9de6c27ecbbfc0e2079fb64b42bad5f upstream.

We have some code in udbg_uart_getc_poll() that tries to protect
against a NULL udbg_uart_in, but gets it all wrong.

Found with the LLVM static analyzer (scan-build).

Fixes: 309257484cc1 ("powerpc: Cleanup udbg_16550 and add support for LPC PIO-only UARTs")
Signed-off-by: Anton Blanchard <anton@samba.org>
[mpe: Add some newlines for readability while we're here]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/kernel/udbg_16550.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/udbg_16550.c b/arch/powerpc/kernel/udbg_16550.c
index 6e7c4923b5ea..411116c38da4 100644
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
2.1.4

