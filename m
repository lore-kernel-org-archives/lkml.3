Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750758Ab3IFFQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:16:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35024 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3IFFQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:16:48 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-4d-5229653990a4
From: Weijie Yang <weijie.yang@samsung.com>
To: sjenning@linux.vnet.ibm.com
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] mm/zswap bugfix: memory leaks and other problems
Date: Fri, 06 Sep 2013 13:15:08 +0800
Message-id: <000501ceaac0$4568ec70$d03ac550$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6qwA2j9Xb0+k0jSS62TaEH9Ag/Og==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jQV3LVM0gg4UH9S26Tk1lsbi8aw6b
	xb01/1ktln19z25xaN8qdosnJ/6zOLB57Jx1l91j06pONo9Nnyaxezw4tJnF4+PTWywenzfJ
	BbBFcdmkpOZklqUW6dslcGU8unqDtWAmT0XTtfUsDYyvOLsYOTkkBEwkml59ZYGwxSQu3FvP
	BmILCUxnlHjWyd3FyAVk/2GU+H+xlxkkwSagLXG3fyMriC0iIC+x+9t3MJtZoELi+bTvYDXC
	Ah4SEybeBLNZBFQlPu05DjSUg4NXwE6ivTcGJMwrICjxY/I9FpAws4C6xJQpuRBT5CU2r3nL
	DBKWAAo/+qsLsUhPonnCahaIEnGJjUdusUxgFJiFZNAshEGzkAyahaRjASPLKkbR1ILkguKk
	9FwjveLE3OLSvHS95PzcTYzgoH8mvYNxVYPFIUYBDkYlHl6OHo0gIdbEsuLK3EOMEhzMSiK8
	4hqaQUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYl1U6
	WT9kTd93Uz3g8SH99wzm5v9W7BOfI9j84OnnOt6OV+f3vz7sM/fhjmqWFcIbMorYnHZv7J3B
	H74txKhDw6zn8rzuMp+NTp+C2XKOXL16oHTy4zX+ddMMepzfHtzTcMa8QitHWVxKbUHqBK7r
	JfIHl1WUv9r7uH7qz4Cz+uxtjyuj9nztUmIpzkg01GIuKk4EAKAxJi92AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fix a few bugs in zswap based on Linux-3.11.

v1 --> v2
	- free memory in zswap_frontswap_invalidate_area (in patch 1)
	- fix whitespace corruption (line wrapping)

Corresponding mail thread: https://lkml.org/lkml/2013/8/18/59

These issues fixed/optimized are:

 1. memory leaks when re-swapon
 
 2. memory leaks when invalidate and reclaim occur concurrently
 
 3. avoid unnecessary page scanning
 
 4. use GFP_NOIO instead of GFP_KERNEL to avoid zswap store and reclaim 
functions called recursively

Issues discussed in that mail thread NOT fixed as it happens rarely or
not a big problem:

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

 mm/zswap.c |   34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

