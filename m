Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbaCMVk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 17:40:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaCMVk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 17:40:26 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Tony Luck <tony.luck@intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, linux-mm@kvack.org
Subject: [PATCH 0/6] memory error report/recovery for dirty pagecache v3
Date: Thu, 13 Mar 2014 17:39:40 -0400
Message-Id: <1394746786-6397-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset tries to solve the following issues related to handling memory
errors on dirty pagecache:
 1. stickiness of error info: in current implementation, the events of
    dirty pagecache memory error are recorded as AS_EIO on page_mapping(page),
    which is not sticky (cleared once checked). As a result, we have a race
    window of ignoring the data lost due to concurrent accesses even if
    your application can handle the error report by itself.
 2. finer granularity: when memory error hits a page of a file, we get the
    error report in accessing to other healthy pages, which is confusing for
    userspace.
 3. overwrite recovery: with fixes on problem 1 and 2, we have a possibility
    to recover from the memory error if applications recreate the date on the
    error page or applications are sure of that data on the error page is not
    important.
These problems are solved by introducing a new pagecache tag to remember
memory errors.

Patch 1 is extending some radix_tree operation to support end parameter,
which is used later.

Patch 2 introduces PAGECACHE_TAG_HWPOISON and solve problem 1 and 2 with it.

Patch 3 implements overwrite recovery to solve problem 3.

Patch 4-6 add a new interface /proc/kpagecache which is helpful when
testing/debugging pagecache related issues like this patchset.
Some sample usespace code and documentation is also added.

I think that we can straightforwardly raplace error reporting for normal
IO error with pagecache tag, and we have a clear benefit of doing so in
finer granurality. And overwrite recovery is also fine for example when
dirty data was lost in write failure. But at first I want review and 
feedback on the base idea.

Previous discussions are available from the URLs:
- v1: http://thread.gmane.org/gmane.linux.kernel/1341433
- v2: http://thread.gmane.org/gmane.linux.kernel.mm/84760

Test code:
  https://github.com/Naoya-Horiguchi/test_memory_error_reporting
---
Summary:

Naoya Horiguchi (6):
      radix-tree: add end_index to support ranged iteration
      mm/memory-failure.c: report and recovery for memory error on dirty pagecache
      mm/memory-failure.c: add code to resolve quasi-hwpoisoned page
      fs/proc/page.c: introduce /proc/kpagecache interface
      tools/vm/page-types.c: add file scanning mode
      Documentation: update Documentation/vm/pagemap.txt

 Documentation/vm/pagemap.txt  |  29 ++++++
 drivers/gpu/drm/qxl/qxl_ttm.c |   2 +-
 fs/proc/page.c                | 106 +++++++++++++++++++
 include/linux/fs.h            |  12 ++-
 include/linux/pagemap.h       |  27 +++++
 include/linux/radix-tree.h    |  31 ++++--
 kernel/irq/irqdomain.c        |   2 +-
 lib/radix-tree.c              |   8 +-
 mm/filemap.c                  |  28 ++++-
 mm/memory-failure.c           | 230 +++++++++++++++++++++++++++++++++++-------
 mm/shmem.c                    |   2 +-
 mm/truncate.c                 |   7 ++
 tools/vm/page-types.c         | 117 ++++++++++++++++++---
 13 files changed, 530 insertions(+), 71 deletions(-)
