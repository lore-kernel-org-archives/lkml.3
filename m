Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaKDEhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 23:37:00 -0500
Received: from [133.145.228.44] ([133.145.228.44]:50939 "EHLO
	mail9.hitachi.co.jp" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaKDEg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 23:36:59 -0500
Message-ID: <545857CF.3060709@hitachi.com>
Date: Tue, 04 Nov 2014 13:36:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: Re: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new
 options for cache
References: <20141031185128.27889.32747.stgit@localhost.localdomain> <20141031121301.GI1313@kernel.org> <545770E6.2010506@hitachi.com> <20141103161900.GA18464@kernel.org>
In-Reply-To: <20141103161900.GA18464@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/04 1:19), Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 03, 2014 at 09:11:18PM +0900, Masami Hiramatsu escreveu:
>> (2014/10/31 21:13), Arnaldo Carvalho de Melo wrote:
>>> Em Fri, Oct 31, 2014 at 02:51:29PM -0400, Masami Hiramatsu escreveu:
>>>>   p:probe/reset_early_page_tables _text+12980741
>>>>   p:probe/copy_bootdata _text+12980830 real_mode_data=%di:u64
>>>>   p:probe/exit_amd_microcode _text+14692680
>>>>   p:probe/early_make_pgtable _text+12981274 address=%di:u64
>>>>   p:probe/x86_64_start_reservations _text+12981700 real_mode_data=%di:u64
>>>>   p:probe/x86_64_start_kernel _text+12981744 real_mode_data=%di:u64
>>>>   p:probe/reserve_ebda_region _text+12982117
> 
>>>> This event.cache file will be big (but much smaller than native
>>>> debuginfo :) ) if your kernel have many option embedded.
>>>> Anyway, you can compress it too.
> 
>>> How do you validate that the cache can be used against some kernel? I.e.
>>> is this that the user has to do? Isn't this prone to errors?
> 
>> Actually, kprobe event itself can reject command if the given address
>> is not in the kernel text nor instruction boundary (perhaps, uprobes
>> may have a problem...), so for the kernel level, it is safe.
> 
> No, it is not necessarily safe.
> 
> What if you specify function foo() that has address 0x1234 for kernel
> v3.16 and then run the cached probe on kernel v3.18 and on that kernel
> the function foo() maps to address 0x2345 and function bar() instead
> maps to address 0x1234? Oops.

In that case user just trace bar() instead of foo(). Of course it's
not correct, but shouldn't break the kernel (if the kernel is broken,
it is a bug of kprobes).

> The build-id was designed to uniquely identify a DSO, we need to use it.
> 
> I think that at some point not using it should be left to a, in
> systemtap parlance, "guru" mode, with tooling warning profusely when
> build ids are not available and requiring even more forcing when it
> doesn't matches.

But it is not necessarily everyone uses perf probe to set up the probe
events(because it is a part of ftrace), as we can see in the Brendan's
scripts.
I think, at least what we need is clarifying how can they ensure
build-id before setting the probe events. I'd like to give them options
with knowledge instead of forcing by tools.

>>> Perhaps you could pick the build-id and store it into the event cache
>>> file, in the first lines, somethings like:
>  
>> Agreed, build-id should be the best way to check that.
>  
>> For kprobes, user can easy to get and compare it with local one as below :)
>>   ----
>>   RLOGIN=root@$REMOTE
>>   rid=`ssh $RLOGIN "od -j16 -w48 -An -t x1 /sys/kernel/notes |  tr -d ' '"`
>>   lid=`od -j16 -w48 -An -t x1 /sys/kernel/notes | tr -d ' '`
>>   if [ $rid != $lid ]; then
>>     echo "Error: Build-id mis-matched!"
>>     exit 1;
>>   fi
>>   echo "Setting up $EVENTNAME at $REMOTE"
>>   zcat event.cache.gz | grep $EVENTNAME |\
>>   ssh $RLOGIN "tee -a /sys/kernel/debug/tracing/kprobe_events"
>>   echo "Done"
>>   ----
>  
>> With this script, you don't need to install perf at remote hosts.
>> (This is what enterprise people called "agent-less")
> 
> This is only sufficient (and a cool feature!) if you will immediataly use the
> cached info (i.e. using just two systems: one development machine, with all
> debugging info, devel tools, etc, and the other the machine to observe, that is
> bare bones, no debugging info, etc)), but the moment you store that
> event.cache.gz (that has no build id embedded from what I can see from the
> above example) then you lose the build id for those cached events.

Right, in this case, it should be stored with build-id, like below :)

lid=`od -j16 -w48 -An -t x1 /sys/kernel/notes | tr -d ' '`
perf probe -o - --max-probes=10000 --no-inlines -a '* $params' | \
 gzip -c - > $lid.gz

Anyway, this is just a workaround by operation.

> You need to tightly associate whatever symbol resolution is done with
> the build id, at symbol resolution/caching time.

Agreed,

> 
> Then, before using the cached symbol resolution, we need to check if the target
> kernel/DSO build id is the same as the cached symbol kernel/DSO build id.

Yeah, but again, some users may not like to install perf to the
target system (like embedded system etc.) and also, I, personally,
like to avoid introducing server-client networking feature
for perftools, since it may open another pandora-box of security...
I'd like to use it combining with other tools, like ssh or something
like that.

> 
> Right, what is in ~/.debug/ may be used by multiple tools, just like
> debuginfo files are, by keying the content by its build id.
> 
> And also by having separate subdirectory trees for different kinds of
> symbol information, i.e. the ~/.debug/.build-id/ links may point to
> either ELF files or to kallsyms data. What we are discussing here is to
> make it also point to the [ku]probes_tracer cached probes files.
> 
> The way that DSO files are cached may by the same that you end up adding
> the [ku]probes_tracer cached files, take a look at the example of
> caching for the '/usr/bin/gcc' DSO on a test maachine here at my home
> lab:

Thanks, this is useful for me :)

[snip]

> 
> This solves the problem with debuginfo packages where we can't have multiple
> debuginfo packages installed, as well as for files that didn't came from
> debuginfo files.
> 
> [root@zoo ~]# perf buildid-cache --hell
>   Error: unknown option `hell'
> 
>  usage: perf buildid-cache [<options>]
> 
>     -a, --add <file list>
>                           file(s) to add
>     -k, --kcore <file>    kcore file to add
>     -r, --remove <file list>
>                           file(s) to remove
>     -M, --missing <file>  to find missing build ids in the cache
>     -f, --force           don't complain, do it
>     -u, --update <file list>
>                           file(s) to update
>     -v, --verbose         be more verbose
> 
> [root@zoo ~]#
> 
> Already has support for yet another of content: kcore files, its just a matter of adding
> one more:
> 
>    perf buildid-cache --probe 
> 
> :-)

OK, I agree using .debug/.buildid/ to store caches.
Here is what I'm thinking,

  # this makes caches for given pattern instead of adding probes.
  perf probe --cache '* $params'
  # the cache is stored in .debug/.buildid/<buildid>.probe
  # the cache entry can be queried by buildid and eventname
  perf probe --query ${remote_buildid}:do_fork
  p:probe/do_fork _text+298722 clone_flags=%di:u64 stack_start=%si:u64 stack_size=%dx:u64 parent_tidptr=%cx:u64 child_tidptr=%r8:u64
  # or perf can set it up directly to local
  perf probe --query-add do_fork
  Added new event:
    probe:do_fork        (on do_fork with clone_flags satck_start stack_size parent_tidptr child_tidptr)

  You can now use it in all perf tools, such as:

        perf record -e probe:do_fork -aR sleep 1

What would you think about this? :)

> 
>>> Then, later, one would use 'perf archive' passing some keys (or a
>>> perf.data file, like done nowadays to pick the files in ~/.debug for
>>> dsos that had hits on the specified perf.data file) to get the cached
>>> values to use on some other machine, to avoid having to use the
>>> debuginfo files there.
>  
>> Yeah, querying it from the BUILDID database by using a pair of remote
>> build-id and the binary path is a good feature.
>  
>>> I.e. in summary I think that the format is ok, but we need to have this
>>> inside the ~/.debug hierarchy so that we can make sure that we use the
>>> right probe definition, one that matches the DSOs being used (the kernel
>>> or some other userspace binary).
> 
>> OK, perhaps, that is also good to SDT series at last.
> 
> Sure thing!
> 

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


