Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab3LXIqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 03:46:21 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45588 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3LXIqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 03:46:19 -0500
X-AuditID: 9c93016f-b7b37ae000002852-e7-52b949d8ed79
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt \(Red Hat\)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip 3/3] perf-probe: Use the actual address as a hint for uprobes
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal>
	<20131220100302.7169.96318.stgit@kbuild-fedora.novalocal>
	<20131220180351.GC28878@ghostprotocols.net>
	<52B75F9E.7000802@hitachi.com> <87wqiwc8ly.fsf@sejong.aot.lge.com>
	<52B81562.5000607@hitachi.com> <87y53afzv3.fsf@sejong.aot.lge.com>
	<52B94581.40704@hitachi.com>
Date: Tue, 24 Dec 2013 17:46:16 +0900
In-Reply-To: <52B94581.40704@hitachi.com> (Masami Hiramatsu's message of "Tue,
	24 Dec 2013 17:27:45 +0900")
Message-ID: <87lhzafxgn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Dec 2013 17:27:45 +0900, Masami Hiramatsu wrote:
> (2013/12/24 16:54), Namhyung Kim wrote:
>> Hi Masami,
>> 
>> On Mon, 23 Dec 2013 19:50:10 +0900, Masami Hiramatsu wrote:
>>> (2013/12/23 16:46), Namhyung Kim wrote:
>>>> On Mon, 23 Dec 2013 06:54:38 +0900, Masami Hiramatsu wrote:
>>>>> (2013/12/21 3:03), Arnaldo Carvalho de Melo wrote:
>>>>>> Em Fri, Dec 20, 2013 at 10:03:02AM +0000, Masami Hiramatsu escreveu:
>>>>> BTW, I'm not sure why debuginfo and nm shows symbol address + 0x400000,
>>>>> and why the perf's map/symbol can remove this offset. Could you tell me
>>>>> how it works?
>>>>> If I can get the offset (0x400000) from binary, I don't need this kind
>>>>> of ugly hacks...
>>>>
>>>> AFAIK the actual symbol address is what nm (and debuginfo) shows.  But
>>>> perf adjusts symbol address to have a relative address from the start of
>>>> mapping (i.e. file offset) like below:
>>>>
>>>> 	sym.st_value -= shdr.sh_addr - shdr.sh_offset;
>>>
>>> Thanks! this is what I really need!
>
> BTW, what I've found is that the perf's map has start, end and pgoffs
> but those are not initialized when we load user-binary (see dso__load_sym).
> I'm not sure why.

It's only set from a mmap event either sent from kernel or synthesized
using /proc/<pid>/maps.  We cannot know the load address of a library
until it gets loaded but for an executable, we could use the address of
ELF segments/sections.

>
>>>> This way, we can handle mmap and symbol address almost uniformly
>>>> (i.e. ip = map->start + symbol->address).  But this requires the mmap
>>>> event during perf record.  For perf probe, we might need to synthesize
>>>> mapping info from the section/segment header since it doesn't have the
>>>> mmap event.  Currently, the dso__new_map() just creates a map starts
>>>> from 0.
>>>
>>> I think the uprobe requires only the relative address, doesn't that?
>> 
>> Yes, but fetching arguments is little different than a normal relative
>> address, I think.
>
> Is this for uprobe probing address? or fetching symbol(global variables)?
> I'd like to support uprobes probing address first.

It's for argument fetching.  For probing, you can simply use a relative
address.

>
>> An offset of an argument bases on the mapping address of text segment.
>> This fits naturally for a shared library case - base address is 0.  So
>> we can use the symbol address (st_value) directly.  But for executables,
>> the base address of text segment is 0x400000 on x86-64 and data symbol
>> is on 0x6XXXXX typically.  So in this case the offset given to uprobe
>> should be "@+0x2XXXXX" (st_value - text_base).
>
> Oh, I see. I'd better make a testcase for checking what the best
> way to get such offsets.

Okay, please share the result then. :)

Thanks,
Namhyung
