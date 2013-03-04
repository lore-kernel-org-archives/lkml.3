Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab3CDMri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:47:38 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34616 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab3CDMrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:47:36 -0500
MIME-Version: 1.0
Date: Mon, 4 Mar 2013 20:47:31 +0800
Message-ID: <CAJd=RBD0UWxpMv7W78fH0U_zBAOozP1owaMePGaUEVitotRfBg@mail.gmail.com>
Subject: [PATCH resend] rmap: recompute pgoff for unmapping huge page
From: Hillf Danton <dhillf@gmail.com>
To: Linux-MM <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend due to error in delivering to linux-kernel@vger.kernel.org,
caused probably by the rich format provided by the mail agent by default.]

We have to recompute pgoff if the given page is huge, since result based on
HPAGE_SIZE is not approapriate for scanning the vma interval tree, as shown
by commit 36e4f20af833(hugetlb: do not use vma_hugecache_offset() for
vma_prio_tree_foreach)

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/mm/rmap.c	Mon Mar  4 20:00:00 2013
+++ b/mm/rmap.c	Mon Mar  4 20:02:16 2013
@@ -1513,6 +1513,9 @@ static int try_to_unmap_file(struct page
 	unsigned long max_nl_size = 0;
 	unsigned int mapcount;

+	if (PageHuge(page))
+		pgoff = page->index << compound_order(page);
+
 	mutex_lock(&mapping->i_mmap_mutex);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
 		unsigned long address = vma_address(page, vma);
--
