Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaHTPEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:04:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:17652 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaHTPEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:04:50 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-07-53f4b91023a9
Subject: [PATCH 3/7] mm/balloon_compaction: isolate balloon pages without
 lru_lock
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 20 Aug 2014 19:04:46 +0400
Message-id: <20140820150446.4194.5716.stgit@buzz>
In-reply-to: <20140820150435.4194.28003.stgit@buzz>
References: <20140820150435.4194.28003.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xq7oCO78EG6zqV7GYs34Nm8WMh79Y
	LH7s7GW1uLxrDpvFvTX/WS2Ob93CbLH4yG1mB3aPnbPusnts+jSJ3ePEjN8sHh+f3mLxeL/v
	KptH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZRw52sdecJmt4seM0ywNjDtYuxg5OCQETCQu
	bo3sYuQEMsUkLtxbz9bFyMUhJLCUUaLn3QdmCKeRSeLuy/lsIFXCAiES9zf8YwGx2QTMJLbt
	u80IYosIpEl8fbYFrIZZoEjixc1ZYDaLgKrEoof7mUBsXgFDiVXP7oPZnALGEmuOvwTrFRIw
	krjW85sZxBYVkJNYebmFFaJeUOLH5HssIIcyC6hLTJmSCzFeXmLzmrfMExgFZiGpmoVQNQtJ
	1QJG5lWMoqmlyQXFSem5hnrFibnFpXnpesn5uZsYIUH/ZQfj4mNWhxgFOBiVeHhvLPoSLMSa
	WFZcmXuIUYKDWUmE98QGoBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZGucMxIRxSjP4vCzqtn7K8
	T+0s1RY+c910r3y0+oyiKz0PTN6pcn0u4vD9HDffoF+7NOXqJOFbdd75t5uXV35vVbMTVVdc
	e3Pe6iP/786PX/+SVyDy5Y68jBUhax1KPEPdCpdmSszw69jnWrbrz6NFJ2y2HpT/PutP9E/l
	dwpzypKsJgVP7TupxFKckWioxVxUnAgA2IWNQFgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LRU-lock isn't required for balloon page isolation. This check makes migration
of some ballooned pages mostly impossible because isolate_migratepages_range()
drops LRU lock periodically.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: stable <stable@vger.kernel.org> # v3.8
---
 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 21bf292..0653f5f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -597,7 +597,7 @@ isolate_migratepages_range(struct zone *zone, struct compact_control *cc,
 		 */
 		if (!PageLRU(page)) {
 			if (unlikely(balloon_page_movable(page))) {
-				if (locked && balloon_page_isolate(page)) {
+				if (balloon_page_isolate(page)) {
 					/* Successfully isolated */
 					goto isolate_success;
 				}

