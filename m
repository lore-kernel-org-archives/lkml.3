Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaENXXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:23:18 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34735 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaENXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:23:17 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v2 3.15] x86,vdso: Fix an OOPS accessing the hpet mapping w/o an hpet
Date: Wed, 14 May 2014 16:23:13 -0700
Message-Id: <e99025d887d6670b6c4d81e6ccfeeb83770b21e9.1400109621.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---

I'll resend the tip/x86/vdso version of this patch once this one gets
picked up.

 arch/x86/vdso/vdso32-setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0034898..3adf2e6 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -154,6 +154,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	unsigned long addr;
 	int ret = 0;
 	struct vm_area_struct *vma;
+	static struct page *no_pages[] = {NULL};
 
 #ifdef CONFIG_X86_X32_ABI
 	if (test_thread_flag(TIF_X32))
@@ -192,7 +193,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 			addr -  VDSO_OFFSET(VDSO_PREV_PAGES),
 			VDSO_OFFSET(VDSO_PREV_PAGES),
 			VM_READ,
-			NULL);
+			no_pages);
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
-- 
1.9.0

