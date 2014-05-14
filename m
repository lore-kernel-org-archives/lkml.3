Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaENXB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:01:28 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:37311 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaENXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:01:26 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 3.15] x86,vdso: Fix an OOPS accessing the hpet mapping w/o an hpet
Date: Wed, 14 May 2014 16:01:22 -0700
Message-Id: <e1640272803e7711d9a43d9454dbdae57ba22eed.1400108299.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The access should fail, but it shouldn't oops.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

The oops can be triggered in qemu using -no-hpet (but not nohpet) by
running a 32-bit program and reading a couple of pages before the vdso.

This will conflict with tip/x86/vdso.  Sorry.

 arch/x86/vdso/vdso32-setup.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 0034898..33426da 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -147,6 +147,8 @@ int __init sysenter_setup(void)
 	return 0;
 }
 
+static struct page *no_pages[] = {NULL};
+
 /* Setup a VMA at program startup for the vsyscall page */
 int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 {
@@ -192,7 +194,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 			addr -  VDSO_OFFSET(VDSO_PREV_PAGES),
 			VDSO_OFFSET(VDSO_PREV_PAGES),
 			VM_READ,
-			NULL);
+			no_pages);
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
-- 
1.9.0

