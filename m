Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3EHPoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:44:46 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:42408 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3EHPop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:44:45 -0400
Message-ID: <518A72E3.6070606@hp.com>
Date: Wed, 08 May 2013 11:44:35 -0400
From: Waiman Long <Waiman.Long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120601 Thunderbird/10.0.5
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH] perf: fix symbol processing bug and greatly improve performance
References: <1367847833-4932-1-git-send-email-Waiman.Long@hp.com> <20130507093031.GA1076@krava.brq.redhat.com>
In-Reply-To: <20130507093031.GA1076@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 05:30 AM, Jiri Olsa wrote:
> On Mon, May 06, 2013 at 09:43:53AM -0400, Waiman Long wrote:
>> When "perf record" was used on a large machine with a lot of CPUs,
>> the perf post-processing time could take a lot of minutes and even
>> hours depending on how large the resulting perf.data file was.
>>
>> While running AIM7 1500-user high_systime workload on a 80-core x86-64
>> system with a 3.9 kernel, the workload itself took about 2 minutes
>> to run and the perf.data file had a size of 1108.746 MB. However,
>> the post-processing step took more than 10 minutes.
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
> hi,
> the issue is there and fix looks ok, thanks!
>
> though I'm not able to get vdso callchains to pop out
> even by investigating report with vdso heavy workload.
>
> I'll have a closer look..

Is there a chance that the fix will go to v3.10 or have to wait for v3.11?

Regards,
Longman
