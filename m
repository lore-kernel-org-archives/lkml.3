Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaKCML3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:11:29 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45762 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaKCMLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:11:25 -0500
Message-ID: <545770E6.2010506@hitachi.com>
Date: Mon, 03 Nov 2014 21:11:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new options
 for cache
References: <20141031185128.27889.32747.stgit@localhost.localdomain> <20141031121301.GI1313@kernel.org>
In-Reply-To: <20141031121301.GI1313@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/10/31 21:13), Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 31, 2014 at 02:51:29PM -0400, Masami Hiramatsu escreveu:
>> Hi,
>>
>> Here is a sereis of patches for enabling "event cache" feature
>> to perf probe. Brendan gives me this cool idea, thanks! :)
>>
>> In this series, I added following options/features;
>>  - --output option
>>    We can save the probe definition command for given probe-event
>>    instead of setting up the local tracing/kprobe_events.
>>
>>  - --no-inlines option
>>    We can avoid searching the inline functions in debuginfo. Usually
>>    useful with wildcards since the wildcards will hit a huge amount
>>    of probe-points.
>>
>>  - $params special probe argument
>>    $params is expanded to function parameters only, no locally defined
>>    variables. This is useful for function-call tracing.
>>
>>  - wildcard support for function name
>>    Wildcard support is the key feature for this idea. Now we can use
>>    '*foo*' for function name to define the probe-point.
>>
>> So by using all of them, we can make an "event cache" file on all
>> functions (except for inlined functions) as below.
>>
>>   # perf probe --max-probes=100000 --no-inlines -a '* $params' -o event.cache
>>
>> builds "event.cache" file in which event settings for
>> all function entries, like below;
>>
>>   p:probe/reset_early_page_tables _text+12980741
>>   p:probe/copy_bootdata _text+12980830 real_mode_data=%di:u64
>>   p:probe/exit_amd_microcode _text+14692680
>>   p:probe/early_make_pgtable _text+12981274 address=%di:u64
>>   p:probe/x86_64_start_reservations _text+12981700 real_mode_data=%di:u64
>>   p:probe/x86_64_start_kernel _text+12981744 real_mode_data=%di:u64
>>   p:probe/reserve_ebda_region _text+12982117
>>
>> This event.cache file will be big (but much smaller than native
>> debuginfo :) ) if your kernel have many option embedded.
>> Anyway, you can compress it too.
> 
> How do you validate that the cache can be used against some kernel? I.e.
> is this that the user has to do? Isn't this prone to errors?

Actually, kprobe event itself can reject command if the given address
is not in the kernel text nor instruction boundary (perhaps, uprobes
may have a problem...), so for the kernel level, it is safe.

> 
> Perhaps you could pick the build-id and store it into the event cache
> file, in the first lines, somethings like:

Agreed, build-id should be the best way to check that.

For kprobes, user can easy to get and compare it with local one as below :)
  ----
  RLOGIN=root@$REMOTE
  rid=`ssh $RLOGIN "od -j16 -w48 -An -t x1 /sys/kernel/notes |  tr -d ' '"`
  lid=`od -j16 -w48 -An -t x1 /sys/kernel/notes | tr -d ' '`
  if [ $rid != $lid ]; then
    echo "Error: Build-id mis-matched!"
    exit 1;
  fi
  echo "Setting up $EVENTNAME at $REMOTE"
  zcat event.cache.gz | grep $EVENTNAME |\
  ssh $RLOGIN "tee -a /sys/kernel/debug/tracing/kprobe_events"
  echo "Done"
  ----

With this script, you don't need to install perf at remote hosts.
(This is what enterprise people called "agent-less")

> [acme@zoo ~]$ printf "buildid: %s\n" $(perf buildid-list --kernel) 
> buildid: a4cacca49391fc4f42ac8f58990f4e97042efae8
> 
> [acme@zoo ~]$ printf "buildid: %s\n" $(perf buildid-list --kernel) 
> buildid: a4cacca49391fc4f42ac8f58990f4e97042efae8
> 
> Maybe this would be nice to have integrated with 'perf archive' somehow
> and then store this into ~/.debug/[probe]/<BUILDID>/dso-name
> 
> where dso-name would be [kernel] for the kernel and the full path for
> userspace stuff, and then when adding a new probe we would look there
> for a pre-built/cached event definition, only looking for the debuginfo
> (which is done using the build-id already, right) and would insert the
> probe definitions there, etc.

This will be good for SDT too. Perhaps, both of SDT and cached probes
should share the same file.

> Then, later, one would use 'perf archive' passing some keys (or a
> perf.data file, like done nowadays to pick the files in ~/.debug for
> dsos that had hits on the specified perf.data file) to get the cached
> values to use on some other machine, to avoid having to use the
> debuginfo files there.

Yeah, querying it from the BUILDID database by using a pair of remote
build-id and the binary path is a good feature.

> 
> I.e. in summary I think that the format is ok, but we need to have this
> inside the ~/.debug hierarchy so that we can make sure that we use the
> right probe definition, one that matches the DSOs being used (the kernel
> or some other userspace binary).

OK, perhaps, that is also good to SDT series at last.

> 
> Great stuff, keep it up!

Thanks!

> 
> - Arnaldo
>  
>>   # wc -l event.cache
>>   33813 event.cache
>>   # ls -sh event.cache
>>   2.3M event.cache
>>   # ls -sh event.cache.gz
>>   464K event.cache.gz
>>
>> For setting up a probe event, you can grep the function name
>> and write it to tracing/kprobe_events, as below;
>>
>>   # zcat event.cache.gz | \
>>     grep probe/vfs_symlink > /sys/kernel/debug/tracing/kprobe_events
>>
>> This can be applied for the remote machine only if the machine
>> runs on completely same kernel binary. Perhaps, we need some
>> helper tool to check it.
>>
>> Thank you,
>>
>>
>> ---
>>
>> Masami Hiramatsu (6):
>>       [BUGFIX] perf-probe: Fix to handle optimized not-inlined but has no instance
>>       [DOC] perf-probe: Update perf-probe document
>>       perf-probe: Add --output option to write commands in a standard file
>>       perf-probe: Add --no-inlines option to avoid searching inline functions
>>       perf-probe: Support $params special probe argument
>>       perf-probe: Support glob wildcards for function name
>>
>>
>>  tools/perf/Documentation/perf-probe.txt |   25 ++++++++++
>>  tools/perf/builtin-probe.c              |   32 +++++++++++++
>>  tools/perf/util/dwarf-aux.c             |   31 +++++++++++++
>>  tools/perf/util/dwarf-aux.h             |    6 +++
>>  tools/perf/util/probe-event.c           |   73 +++++++++++++++++++++++--------
>>  tools/perf/util/probe-event.h           |    4 +-
>>  tools/perf/util/probe-finder.c          |   74 +++++++++++++++++++------------
>>  tools/perf/util/probe-finder.h          |    6 ++-
>>  tools/perf/util/util.h                  |    4 ++
>>  9 files changed, 202 insertions(+), 53 deletions(-)
>>
>> --
>> Masami HIRAMATSU
>> Software Platform Research Dpt. Linux Technology Center
>> Hitachi, Ltd., Yokohama Research Laboratory
>> E-mail: masami.hiramatsu.pt@hitachi.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


