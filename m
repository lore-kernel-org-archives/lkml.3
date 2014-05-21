Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaEUXWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:22:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373AbaEUXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:22:06 -0400
Date: Wed, 21 May 2014 16:21:35 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-1e844fb43c96dcdba3b578918f5c485d88750891@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, stefani@seibold.net, luto@amacapital.net,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, stefani@seibold.net, luto@amacapital.net,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <c8b0a9a0b8d011a8b273cbb2de88d37190ed2751.1400538962.git.luto@amacapital.net>
References: <c8b0a9a0b8d011a8b273cbb2de88d37190ed2751.1400538962.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, vdso:
  Fix an OOPS accessing the HPET mapping w/o an HPET
Git-Commit-ID: 1e844fb43c96dcdba3b578918f5c485d88750891
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

Commit-ID:  1e844fb43c96dcdba3b578918f5c485d88750891
Gitweb:     http://git.kernel.org/tip/1e844fb43c96dcdba3b578918f5c485d88750891
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 19 May 2014 15:58:31 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 May 2014 11:36:21 -0700

x86, vdso: Fix an OOPS accessing the HPET mapping w/o an HPET

The oops can be triggered in qemu using -no-hpet (but not nohpet) by
reading a couple of pages past the end of the vdso text.  This
should send SIGBUS instead of OOPSing.

The bug was introduced by:

commit 7a59ed415f5b57469e22e41fc4188d5399e0b194
Author: Stefani Seibold <stefani@seibold.net>
Date:   Mon Mar 17 23:22:09 2014 +0100

    x86, vdso: Add 32 bit VDSO time support for 32 bit kernel

which is new in 3.15.

This will be fixed separately in 3.15, but that patch will not apply
to tip/x86/vdso.  This is the equivalent fix for tip/x86/vdso and,
presumably, 3.16.

Cc: Stefani Seibold <stefani@seibold.net>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/c8b0a9a0b8d011a8b273cbb2de88d37190ed2751.1400538962.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/vdso/vma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index e915eae..8ad0081 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -90,6 +90,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 	struct vm_area_struct *vma;
 	unsigned long addr;
 	int ret = 0;
+	static struct page *no_pages[] = {NULL};
 
 	if (calculate_addr) {
 		addr = vdso_addr(current->mm->start_stack,
@@ -125,7 +126,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 				       addr + image->size,
 				       image->sym_end_mapping - image->size,
 				       VM_READ,
-				       NULL);
+				       no_pages);
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
