Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbaF1TJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 15:09:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52987 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaF1RsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.10 21/77] arm64: ptrace: change fs when passing kernel pointer to regset code
Date: Sat, 28 Jun 2014 10:46:14 -0700
Message-Id: <20140628174522.665297914@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
References: <20140628174521.691276402@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit c168870704bcde6bb63d05f7882b620dd3985a46 upstream.

Our compat PTRACE_POKEUSR implementation simply passes the user data to
regset_copy_from_user after some simple range checking. Unfortunately,
the data in question has already been copied to the kernel stack by this
point, so the subsequent access_ok check fails and the ptrace request
returns -EFAULT. This causes problems tracing fork() with older versions
of strace.

This patch briefly changes the fs to KERNEL_DS, so that the access_ok
check passes even with a kernel address.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/ptrace.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -872,6 +872,7 @@ static int compat_ptrace_write_user(stru
 				    compat_ulong_t val)
 {
 	int ret;
+	mm_segment_t old_fs = get_fs();
 
 	if (off & 3 || off >= COMPAT_USER_SZ)
 		return -EIO;
@@ -879,10 +880,13 @@ static int compat_ptrace_write_user(stru
 	if (off >= sizeof(compat_elf_gregset_t))
 		return 0;
 
+	set_fs(KERNEL_DS);
 	ret = copy_regset_from_user(tsk, &user_aarch32_view,
 				    REGSET_COMPAT_GPR, off,
 				    sizeof(compat_ulong_t),
 				    &val);
+	set_fs(old_fs);
+
 	return ret;
 }
 


