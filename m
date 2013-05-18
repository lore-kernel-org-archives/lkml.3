Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab3ERDAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758495Ab3ERDAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:07 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=jpEcaPsV8WMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=NRMChUP4DG0A:10 a=20KFwNOVAAAA:8 a=ufHFDILaAAAA:8 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=jEp0ucaQiEUA:10 a=l7ZknGph1ugA:10 a=0kPLrQdw3YYA:10 a=UTB_XpHje0EA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021650.462318150@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jerome Marchand <jmarchan@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 054/136 ] swap: redirty page if page write fails on swap file
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0054-swap-redirty-page-if-page-write-fails-on-swap-file.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jerome Marchand <jmarchan@redhat.com>

[ Upstream commit 2d30d31ea3c5be426ce25607b9bd1835acb85e0a ]

Since commit 62c230bc1790 ("mm: add support for a filesystem to activate
swap files and use direct_IO for writing swap pages"), swap_writepage()
calls direct_IO on swap files.  However, in that case the page isn't
redirtied if I/O fails, and is therefore handled afterwards as if it has
been successfully written to the swap file, leading to memory corruption
when the page is eventually swapped back in.

This patch sets the page dirty when direct_IO() fails.  It fixes a
memory corruption that happened while using swap-over-NFS.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>	[3.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/page_io.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_io.c b/mm/page_io.c
index 78eee32..04ca00d 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -222,6 +222,8 @@ int swap_writepage(struct page *page, struct writeback_control *wbc)
 		if (ret == PAGE_SIZE) {
 			count_vm_event(PSWPOUT);
 			ret = 0;
+		} else {
+			set_page_dirty(page);
 		}
 		return ret;
 	}
-- 
1.7.10.4


