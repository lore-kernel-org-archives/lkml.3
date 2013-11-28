Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3K1ItA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:49:00 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35227 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3K1Is5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:48:57 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52970342.8090302@jp.fujitsu.com>
Date: Thu, 28 Nov 2013 17:48:02 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: [PATCH] vmcore: call remap_pfn_range() separately for respective
 partial pages
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vivek,

Here is a patch set for mmap failure for /proc/vmcore.
Could you try to use this on the problematic system?

This patch doesn't copy partial pages to the 2nd kernel, only prepares
vmcore objects for respective partial pages to invoke remap_pfn_range()
for individual partial pages.

>From c83dddd23be2a2972dcb3f252598c39abfa23078 Mon Sep 17 00:00:00 2001
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Date: Thu, 28 Nov 2013 14:51:22 +0900
Subject: [PATCH] vmcore: call remap_pfn_range() separately for respective
 partial pages

Acording to the report by Vivek in
https://lkml.org/lkml/2013/11/13/439, on some specific systems, some
of the System RAM ranges don't end at page boundary and the later part
of the same page is used for some kind of ACPI data. As a result,
remap_pfn_range() to the partial page failed if mapping range covers a
boundary of the System RAM part and the ACPI data part in the partial
page, due to the detection of different cache types in
track_pfn_remap().

To resolve the issue, call remap_pfn_range() separately for respective
partial pages, not for multiple consequtive pages that don't either
start or end at page boundary, by creating vmcore objects for
respective partial pages.

This patch never changes shape of /proc/vmcore visible from user-land.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 fs/proc/vmcore.c | 108 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 84 insertions(+), 24 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 9100d69..e396a1d 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -816,26 +816,56 @@ static int __init process_ptload_program_headers_elf64(char *elfptr,
 	vmcore_off = elfsz + elfnotes_sz;
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
-		u64 paddr, start, end, size;
+		u64 start, end, size, rest;
+		u64 start_up, start_down, end_up, end_down;
 
 		if (phdr_ptr->p_type != PT_LOAD)
 			continue;
 
-		paddr = phdr_ptr->p_offset;
-		start = rounddown(paddr, PAGE_SIZE);
-		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
-		size = end - start;
+		start = phdr_ptr->p_offset;
+		start_up = roundup(start, PAGE_SIZE);
+		start_down = rounddown(start, PAGE_SIZE);
+		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
+		end_up = roundup(end, PAGE_SIZE);
+		end_down = rounddown(end, PAGE_SIZE);
+		size = end_up - start_down;
+		rest = phdr_ptr->p_memsz;
+
+		if (!PAGE_ALIGNED(start)) {
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = start_down;
+			new->size = PAGE_SIZE;
+			list_add_tail(&new->list, vc_list);
+			rest -= min(start_up, end) - start;
+		}
 
 		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
-			return -ENOMEM;
-		new->paddr = start;
-		new->size = size;
-		list_add_tail(&new->list, vc_list);
+		if (rest > 0 && start_up < end_down) {
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = start_up;
+			new->size = end_down - start_up;
+			list_add_tail(&new->list, vc_list);
+			rest -= end_down - start_up;
+		}
+
+		if (rest > 0) {
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = end_down;
+			new->size = PAGE_SIZE;
+			list_add_tail(&new->list, vc_list);
+			rest -= end - end_down;
+		}
+
+		WARN_ON(rest > 0);
 
 		/* Update the program header offset. */
-		phdr_ptr->p_offset = vmcore_off + (paddr - start);
+		phdr_ptr->p_offset = vmcore_off + (start - start_down);
 		vmcore_off = vmcore_off + size;
 	}
 	return 0;
@@ -859,26 +889,56 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 	vmcore_off = elfsz + elfnotes_sz;
 
 	for (i = 0; i < ehdr_ptr->e_phnum; i++, phdr_ptr++) {
-		u64 paddr, start, end, size;
+		u64 start, end, size, rest;
+		u64 start_up, start_down, end_up, end_down;
 
 		if (phdr_ptr->p_type != PT_LOAD)
 			continue;
 
-		paddr = phdr_ptr->p_offset;
-		start = rounddown(paddr, PAGE_SIZE);
-		end = roundup(paddr + phdr_ptr->p_memsz, PAGE_SIZE);
-		size = end - start;
+		start = phdr_ptr->p_offset;
+		start_up = roundup(start, PAGE_SIZE);
+		start_down = rounddown(start, PAGE_SIZE);
+		end = phdr_ptr->p_offset + phdr_ptr->p_memsz;
+		end_up = roundup(end, PAGE_SIZE);
+		end_down = rounddown(end, PAGE_SIZE);
+		rest = phdr_ptr->p_memsz;
+		size = end_up - start_down;
+
+		if (!PAGE_ALIGNED(start)) {
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = start_down;
+			new->size = PAGE_SIZE;
+			list_add_tail(&new->list, vc_list);
+			rest -= min(start_up, end) - start;
+		}
 
 		/* Add this contiguous chunk of memory to vmcore list.*/
-		new = get_new_element();
-		if (!new)
-			return -ENOMEM;
-		new->paddr = start;
-		new->size = size;
-		list_add_tail(&new->list, vc_list);
+		if (rest > 0 && start_up < end_down) {
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = start_up;
+			new->size = end_down - start_up;
+			list_add_tail(&new->list, vc_list);
+			rest -= end_down - start_up;
+		}
+
+		if (rest > 0) {
+			new = get_new_element();
+			if (!new)
+				return -ENOMEM;
+			new->paddr = end_down;
+			new->size = PAGE_SIZE;
+			list_add_tail(&new->list, vc_list);
+			rest -= end - end_down;
+		}
+
+		WARN_ON(rest > 0);
 
 		/* Update the program header offset */
-		phdr_ptr->p_offset = vmcore_off + (paddr - start);
+		phdr_ptr->p_offset = vmcore_off + (start - start_down);
 		vmcore_off = vmcore_off + size;
 	}
 	return 0;
-- 
1.8.3.1

-- 
Thanks.
HATAYAMA, Daisuke

