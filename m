Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaI2UHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:07:39 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:26735 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaI2UHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:07:38 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v5 0/2] perf tool: improves DSO long names search speed with rbtree
Date: Mon, 29 Sep 2014 16:07:27 -0400
Message-Id: <1412021249-19201-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4->v5:
  - Remove the unneeded dsos field from the DSO structure.
  - Add check in dso__delete() to make sure that the DSO isn't in
    a rbtree.
  - Revise the dso__findlink_by_longname() function to get rid of
    pointer arithmetic.

v3->v4:
  - As suggested by Arnaldo, keep the DSO linked list for iteration
    purpose and create a new dsos structure to host the dual list
    head and rbtree root for DSOs inside the machine structure.

v2->v3:
  - Move the rbtree linking operation from dso__set_long_name() to
    dsos__add(), where the list_add() operation was done.
  - Add a second patch to remove the linked list and iterates the
    DSO structures by going through them in the rbtree. This requires
    changes in quite a number of files, but it makes for neater code.
  - Rebased to the 3.17-rc5 kernel.

v1->v2:
 - Rename DSO longname RBtree find function to segregate its two
   different uses of searching and linking DSO into RB tree.

This patch set adds a rbtree for linking the DSO structures of the
perf tool sorted by their long names in additional to the linked list
which is of no specific order. The list enables fast iterations of
the DSOs and the rbtree root allows fast lookup by long name. The
latter use can significantly speed up DSO processing when a large
number of DSOs are beining profiled.

Waiman Long (2):
  perf tool: encapsulate dsos list head into struct dsos
  perf tool: improves DSO long names lookup speed with rbtree

 tools/perf/util/dso.c         |   87 +++++++++++++++++++++++++++++++++++-----
 tools/perf/util/dso.h         |    9 +++-
 tools/perf/util/header.c      |   32 ++++++++-------
 tools/perf/util/machine.c     |   25 ++++++------
 tools/perf/util/machine.h     |   13 +++++-
 tools/perf/util/probe-event.c |    3 +-
 tools/perf/util/symbol-elf.c  |    7 +++-
 7 files changed, 132 insertions(+), 44 deletions(-)

