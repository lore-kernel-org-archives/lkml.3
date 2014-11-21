Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbaKUILj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:11:39 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:39334 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaKUILi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:11:38 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>, Dave Hansen <dave@sr71.net>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 0/7] Resurrect and use struct page extension for some debugging features
Date: Fri, 21 Nov 2014 17:13:59 +0900
Message-Id: <1416557646-21755-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Major Changes from v1
* patch 1: add overall design description in code comment
* patch 6: make page owner more accurate for alloc_pages_exact() and
compaction/CMA
* patch 7: handles early allocated pages for page owner

When we debug something, we'd like to insert some information to
every page. For this purpose, we sometimes modify struct page itself.
But, this has drawbacks. First, it requires re-compile. This makes us
hesitate to use the powerful debug feature so development process is
slowed down. And, second, sometimes it is impossible to rebuild the kernel
due to third party module dependency. At third, system behaviour would be
largely different after re-compile, because it changes size of struct
page greatly and this structure is accessed by every part of kernel.
Keeping this as it is would be better to reproduce errornous situation.

To overcome these drawbacks, we can extend struct page on another place
rather than struct page itself. Until now, memcg uses this technique. But,
now, memcg decides to embed their variable to struct page itself and it's
code to extend struct page has been removed. I'd like to use this code
to develop debug feature, so this series resurrect it.

With resurrecting it, this patchset makes two debugging features boottime
configurable. As mentioned above, rebuild has serious problems. Making
it boottime configurable mitigate these problems with marginal
computational overhead. One of the features, page_owner isn't in mainline
now. But, it is really useful so it is in mm tree for a long time. I think
that it's time to upstream this feature.

Any comments are more than welcome.

This patchset is based on next-20141106 + my two patches related to
debug-pagealloc [1].

[1]: https://lkml.org/lkml/2014/11/7/78

Joonsoo Kim (7):
  mm/page_ext: resurrect struct page extending code for debugging
  mm/debug-pagealloc: prepare boottime configurable on/off
  mm/debug-pagealloc: make debug-pagealloc boottime configurable
  mm/nommu: use alloc_pages_exact() rather than it's own implementation
  stacktrace: introduce snprint_stack_trace for buffer output
  mm/page_owner: keep track of page owners
  mm/page_owner: correct owner information for early allocated pages

 Documentation/kernel-parameters.txt |   14 ++
 arch/powerpc/mm/hash_utils_64.c     |    2 +-
 arch/powerpc/mm/pgtable_32.c        |    2 +-
 arch/s390/mm/pageattr.c             |    2 +-
 arch/sparc/mm/init_64.c             |    2 +-
 arch/x86/mm/pageattr.c              |    2 +-
 include/linux/mm.h                  |   36 +++-
 include/linux/mm_types.h            |    4 -
 include/linux/mmzone.h              |   12 ++
 include/linux/page-debug-flags.h    |   32 ---
 include/linux/page_ext.h            |   84 ++++++++
 include/linux/page_owner.h          |   19 ++
 include/linux/stacktrace.h          |    3 +
 init/main.c                         |    7 +
 kernel/stacktrace.c                 |   24 +++
 lib/Kconfig.debug                   |   13 ++
 mm/Kconfig.debug                    |   10 +
 mm/Makefile                         |    2 +
 mm/debug-pagealloc.c                |   45 +++-
 mm/nommu.c                          |   33 +--
 mm/page_alloc.c                     |   67 +++++-
 mm/page_ext.c                       |  393 +++++++++++++++++++++++++++++++++++
 mm/page_owner.c                     |  313 ++++++++++++++++++++++++++++
 mm/vmstat.c                         |   93 +++++++++
 tools/vm/Makefile                   |    4 +-
 tools/vm/page_owner_sort.c          |  144 +++++++++++++
 26 files changed, 1286 insertions(+), 76 deletions(-)
 delete mode 100644 include/linux/page-debug-flags.h
 create mode 100644 include/linux/page_ext.h
 create mode 100644 include/linux/page_owner.h
 create mode 100644 mm/page_ext.c
 create mode 100644 mm/page_owner.c
 create mode 100644 tools/vm/page_owner_sort.c

-- 
1.7.9.5

