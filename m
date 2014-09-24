Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbaIXCYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 22:24:36 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56894 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346AbaIXCY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 22:24:26 -0400
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arun Sharma <asharma@fb.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH 2/2] perf callchain: Use global caching provided by libunwind
References: <1411453828-14832-1-git-send-email-namhyung@kernel.org>
	<1411453828-14832-2-git-send-email-namhyung@kernel.org>
	<54217D09.40500@fb.com>
Date: Wed, 24 Sep 2014 11:24:24 +0900
In-Reply-To: <54217D09.40500@fb.com> (Arun Sharma's message of "Tue, 23 Sep
	2014 14:01:22 +0000")
Message-ID: <874mvxlprb.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arun,

On Tue, 23 Sep 2014 14:01:22 +0000, Arun Sharma wrote:
> On 9/23/14, 12:00 PM, Namhyung Kim wrote:
>
>> +	unw_set_caching_policy(addr_space, UNW_CACHE_GLOBAL);
>
> The result is a bit surprising for me. In micro benchmarking (eg:
> Lperf-simple), the per-thread policy is generally faster because it
> doesn't involve locking.
>
> libunwind/tests/Lperf-simple
> unw_getcontext : cold avg=  109.673 nsec, warm avg=   28.610 nsec
> unw_init_local : cold avg=  259.876 nsec, warm avg=    9.537 nsec
> no cache        : unw_step : 1st= 3258.387 min= 2922.331 avg= 3002.384 nsec
> global cache    : unw_step : 1st= 1192.093 min=  960.486 avg=  982.208 nsec
> per-thread cache: unw_step : 1st=  429.153 min=  113.533 avg=  121.762 nsec

Yes, per-thread policy is faster than global caching policy.  Below is my
test result.  Note that I already run this several times before to
remove an effect that file contents loaded in page cache.

 Performance counter stats for
   'perf report -i /home/namhyung/tmp/perf-testing/perf.data.kbuild.dwarf --stdio' (3 runs):

                                 UNW_CACHE_NONE         UNW_CACHE_GLOBAL     UNW_CACHE_PER_THREAD
  -----------------------------------------------------------------------------------------------
  task-clock (msec)                14298.911947              7112.171928              6913.244797      
  context-switches                        1,507                      762                      742      
  cpu-migrations                              1                        2                        1      
  page-faults                         2,924,889                1,101,380                1,101,380      
  cycles                         53,895,784,665           26,798,627,423           26,070,728,349      
  stalled-cycles-frontend        24,472,506,687           12,577,760,746           12,435,320,081      
  stalled-cycles-backend         17,550,483,726            9,075,054,009            9,035,478,957      
  instructions                   73,544,039,490           34,352,889,707           33,283,120,736      
  branches                       14,969,890,371            7,139,469,848            6,926,994,151      
  branch-misses                     193,852,116              100,455,431               99,757,213      
  time elapsed                     14.905719730              7.455597356              7.242275972      


>
> I can see how the global policy would involve less memory allocation
> because of shared data structures. Curious about the reason for the
> speedup (specifically if libunwind should change the defaults for the
> non-local unwinding case).

I don't see much difference between global and per-thread caching for
remote unwind (besides rs_cache->lock you mentioned).  Also I'm curious
that how rs_new() is protected from concurrent accesses in per-thread
caching.  That's why I chose the global caching - yeah, it probably
doesn't matter to a single thread, but... :)

Thanks
Namhyung
