Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934736Ab3FSRzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:55:04 -0400
Received: from longford.logfs.org ([213.229.74.203]:59605 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934254Ab3FSRzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:55:01 -0400
Date: Wed, 19 Jun 2013 12:25:06 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mmap: allow MAP_HUGETLB for hugetlbfs files v2
Message-ID: <20130619162506.GA7511@logfs.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
 <1371581225-27535-3-git-send-email-joern@logfs.org>
 <51C107E9.9050900@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51C107E9.9050900@huawei.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is counterintuitive at best that mmap'ing a hugetlbfs file with
MAP_HUGETLB fails, while mmap'ing it without will a) succeed and b)
return huge pages.
v2: use is_file_hugepages(), as suggested by Jianguo

Signed-off-by: Joern Engel <joern@logfs.org>
Cc: Jianguo Wu <wujianguo@huawei.com>
---
 mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 2a594246..cdc8e7a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1322,11 +1322,12 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 
 	if (!(flags & MAP_ANONYMOUS)) {
 		audit_mmap_fd(fd, flags);
-		if (unlikely(flags & MAP_HUGETLB))
-			return -EINVAL;
 		file = fget(fd);
 		if (!file)
 			goto out;
+		retval = -EINVAL;
+		if (unlikely(flags & MAP_HUGETLB && !is_file_hugepages(file)))
+			goto out_fput;
 	} else if (flags & MAP_HUGETLB) {
 		struct user_struct *user = NULL;
 		/*
@@ -1346,6 +1347,7 @@ SYSCALL_DEFINE6(mmap_pgoff, unsigned long, addr, unsigned long, len,
 	flags &= ~(MAP_EXECUTABLE | MAP_DENYWRITE);
 
 	retval = vm_mmap_pgoff(file, addr, len, prot, flags, pgoff);
+out_fput:
 	if (file)
 		fput(file);
 out:
-- 
1.7.10.4

