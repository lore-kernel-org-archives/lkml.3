Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3CRGNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 02:13:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:50309 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab3CRGNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 02:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,862,1355126400"; 
   d="scan'208";a="272180166"
From: "Hampson, Steven T" <steven.t.hampson@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH} mm: Merging memory blocks resets mempolicy
Thread-Topic: [PATCH} mm: Merging memory blocks resets mempolicy
Thread-Index: AQHOI5+9WyYs+fRR6kiT6UDhwiPmNQ==
Date: Mon, 18 Mar 2013 06:13:42 +0000
Message-ID: <CD6BFEA8.10FFB%steven.t.hampson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.2.130206
x-originating-ip: [10.252.141.20]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ECDE31AD55DC0B49A208414B031BB417@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using mbind to change the mempolicy to MPOL_BIND on several adjacent
mmapped blocks
may result in a reset of the mempolicy to MPOL_DEFAULT in vma_adjust.

Test code.  Correct result is three lines containing "OK".


#include <stdio.h>
#include <unistd.h>
#include <sys/mman.h>
#include <numaif.h>
#include <errno.h>

/* gcc mbind_test.c -lnuma -o mbind_test -Wall */
#define MAXNODE 4096

void allocate()
{
	int ret;
	int len;
	int policy = -1;
	unsigned char *p;
	unsigned long mask[MAXNODE] = { 0 };
	unsigned long retmask[MAXNODE] = { 0 };

	len = getpagesize() * 0x2fc00;
	p = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
		 -1, 0);
	if (p == MAP_FAILED)
		printf("mbind err: %d\n", errno);

	mask[0] = 1;
	ret = mbind(p, len, MPOL_BIND, mask, MAXNODE, 0);
	if (ret < 0)
		printf("mbind err: %d %d\n", ret, errno);
	ret = get_mempolicy(&policy, retmask, MAXNODE, p, MPOL_F_ADDR);
	if (ret < 0)
		printf("get_mempolicy err: %d %d\n", ret, errno);

	if (policy == MPOL_BIND)
		printf("OK\n");
	else
		printf("ERROR: policy is %d\n", policy);
}

int main()
{
	allocate();
	allocate();
	allocate();
	return 0;
}

Signed-off-by: Steven T Hampson <steven.t.hampson@intel.com>


---

diff --git a/mm/mmap.c b/mm/mmap.c
index 8832b87..5ba8b92 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -820,7 +820,7 @@ again:			remove_next = 1 + (end > next->vm_end);
 		if (next->anon_vma)
 			anon_vma_merge(vma, next);
 		mm->map_count--;
-		mpol_put(vma_policy(next));
+		vma_set_policy(vma, vma_policy(next));
 		kmem_cache_free(vm_area_cachep, next);
 		/*
 		 * In mprotect's case 6 (see comments on vma_merge),

