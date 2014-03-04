Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaCDUEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:04:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaCDUE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 3.13 148/172] xtensa: save current register frame in fast_syscall_spill_registers_fixup
Date: Tue,  4 Mar 2014 12:03:52 -0800
Message-Id: <20140304200304.461128130@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 3251f1e27a5a17f0efd436cfd1e7b9896cfab0a0 upstream.

We need it saved because it contains a3 where we track which register
windows we still need to spill, and fixup handler may call C exception
handlers. Also fix comments.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/kernel/entry.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -1117,6 +1117,13 @@ ENDPROC(fast_syscall_spill_registers)
  * We basically restore WINDOWBASE and WINDOWSTART to the condition when
  * we entered the spill routine and jump to the user exception handler.
  *
+ * Note that we only need to restore the bits in windowstart that have not
+ * been spilled yet by the _spill_register routine. Luckily, a3 contains a
+ * rotated windowstart with only those bits set for frames that haven't been
+ * spilled yet. Because a3 is rotated such that bit 0 represents the register
+ * frame for the current windowbase - 1, we need to rotate a3 left by the
+ * value of the current windowbase + 1 and move it to windowstart.
+ *
  * a0: value of depc, original value in depc
  * a2: trashed, original value in EXC_TABLE_DOUBLE_SAVE
  * a3: exctable, original value in excsave1
@@ -1131,10 +1138,15 @@ ENTRY(fast_syscall_spill_registers_fixup
 	/* We need to make sure the current registers (a0-a3) are preserved.
 	 * To do this, we simply set the bit for the current window frame
 	 * in WS, so that the exception handlers save them to the task stack.
+	 *
+	 * Note: we use a3 to set the windowbase, so we take a special care
+	 * of it, saving it in the original _spill_registers frame across
+	 * the exception handler call.
 	 */
 
 	xsr	a3, excsave1	# get spill-mask
 	slli	a3, a3, 1	# shift left by one
+	addi	a3, a3, 1	# set the bit for the current window frame
 
 	slli	a2, a3, 32-WSBITS
 	src	a2, a3, a2	# a2 = xxwww1yyxxxwww1yy......


