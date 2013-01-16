Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab3APQGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:06:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36317 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab3APQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:05:58 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 133/222] ARM: missing ->mmap_sem around find_vma() in swp_emulate.c
Date: Wed, 16 Jan 2013 13:55:33 -0200
Message-Id: <1358351822-7675-134-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 7bf9b7bef881aac820bf1f2e9951a17b09bd7e04 upstream.

find_vma() is *not* safe when somebody else is removing vmas.  Not just
the return value might get bogus just as you are getting it (this instance
doesn't try to dereference the resulting vma), the search itself can get
buggered in rather spectacular ways.  IOW, ->mmap_sem really, really is
not optional here.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/kernel/swp_emulate.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/kernel/swp_emulate.c b/arch/arm/kernel/swp_emulate.c
index df74518..ab1017b 100644
--- a/arch/arm/kernel/swp_emulate.c
+++ b/arch/arm/kernel/swp_emulate.c
@@ -109,10 +109,12 @@ static void set_segfault(struct pt_regs *regs, unsigned long addr)
 {
 	siginfo_t info;
 
+	down_read(&current->mm->mmap_sem);
 	if (find_vma(current->mm, addr) == NULL)
 		info.si_code = SEGV_MAPERR;
 	else
 		info.si_code = SEGV_ACCERR;
+	up_read(&current->mm->mmap_sem);
 
 	info.si_signo = SIGSEGV;
 	info.si_errno = 0;
-- 
1.7.9.5

