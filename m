Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaIXPp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:45:58 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:48450 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaIXPp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:45:57 -0400
From: Waiman Long <Waiman.Long@hp.com>
To: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Scott J Norton <scott.norton@hp.com>,
        Douglas Hatch <doug.hatch@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Waiman Long <Waiman.Long@hp.com>
Subject: [PATCH v4 0/2] perf tool: improves DSO long names search speed with rbtree
Date: Wed, 24 Sep 2014 11:45:38 -0400
Message-Id: <1411573540-8765-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

 tools/perf/util/dso.c         |   90 ++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/dso.h         |   10 +++-
 tools/perf/util/header.c      |   32 ++++++++------
 tools/perf/util/machine.c     |   24 +++++-----
 tools/perf/util/machine.h     |   13 +++++-
 tools/perf/util/probe-event.c |    3 +-
 tools/perf/util/symbol-elf.c  |    2 +-
 7 files changed, 130 insertions(+), 44 deletions(-)

