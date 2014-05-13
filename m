Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbaEMKIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:08:38 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60789 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760059AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 051/182] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
Date: Tue, 13 May 2014 11:26:43 +0200
Message-Id: <60cf83e2f8e7ccd5324d577f47041a6e6903bf4c.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/ldt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index ebc987398923..af1d14a9ebda 100644
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
1.9.3

