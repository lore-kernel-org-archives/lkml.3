Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab3HWL0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:26:04 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:39271 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3HWL0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:26:02 -0400
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 19:26:01 +0800
Message-ID: <CAL1ERfON5p1t_KskkQc_7u78Qk=kmy6nNyqsnDwriesTi2ubLA@mail.gmail.com>
Subject: [PATCH 0/4] zswap bugfix: memory leaks and other problem
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Minchan Kim <minchan@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        sjenning@linux.vnet.ibm.com
Cc: weijie.yang@samsung.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
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

Issues discussed in that mail thread NOT fixed as it happens rarely or
not a big problem:
 1. a "theoretical race condition" when reclaim page
 when a handle alloced from zbud, zbud considers this handle is used
validly by upper(zswap) and can be a candidate for reclaim.
 But zswap has to initialize it such as setting swapentry and adding
it to rbtree. so there is a race condition, such as:
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
