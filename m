Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaJNSEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 14:04:00 -0400
Received: from mail.kernel.org ([198.145.19.201]:39131 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbaJNSD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 14:03:58 -0400
Date: Tue, 14 Oct 2014 15:03:53 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Don Zickus <dzickus@redhat.com>, Douglas Hatch <doug.hatch@hp.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 6/8] perf symbols: Improve DSO long names lookup speed
 with rbtree
Message-ID: <20141014180353.GF3198@kernel.org>
References: <1412193043-15493-1-git-send-email-acme@kernel.org>
 <1412193043-15493-7-git-send-email-acme@kernel.org>
 <20141014090958.GC5459@krava.redhat.com>
 <20141014173403.GE3198@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141014173403.GE3198@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 14, 2014 at 02:34:03PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Tue, Oct 14, 2014 at 11:09:58AM +0200, Jiri Olsa escreveu:
> > On Wed, Oct 01, 2014 at 04:50:41PM -0300, Arnaldo Carvalho de Melo wrote:
> > > From: Waiman Long <Waiman.Long@hp.com>

> > > With workload that spawns and destroys many threads and processes, it
> > > was found that perf-mem could took a long time to post-process the perf
> > > data after the target workload had completed its operation.

> > > The performance bottleneck was found to be the lookup and insertion of
> > > the new DSO structures (thousands of them in this case).

> > this change segfaults (below) some tests, but only if I compiled
> > without DEBUG when I revert this commit, I can no longer reproduce..
 
> Reproduced, looking at it... 

Fixed, this happens because we end up using a struct machines on the
stack, and then machines__init() was not initializing the newly
introduced rb_root, just the existing list_head.

When we introduced struct dsos, to group the two ways to store dsos,
i.e. the linked list and the rbtree, we didn't turned the initialization
done in machines__init(machines->host) -> machine__init() ->
INIT_LIST_HEAD into a dsos__init() to keep on initializing the list_head
but _as well_ initializing the rb_root, oops. All worked because outside
perf-test we probably zalloc the whole thing which ends up initializing
it in to NULL.

So the problem looks contained to 'perf test' that uses it on stack,
etc.

Will add your Reported-by, but if you're quick, I can give you a
Tested-by too ;-)

- Arnaldo

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index b7d477fbda02..34fc7c8672e4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -13,12 +13,18 @@
 #include <symbol/kallsyms.h>
 #include "unwind.h"
 
+static void dsos__init(struct dsos *dsos)
+{
+	INIT_LIST_HEAD(&dsos->head);
+	dsos->root = RB_ROOT;
+}
+
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 {
 	map_groups__init(&machine->kmaps);
 	RB_CLEAR_NODE(&machine->rb_node);
-	INIT_LIST_HEAD(&machine->user_dsos.head);
-	INIT_LIST_HEAD(&machine->kernel_dsos.head);
+	dsos__init(&machine->user_dsos);
+	dsos__init(&machine->kernel_dsos);
 
 	machine->threads = RB_ROOT;
 	INIT_LIST_HEAD(&machine->dead_threads);
