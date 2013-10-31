Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3JaIJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 04:09:40 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:59439 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab3JaIJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 04:09:35 -0400
Date: Thu, 31 Oct 2013 09:09:32 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131031080932.GA8479@gmail.com>
References: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383202576-28141-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* Namhyung Kim <namhyung@kernel.org> wrote:

> When the -g cumulative option is given, it'll be shown like this:
> 
>   $ perf report -g cumulative --stdio
> 
>   # Overhead  Overhead (Acc)  Command      Shared Object                   Symbol
>   # ........  ..............  .......  .................  .......................
>   #
>        0.00%          88.29%      abc  libc-2.17.so       [.] __libc_start_main  
>        0.00%          88.29%      abc  abc                [.] main               
>        0.00%          88.29%      abc  abc                [.] c                  
>        0.00%          88.29%      abc  abc                [.] b                  
>       88.29%          88.29%      abc  abc                [.] a                  
>        0.00%          11.61%      abc  ld-2.17.so         [k] _dl_sysdep_start   
>        0.00%           9.43%      abc  ld-2.17.so         [.] dl_main            
>        9.43%           9.43%      abc  ld-2.17.so         [.] _dl_relocate_object
>        2.27%           2.27%      abc  [kernel.kallsyms]  [k] page_fault         
>        0.00%           2.18%      abc  ld-2.17.so         [k] _dl_start_user     
>        0.00%           0.10%      abc  ld-2.17.so         [.] _start             
> 
> As you can see __libc_start_main -> main -> c -> b -> a callchain 
> show up in the output.

This looks really useful!

A couple of details:

1)

This is pretty close to SysProf output, right? So why not use the 
well-known SysProf naming and call the first column 'self' and the 
second column 'total'? I think those names are pretty intuitive and 
it would help people who come from SysProf over to perf.

2)

Is it possible to configure the default 'report -g' style, so that 
people who'd like to use it all the time don't have to type '-g 
cumulative' all the time?

3)

I'd even argue that we enable this reporting feature by default, if 
a data file includes call-chain data: the first column will still 
show the well-known percentage that perf report produces today, the 
second column will be a new feature in essence.

The only open question would be, by which column should we sort: 
'sysprof style' sorts by 'total', 'perf style' sorts by 'self'. 
Agreed?

4)

This is not directly related to the new feature you added: 
call-graph profiling still takes quite a bit of time. It might make 
sense to save the ordered histogram to a perf.data.ordered file, so 
that repeat invocations of 'perf report' don't have to recalculate 
everything again and again?

This file would be maintained transparently and would only be 
re-created when the perf.data file changes, or something like that.

5)

I realize that this is an early RFC, still there are some usability 
complaints I have about call-graph recording/reporting which should 
be addressed before adding new features.

For example I tried to get a list of the -g output modi via:

   $ perf report -g help

Which produced a lot of options - I think it should produce only a 
list of -g options. It also doesn't list cumulative:

    -g, --call-graph <output_type,min_percent[,print_limit],call_order>
                          Display callchains using output_type 
(graph, flat, fractal, or none) , min percent threshold, optional 
print limit, callchain order, key (function or address). Default: 
fractal,0.5,callee,function

Also, the list is very long and not very readable - I think there 
should be more newlines.

Then I tried to do:

   $ perf report -g

which, somewhat surprisingly, was accepted. Given that call-graph 
perf.data is recognized automatically by 'perf report', the -g 
option should only accept -g <type> syntax and provide a list of 
options when '-g' or '-g help' is provided.

6)

A similar UI problem exists on the 'perf record' side: 'perf record 
--call-graph help' should produce a specific list of call-graph 
possibilities, not the two screens full output it does today.

> I know it have some rough edges or even bugs, but I really want to 
> release it and get reviews.  It does not handle event groups and 
> annotations and it has a bug on TUI.
> 
> You can also get this series on 'perf/cumulate-v2' branch in my tree at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git

So I tried it out on top of tip:master, with your testcase, and in 
the --stdio case it works very well:

# Overhead  Overhead (Acc)  Command      Shared Object                                      Symbol
# ........  ..............  .......  .................  ..........................................
#
     0.00%         100.00%      abc  abc                [.] _start                                
     0.00%         100.00%      abc  libc-2.17.so       [.] __libc_start_main                     
     0.00%         100.00%      abc  abc                [.] main                                  
     0.00%         100.00%      abc  abc                [.] c                                     
     0.00%         100.00%      abc  abc                [.] b                                     
    99.79%         100.00%      abc  abc                [.] a                                     
     0.01%           0.21%      abc  [kernel.kallsyms]  [k] apic_timer_interrupt     

In the TUI output the 'c' entry is not visible:

   99.79%  100.00%  abc  abc                [.] a                                                               
    0.00%   99.79%  abc  abc                [.] b                                                               
    0.01%    0.21%  abc  [kernel.kallsyms]  [k] apic_timer_interrupt                                            
    0.00%    0.19%  abc  [kernel.kallsyms]  [k] smp_apic_timer_interrupt                 

I suspect this is the 'TUI bug' you mentioned?

> Any comments are welcome, thanks.

Cool stuff, let's fix & merge it ASAP! :-)

Thanks,

	Ingo
