Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3IWIVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:21:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56692 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab3IWIVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:21:46 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-ac-523ffa19a4e9
From: Weijie Yang <weijie.yang@samsung.com>
To: akpm@linux-foundation.org
Cc: sjenning@linux.vnet.ibm.com, bob.liu@oracle.com, minchan@kernel.org,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
Subject: [PATCH v3 0/3] mm/zswap bugfix: memory leaks and other problems
Date: Mon, 23 Sep 2013 16:19:36 +0800
Message-id: <000001ceb835$f0899910$d19ccb30$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64NaQVXSyG00U5SleGMypsUgTshw==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t9jQV3JX/ZBBjfvc1jMWb+GzeJN6202
	i65TU1ksTlystbh6eRmjxcHZS5gszja9Ybe4vGsOm8W9Nf9ZLZZ9fc9u8fDpdXaLQ/tWsVss
	2PiI0eLJif8sDnweO2fdZffYtKqTzWPTp0nsHidm/GbxeHBoM4vHx6e3WDz6tqxi9Pi8SS6A
	I4rLJiU1J7MstUjfLoEr4/HHqSwFG3kq2lY9YW1g/MXZxcjJISFgIrGmdQE7hC0mceHeerYu
	Ri4OIYHpjBLHjuxhh3D+MEpM+LiNBaSKTUBb4m7/RlYQW0RAVmLq3/NgcWaBg0wSczfxg9jC
	Ah4Sm7sawWpYBFQlpmy8wgZi8wrYSew9tpMVwhaU+DH5HlAvB1CvusSUKbkQY+QlNq95ywwS
	lgAKP/qrC7FJT+LlzEtsECXiEhuP3GKZwCgwC8mgWQiDZiEZNAtJxwJGllWMoqkFyQXFSem5
	RnrFibnFpXnpesn5uZsYwbH1THoH46oGi0OMAhyMSjy8kYn2QUKsiWXFlbmHGCU4mJVEeJs6
	gUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoY14nedLhT
	FtdTwp0vlV3/ert0jPEGd4me44uPuz15L7/59FnTRt/v3p+dreRbmS12P6iZ9OpWso0+w2wv
	c7cCpRKfE2k3Nv/+92Dzpge93Bckgv5/cV2/eskdBd7HW81+HpRbNP/VD7Ere+37z0rEeKkx
	qy9QvtF6IMGTZb0Dw78PSy1X5fVeUGIpzkg01GIuKk4EAAz4GoqpAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fix a few bugs in mm/zswap based on Linux-3.11.

v2 --> v3
	- keep GFP_KERNEL flag

v1 --> v2
	- free memory in zswap_frontswap_invalidate_area(in patch 1)
	- fix whitespace corruption (line wrapping)
	
Corresponding mail thread: https://lkml.org/lkml/2013/8/18/59

These issues fixed/optimized are:

 1. memory leaks when re-swapon
 
 2. memory leaks when invalidate and reclaim occur concurrently
 
 3. avoid unnecessary page scanning


Issues discussed in that mail thread NOT fixed as it happens rarely or
not a big problem or controversial:

 1. a "theoretical race condition" when reclaim page
When a handle alloced from zbud, zbud considers this handle is used
validly by upper(zswap) and can be a candidate for reclaim. But zswap has
to initialize it such as setting swapentry and adding it to rbtree.
so there is a race condition, such as:
 thread 0: obtain handle x from zbud_alloc
 thread 1: zbud_reclaim_page is called
 thread 1: callback zswap_writeback_entry to reclaim handle x
 thread 1: get swpentry from handle x (it is random value now)
 thread 1: bad thing may happen
 thread 0: initialize handle x with swapentry

2. frontswap_map bitmap not cleared after zswap reclaim
Frontswap uses frontswap_map bitmap to track page in "backend" implementation,
when zswap reclaim a page, the corresponding bitmap record is not cleared.

3. the potential that zswap store and reclaim functions called recursively


 mm/zswap.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

