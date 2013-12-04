Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab3LDQ7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:59:18 -0500
Received: from relay3.sgi.com ([192.48.152.1]:39375 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932508Ab3LDQ7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:59:15 -0500
Date: Wed, 4 Dec 2013 10:59:18 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/15] mm: thp: give transparent hugepage code a separate
 copy_page
Message-ID: <20131204165918.GA13191@sgi.com>
References: <1386060721-3794-1-git-send-email-mgorman@suse.de>
 <1386060721-3794-4-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1386060721-3794-4-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -void copy_huge_page(struct page *dst, struct page *src)
> -{
> -	int i;
> -	struct hstate *h = page_hstate(src);
> -
> -	if (unlikely(pages_per_huge_page(h) > MAX_ORDER_NR_PAGES)) {

With CONFIG_HUGETLB_PAGE=n, the kernel fails to build, throwing this
error:

mm/migrate.c: In function ‘copy_huge_page’:
mm/migrate.c:473: error: implicit declaration of function ‘page_hstate’

I got it to build by sticking the following into hugetlb.h:

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 4694afc..fd76912 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -403,6 +403,7 @@ struct hstate {};
 #define hstate_sizelog(s) NULL
 #define hstate_vma(v) NULL
 #define hstate_inode(i) NULL
+#define page_hstate(p) NULL
 #define huge_page_size(h) PAGE_SIZE
 #define huge_page_mask(h) PAGE_MASK
 #define vma_kernel_pagesize(v) PAGE_SIZE

I figure that the #define I stuck in isn't actually solving the real
problem, but it got things working again.

- Alex
