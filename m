Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaF0XQI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:16:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:50683 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbaF0XQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:16:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="535317070"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org
Subject: perf: Add support for full Intel event lists v7
Date: Fri, 27 Jun 2014 16:15:55 -0700
Message-Id: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should be ready for merge now. Please consider.

[v2: Review feedback addressed and some minor improvements]
[v3: More review feedback addressed and handle test failures better.
Ported to latest tip/core.]
[v4: Addressed Namhyung's feedback]
[v5: Rebase to latest tree. Minor description update.]
[v6: Rebase. Add acked by from Namhyung and address feedback. Some minor
fixes. Should be good to go now I hope. The period patch was dropped,
as that is already handled. I added an extra patch for a --quiet argument
for perf list]
[v7: Just rebase to latest tip/core. Should be ready to merge.]

perf has high level events which are useful in many cases. However
there are some tuning situations where low level events in the CPU
are needed. Traditionally this required specifying the event in 
raw form (very awkward) or using non standard frontends
like ocperf or patching in libpfm.

Intel CPUs can have very large event files (Haswell has ~336 core events,
much more if you add uncore or all the offcore combinations), which is too
large to describe through the kernel interface. It would require tying up
significant amounts of unswappable memory for this.

oprofile always had separate event list files that were maintained by 
the CPU vendors. The oprofile events were shipped with the tool.
The Intel events get updated regularly, for example to add references
to the specification updates or add new events.

Unfortunately oprofile usually did not keep up with these updates,
so the events in oprofile were often out of date. In addition
it ties up quite a bit of disk space, mostly for CPUs you don't have.

This patch kit implements another mechanism that avoids these problems.
Intel releases the event lists for CPUs in a standardized JSON format
on a download server.

I implemented an automatic downloader to get the event file for the
current CPU.  The events are stored in ~/.cache/pmu-events.
Then perf adds a parser that converts the JSON format into perf event
aliases, which then can be used directly as any other perf event.

The parsing is done using a simple existing JSON library.

The events are still abstracted for perf, but the abstraction mechanism is
through the downloaded file instead of through the kernel.

The JSON format and perf parser has some minor Intelisms, but they
are simple and small and optional. It's easy to extend, so it would be
possible to use it for other CPUs too, add different pmu attributes, and
add new download sites to the downloader tool.

Currently only core events are supported, uncore may come at a later
point. No kernel changes, all code in perf user tools only.

Some of the parser files are partially shared with separate event parser
library and are thus 2-clause BSD licensed.

Patches also available from
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/json

Example output:

% perf download 
Downloading models file
Downloading readme.txt
2014-03-05 10:39:33 URL:https://download.01.org/perfmon/readme.txt [10320/10320] -> "readme.txt" [1]
2014-03-05 10:39:34 URL:https://download.01.org/perfmon/mapfile.csv [1207/1207] -> "mapfile.csv" [1]
Downloading events file
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
