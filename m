Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3GERJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:09:30 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:27952 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab3GERJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:09:29 -0400
Message-ID: <51D6FDBD.6010606@hp.com>
Date: Fri, 05 Jul 2013 13:09:17 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v2] perf record: fix symbol processing bug and greatly
 improve performance
References: <1368110568-64714-1-git-send-email-Waiman.Long@hp.com> <20130510081214.GA6848@gmail.com>
In-Reply-To: <20130510081214.GA6848@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 04:12 AM, Ingo Molnar wrote:
> * Waiman Long<Waiman.Long@hp.com>  wrote:
>
>> When "perf record" was used on a large machine with a lot of CPUs,
>> the perf post-processing time (the time after the workload was done
>> until the perf command itself exited) could take a lot of minutes
>> and even hours depending on how large the resulting perf.data file was.
>>
>> While running AIM7 1500-user high_systime workload on a 80-core
>> x86-64 system with a 3.9 kernel (with only the -s -a options used),
>> the workload itself took about 2 minutes to run and the perf.data
>> file had a size of 1108.746 MB. However, the post-processing step
>> took more than 10 minutes.
>>
>> With a gprof-profiled perf binary, the time spent by perf was as
>> follows:
>>
>>    %   cumulative   self              self     total
>>   time   seconds   seconds    calls   s/call   s/call  name
>>   96.90    822.10   822.10   192156     0.00     0.00  dsos__find
>>    0.81    828.96     6.86 172089958     0.00     0.00  rb_next
>>    0.41    832.44     3.48 48539289     0.00     0.00  rb_erase
>>
>> So 97% (822 seconds) of the time was spent in a single dsos_find()
>> function. After analyzing the call-graph data below:
>>
>> -----------------------------------------------
>>                  0.00  822.12  192156/192156      map__new [6]
>> [7]     96.9    0.00  822.12  192156         vdso__dso_findnew [7]
>>                822.10    0.00  192156/192156      dsos__find [8]
>>                  0.01    0.00  192156/192156      dsos__add [62]
>>                  0.01    0.00  192156/192366      dso__new [61]
>>                  0.00    0.00       1/45282525     memdup [31]
>>                  0.00    0.00  192156/192230      dso__set_long_name [91]
>> -----------------------------------------------
>>                822.10    0.00  192156/192156      vdso__dso_findnew [7]
>> [8]     96.9  822.10    0.00  192156         dsos__find [8]
>> -----------------------------------------------
>>
>> It was found that the vdso__dso_findnew() function failed to locate
>> VDSO__MAP_NAME ("[vdso]") in the dso list and have to insert a new
>> entry at the end for 192156 times. This problem is due to the fact that
>> there are 2 types of name in the dso entry - short name and long name.
>> The initial dso__new() adds "[vdso]" to both the short and long names.
>> After that, vdso__dso_findnew() modifies the long name to something
>> like /tmp/perf-vdso.so-NoXkDj. The dsos__find() function only compares
>> the long name. As a result, the same vdso entry is duplicated many
>> time in the dso list. This bug increases memory consumption as well
>> as slows the symbol processing time to a crawl.
>>
>> To resolve this problem, the dsos__find() function interface was
>> modified to enable searching either the long name or the short
>> name. The vdso__dso_findnew() will now search only the short name
>> while the other call sites search for the long name as before.
>>
>> With this change, the cpu time of perf was reduced from 848.38s to
>> 15.77s and dsos__find() only accounted for 0.06% of the total time.
>>
>>    0.06     15.73     0.01   192151     0.00     0.00  dsos__find
>>
>> Signed-off-by: Waiman Long<Waiman.Long@hp.com>
>> ---
>>   tools/perf/util/dso.c  |   10 ++++++++--
>>   tools/perf/util/dso.h  |    3 ++-
>>   tools/perf/util/vdso.c |    2 +-
>>   3 files changed, 11 insertions(+), 4 deletions(-)
> Acked-by: Ingo Molnar<mingo@kernel.org>
>
> Thanks,
>
> 	Ingo

Thank for the Ack. Will that patch go into v3.11?

Regards,
Longman
