Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174Ab3JKU2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:28:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021Ab3JKTkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Kent Overstreet <koverstreet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 076/110] mm/bounce.c: fix a regression where MS_SNAP_STABLE (stable pages snapshotting) was ignored
Date: Fri, 11 Oct 2013 12:38:56 -0700
Message-Id: <20131011193816.121073014@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 83b2944fd2532b92db099cb3ada12df32a05b368 upstream.

The "force" parameter in __blk_queue_bounce was being ignored, which
means that stable page snapshots are not always happening (on ext3).
This of course leads to DIF disks reporting checksum errors, so fix this
regression.

The regression was introduced in commit 6bc454d15004 ("bounce: Refactor
__blk_queue_bounce to not use bi_io_vec")

Reported-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Cc: Kent Overstreet <koverstreet@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/bounce.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -204,6 +204,8 @@ static void __blk_queue_bounce(struct re
 	struct bio_vec *to, *from;
 	unsigned i;
 
+	if (force)
+		goto bounce;
 	bio_for_each_segment(from, *bio_orig, i)
 		if (page_to_pfn(from->bv_page) > queue_bounce_pfn(q))
 			goto bounce;


