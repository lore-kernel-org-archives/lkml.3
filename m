Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaD1BaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42808 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.455935396@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 86/94] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit b3b42ac2cbae1f3cecbb6229964a4d48af31d382 upstream.

The IRET instruction, when returning to a 16-bit segment, only
restores the bottom 16 bits of the user space stack pointer.  We have
a software workaround for that ("espfix") for the 32-bit kernel, but
it relies on a nonzero stack segment base which is not available in
32-bit mode.

Since 16-bit support is somewhat crippled anyway on a 64-bit kernel
(no V86 mode), and most (if not quite all) 64-bit processors support
virtualization for the users who really need it, simply reject
attempts at creating a 16-bit segment when running on top of a 64-bit
kernel.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/n/tip-kicdm89kzw9lldryb1br9od0@git.kernel.org
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/ldt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -230,6 +230,17 @@ static int write_ldt(void __user *ptr, u
 		}
 	}
 
+	/*
+	 * On x86-64 we do not support 16-bit segments due to
+	 * IRET leaking the high bits of the kernel stack address.
+	 */
+#ifdef CONFIG_X86_64
+	if (!ldt_info.seg_32bit) {
+		error = -EINVAL;
+		goto out_unlock;
+	}
+#endif
+
 	fill_ldt(&ldt, &ldt_info);
 	if (oldmode)
 		ldt.avl = 0;

