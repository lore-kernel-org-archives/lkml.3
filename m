Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab3LXPDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:03:50 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:46766 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3LXPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:03:48 -0500
Message-ID: <52B9A24C.2070702@hitachi.com>
Date: Wed, 25 Dec 2013 00:03:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, lkml <linux-kernel@vger.kernel.org>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, systemtap@sourceware.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH -tip 3/3] perf-probe: Use the actual address as
 a hint for uprobes
References: <20131220100255.7169.19384.stgit@kbuild-fedora.novalocal> <20131220100302.7169.96318.stgit@kbuild-fedora.novalocal> <20131220180351.GC28878@ghostprotocols.net> <52B75F9E.7000802@hitachi.com> <87wqiwc8ly.fsf@sejong.aot.lge.com> <52B81562.5000607@hitachi.com> <87y53afzv3.fsf@sejong.aot.lge.com> <52B94581.40704@hitachi.com> <87lhzafxgn.fsf@sejong.aot.lge.com>
In-Reply-To: <87lhzafxgn.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/24 17:46), Namhyung Kim wrote:
> On Tue, 24 Dec 2013 17:27:45 +0900, Masami Hiramatsu wrote:
>> (2013/12/24 16:54), Namhyung Kim wrote:
>>> Hi Masami,
>>>
>>> On Mon, 23 Dec 2013 19:50:10 +0900, Masami Hiramatsu wrote:
>>>> (2013/12/23 16:46), Namhyung Kim wrote:
>>>>> On Mon, 23 Dec 2013 06:54:38 +0900, Masami Hiramatsu wrote:
>>>>>> (2013/12/21 3:03), Arnaldo Carvalho de Melo wrote:
>>>>>>> Em Fri, Dec 20, 2013 at 10:03:02AM +0000, Masami Hiramatsu escreveu:
>>>>>> BTW, I'm not sure why debuginfo and nm shows symbol address + 0x400000,
>>>>>> and why the perf's map/symbol can remove this offset. Could you tell me
>>>>>> how it works?
>>>>>> If I can get the offset (0x400000) from binary, I don't need this kind
>>>>>> of ugly hacks...
>>>>>
>>>>> AFAIK the actual symbol address is what nm (and debuginfo) shows.  But
>>>>> perf adjusts symbol address to have a relative address from the start of
>>>>> mapping (i.e. file offset) like below:
>>>>>
>>>>> 	sym.st_value -= shdr.sh_addr - shdr.sh_offset;
>>>>
>>>> Thanks! this is what I really need!
>>
>> BTW, what I've found is that the perf's map has start, end and pgoffs
>> but those are not initialized when we load user-binary (see dso__load_sym).
>> I'm not sure why.
> 
> It's only set from a mmap event either sent from kernel or synthesized
> using /proc/<pid>/maps.  We cannot know the load address of a library
> until it gets loaded but for an executable, we could use the address of
> ELF segments/sections.

I see, the problem is that the address recorded in the debuginfo
is not the relative address. Thus, I think I need to get the
".text" section offset by decoding elf file (not the debuginfo).

>>>>> This way, we can handle mmap and symbol address almost uniformly
>>>>> (i.e. ip = map->start + symbol->address).  But this requires the mmap
>>>>> event during perf record.  For perf probe, we might need to synthesize
>>>>> mapping info from the section/segment header since it doesn't have the
>>>>> mmap event.  Currently, the dso__new_map() just creates a map starts
>>>>> from 0.
>>>>
>>>> I think the uprobe requires only the relative address, doesn't that?
>>>
>>> Yes, but fetching arguments is little different than a normal relative
>>> address, I think.
>>
>> Is this for uprobe probing address? or fetching symbol(global variables)?
>> I'd like to support uprobes probing address first.
> 
> It's for argument fetching.  For probing, you can simply use a relative
> address.

Hm, OK.
BTW, I've found that current uprobe's address calculation routine is
trying to get the absolute address.

        if (map->start > sym->start)
                vaddr = map->start;
        vaddr += sym->start + pp->offset + map->pgoff;

Currently it just returns a relative address because both of map->pgoff
and map->start are zero :) But I think it should be

  vaddr = sym->start + pp->offset;

Since uprobe requires a simple relative offset.

>>> An offset of an argument bases on the mapping address of text segment.
>>> This fits naturally for a shared library case - base address is 0.  So
>>> we can use the symbol address (st_value) directly.  But for executables,
>>> the base address of text segment is 0x400000 on x86-64 and data symbol
>>> is on 0x6XXXXX typically.  So in this case the offset given to uprobe
>>> should be "@+0x2XXXXX" (st_value - text_base).
>>
>> Oh, I see. I'd better make a testcase for checking what the best
>> way to get such offsets.
> 
> Okay, please share the result then. :)

I just wrote a short test program as below;
---
#include <stdio.h>

int global_var = 0xbeef;

int target(int arg1i, char *arg2s)
{
        printf("arg1=%d, arg2=%s\n", arg1i, arg2s);
        return arg1i;
}

int main(int argc, char *argv[])
{
        int ret;

        ret = target(argc, argv[0]);
        if (ret)
                target(global_var, "test");
        return 0;
}
----

And run nm and eu-readelf as below.
---
$ nm a.out | egrep "(target|global_var)"
0000000000601034 D global_var
0000000000400530 T target
$ eu-readelf -S a.out | egrep "\\.(text|data)"
[13] .text                PROGBITS     0000000000400440 00000440 000001b4  0 AX     0   0 16
[24] .data                PROGBITS     0000000000601030 00001030 00000008  0 WA     0   0  4
---
As you can see, the .text and .data offsets will be calculated by
section start - section offset. Thus, we can do

Dwarf's global_var address - (.text start - .text offset)

for the relative global_var address (unless the kernel loads .data
section into different address.)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


