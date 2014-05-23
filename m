Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaEWFTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:19:08 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43160 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbaEWFTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:19:06 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        palves@redhat.com, Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH] elf, coredump: Extract only the active register set during core dump
Date: Fri, 23 May 2014 10:46:53 +0530
Message-Id: <1400822213-18004-1-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052305-6102-0000-0000-000005A2DB65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regset active hooks provide a way to query how many registers in the
register set are active at any point of time. Currently this information
is being ignored while creating core dump sections corresponding to any
core note register set. This way the core dump will contain data which are
not part of the active context of the process and may not be useful. This
patch will make sure that only the active part of the register set are
captured during the core dump process which will reduce the core dump
size.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
NOTE:
Pedro Alves has mentioned that producing smaller note sections in the core
dump may break some existing consumers. I request suggestions, reviews and
test reports on different architectures to prove that this patch does not
break any existing consumer. Thank you.

Please find the previous discussion here

https://lkml.org/lkml/2014/5/20/185

Regards
Anshuman

 fs/binfmt_elf.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index aa3cb62..00aba07 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1551,10 +1551,18 @@ static int fill_thread_core_info(struct elf_thread_core_info *t,
 		const struct user_regset *regset = &view->regsets[i];
 		do_thread_regset_writeback(t->task, regset);
 		if (regset->core_note_type && regset->get &&
-		    (!regset->active || regset->active(t->task, regset))) {
+		    (!regset->active || regset->active(t->task, regset) > 0)) {
 			int ret;
-			size_t size = regset->n * regset->size;
-			void *data = kmalloc(size, GFP_KERNEL);
+			size_t size;
+			void *data;
+
+			if (!regset->active)
+				size = regset->n * regset->size;
+			else
+				size = regset->active(t->task, regset)
+								* regset->size;
+
+			data = kmalloc(size, GFP_KERNEL);
 			if (unlikely(!data))
 				return 0;
 			ret = regset->get(t->task, regset,
-- 
1.7.11.7

