Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaA0GWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 01:22:46 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:59215 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaA0GWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 01:22:45 -0500
X-AuditID: 9c93017d-b7b51ae000000e33-1d-52e5fb33688c
From: Namhyung Kim <namhyung@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Arun Sharma <asharma@fb.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHSET 00/24] perf tools: Add support to accumulate hist periods (v7)
References: <1390436045-16830-1-git-send-email-namhyung@kernel.org>
	<20140123162248.GF1180@krava.brq.redhat.com>
Date: Mon, 27 Jan 2014 15:22:43 +0900
In-Reply-To: <20140123162248.GF1180@krava.brq.redhat.com> (Jiri Olsa's message
	of "Thu, 23 Jan 2014 17:22:48 +0100")
Message-ID: <87k3dm54gc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 17:22:48 +0100, Jiri Olsa wrote:
> On Thu, Jan 23, 2014 at 09:13:44AM +0900, Namhyung Kim wrote:
>> 
>>   $ perf report --no-call-graph --children --stdio
>> 
>>   #     Self  Children  Command      Shared Object                 Symbol
>>   # ........  ........  .......  .................  .....................
>>   #
>>        0.00%    91.50%      abc  libc-2.17.so       [.] __libc_start_main
>>        0.00%    91.50%      abc  abc                [.] main             
>>        0.00%    91.50%      abc  abc                [.] c                
>>        0.00%    91.50%      abc  abc                [.] b                
>>       91.50%    91.50%      abc  abc                [.] a                
>>        0.00%     8.18%      abc  ld-2.17.so         [.] _dl_sysdep_start 
>>        8.18%     8.18%      abc  ld-2.17.so         [.] strlen           
>>        0.01%     0.33%      abc  ld-2.17.so         [.] _start           
>>        0.31%     0.31%      abc  [kernel.kallsyms]  [k] page_fault       
>
> I couldnt get this one working:
>
> [jolsa@krava perf]$ ./perf report --no-call-graph --children --stdio
>
> #
> #     Self  Children  Command  Shared Object                      Symbol
> # ........  ........  .......  .............  ..........................
> #
>     94.47%    94.47%      abc  abc            [.] a                     
>      4.74%     4.74%      abc  ld-2.17.so     [.] _dl_map_object_from_fd
>      0.75%     0.75%      abc  ld-2.17.so     [.] _dl_start             
>      0.04%     0.04%      abc  ld-2.17.so     [.] _start                
>
> I was looking for cumulated stdio output without callchain unwinded,
> TUI shows it properly as default

Oops, I missed a change below, sorry.


diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index ac658135079f..c1d4ccd755ed 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -538,7 +538,8 @@ int sample__resolve_callchain(struct perf_sample *sample, struct symbol **parent
 	if (sample->callchain == NULL)
 		return 0;
 
-	if (symbol_conf.use_callchain || sort__has_parent) {
+	if (symbol_conf.use_callchain || symbol_conf.cumulate_callchain ||
+	    sort__has_parent) {
 		return machine__resolve_callchain(al->machine, evsel, al->thread,
 						  sample, parent, al, max_stack);
 	}
-- 
1.7.11.7

