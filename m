Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178AbaKEIqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 03:46:19 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:59291 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaKEIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 03:46:16 -0500
Message-ID: <5459E3D2.3050106@hitachi.com>
Date: Wed, 05 Nov 2014 17:46:10 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, srikar@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new options
 for cache
References: <20141031185128.27889.32747.stgit@localhost.localdomain> <20141031121301.GI1313@kernel.org> <545770E6.2010506@hitachi.com> <20141103161900.GA18464@kernel.org> <545857CF.3060709@hitachi.com> <20141104143814.GH18464@kernel.org> <5458FD56.8040304@hitachi.com> <87h9yew4gf.fsf@sejong.aot.lge.com>
In-Reply-To: <87h9yew4gf.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/05 15:23), Namhyung Kim wrote:
> On Wed, 05 Nov 2014 01:22:46 +0900, Masami Hiramatsu wrote:
>> (2014/11/04 23:38), Arnaldo Carvalho de Melo wrote:
>>> Em Tue, Nov 04, 2014 at 01:36:31PM +0900, Masami Hiramatsu escreveu:
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
> Either is fine to me.  But my concern is that it might be bloated as
> system/package update is going on, so we need to control it somehow.
> That's why I suggested the probe-cache command.

Yes, that is also my question. Should we really have 3 cache management
commands? At the first step, maybe we can have those as separated,
but it would better be consolidated to one perf-cache command, I think.


>>>>   perf probe --query ${remote_buildid}:do_fork
>>>>   p:probe/do_fork _text+298722 clone_flags=%di:u64 stack_start=%si:u64 stack_size=%dx:u64 parent_tidptr=%cx:u64 child_tidptr=%r8:u64
>>>
>>>>   # or perf can set it up directly to local
>>>>   perf probe --query-add do_fork
>>>
>>> You missed the build id above, no? I.e. it would be:
>>>
>>>>   # or perf can set it up directly to local
>>>>   perf probe --query-add ${remote_buildid}:do_fork
>>
>> No, since this command set the event to local machine, perf-probe
>> should check the local build-id and query the appropriate event
>> from the cache.
>> # BTW, maybe we'd better use perf probe --add '$do_fork' (calls
>> # "cache of do_fork")  instead of long --query-add. :)
> 
> It should take care of uprobe case too.  So simple do_fork should have
> group/event or provider/marker form instead so that it can help to find
> which binary defines the cached event.  Maybe we also need to keep a
> event-to-binary table and then check (current?) build-id somehow to
> identify correct event to be used.
> 

Good catch! :)

 perf probe --add '$group:event $params' # for cached event
 perf probe --add '%provider[@path]:marker $params' # for SDT event

and these are automatically check the build-id.

> Also this function entry level event cache can be used with uprobes..

Yes, of course :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


