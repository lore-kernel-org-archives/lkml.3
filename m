Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbbANHfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:35:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58590 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbbANHf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:35:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anton Blanchard <anton@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 3.14 18/77] powerpc: Fix bad NULL pointer check in udbg_uart_getc_poll()
Date: Tue, 13 Jan 2015 23:22:58 -0800
Message-Id: <20150114072225.183239182@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072224.182299947@linuxfoundation.org>
References: <20150114072224.182299947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/udbg_16550.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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
 


