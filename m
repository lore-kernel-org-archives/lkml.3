Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750811Ab3IFFR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:17:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35252 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3IFFR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:17:57 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-f0-522965847170
From: Weijie Yang <weijie.yang@samsung.com>
To: sjenning@linux.vnet.ibm.com
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] mm/zswap: avoid unnecessary page scanning
Date: Fri, 06 Sep 2013 13:16:45 +0800
Message-id: <000701ceaac0$71c43590$554ca0b0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6qwDwCsIgPqkt1R3OrCKxYjIjm0A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd2WVM0gg+mHuS26Tk1lsbi8aw6b
	xb01/1ktln19z25xaN8qdosnJ/6zOLB57Jx1l91j06pONo9Nnyaxezw4tJnF4+PTWywenzfJ
	BbBFcdmkpOZklqUW6dslcGWcfrCDrWASW8XWzQ1sDYz/WLoYOTkkBEwk7p+4xgphi0lcuLee
	rYuRi0NIYDqjxOyD71ggnD+MEp3H1zKBVLEJaEvc7d8I1iEiIC+x+9t3MJtZoELi+bTvzCC2
	sICjxKIlq9lAbBYBVYll3zeD2bwCdhJ/dq5igrAFJX5Mvge0gAOoV11iypRciDHyEpvXvGUG
	CUsAhR/91YXYpCcx43MbC0SJuMTGI7dYJjAKzEIyaBbCoFlIBs1C0rGAkWUVo2hqQXJBcVJ6
	rqFecWJucWleul5yfu4mRnDgP5PawbiyweIQowAHoxIPL0ePRpAQa2JZcWXuIUYJDmYlEV5x
	Dc0gId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYxneBZk
	zj5jX2W/vW5G/Nb+nd31i2bzbvWcoZ+5z+pYnWZH4wov4S1Hor+q2zkotT+LjS15+LBB3mez
	95nfYgleyhk7V3Nu536fkzvP7UxQyu74FrHXeu9uxaQ9yzNb3Pnhhxy3zenmrleTPeoPzDVX
	Yq+00D4tkfW7/Jb7HgOR9GvPFfcYLlJiKc5INNRiLipOBAC+oLcdeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add SetPageReclaim before __swap_writepage so that page can be moved to the
tail of the inactive list, which can avoid unnecessary page scanning as this
page was reclaimed by swap subsystem before.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/zswap.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 1be7b90..cc40e6a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -556,6 +556,9 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 		SetPageUptodate(page);
 	}
 
+	/* move it to the tail of the inactive list after end_writeback */
+	SetPageReclaim(page);
+
 	/* start writeback */
 	__swap_writepage(page, &wbc, end_swap_bio_write);
 	page_cache_release(page);
-- 
1.7.10.4


