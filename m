Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab3JBOeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:34:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab3JBO26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:58 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 16/26] mm: Provide get_user_pages_unlocked()
Date: Wed,  2 Oct 2013 16:27:57 +0200
Message-Id: <1380724087-13927-17-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a wrapper for get_user_pages() which takes care of acquiring and
releasing mmap_sem. Using this function reduces amount of places in
which we deal with mmap_sem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/mm.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8b6e55ee8855..70031ead06a5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1031,6 +1031,20 @@ long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 		    struct vm_area_struct **vmas);
 int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 			struct page **pages);
+static inline long
+get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
+		 	unsigned long start, unsigned long nr_pages,
+			int write, int force, struct page **pages)
+{
+	long ret;
+
+	down_read(&mm->mmap_sem);
+	ret = get_user_pages(tsk, mm, start, nr_pages, write, force, pages,
+			     NULL);
+	up_read(&mm->mmap_sem);
+	return ret;
+}
+
 struct kvec;
 int get_kernel_pages(const struct kvec *iov, int nr_pages, int write,
 			struct page **pages);
-- 
1.8.1.4

