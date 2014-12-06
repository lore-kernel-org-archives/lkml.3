Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaLFRzY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:55:24 -0500
Received: from 1wt.eu ([62.212.114.60]:40759 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbaLFRzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:55:16 -0500
Message-Id: <20141206174148.596017245@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:41:52 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 04/25] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
(cherry picked from 3.2 commit a862b5c4076b1ba4dd6c87aebac478853dc6db47)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/ldt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index ec6ef60..75e356c 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -229,6 +229,17 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
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
-- 
1.7.12.2.21.g234cd45.dirty



