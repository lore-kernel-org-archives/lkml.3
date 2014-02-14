Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaBNGmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:42:33 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:40465 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaBNGmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:42:32 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-f3-52fdbad662b2
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Mel Gorman'" <mgorman@suse.de>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>, riel@redhat.com,
        "'Minchan Kim'" <minchan@kernel.org>, weijie.yang.kh@gmail.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 1/2] mm/vmscan: restore sc->gfp_mask after promoting it to
 __GFP_HIGHMEM
Date: Fri, 14 Feb 2014 14:41:33 +0800
Message-id: <000101cf294f$eef39610$ccdac230$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8pT8ybmBi8tOG2TuKw284epdypdg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9jQd1ru/4GGXzeb2MxZ/0aNovLu+aw
	Wdxb85/VYvK7Z4wWy76+Z7f4e2U9i8WTE/9ZHNg9ds66y+6xaVUnm8emT5PYPU7M+M3i8X7f
	VTaPzaerPT5vkgtgj+KySUnNySxLLdK3S+DKaFp9kbmgn7ui6cta9gbGnxxdjBwcEgImEj92
	GnQxcgKZYhIX7q1n62Lk4hASmM4osWDmYnYI5w+jxJkXfawgVWwC2hJ3+zeC2SICShKn/3wF
	62AWuMQo8eh8ByPIVGGBWInG9WA1LAKqEi3Pl4DZvAJ2EhNnrWGEsAUlfky+xwJiMwuoS0ya
	t4gZwpaX2LzmLTPEceoSj/7qQqzSk9i+bD0TRIm4xMYjt1gmMArMQjJpFpJJs5BMmoWkZQEj
	yypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Gh4JrWDcWWDxSFGAQ5GJR5ejwd/goRYE8uK
	K3MPMUpwMCuJ8DKl/Q0S4k1JrKxKLcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUI
	JsvEwSnVwKhg8vxsWX8y1wmz5D6exu1fZ7j28/0Snfv19uzrPXxnjjw7l+i1ZE3cQm7enj0v
	TuZtF7owz8tU7lH8SsEfjQ1R82/+OdX1w63ifmPG+2lTfjx+N+U8U1P5+/0Gk0IcLwXNP8ZX
	tTGltTP35sOeu0cMfCNtwzK+ru74Gua95NGdNdNzAv9k39ilxFKckWioxVxUnAgAfigfRoIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We promote sc->gfp_mask to __GFP_HIGHMEM to forcibly scan highmem if
there are too many buffer_heads pinning highmem. see: cc715d99e5

This patch restores sc->gfp_mask to its caller original value after
finishing the scan job, to avoid the impact on other invocations from
its upper caller, such as vmpressure_prio(), shrink_slab().

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
Changes since v1:
	- use orig_mask to record the caller's orininal mask and restore
	 it after finishing scan, according to Riel's suggestion.

V1: https://lkml.org/lkml/2014/2/12/764

 mm/vmscan.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a9c74b4..da0a87c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2298,6 +2298,7 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	unsigned long nr_soft_reclaimed;
 	unsigned long nr_soft_scanned;
 	bool aborted_reclaim = false;
+	gfp_t orig_mask = sc->gfp_mask;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -2354,6 +2355,12 @@ static bool shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		shrink_zone(zone, sc);
 	}
 
+	/*
+	 * restore to original mask to avoid the impact on its caller
+	 * if we promote it to __GFP_HIGHMEM.
+	 */
+	sc->gfp_mask = orig_mask;
+
 	return aborted_reclaim;
 }
 
-- 
1.7.10.4


