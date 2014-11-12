Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbaKLP0I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:26:08 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49194 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbaKLP0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:26:05 -0500
Message-ID: <54637C05.5090807@hitachi.com>
Date: Thu, 13 Nov 2014 00:25:57 +0900
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
References: <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com> <54609A8C.4050308@hitachi.com> <20141110122321.GC4468@redhat.com> <5461B276.50004@hitachi.com> <20141111131030.GG4468@redhat.com>
In-Reply-To: <20141111131030.GG4468@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/11 22:10), Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 11, 2014 at 03:53:42PM +0900, Masami Hiramatsu escreveu:
>> (2014/11/10 21:23), Arnaldo Carvalho de Melo wrote:
>>> Em Mon, Nov 10, 2014 at 07:59:24PM +0900, Masami Hiramatsu escreveu:
>>>> Here is the second try for the probe-cache. This version simplifies
>>>> the synopsis, and unifies the SDT and probe caches.
>>>> Please give me your comments/ideas!
>>>>
>>>> Command-line Synopsis
>>>> =====================
> 
>>>> Add elf(or symbols) and probe-caches of SDT if exists in <FILES>
>>>>  perf cache --add <FILES> [--probe <SPEC>] # for user programs
> 
>>> Why the --probe above? Shouldn't this be just (if you are talking about
>>> ELF files only):
> 
>>> perf cache --add <FILES>
>  
>> Yes, for the elf and sdt cache, we don't need --probe.
>> Note that "[]" means optional. If we would like to add some probe cache,
>> we need a spec of probe definition.
> 
> I understand that, its just that it looked superfluous at that specific
> place, where you are explaining how to add ELF files.
> 
>>>>  perf cache --kcore <FILE> [--probe <SPEC>] # for kcore ?
> 
>>> Adrian, aren't kcore files easily identifiable as such and thus could be
>>> added as:
> 
>>>  perf cache --add <FILES>
> 
>>>>  perf cache --probe <SPEC>  # for the current kernel
> 
>>> Why do we need a --probe here? Don't they always start with a character
>>> that is seldomly used in ELF file names and thus we could get away with
>>> not requiring --probe?
> 
>> This is only for adding the probe cache (not elf, nor sdt), which requires
>> a probe definition. Moreover, I'd like to unify the specification of the
>> probe definition with perf-probe. In that case, --probe is more natural.
> 
> What I meant was, what is wrong with replacing:
> 
>  perf cache --probe <SPEC>  # for the current kernel
> 
> With:
> 
>  perf cache --add <PROBE-SPEC> # for the current kernel
> 
> And have it figure out that what is being added is a probe and do the
> right thing?

As I've said previously, PROBE-SPEC can be same as FILES (imagine that a binary
file which has same name function in the kernel.)
Moreover, PROBE-SPEC requires the target binary(or kernel module) except for
kernel probes. In that case, anyway we need -x or -m options with file-path
for --add, that is very strange.

e.g.

For me,

 perf cache --add ./binary --probe '*'

looks more natural than

 perf cache --add '*' -exec ./binary

since in other cases(sdt/elf), we'll just do

 perf cache --add ./binary

:-/

>>>> Remove caches related to <FILES> or <BUILDIDS>
>>>>  perf cache --remove <FILES>|<BUILDIDS>
>>>>
>>>> Show all probe caches(including SDT) or buildids
>>>>  perf cache --list [probe|buildid]
>>>>
>>>> Delete existing probe-cache entries for kernel, <PATH> or/and <BUILDID>.
>>>>  perf cache　--probe-del [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
>>>
>>> Ditto, i.e. can't we just use:
>>>
>>>  perf cache　--remove [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
>>>
>>> And it figure out that this is a probe that is being removed?
>>
>> In most cases, it may be OK, but it is also possible to cause unexpected
>> result when mis-typing. I think if <FILE> is always starting at '/', it
>> is easy to identify.
> 
> We can keep the explicit switch (--probe-del) perhaps to resolve
> ambiguities, if they happen, but make it so that it is not strictly
> required for the common case.

OK, it'll take a longer time to remove, since we need to load all caches
to find matching entries of probe caches, but is feasible.

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


