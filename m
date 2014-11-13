Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbaKMCGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:06:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:47316 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbaKMCFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:05:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,372,1413270000"; 
   d="scan'208";a="631134604"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org
Subject: Implement lbr-as-callgraph v10
Date: Wed, 12 Nov 2014 18:05:18 -0800
Message-Id: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Reworks to address all the review feedback. Rebased to latest tree]
[Just a repost after a rebase]
[Even more review feedback and some bugs addressed.]
[Only port to changes in perf/core. No other changes.]
[Rebase to latest perf/core]
[Another rebase. No changes]

This patchkit implements lbr-as-callgraphs in per freport,
as an alternative way to present LBR information.

Current perf report does a histogram over the branch edges,
which is useful to look at basic blocks, but doesn't tell
you anything about the larger control flow behaviour.

This patchkit adds a new option --branch-history that
adds the branch paths to the callgraph history instead.

This allows to reason about individual branch paths leading
to specific samples.

Also available at
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/lbr-callgraph8

v2:
- rebased on perf/core
- fix various issues
- rename the option to --branch-history
- various fixes to display the information more concise
v3:
- White space changes
- Consolidate some patches
- Update some descriptions
v4:
- Fix various display problems
- Unknown srcline is now printed as symbol+offset
- Refactor some code to address review feedback
- Merge with latest tip
- Fix missing srcline display in stdio hist output.
v5:
- Rename functions
- Fix gtk build problem
- Fix crash without -g
- Improve error messages
- Improve srcline display in various ways
v6:
- Port to latest perf/core
v7:
- Really port to latest perf/core
v8:
- Rebased on 3.16-rc1
v9:
- Rebase on 3.17-rc* tip/perf/core
v10:
- Rebase to latest tree.
- Address review feedback (except where commented). See
the individual patches for changelog. I dropped the -v 
option support.

Example output:

    % perf record -b -g ./tsrc/tcall
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.044 MB perf.data (~1923 samples) ]
    % perf report --branch-history
    ...
        54.91%  tcall.c:6  [.] f2                      tcall
                |
                |--65.53%-- f2 tcall.c:5
                |          |
                |          |--70.83%-- f1 tcall.c:11
                |          |          f1 tcall.c:10
                |          |          main tcall.c:18
                |          |          main tcall.c:18
                |          |          main tcall.c:17
                |          |          main tcall.c:17
                |          |          f1 tcall.c:13
                |          |          f1 tcall.c:13
                |          |          f2 tcall.c:7
                |          |          f2 tcall.c:5
                |          |          f1 tcall.c:12
                |          |          f1 tcall.c:12
                |          |          f2 tcall.c:7
                |          |          f2 tcall.c:5
                |          |          f1 tcall.c:11


