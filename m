Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3DCXwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:52:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60664 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3DCXwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:52:39 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, Arun Sharma <asharma@fb.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jason Evans <je@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [RFC PATCH 0/4] Support vranges on files
Date: Wed,  3 Apr 2013 16:52:19 -0700
Message-Id: <1365033144-15156-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is against Minchan's vrange work here:
	https://lkml.org/lkml/2013/3/12/105

Extending it to support volatile ranges on files. In effect
providing the same functionality of my earlier file based
volatile range patches on-top of Minchan's anonymous volatile
range work.

Volatile ranges on files are different then on anonymous memory,
because the volatility state can be shared between multiple
applications. This makes storing the volatile ranges exclusively
in the mm_struct (or in vmas as in Minchan's earlier work)
inappropriate.

The patchset starts with some minor cleanup.

Then we introduce the idea of a vrange_root, which provides a
interval-tree root and a lock to protect the tree. This structure
can then be stored in the mm_struct or in an addres_space. Then the
same infrastructure can be used to manage volatile ranges on both
anonymous and file backed memory.

Next we introduce a parallel fvrange() syscall for creating
volatile ranges directly against files.

And finally, we change the range pruging logic to be able to
handle both anonymous and file volatile ranges.

Now there are some quirks still to be resolved with the approach
used here. The biggest one being the vrange() call can't be used to
create volatile ranges against mmapped files. Instead only the
fvrange() can be used to create file backed volatile ranges.

This could be overcome by iterating across all the process VMAs to
determine if they're anonymous or file based, and if file-based,
create a VMA sized volatile range on the mapping pointed to by the
VMA.

But this would have downsides, as Minchan has been clear that he wants
to optmize the vrange() calls so that it is very cheap to create and
destroy volatile ranges. Having simple per-process ranges be created
means we don't have to iterate across the vmas in the range to
determine if they're anonymous or file backed. Instead the current
vrange() code just creates per process ranges (which may or may not
cover mmapped file data), but will only purge anonymous pages in
that range. This keeps the vrange() call cheap.

Additionally, just creating or destroying a single range is very
simple to do, and requires a fixed amount of memory known up front.
Thus we can allocate needed data prior to making any modifications.

But If we were to create a range that crosses anonymous and file
backed pages, it must create or destroy multiple per-process or
per-file ranges. This could require an unknown number of allocations,
opening the possibility of getting an ENOMEM half-way through the
operation, leaving the volatile range partially created or destroyed.

So to keep this simple for this first pass, for now we have two
syscalls for two types of volatile ranges.

Let me know if you have any thoughts or comments. I'm sure there's
plenty of room for improvement here.

In the meantime I'll be playing with some different approaches to
try to handle single volatile ranges that cross file and anonymous
vmas.

The entire queue, both Minchan's changes and mine can be found here:
git://git.linaro.org/people/jstultz/android-dev.git dev/vrange-minchan

thanks
-john

Cc: linux-mm@kvack.org
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave@sr71.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Neil Brown <neilb@suse.de>
Cc: Mike Hommey <mh@glandium.org>
Cc: Taras Glek <tglek@mozilla.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jason Evans <je@fb.com>
Cc: sanjay@google.com
Cc: Paul Turner <pjt@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>


John Stultz (4):
  vrange: Make various vrange.c local functions static
  vrange: Introduce vrange_root to make vrange structures more flexible
  vrange: Support fvrange() syscall for file based volatile ranges
  vrange: Enable purging of file backed volatile ranges

 arch/x86/syscalls/syscall_64.tbl |    1 +
 fs/file_table.c                  |    5 +
 fs/inode.c                       |    2 +
 fs/proc/task_mmu.c               |   10 +-
 include/linux/fs.h               |    2 +
 include/linux/mm_types.h         |    4 +-
 include/linux/vrange.h           |   60 ++++---
 include/linux/vrange_types.h     |   22 +++
 kernel/fork.c                    |    2 +-
 mm/vrange.c                      |  334 ++++++++++++++++++++++++++------------
 10 files changed, 308 insertions(+), 134 deletions(-)
 create mode 100644 include/linux/vrange_types.h

-- 
1.7.10.4

