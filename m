Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3EHXjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:39:16 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:61069 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3EHXjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:39:13 -0400
X-AuditID: 9c930179-b7bb6ae000001131-d0-518ae2188856
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>
Subject: [PATCH v4 0/6] Per process reclaim
Date: Thu,  9 May 2013 08:38:56 +0900
Message-Id: <1368056342-30836-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.2.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These day, there are many platforms avaiable in the embedded market
and they are smarter than kernel which has very limited information
about working set so they want to involve memory management more heavily
like android's lowmemory killer and ashmem or recent many lowmemory
notifier(there was several trial for various company NOKIA, SAMSUNG,
Linaro, Google ChromeOS, Redhat).

One of the simple imagine scenario about userspace's intelligence is that
platform can manage tasks as forground and backgroud so it would be
better to reclaim background's task pages for end-user's *responsibility*
although it has frequent referenced pages.

The patch[1] adds new knob "reclaim under proc/<pid>/" so task manager
can reclaim any target process anytime, anywhere. It could give another
method to platform for using memory efficiently.

It can avoid process killing for getting free memory, which was really
terrible experience because I lost my best score of game I had ever
after I switch the phone call while I enjoyed the game.

Reclaim file-backed pages only.
	echo file > /proc/PID/reclaim
Reclaim anonymous pages only.
	echo anon > /proc/PID/reclaim
Reclaim all pages
	echo all > /proc/PID/reclaim

Some pages could be shared by several processes. (ex, libc)
In case of that, it's too bad to reclaim them from the beginnig.
The patch[4] causes VM to keep them on memory until last task
try to reclaim them so shared pages will be reclaimed only if
all of task has gone swapping out.

Another requirement is per address space reclaim.(By Michael Kerrisk)
In case of Webkit1, it uses a address space for handling multi tabs.
IOW, it uses *one* process model so all tabs shares address space
of the process. In such scenario, per-process reclaim is rather
coarse-grained so patch[5] supports more fine-grained reclaim
for being able to reclaim target address range of the process.
For reclaim target range, you should use following format.

	echo [addr] [size-byte] > /proc/pid/reclaim

* Changelog from v3
  * Rebased on next-20130508
  * Minor change

* Changelog from v2
  * Use memparse - Namhung Kim
  * Add Acked-by

* Changelog from v1
  * Change reclaim knob interface - Dave Hansen
  * proc.txt document change - Rob Landley

Minchan Kim (6):
  [1] mm: Per process reclaim
  [2] mm: make shrink_page_list with pages work from multiple zones
  [3] mm: Remove shrink_page
  [4] mm: Enhance per process reclaim to consider shared pages
  [5] mm: Support address range reclaim
  [6] add documentation about reclaim knob on proc.txt

 Documentation/filesystems/proc.txt |  20 +++++
 fs/proc/base.c                     |   3 +
 fs/proc/internal.h                 |   1 +
 fs/proc/task_mmu.c                 | 176 +++++++++++++++++++++++++++++++++++++
 include/linux/ksm.h                |   6 +-
 include/linux/rmap.h               |  10 ++-
 mm/Kconfig                         |  16 ++++
 mm/ksm.c                           |   9 +-
 mm/memory-failure.c                |   2 +-
 mm/migrate.c                       |   6 +-
 mm/rmap.c                          |  57 ++++++++----
 mm/vmscan.c                        |  57 +++++++++++-
 12 files changed, 336 insertions(+), 27 deletions(-)

-- 
1.8.2.1

