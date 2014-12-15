Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaLOFaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 00:30:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaLOFaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 00:30:04 -0500
From: WANG Chao <chaowang@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Anderson <anderson@redhat.com>, Baoquan He <bhe@redhat.com>,
        rwright@hp.com, Vivek Goyal <vgoyal@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Fabian Frederick <fabf@skynet.be>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Greg Pearson <greg.pearson@hp.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] vmcore: fix PT_NOTE n_namesz, n_descsz overflow issue
Date: Mon, 15 Dec 2014 13:29:36 +0800
Message-Id: <1418621378-8266-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When updating PT_NOTE header size (ie. p_memsz), an overflow issue
happens with the following bogus note entry:

n_namesz = 0xFFFFFFFF
n_descsz = 0x0
n_type   = 0x0

This kind of note entry should be dropped during updating p_memsz. But
because n_namesz is 32bit, after (n_namesz + 3) & (~3), it's overflow to
0x0, the note entry size looks sane and reserved.

When user space (eg. crash utility) is trying to access such bogus note,
it could lead to an unexpected behavior (eg. crash utility segment
fault because it's reading bogus address).

The source of bogus note hasn't been identified yet. At least we could
drop the bogus note so user space wouldn't be surprised.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 fs/proc/vmcore.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index a90d6d35..4e61388 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -546,8 +546,8 @@ static int __init update_note_header_size_elf64(const Elf64_Ehdr *ehdr_ptr)
 		nhdr_ptr = notes_section;
 		while (nhdr_ptr->n_namesz != 0) {
 			sz = sizeof(Elf64_Nhdr) +
-				((nhdr_ptr->n_namesz + 3) & ~3) +
-				((nhdr_ptr->n_descsz + 3) & ~3);
+				(((u64)nhdr_ptr->n_namesz + 3) & ~3) +
+				(((u64)nhdr_ptr->n_descsz + 3) & ~3);
 			if ((real_sz + sz) > max_sz) {
 				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
 					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
@@ -732,8 +732,8 @@ static int __init update_note_header_size_elf32(const Elf32_Ehdr *ehdr_ptr)
 		nhdr_ptr = notes_section;
 		while (nhdr_ptr->n_namesz != 0) {
 			sz = sizeof(Elf32_Nhdr) +
-				((nhdr_ptr->n_namesz + 3) & ~3) +
-				((nhdr_ptr->n_descsz + 3) & ~3);
+				(((u64)nhdr_ptr->n_namesz + 3) & ~3) +
+				(((u64)nhdr_ptr->n_descsz + 3) & ~3);
 			if ((real_sz + sz) > max_sz) {
 				pr_warn("Warning: Exceeded p_memsz, dropping PT_NOTE entry n_namesz=0x%x, n_descsz=0x%x\n",
 					nhdr_ptr->n_namesz, nhdr_ptr->n_descsz);
-- 
1.9.3

