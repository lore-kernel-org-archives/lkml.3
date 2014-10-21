Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbaJUUz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:55:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:45951 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014AbaJUUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:55:57 -0400
X-Greylist: delayed 491 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2014 16:55:56 EDT
X-AuthUser: davidel@xmailserver.org
Date: Tue, 21 Oct 2014 13:47:44 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx3
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>
Subject: [patch] MAP_HUGETLB munmap fails with size not 2MB aligned
Message-ID: <alpine.DEB.2.10.1410211047300.16997@davide-lnx3>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling mmap with MAP_HUGETLB and a size which is not 2MB aligned, causes 
mmap to fail. Tested on 3.13.x but tracking back to 3.2.x.
In do_munmap() we forcibly want a 4KB default page, and we wrongly calculate
the end of the map, by doing a split right in the middle of a huge page, 
which will result in EINVAL.
Tentative (untested) patch and test case attached (be sure you have a few 
huge pages available via /proc/sys/vm/nr_hugepages tinkering).


Signed-Off-By: Davide Libenzi <davidel@xmailserver.org>


- Davide


diff --git a/mm/mmap.c b/mm/mmap.c
index 7f85520..6dba257 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2528,10 +2528,6 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 	if ((start & ~PAGE_MASK) || start > TASK_SIZE || len > TASK_SIZE-start)
 		return -EINVAL;
 
-	len = PAGE_ALIGN(len);
-	if (len == 0)
-		return -EINVAL;
-
 	/* Find the first overlapping VMA */
 	vma = find_vma(mm, start);
 	if (!vma)
@@ -2539,6 +2535,16 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len)
 	prev = vma->vm_prev;
 	/* we have  start < vma->vm_end  */
 
+	if (likely(!is_vm_hugetlb_page(vma)))
+		len = PAGE_ALIGN(len);
+	else {
+		unsigned long hpage_size = huge_page_size(hstate_vma(vma));
+
+		len = ALIGN(len, hpage_size);
+	}
+	if (unlikely(len == 0))
+		return -EINVAL;
+
 	/* if it doesn't overlap, we have nothing.. */
 	end = start + len;
 	if (vma->vm_start >= end)





[hugebug.c]

#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

static void test(int flags, size_t size)
{
    void* addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
                      flags | MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    if (addr == MAP_FAILED)
    {
        perror("mmap");
        exit(1);
    }
    *(char*) addr = 17;

    if (munmap(addr, size) != 0)
    {
        perror("munmap");
        exit(1);
    }
}

int main(int ac, const char** av)
{
    static const size_t hugepage_size = 2 * 1024 * 1024;

    printf("Testing normal pages with 2MB size ...\n");
    test(0, hugepage_size);
    printf("OK\n");

    printf("Testing huge pages with 2MB size ...\n");
    test(MAP_HUGETLB, hugepage_size);
    printf("OK\n");


    printf("Testing normal pages with 4KB byte size ...\n");
    test(0, 4096);
    printf("OK\n");

    printf("Testing huge pages with 4KB byte size ...\n");
    test(MAP_HUGETLB, 4096);
    printf("OK\n");


    printf("Testing normal pages with 1 byte size ...\n");
    test(0, 1);
    printf("OK\n");

    printf("Testing huge pages with 1 byte size ...\n");
    test(MAP_HUGETLB, 1);
    printf("OK\n");

    return 0;
}

