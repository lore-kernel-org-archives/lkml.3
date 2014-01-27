Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaA0NWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:22:32 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:42751 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbaA0NVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:21:54 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/3] fs/compat: fix lookup_dcookie() parameter handling
Date: Mon, 27 Jan 2014 14:21:44 +0100
Message-Id: <1390828905-52245-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1390828905-52245-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1390828905-52245-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012713-2966-0000-0000-00000A0E0B24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d5dc77bfeeab0 "consolidate compat lookup_dcookie()" coverted all
architectures to the new compat_sys_lookup_dcookie() syscall.

The "len" paramater of the new compat syscall must have the type
compat_size_t in order to enforce zero extension for architectures
where the ABI requires that the caller of a function performed
zero and/or sign extension to 64 bit of all parameters.

Cc: stable@vger.kernel.org # v3.10+
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 fs/dcookies.c          | 2 +-
 include/linux/compat.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dcookies.c b/fs/dcookies.c
index ab5954b50267..ac44a69fbea9 100644
--- a/fs/dcookies.c
+++ b/fs/dcookies.c
@@ -204,7 +204,7 @@ out:
 }
 
 #ifdef CONFIG_COMPAT
-COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, w0, u32, w1, char __user *, buf, size_t, len)
+COMPAT_SYSCALL_DEFINE4(lookup_dcookie, u32, w0, u32, w1, char __user *, buf, compat_size_t, len)
 {
 #ifdef __BIG_ENDIAN
 	return sys_lookup_dcookie(((u64)w0 << 32) | w1, buf, len);
diff --git a/include/linux/compat.h b/include/linux/compat.h
index c5642b83e02b..19f6003291de 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -422,7 +422,7 @@ extern long compat_arch_ptrace(struct task_struct *child, compat_long_t request,
 asmlinkage long compat_sys_ptrace(compat_long_t request, compat_long_t pid,
 				  compat_long_t addr, compat_long_t data);
 
-asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, size_t);
+asmlinkage long compat_sys_lookup_dcookie(u32, u32, char __user *, compat_size_t);
 /*
  * epoll (fs/eventpoll.c) compat bits follow ...
  */
-- 
1.8.4.5

