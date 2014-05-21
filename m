Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaEUXWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:22:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43351 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaEUXWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:22:42 -0400
Date: Wed, 21 May 2014 16:22:21 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-368b69a5b010cb00fc9ea04d588cff69af1a1359@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, stefani@seibold.net, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <e99025d887d6670b6c4d81e6ccfeeb83770b21e9.1400109621.git.luto@amacapital.net>
References: <e99025d887d6670b6c4d81e6ccfeeb83770b21e9.1400109621.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, vdso:
  Fix an OOPS accessing the HPET mapping w/o an HPET
Git-Commit-ID: 368b69a5b010cb00fc9ea04d588cff69af1a1359
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

Commit-ID:  368b69a5b010cb00fc9ea04d588cff69af1a1359
Gitweb:     http://git.kernel.org/tip/368b69a5b010cb00fc9ea04d588cff69af1a1359
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Wed, 14 May 2014 16:23:13 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 21 May 2014 16:14:04 -0700

x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET

The oops can be triggered in qemu using -no-hpet (but not nohpet) by
running a 32-bit program and reading a couple of pages before the vdso.
This should send SIGBUS instead of OOPSing.

The bug was introduced by:

commit 7a59ed415f5b57469e22e41fc4188d5399e0b194
Author: Stefani Seibold <stefani@seibold.net>
Date:   Mon Mar 17 23:22:09 2014 +0100

    x86, vdso: Add 32 bit VDSO time support for 32 bit kernel

which is new in 3.15.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/e99025d887d6670b6c4d81e6ccfeeb83770b21e9.1400109621.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vdso32-setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index e1f220e..310c5f0 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -155,6 +155,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	unsigned long addr;
 	int ret = 0;
 	struct vm_area_struct *vma;
+	static struct page *no_pages[] = {NULL};
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
@@ -193,7 +194,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 			addr -  VDSO_OFFSET(VDSO_PREV_PAGES),
 			VDSO_OFFSET(VDSO_PREV_PAGES),
 			VM_READ,
-			NULL);
+			no_pages);
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
