Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbaCXRFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 13:05:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaCXRFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 13:05:18 -0400
Date: Mon, 24 Mar 2014 10:04:27 -0700
From: tip-bot for Stefani Seibold <tipbot@zytor.com>
Message-ID: <tip-645a387ecbdb4aa78c8451a66416340616134537@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1395592694-20571-1-git-send-email-stefani@seibold.net>
References: <1395592694-20571-1-git-send-email-stefani@seibold.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso: Fix size of get_unmapped_area()
Git-Commit-ID: 645a387ecbdb4aa78c8451a66416340616134537
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

Commit-ID:  645a387ecbdb4aa78c8451a66416340616134537
Gitweb:     http://git.kernel.org/tip/645a387ecbdb4aa78c8451a66416340616134537
Author:     Stefani Seibold <stefani@seibold.net>
AuthorDate: Sun, 23 Mar 2014 17:38:14 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 24 Mar 2014 09:31:23 -0700

x86, vdso: Fix size of get_unmapped_area()

The size of the reserved memory for a 32 bit vdso must be the size of the
32 bit vDSO in pages + HPET page + VVAR page.

One page is not enough for this. Grrrr.... silly copy and paste bug,
was right in previous patch.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/1395592694-20571-1-git-send-email-stefani@seibold.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vdso32-setup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 791c1cb..0034898 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -165,12 +165,14 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 
 	down_write(&mm->mmap_sem);
 
-	addr = get_unmapped_area(NULL, 0, PAGE_SIZE, 0, 0);
+	addr = get_unmapped_area(NULL, 0, vdso32_size + VDSO_OFFSET(VDSO_PREV_PAGES), 0, 0);
 	if (IS_ERR_VALUE(addr)) {
 		ret = addr;
 		goto up_fail;
 	}
 
+	addr += VDSO_OFFSET(VDSO_PREV_PAGES);
+
 	current->mm->context.vdso = (void *)addr;
 
 	/*
