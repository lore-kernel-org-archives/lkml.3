Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136Ab3EQVjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:39:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab3EQViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:38:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>, Helge Deller <deller@gmx.de>
Subject: [ 098/102] parisc: use long branch in fork_like macro
Date: Fri, 17 May 2013 14:36:53 -0700
Message-Id: <20130517213254.576824991@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John David Anglin <dave.anglin@bell.net>

commit bbbfde782084b4f0d85ddffb88f1cf4650ff40e4 upstream.

The "b" branch instruction used in the fork_like macro only can handle
17-bit pc-relative offsets.
This fails with an out of range offset with some .config files.
Rewrite to use the "be" instruction which
can branch to any address in a space.

Signed-off-by: John David Anglin  <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/entry.S |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/parisc/kernel/entry.S
+++ b/arch/parisc/kernel/entry.S
@@ -1709,7 +1709,8 @@ ENTRY(sys_\name\()_wrapper)
 	ldo	TASK_REGS(%r1),%r1
 	reg_save %r1
 	mfctl	%cr27, %r28
-	b	sys_\name
+	ldil	L%sys_\name, %r31
+	be	R%sys_\name(%sr4,%r31)
 	STREG	%r28, PT_CR27(%r1)
 ENDPROC(sys_\name\()_wrapper)
 	.endm


