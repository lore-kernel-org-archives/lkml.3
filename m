Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaKHE0q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 23:26:46 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:48739 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbaKHE0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 23:26:45 -0500
Message-ID: <545D9B7D.6070307@hitachi.com>
Date: Sat, 08 Nov 2014 13:26:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mark Wielaard <mjw@redhat.com>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, oleg@redhat.com, hegdevasant@linux.vnet.ibm.com,
        mingo@redhat.com, systemtap@sourceware.org,
        aravinda@linux.vnet.ibm.com, penberg@iki.fi, brendan.d.gregg@gmail.com,
        acme@kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC] perf-cache command interface design
References: <20141102105006.21708.28734.stgit@hemant-fedora> <20141102105557.21708.19032.stgit@hemant-fedora> <87lhnr5sbl.fsf@sejong.aot.lge.com> <54588905.7040002@linux.vnet.ibm.com> <5458CD15.4010101@hitachi.com> <874muew2hk.fsf@sejong.aot.lge.com> <5459E865.6050207@hitachi.com> <545B1DDE.9000202@linux.vnet.ibm.com> <545C80F4.4020905@hitachi.com> <20141107143804.GA2137@redhat.com>
In-Reply-To: <20141107143804.GA2137@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/11/07 23:38), Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 07, 2014 at 05:21:08PM +0900, Masami Hiramatsu escreveu:
>> Hello,
>>
>> Here, I've tried to describe my idea of perf-cache subcommand interface.
>> It is just a design review, not implemented yet :)
>> Please give me your comments/ideas!
>>
>> Command-line Synopsis
>> =====================
>>
>> Current "perf buildid-cache [options]" are directly mapped to
>> "perf cache --buildid [options]".
>>
>> And adding --sdt for managing SDT caches as below.
> 
> Can't we avoid having to specify the content? I.e. the tool can surely
> be smart enough to figure that out, no?
> 
> We should, as much as possible, to make things more compact yet
> unambiguous, IMHO.

Agreed.

>  
>>   Add or update SDT events in <FILES>
>>     perf cache --sdt --add|--update <FILES>
> 
> Can automagically figure this out, so, it would become just:
> 
> 	Add or update events in <FILES>
> 
> 	  perf cache --add/--update <FILES>

Ah, nice idea :-)

>  
>>   Remove all SDT events for <FILES>
>>     perf cache --sdt --remove <FILES>
> 
> Ditto.
>  
>>   List all SDT events
>>     perf cache --sdt --list
> 
> That is ok, since the cache can hold different types of contents, but:
> 
> 	perf cache --list
> 
> should show everything, with some marking showing the content type.

Yeah, as I replied to Hemant, --sdt/--probe can be unified.

>  
>> And --probes for managing probe-caches as below.
>>
>>   Add new probe-cache entries for kernel, <PATH> or <MOD>.
>>     perf cache --probe [--exec <PATH>|--module <MOD>] --add <SPEC>
> 
> No need to specify --probe
>  
>>   Delete existing probe-cache entries for kernel, <PATH> or/and <BUILDID>.
>>     perf cache --probe --del [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
> 
> Ditto
>  
>>   Or remove all entires for given FILES
>>     perf cache --probe --remove <FILES>
> 
> Ok
>  
>>   List the probe caches(including SDT) for kernel, <PATH>, or/and <BUILDID>.
>>     perf cache --probe --list [@<PATH>][#<BUILDID>]
> 
> Can figure out the kind by the initial character, so no need to specify
> --probe

OK.

>>   Query the probe definitions.
>>     perf cache --probe --query [<GROUP>:]<EVENT>[@<PATH>][#<BUILDID>]
> 
> Ditto
>  
>> Note that --probes also can be used for managing SDT events, which has % prefix
>> e.g.
>>   Add all SDT events for <PATH>
>>     perf cache --probe --exec <PATH> --add '%*:*'
> 
> See? --probe is smart enough to deal with SDT and probe caches, it can
> disambiguate by looking at the first char.

OK, but --add already have FILES arguments (according to buildid-cache)
So I'd like to move that pattern argument to --probe as I've described
in previous reply to Hemant.

>  
>>   Remove some SDT events for <PATH>
>>     perf cache --probe --del '%some:events@<PATH>'
> 
> No need for --probe
>  
>>   Or remove all SDT events for <BUILDID>
>>     perf cache --probe --del '%*:*#<BUILDID>'
> 
> Ditto
>  
>>
>> File Format
>> ===========
>> All the cache files are placed under ~/.debug/ by default.
>> The paths of buildid cache of binary/symbols are not changed.
>>
>> The SDT/probe caches are placed under the ~/.debug/.probes/path/to/bin/bu/ildid
> 
> Here I think we could group everything related to a /path/to/bin into:
> 
> ~/.debug/path/to/bin/bu/ild/
> 
> With one file per content type:
> 
> ~/.debug/path/to/bin/bu/ild/elf
> ~/.debug/path/to/bin/bu/ild/probe

Ah, OK, this is good for me too. :)

> 
> That leaves room for us to add more file formats (CTF anyone? The Dtrace
> one, Compact C Type Information, I mean).

Perhaps.

> So that if we wanted to pick everything related to a pathname we could
> do:
> 
> tar cf gcc.debug.tar ~/.debug/usr/bin/gcc/
> 
> If we instead wanted to pick all files to a specific gcc build id, we
> would do:
> 
> tar cf gcc.debug.tar ~/.debug/usr/bin/gcc/bu/ild/

OK.

>> and that is linked to ~/.debug/.probes/.buildid/bu/ildid
> 
> Since this would break compatibility with the existing cache format, we
> could as well allow collecting everything related to a build id, by
> making the link be also in this fashion:
> 
> tar cf bu.ildid.tar ~/.debug/.build-id/bu/ildid/
> 
> Because we would have:
> 
> ~/.debug/.build-id/bu/ildid/elf -> ~/.debug/usr/bin/gcc/bu/ild/elf
> ~/.debug/.build-id/bu/ildid/probe -> ~/.debug/usr/bin/gcc/bu/ild/probe
> 
> And also links to the files that have no pathnames:
> 
> ~/.debug/.build-id/bu/ildid/vdso -> ~/.debug/[vdso]/bu/ild
> ~/.debug/.build-id/bu/ildid/kallsyms -> ~/.debug/[kernel.kallsyms]/bu/ild
> ~/.debug/.build-id/bu/ildid/kcore -> ~/.debug/[kcore]/bu/ild

OK, so let's make bu/ildid to a directory :)

Thank you!
-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


