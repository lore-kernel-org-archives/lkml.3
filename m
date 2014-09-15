Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbaIPAVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:21:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:10904 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758189AbaIPAT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:19:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,531,1406617200"; 
   d="scan'208";a="600070661"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com
Subject: Implement lbr-as-callgraph v9
Date: Mon, 15 Sep 2014 16:54:25 -0700
Message-Id: <1410825273-7054-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/lbr-callgraph4

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


