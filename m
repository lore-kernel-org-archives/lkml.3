Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaENXBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 19:01:33 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:34723 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbaENXB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 19:01:28 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH] x86,vdso: Fix an OOPS accessing the hpet mapping w/o an hpet
Date: Wed, 14 May 2014 16:01:23 -0700
Message-Id: <c13c62bd41e75eb9f414b541dfd2adada009c7c2.1400107790.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <e1640272803e7711d9a43d9454dbdae57ba22eed.1400108299.git.luto@amacapital.net>
References: <e1640272803e7711d9a43d9454dbdae57ba22eed.1400108299.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The access should fail, but it shouldn't oops.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---

This applies to tip/x86/vdso and should be applied to unbreak Trinity
on linux-next.

 arch/x86/vdso/vma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index e915eae..d02131e 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -84,6 +84,8 @@ static unsigned long vdso_addr(unsigned long start, unsigned len)
 	return addr;
 }
 
+static struct page *no_pages[] = {NULL};
+
 static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 {
 	struct mm_struct *mm = current->mm;
@@ -125,7 +127,7 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
 				       addr + image->size,
 				       image->sym_end_mapping - image->size,
 				       VM_READ,
-				       NULL);
+				       no_pages);
 
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
-- 
1.9.0

