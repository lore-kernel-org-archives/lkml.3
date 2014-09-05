Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717AbaIEDTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 23:19:46 -0400
Received: from mail-oi0-f47.google.com ([209.85.218.47]:52977 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaIEDTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 23:19:43 -0400
MIME-Version: 1.0
In-Reply-To: <8761h2ap9f.fsf@sejong.aot.lge.com>
References: <1409035119-24357-1-git-send-email-namhyung@kernel.org>
	<CABPqkBRdbp6nDBFsz0gdp+qpNu+H6C4pyPTAC-EKYFoca2z+sQ@mail.gmail.com>
	<8761h2ap9f.fsf@sejong.aot.lge.com>
Date: Fri, 5 Sep 2014 05:19:43 +0200
Message-ID: <CABPqkBTJPG=8f_DRcgRWguB_3ZsDj9e+W641PMo2hF5q+PpNeg@mail.gmail.com>
Subject: Re: [PATCH] perf tools: Fix build-id matching on vmlinux
From: Stephane Eranian <eranian@google.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 2:23 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> Hi Stephane,
>
> On Thu, 4 Sep 2014 16:37:51 +0200, Stephane Eranian wrote:
>> On Tue, Aug 26, 2014 at 8:38 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>>>
>>> There's a problem on finding correct kernel symbols when perf report
>>> runs on a different kernel.  Although a part of the problem was solved
>>> by the prior commit 0a7e6d1b6844 ("perf tools: Check recorded kernel
>>> version when finding vmlinux"), there's a remaining problem still.
>>>
>>> When perf records samples, it synthesizes the kernel map using
>>> machine__mmap_name() and ref_reloc_sym like "[kernel.kallsyms]_text".
>>> You can easily see it using 'perf report -D' command.
>>>
>>> After finishing record, it goes through the recorded events to find
>>> maps/dsos actually used.  And then record build-id info of them.
>>>
>>> During this process, it needs to load symbols in a dso and it'd call
>>> dso__load_vmlinux() since the default value of the symbol_conf.try_
>>> vmlinux_path is true.  However it changes dso->long_name to a real
>>> path of the vmlinux file (e.g. /lib/modules/3.16.0-rc2+/build/vmlinux)
>>> if one is running on a custom kernel.
>>>
>>> It resulted in that perf report reads the build-id of the vmlinux, but
>>> cannot use it since it only knows about the [kernel.kallsyms] map.  It
>>> then falls back to possible vmlinux paths by using the recorded kernel
>>> version (in case of a recent version) or a running kernel silently
>>> (which might break the result).  I think it's worth going to the
>>> stable tree.
>>>
>>> I can think of a couple of ways to fix it.  In this patch, I changed
>>> to use the name of "[kernel.kallsyms]" for the kernel build-id event
>>> instead of not trying vmlinux paths.  This way we can provide maximum
>>> info (like annotation) with minimum change IMHO.
>>>
>>> Before:
>>>
>>>   $ perf record -a usleep 1
>>>
>>>   $ perf buildid-list
>>>   00d5ff078efe1d30b8492854f259215fd877ce30 /lib/modules/3.16.0-rc2+/build/vmlinux
>>>   78186287bba77069a056a5ccbeb14b7fd2ca3a4b /usr/lib64/libc-2.17.so
>>>   4eadca6cb82e0a85edb87c15b5e3980742514501 /usr/lib64/ld-2.17.so
>>>   1e272ca30081e81ef41935a630eb2f4c636798b4 /usr/lib64/dri/swrast_dri.so
>>>
>>>   $ perf buildid-list -H
>>>   0000000000000000000000000000000000000000 [kernel.kallsyms]
>>>   78186287bba77069a056a5ccbeb14b7fd2ca3a4b /usr/lib64/libc-2.17.so
>>>   4eadca6cb82e0a85edb87c15b5e3980742514501 /usr/lib64/ld-2.17.so
>>>   1e272ca30081e81ef41935a630eb2f4c636798b4 /usr/lib64/dri/swrast_dri.so
>>>   0000000000000000000000000000000000000000 /tmp/perf-2523.map
>>>
>> There is something I don't understand in your example above.  The -H
>> option shows only DSO with samples. So why do you get the buildid
>> without -H and you get no buildid with -H? In other words, I don't
>> connect the dots between what -H does on the buildid change for the
>> kernel. Looks like you have the buildid in the perf.data file.
>
> Without -H, it just prints all DSOs found in build-id table (rebuilt
> during read perf data file header) and skips processing events.  But
> with -H, it'd process the event records and so set kernel map to
> '[kernel.kallsyms]' - since the kernel mmap event always has the name -
> and mark it as hit.  Thus the actual vmlinux can't be marked and then
> cannot be printed.
>
Still don't follow this. You're saying because as part of processing the events,
you create or replace the mmap record corresponding to the kernel from the
synthesized mmap (actual kernel filename) to the generic kernel.kallsyms, you
lose the buildid. Why not just transfer it? It has to be the one
listed without -H.
This would certainly be much less confusing (to me at least)! Seems to me
you have one piece of information or the other (buildid or filename) but
never both.



> Hmm.. now I'm curious that why the -H option is needed at all.. the perf
> record already wrote build-ids that are actually hits..
>
> Thanks,
> Namhyung
