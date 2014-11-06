Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaKFKPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:15:30 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58724 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaKFKPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:15:21 -0500
Message-ID: <545B4A32.7060104@hitachi.com>
Date: Thu, 06 Nov 2014 19:15:14 +0900
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
Subject: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new options
 for cache
References: <20141031185128.27889.32747.stgit@localhost.localdomain> <20141031121301.GI1313@kernel.org> <545770E6.2010506@hitachi.com> <20141103161900.GA18464@kernel.org> <545857CF.3060709@hitachi.com> <20141104143814.GH18464@kernel.org> <5458FD56.8040304@hitachi.com> <20141105130429.GI18464@kernel.org>
In-Reply-To: <20141105130429.GI18464@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/05 22:04), Arnaldo Carvalho de Melo wrote:
> Em Wed, Nov 05, 2014 at 01:22:46AM +0900, Masami Hiramatsu escreveu:
>> (2014/11/04 23:38), Arnaldo Carvalho de Melo wrote:
>>> Em Tue, Nov 04, 2014 at 01:36:31PM +0900, Masami Hiramatsu escreveu:
>>>> (2014/11/04 1:19), Arnaldo Carvalho de Melo wrote:
>>>>> Em Mon, Nov 03, 2014 at 09:11:18PM +0900, Masami Hiramatsu escreveu:
>>>>>> (2014/10/31 21:13), Arnaldo Carvalho de Melo wrote:
>>>>>>> Em Fri, Oct 31, 2014 at 02:51:29PM -0400, Masami Hiramatsu escreveu:
>>>>>> Actually, kprobe event itself can reject command if the given address
>>>>>> is not in the kernel text nor instruction boundary (perhaps, uprobes
>>>>>> may have a problem...), so for the kernel level, it is safe.
>>>
>>>>> No, it is not necessarily safe.
>>>
>>>>> What if you specify function foo() that has address 0x1234 for kernel
>>>>> v3.16 and then run the cached probe on kernel v3.18 and on that kernel
>>>>> the function foo() maps to address 0x2345 and function bar() instead
>>>>> maps to address 0x1234? Oops.
> 
>>>> In that case user just trace bar() instead of foo(). Of course it's
>>>> not correct, but shouldn't break the kernel (if the kernel is broken,
>>>> it is a bug of kprobes).
> 
>>> I.e. no crashes, just misleading information :-\
>  
>> Right.
> 
> The kernel doesn't crashes, just the user, after scratching his head
> trying to make sense of wrong information :-P
> 
> Digressing: is there some kprobe_tracer_fuzzer out there?

No, but it's a good idea:) I just used to more systematic one
(only for the function entry).

>>>>> The build-id was designed to uniquely identify a DSO, we need to use it.
> 
>>>>> I think that at some point not using it should be left to a, in
>>>>> systemtap parlance, "guru" mode, with tooling warning profusely when
>>>>> build ids are not available and requiring even more forcing when it
>>>>> doesn't matches.
> 
>>>> But it is not necessarily everyone uses perf probe to set up the probe
>>>> events(because it is a part of ftrace), as we can see in the Brendan's
>>>> scripts.
> 
>>> Right, If I implied that some particular tool should be used, sorry
>>> about that, what I wanted to get accross was that the information that
>>> allows users or tools to make sure there is no mismatch between the
>>> cached probes and the target kernel is collected at cached probe
>>> creating time and available at target use time.
>  
>> Yes, and if user setting probes via perf, the perf must ensure that it
>> picks up the correct cache by using build-id. If someone wants to use
>> other tools, he/she must ensure it. We just give a information how to
>> check that :)
>  
>>>> I think, at least what we need is clarifying how can they ensure
>>>> build-id before setting the probe events. I'd like to give them options
>>>> with knowledge instead of forcing by tools.
> 
>>> Right, so we need to have the build-id as part of the cache format,
>>> perhaps as the first line, starting with a comment (#), that way the
>>> user can use whatever way he has at its disposal to check that the
>>> running kernel build-id is the same as the one on that comment. Using
>>> that script you provided, that uses just things that are on the machine
>>> (od, /sys/kernel/notes).
>  
>> Ah, that's a good idea :)
>> So, with such build-id comment line, would you think we can have an
>> --output option? Or we'd better moving onto the .debug/ cache file?
> 
> Well, these are two separate things: The ./debug cache file is for
> repeated use of the same probe on the same machine, say, across reboots
> or in tools that script using perf probe to add some probe, then remove
> the probes at exit, using it multiple times would provide a after
> caching, as no ELF DWARF parsing would be involved after we cached it.

OK, but it would be the next step. At first, I'd like to add/use cache
explicitly.

> As well for when using 'perf archive' to reuse the probe definitions
> using 'perf probe' on the target machine, where no -debuginfo packages
> (or binaries with DWARF) would be available.
> 
> I.e. both having the comment on the cache file with the build id and
> having it stored in ~/.debug/ have values for different workloads or
> different ways of doing the same thing.

OK, I'lll add a build-id comment line then.

>> What I'm thinking about this feature is to make a compact and reduced
>> function-entry level probe cache while building the kernel (as a part
>> of kbuild), so that we can deploy the stripped kernel and the cache
>> to remote machines.
> 
> Which is a cool feature as well! :-)

Thanks :)

>  
>> [snip]
>>>> OK, I agree using .debug/.buildid/ to store caches.
>>>> Here is what I'm thinking,
>>>  
>>>>   # this makes caches for given pattern instead of adding probes.
>>>>   perf probe --cache '* $params'
>>>
>>>>   # the cache is stored in .debug/.buildid/<buildid>.probe
>>>>   # the cache entry can be queried by buildid and eventname
>>>
>>> To follow the existing standard this would instead go to:
>>>
>>>>   # the cache is stored in .debug/probes/path/to/dso/name/buildid
>>>>   # And can be found via its buildid link .debug/.buildid/bu/ildid -> ../../probes/path/to/dso/name/buildid
>>
>> Ah, I see. so you meant adding a top-level .debug/probes/ dir.
>> But in that case, shouldn't we change .debug/.buildid/bu/ildid to
>> .debug/probes/.buildid/bu/ildid ?
> 
> Humm, understood, perhaps we should have a subdir for probes, i.e.:
> 
> # And can be found via its buildid link .debug/.buildid/probes/bu/ildid -> ../../probes/path/to/dso/name/probes/buildid
> 
> So as not to clash in both cases with the ELF file.

This looks good to me.

> Which leads to a problem when we have both vmlinux and kallsyms, which,
> right now, is not possible, i.e. if we add both a vmlinux and a kallsyms
> file for a kernel, the one that comes last will have the
> 
> .debug/.buildid/bu/ildid
> 
> link, have to fix that so that we first look for the ELF file in the
> cache, and if it fails, fallback to the kallsyms file, if available,
> i.e. give preference to the richer option, and in some cases, like for
> annotation, the only one that matters.

OK, but this seems the problem for buildid-cache, not the probe-cache nor
sdt-cache (since both should have same contents).

Thank you,
-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


