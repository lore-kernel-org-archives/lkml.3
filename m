Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbaG3XYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:24:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:17047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbaG3XW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,768,1400050800"; 
   d="scan'208";a="581452059"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        mingo@kernel.org, peterz@infradead.org
Subject: perf: Add support for full Intel event lists v8
Date: Wed, 30 Jul 2014 16:22:40 -0700
Message-Id: <1406762570-16694-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it seems the download mechanism is controversal, 
I removed the downloader for now until a suitable distribution
method with kernel.org can be established. This is just
the rest of the perf JSON event code that should hopefully
not be controversal.

[v2: Review feedback addressed and some minor improvements]
[v3: More review feedback addressed and handle test failures better.
Ported to latest tip/core.]
[v4: Addressed Namhyung's feedback]
[v5: Rebase to latest tree. Minor description update.]
[v6: Rebase. Add acked by from Namhyung and address feedback. Some minor
fixes. Should be good to go now I hope. The period patch was dropped,
as that is already handled. I added an extra patch for a --quiet argument
for perf list]
[v7: Address Jiri's feedback. Various changes and some patches
were split. perf download uses curl now instead of wget.]
[v8: Removed perf download for now. Port to latest tip/perf/core]

perf has high level events which are useful in many cases. However
there are some tuning situations where low level events in the CPU
are needed. Traditionally this required specifying the event in 
raw form (very awkward) or using non standard frontends
like ocperf or patching in libpfm.

Intel CPUs can have very large event files (Haswell has ~336 core events,
much more if you add uncore or all the offcore combinations), which is too
large to describe through the kernel interface. It would require tying up
significant amounts of unswappable memory for this.

Intel releases these JSON files in a standardized JSON format.
perf adds a parser that converts the JSON format into perf event
aliases, which then can be used directly as any other perf event.

The parsing is done using a simple existing JSON library.

The events are still abstracted for perf, but the abstraction mechanism is
through the file instead of through the kernel.

The JSON format and perf parser has some minor Intelisms, but they
are simple and small and optional. It's easy to extend, so it would be
possible to use it for other CPUs too, add different pmu attributes, and
add new download sites to the downloader tool. For example the format
can be used on POWER.

Currently only core events are supported, uncore may come at a later
point. No kernel changes, all code in perf user tools only.

Some of the parser files are partially shared with separate event parser
library and are thus 2-clause BSD licensed.

Patches also available from
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/json

Example output:

<Put JSON file for CPU in .cache/pmu-events/Vendor-Family-Model-core.json,
for example GenuineIntel-6-3E-core.json>
% perf list
...
  br_inst_exec.all_branches                          [Speculative and retired
                                                      branches]
  br_inst_exec.all_conditional                       [Speculative and retired
                                                      macro-conditional
                                                      branches]
  br_inst_exec.all_direct_jmp                        [Speculative and retired
                                                      macro-unconditional
                                                      branches excluding
                                                      calls and indirects]
... 333 more new events ...

% perf stat -e br_inst_exec.all_direct_jmp true

 Performance counter stats for 'true':

             6,817      cpu/br_inst_exec.all_direct_jmp/                                   

       0.003503212 seconds time elapsed

One nice feature is that a pointer to the specification update is now
included in the description, which will hopefully clear up many problems:

% perf list
...
  mem_load_uops_l3_hit_retired.xsnp_hit              [Retired load uops which
                                                      data sources were L3
                                                      and cross-core snoop
                                                      hits in on-pkg core
                                                      cache. Supports address
                                                      when precise. Spec
                                                      update: HSM26, HSM30
                                                      (Precise event)]
...


-Andi
