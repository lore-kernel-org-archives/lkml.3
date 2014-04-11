Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaDKRhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:37:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45512 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbaDKRhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:37:07 -0400
Date: Fri, 11 Apr 2014 10:36:51 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        stable@vger.kernel.org, hpa@linux.intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64, modify_ldt:
  Ban 16-bit segments on 64-bit kernels
Git-Commit-ID: b3b42ac2cbae1f3cecbb6229964a4d48af31d382
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b3b42ac2cbae1f3cecbb6229964a4d48af31d382
Gitweb:     http://git.kernel.org/tip/b3b42ac2cbae1f3cecbb6229964a4d48af31d382
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sun, 16 Mar 2014 15:31:54 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 11 Apr 2014 10:10:09 -0700

x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels

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
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/ldt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index ebc9873..af1d14a 100644
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
