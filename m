Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaA0KGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:06:04 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57849 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaA0KGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:06:01 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-cb-52e62f882c1a
From: Weijie Yang <weijie.yang@samsung.com>
To: hughd@google.com
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Minchan Kim'" <minchan@kernel.org>, shli@kernel.org,
        "'Bob Liu'" <bob.liu@oracle.com>, weijie.yang.kh@gmail.com,
        "'Heesub Shin'" <heesub.shin@samsung.com>, mquzik@redhat.com,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 6/8] mm/swap: remove swap_lock to simplify si_swapinfo()
Date: Mon, 27 Jan 2014 18:03:04 +0800
Message-id: <000901cf1b47$60f439c0$22dcad40$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8bRuyw+EtBlOFsS4OdO2z/6wtocw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgG6H/rMgg1XtnBZz1q9hs+g6NZXF
	4uDsJUwWTz/1sVhc3jWHzeLemv+sFsu+vme3mPJwEqPFhUP3mSwWbHzEaPHkxH8WB26PnbPu
	snss2FTqsWlVJ5vHpk+T2D1OzPjN4vHx6S0Wj/f7rrJ59G1ZxejxeZNcAGcUl01Kak5mWWqR
	vl0CV8aHLfOYCj5xVhzasoW9gbGfo4uRk0NCwESiu2cOK4QtJnHh3nq2LkYuDiGBRYwSa261
	Qjl/GCUOnfrNBlLFJqAtcbd/I1iHiICIxJo7CxlBipgFzjBJXNjVDlYkLOAhsf9gByOIzSKg
	KnH00HR2EJtXwE5i19SJLBC2oMSPyfeAbA6gZnWJKVNyQcLMAvISm9e8ZQYJSwCFH/3VhVil
	J7FrzQ02iBJxiY1HbrFMYBSYhWTQLIRBs5AMmoWkYwEjyypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4Eh6JrWDcWWDxSFGAQ5GJR7ejOtPg4RYE8uKK3MPMUpwMCuJ8FboPAsS4k1JrKxK
	LcqPLyrNSS0+xCjNwaIkznug1TpQSCA9sSQ1OzW1ILUIJsvEwSnVwDi3Io/196ekmOq17001
	3uz85ZKtKui/6cn9JBVht8nXblSeubohsoL7seXzJZOStv9oSFjyUM2Ws4zx18c2Y95FRibB
	r7dV3+qeU/xjUkVvzazcKt0Nb9ymp+hYMDPaFhzjjX1YXvZg+qwuC4M/BgJ7xCfNjrX7f5pb
	Xr3x8dR23ZP5YiUdNUosxRmJhlrMRcWJAAcAFFCgAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider of performance and simplicity, this patch remove swap_lock
to simplify the si_swapinfo().

Because the system info we obtain through /proc or /sys interface is
just a snapshot, we don't need a very precise freeswap and totalswap count.
Some monitor tool will get these count at per-second period, so it is good
to performance.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/swapfile.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3023172..7332c3d 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2637,19 +2637,8 @@ out:
 
 void si_swapinfo(struct sysinfo *val)
 {
-	unsigned int type;
-	unsigned long nr_to_be_unused = 0;
-
-	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *si = swap_info[type];
-
-		if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
-			nr_to_be_unused += si->inuse_pages;
-	}
-	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;
-	val->totalswap = total_swap_pages + nr_to_be_unused;
-	spin_unlock(&swap_lock);
+	val->freeswap = atomic_long_read(&nr_swap_pages);
+	val->totalswap = total_swap_pages;
 }
 
 /*
-- 
1.7.10.4


