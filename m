Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3HWKNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:13:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32149 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3HWKN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:13:28 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-2f-521735c6d7bb
From: Weijie Yang <weijie.yang@samsung.com>
To: minchan@kernel.org, bob.liu@oracle.com, sjenning@linux.vnet.ibm.com
Cc: weijie.yang.kh@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] zswap bugfix: memory leaks and other problem
Date: Fri, 23 Aug 2013 18:12:33 +0800
Message-id: <000101ce9fe9$6849dab0$38dd9010$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6f6Uh4QigShxGCRRedbD037w4JRA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jAd1jpuJBBjNmmlt0nZrKYnF51xw2
	i3tr/rNaLPv6nt3i0L5V7BZPTvxncWDz2DnrLrvHplWdbB6bPk1i93hwaDOLx8ent1g8Pm+S
	C2CL4rJJSc3JLEst0rdL4Mq4+OI2U0Evd8XSPzsZGxh7ObsYOTkkBEwknvfcYISwxSQu3FvP
	1sXIxSEksIhR4vSjTcwQzh9Gie1nPoNVsQloS9zt38gKYosIuEtc3vuAHcRmFvCT2HLgMBOI
	LSzgKLFlz2ewOIuAqsTWp3PAenkF7CTu/XjFBmELSvyYfI+li5EDqFddYsqUXIgx2hJP3l1g
	BQlLAIUf/dWF2KQn0f7sEyNEibjExiO3WCYwCsxCMmgWwqBZSAbNQtKxgJFlFaNoakFyQXFS
	eq6hXnFibnFpXrpecn7uJkZw4D+T2sG4ssHiEKMAB6MSD+8EZ7EgIdbEsuLK3EOMEhzMSiK8
	H6XFg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwxqVM
	4pY9w5lelSMap7etT+2NxHTbT8ntWadjleatv1WmxHkyKeZmjEuU2vzAvFLvV5+O/Dq9uXGT
	1Wbpz5qZcrGCG3Ibp8287XerK6Wl32GxxMMDht5ix8u6PlzMZ7fxkVsUabfzv0nT6rwFr8WW
	JAgdmThvxafGN3UHJbwOKUse+lhS5c+sxFKckWioxVxUnAgAvKvBHngCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fix a few bugs in zswap based on Linux-3.11-rc6.

Corresponding mail thread see: lkml.org/lkml/2013/8/18/59 .

These issues fixed are:
1. memory leaks when re-swapon
2. potential problem which store and reclaim functions is called recursively 
3. memory leaks when invalidate and reclaim occur simultaneously 
4. unnecessary page scanning

Issues discussed in that mail thread NOT fixed as it happens rarely or not a big problem:
1. a "theoretical race condition" when reclaim page 
when a handle alloced from zbud, zbud considers this handle is used validly by upper(zswap) and can be a candidate for reclaim.
But zswap has to initialize it such as setting swapentry and adding it to rbtree. so there is a race condition, such as:
thread 0: obtain handle x from zbud_alloc 
thread 1: zbud_reclaim_page is called 
thread 1: callback zswap_writeback_entry to reclaim handle x 
thread 1: get swpentry from handle x (it is random value now) 
thread 1: bad thing may happen 
thread 0: initialize handle x with swapentry

2. frontswap_map bitmap not cleared after zswap reclaim 
Frontswap uses frontswap_map bitmap to track page in "backend" implementation, 
when zswap reclaim a page, the corresponding bitmap record is not cleared.

mm/zswap.c |   35 ++++++++++++++++++++++++-----------
 1 files changed, 24 insertions(+), 11 deletions(-)

