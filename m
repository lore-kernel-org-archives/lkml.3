Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328AbaJPDgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:36:18 -0400
Received: from [42.62.48.242] ([42.62.48.242]:15935 "EHLO manager.mioffice.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750969AbaJPDgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:36:17 -0400
From: Hui Zhu <zhuhui@xiaomi.com>
To: <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <m.szyprowski@samsung.com>, <akpm@linux-foundation.org>,
        <mina86@mina86.com>, <aneesh.kumar@linux.vnet.ibm.com>,
        <iamjoonsoo.kim@lge.com>, <hannes@cmpxchg.org>, <riel@redhat.com>,
        <mgorman@suse.de>, <minchan@kernel.org>, <nasa4836@gmail.com>,
        <ddstreet@ieee.org>, <hughd@google.com>, <mingo@kernel.org>,
        <rientjes@google.com>, <peterz@infradead.org>, <keescook@chromium.org>,
        <atomlin@redhat.com>, <raistlin@linux.it>, <axboe@fb.com>,
        <paulmck@linux.vnet.ibm.com>, <kirill.shutemov@linux.intel.com>,
        <n-horiguchi@ah.jp.nec.com>, <k.khlebnikov@samsung.com>,
        <msalter@redhat.com>, <deller@gmx.de>, <tangchen@cn.fujitsu.com>,
        <ben@decadent.org.uk>, <akinobu.mita@gmail.com>,
        <lauraa@codeaurora.org>, <vbabka@suse.cz>, <sasha.levin@oracle.com>,
        <vdavydov@parallels.com>, <suleiman@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, Hui Zhu <zhuhui@xiaomi.com>
Subject: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more aggressive about allocation
Date: Thu, 16 Oct 2014 11:35:47 +0800
Message-ID: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.27.14.101]
X-ClientProxiedBy: CNCAS1.mioffice.cn (10.237.8.131) To cnbox4.mioffice.cn
 (10.237.8.144)
X-EsetResult: clean, is OK
X-EsetId: 587748382C4597170C3011
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In fallbacks of page_alloc.c, MIGRATE_CMA is the fallback of
MIGRATE_MOVABLE.
MIGRATE_MOVABLE will use MIGRATE_CMA when it doesn't have a page in
order that Linux kernel want.

If a system that has a lot of user space program is running, for
instance, an Android board, most of memory is in MIGRATE_MOVABLE and
allocated.  Before function __rmqueue_fallback get memory from
MIGRATE_CMA, the oom_killer will kill a task to release memory when
kernel want get MIGRATE_UNMOVABLE memory because fallbacks of
MIGRATE_UNMOVABLE are MIGRATE_RECLAIMABLE and MIGRATE_MOVABLE.
This status is odd.  The MIGRATE_CMA has a lot free memory but Linux
kernel kill some tasks to release memory.

This patch series adds a new function CMA_AGGRESSIVE to make CMA memory
be more aggressive about allocation.
If function CMA_AGGRESSIVE is available, when Linux kernel call function
__rmqueue try to get pages from MIGRATE_MOVABLE and conditions allow,
MIGRATE_CMA will be allocated as MIGRATE_MOVABLE first.  If MIGRATE_CMA
doesn't have enough pages for allocation, go back to allocate memory from
MIGRATE_MOVABLE.
Then the memory of MIGRATE_MOVABLE can be kept for MIGRATE_UNMOVABLE and
MIGRATE_RECLAIMABLE which doesn't have fallback MIGRATE_CMA.

