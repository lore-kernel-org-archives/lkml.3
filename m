Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaENXq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:46:56 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43993 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbaENXqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:46:55 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v2 -next] x86,vdso: Fix an OOPS accessing the hpet mapping w/o an hpet
Date: Wed, 14 May 2014 16:46:50 -0700
Message-Id: <c8b0a9a0b8d011a8b273cbb2de88d37190ed2751.1400111179.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
-- 
1.9.0

