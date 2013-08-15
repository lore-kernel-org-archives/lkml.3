Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab3HOPjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 11:39:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756277Ab3HOPjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 11:39:32 -0400
Date: Thu, 15 Aug 2013 16:39:27 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hillf Danton <dhillf@gmail.com>, Minchan Kim <minchan@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: [PATCH] mm: compaction: Do not compact pgdat for order-0
Message-ID: <20130815153927.GZ2296@suse.de>
References: <CAJd=RBBF2h_tRpbTV6OkxQOfkvKt=ebn_PbE8+r7JxAuaFZxFQ@mail.gmail.com>
 <20130815104727.GT2296@suse.de>
 <20130815134139.GC8437@gmail.com>
 <20130815135627.GX2296@suse.de>
 <20130815141004.GD8437@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130815141004.GD8437@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kswapd was reclaiming for a high order and resets it to 0 due to
fragmentation it will still call compact_pgdat. For the most part, this will
fail a compaction_suitable() test and not compact but it is unnecessarily
sloppy. It could be fixed in the caller but fix it in the API instead.

[dhillf@gmail.com: Pointed out that it was a potential problem]
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/compaction.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 05ccb4c..c437893 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1131,6 +1131,9 @@ void compact_pgdat(pg_data_t *pgdat, int order)
 		.sync = false,
 	};
 
+	if (!order)
+		return;
+
 	__compact_pgdat(pgdat, &cc);
 }
 
