Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaKKGxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:53:51 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39037 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKKGxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:53:50 -0500
Message-ID: <5461B276.50004@hitachi.com>
Date: Tue, 11 Nov 2014 15:53:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        hegdevasant@linux.vnet.ibm.com, mingo@redhat.com,
        systemtap@sourceware.org, aravinda@linux.vnet.ibm.com, penberg@iki.fi,
        brendan.d.gregg@gmail.com,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com> <54609A8C.4050308@hitachi.com> <20141110122321.GC4468@redhat.com>
In-Reply-To: <20141110122321.GC4468@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/10 21:23), Arnaldo Carvalho de Melo wrote:
> Em Mon, Nov 10, 2014 at 07:59:24PM +0900, Masami Hiramatsu escreveu:
>> Hello,
>>
>> Here is the second try for the probe-cache. This version simplifies
>> the synopsis, and unifies the SDT and probe caches.
>> Please give me your comments/ideas!
>>
>> Command-line Synopsis
>> =====================
>>
>> Add elf(or symbols) and probe-caches of SDT if exists in <FILES>
>>  perf cache --add <FILES> [--probe <SPEC>] # for user programs
> 
> Why the --probe above? Shouldn't this be just (if you are talking about
> ELF files only):
> 
> perf cache --add <FILES>

Yes, for the elf and sdt cache, we don't need --probe.
Note that "[]" means optional. If we would like to add some probe cache,
we need a spec of probe definition.

>>  perf cache --kcore <FILE> [--probe <SPEC>] # for kcore ?
> 
> Adrian, aren't kcore files easily identifiable as such and thus could be
> added as:
> 
>  perf cache --add <FILES>
>  
>>  perf cache --probe <SPEC>  # for the current kernel
> 
> Why do we need a --probe here? Don't they always start with a character
> that is seldomly used in ELF file names and thus we could get away with
> not requiring --probe?

This is only for adding the probe cache (not elf, nor sdt), which requires
a probe definition. Moreover, I'd like to unify the specification of the
probe definition with perf-probe. In that case, --probe is more natural.

>> Remove caches related to <FILES> or <BUILDIDS>
>>  perf cache --remove <FILES>|<BUILDIDS>
>>
>> Show all probe caches(including SDT) or buildids
>>  perf cache --list [probe|buildid]
>>
>> Delete existing probe-cache entries for kernel, <PATH> or/and <BUILDID>.
>>  perf cache　--probe-del [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
> 
> Ditto, i.e. can't we just use:
> 
>  perf cache　--remove [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
> 
> And it figure out that this is a probe that is being removed?

In most cases, it may be OK, but it is also possible to cause unexpected
result when mis-typing. I think if <FILE> is always starting at '/', it
is easy to identify.

>> Query the probe definitions.
>>  perf cache --query [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
> 
> Replace --query with --show?

OK.

Thank you,

>  
>> File Format
>> ===========
>> All the cache files are placed under ~/.debug/ by default.
>> Elf caches are ~/.debug/path/to/file/bu/ildid/elf
>> Symbols caches are ~/.debug/path/to/file/bu/ildid/syms
>> Probes(and SDT) are ~/.debug/path/to/file/bu/ildid/probes
>> And ~/.debug/path/to/file/bu/ildid/ is linked to ~/.debug/.buildid/bu/ildid
>> Optionally, we can gzip the probes file.
> 
> Ok!
>  
>> This probe caches contain probe-definitions as following format.
>> ----
>> #buildid:BUILDID
>> #spec:SDT
>> p:sdt_<PROVIDER>/<EVENT> PATH:OFFSET [ARGS]
>> ...
>> #spec:* $params
>> p:probe_<GROUP>/<EVENT> _text+OFFSET [ARGS]
>> ...
>> ----
>> So the #spec: line gives the information what probe spec has been given.
>> This will be used for updating.
>>
>> And all the "probe_" and "sdt_" prefix will be replaced by % in the command line,
>> e.g.
>>
>>  perf record -e %<PROVIDER>/<EVENT> -> this records sdt_PROVIDER/EVENT
>>
>> Thank you,
>>
>> -- 
>> Masami HIRAMATSU
>> Software Platform Research Dept. Linux Technology Research Center
>> Hitachi, Ltd., Yokohama Research Laboratory
>> E-mail: masami.hiramatsu.pt@hitachi.com
>>
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


