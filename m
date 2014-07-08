Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaGHSoG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:44:06 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55098 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbaGHSoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:44:03 -0400
Date: Tue, 8 Jul 2014 11:43:11 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        acme@infradead.org
Subject: Re: perf: Add support for full Intel event lists v7
Message-ID: <20140708184311.GA14707@us.ibm.com>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070818-9332-0000-0000-000001509C7B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen [andi@firstfloor.org] wrote:
| Should be ready for merge now. Please consider.

Overall I think it is a cool feature.  I was able to run some simple
tests on Power8 (by explicitly specifying the JSON file). Have a couple
of questions below.

| 
| [v2: Review feedback addressed and some minor improvements]
| [v3: More review feedback addressed and handle test failures better.
| Ported to latest tip/core.]
| [v4: Addressed Namhyung's feedback]
| [v5: Rebase to latest tree. Minor description update.]
| [v6: Rebase. Add acked by from Namhyung and address feedback. Some minor
| fixes. Should be good to go now I hope. The period patch was dropped,
| as that is already handled. I added an extra patch for a --quiet argument
| for perf list]
| [v7: Just rebase to latest tip/core. Should be ready to merge.]
| 
| perf has high level events which are useful in many cases. However
| there are some tuning situations where low level events in the CPU
| are needed. Traditionally this required specifying the event in 
| raw form (very awkward) or using non standard frontends
| like ocperf or patching in libpfm.
| 
| Intel CPUs can have very large event files (Haswell has ~336 core events,
| much more if you add uncore or all the offcore combinations), which is too
| large to describe through the kernel interface. It would require tying up
| significant amounts of unswappable memory for this.
| 
| oprofile always had separate event list files that were maintained by 
| the CPU vendors. The oprofile events were shipped with the tool.
| The Intel events get updated regularly, for example to add references
| to the specification updates or add new events.
| 
| Unfortunately oprofile usually did not keep up with these updates,
| so the events in oprofile were often out of date. In addition
| it ties up quite a bit of disk space, mostly for CPUs you don't have.
| 
| This patch kit implements another mechanism that avoids these problems.
| Intel releases the event lists for CPUs in a standardized JSON format
| on a download server.
| 
| I implemented an automatic downloader to get the event file for the
| current CPU.  The events are stored in ~/.cache/pmu-events.
| Then perf adds a parser that converts the JSON format into perf event
| aliases, which then can be used directly as any other perf event.
| 
| The parsing is done using a simple existing JSON library.
| 
| The events are still abstracted for perf, but the abstraction mechanism is
| through the downloaded file instead of through the kernel.
| 
| The JSON format and perf parser has some minor Intelisms, but they
| are simple and small and optional. It's easy to extend, so it would be
| possible to use it for other CPUs too, add different pmu attributes, and
| add new download sites to the downloader tool.

Is there a minimal set of JSON entries an architecture would need ?

I tried the following on Power
	[
	  {
	    "EventCode": "2",
	    "EventName": "PM_INST_CMPL",
	    "BriefDescription": "Instructions completed",
	    "PublicDescription": "Number of PPC instructions finished",
	  },
	  {
	    "EventCode": "0x1E",
	    "EventName": "PM_CYC",
	    "BriefDescription": "Cycles completed",
	    "PublicDescription": "Number of PPC cycles finished",
	  }
	]

	/tmp/perf record --events-file=/tmp/power8.json -e PM_INST_CMPL sleep 1

works, but for some TBD reason,

	/tmp/perf list --events-file=/tmp/power8.json doesn't list PM_INST_CMPL.

Another observation was that the order of --events-file and -e is significant.
Maybe worth a note in the man page.

| 
| Currently only core events are supported, uncore may come at a later
| point. No kernel changes, all code in perf user tools only.
| 
| Some of the parser files are partially shared with separate event parser
| library and are thus 2-clause BSD licensed.
| 
| Patches also available from
| git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/json
| 
| Example output:
| 
| % perf download 
| Downloading models file
| Downloading readme.txt
| 2014-03-05 10:39:33 URL:https://download.01.org/perfmon/readme.txt [10320/10320] -> "readme.txt" [1]
| 2014-03-05 10:39:34 URL:https://download.01.org/perfmon/mapfile.csv [1207/1207] -> "mapfile.csv" [1]
| Downloading events file
| % perf list
| ...
|   br_inst_exec.all_branches                          [Speculative and retired
|                                                       branches]
|   br_inst_exec.all_conditional                       [Speculative and retired
|                                                       macro-conditional
|                                                       branches]
|   br_inst_exec.all_direct_jmp                        [Speculative and retired
|                                                       macro-unconditional
|                                                       branches excluding
|                                                       calls and indirects]
| ... 333 more new events ...
| 
| % perf stat -e br_inst_exec.all_direct_jmp true

Can you specify the qualifiers like ':k' or ':ku' with the events on Intel ?
to only monitor kernel or user ? Or do they need some additional JSON entries ?

With the above events file, I get "invalid event" for 'PM_INST_CMPL:u'

| 
|  Performance counter stats for 'true':
| 
|              6,817      cpu/br_inst_exec.all_direct_jmp/                                   
| 
|        0.003503212 seconds time elapsed
| 
| One nice feature is that a pointer to the specification update is now
| included in the description, which will hopefully clear up many problems:
| 
| % perf list
| ...
|   mem_load_uops_l3_hit_retired.xsnp_hit              [Retired load uops which
|                                                       data sources were L3
|                                                       and cross-core snoop
|                                                       hits in on-pkg core
|                                                       cache. Supports address
|                                                       when precise. Spec
|                                                       update: HSM26, HSM30
|                                                       (Precise event)]
| ...
| 
| 
| -Andi
| --
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/

