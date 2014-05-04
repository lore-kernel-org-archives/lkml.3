Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaEDPvw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:51:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbaEDPmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.4 14/43] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
Date: Sun,  4 May 2014 11:42:08 -0400
Message-Id: <20140504154226.182340048@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154224.211508175@linuxfoundation.org>
References: <20140504154224.211508175@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ldt.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -229,6 +229,17 @@ static int write_ldt(void __user *ptr, u
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


