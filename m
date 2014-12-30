Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaL3WNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 17:13:39 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42720 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaL3WNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 17:13:38 -0500
Message-ID: <54A3238B.90805@hitachi.com>
Date: Wed, 31 Dec 2014 07:13:31 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>
Subject: Re: Re: perf-probe crash in dwarf_getcfi_elf
References: <54A22C76.9000403@gmail.com> <20141230084708.GG6081@sejong> <20141230090533.GH6081@sejong>
In-Reply-To: <20141230090533.GH6081@sejong>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/12/30 18:05), Namhyung Kim wrote:
> On Tue, Dec 30, 2014 at 05:47:08PM +0900, Namhyung Kim wrote:
>> On Mon, Dec 29, 2014 at 09:39:18PM -0700, David Ahern wrote:
>>> Hi Namhyung:
>>>
>>> Using perf-probe from top of Linus' tree I get a segfault on both Fedora 16
>>> and 18 (does not crash on Fedora 20). Command used is:
>>>
>>> perf probe -x /lib64/libc-2.14.90.so -a 'malloc  size=%di'
>>>
>>> git bisect points to:
>>>
>>> commit 03d89412981a7681971bc77edba1669595763030
>>> Author: Namhyung Kim <namhyung@kernel.org>
>>> Date:   Mon Apr 7 16:05:48 2014 +0900
>>>
>>>     perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()
>>>
>>
>> It seems to be related to below commit in elfutils.  We might need to
>> check .eh_frame section has SHT_PROGBITS.  Will send a patch soon.
> 
> 
>>From f56964e74d60a9921214d0e2e5c3d082f5a910c1 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung@kernel.org>
> Date: Tue, 30 Dec 2014 17:47:47 +0900
> Subject: [PATCH] perf probe: Fix a segfault on old libdw
> 
> David reported that perf can segfault when adding an uprobe event like
> this:
> 
>   $ perf probe -x /lib64/libc-2.14.90.so -a 'malloc  size=%di'
> 
>   (gdb) bt
>   #0  parse_eh_frame_hdr (hdr=0x0, hdr_size=2596, hdr_vaddr=71788,
>       ehdr=0x7fffffffd390, eh_frame_vaddr=
>       0x7fffffffd378, table_entries=0x8808d8, table_encoding=0x8808e0 "") at
>       dwarf_getcfi_elf.c:79
>   #1  0x000000385f81615a in getcfi_scn_eh_frame (hdr_vaddr=71788,
>       hdr_scn=0x8839b0, shdr=0x7fffffffd2f0, scn=<optimized out>,
>       ehdr=0x7fffffffd390, elf=0x882b30) at dwarf_getcfi_elf.c:231
>   #2  getcfi_shdr (ehdr=0x7fffffffd390, elf=0x882b30) at dwarf_getcfi_elf.c:283
>   #3  dwarf_getcfi_elf (elf=0x882b30) at dwarf_getcfi_elf.c:309
>   #4  0x00000000004d5bac in debuginfo__find_probes (pf=0x7fffffffd4f0,
>       dbg=Unhandled dwarf expression opcode 0xfa) at util/probe-finder.c:993
>   #5  0x00000000004d634a in debuginfo__find_trace_events (dbg=0x880840,
>       pev=<optimized out>, tevs=0x880f88, max_tevs=<optimized out>) at
>       util/probe-finder.c:1200
>   #6  0x00000000004aed6b in try_to_find_probe_trace_events (target=0x881b20
>       "/lib64/libpthread-2.14.90.so",
>       max_tevs=128, tevs=0x880f88, pev=0x859b30) at util/probe-event.c:482
>   #7  convert_to_probe_trace_events (target=0x881b20
>       "/lib64/libpthread-2.14.90.so", max_tevs=128, tevs=0x880f88,
>       pev=0x859b30) at util/probe-event.c:2356
>   #8  add_perf_probe_events (pevs=<optimized out>, npevs=1, max_tevs=128,
>       target=0x881b20 "/lib64/libpthread-2.14.90.so", force_add=false) at
>       util/probe-event.c:2391
>   #9  0x000000000044014f in __cmd_probe (argc=<optimized out>,
>       argv=0x7fffffffe2f0, prefix=Unhandled dwarf expression opcode 0xfa) at
>       at builtin-probe.c:488
>   #10 0x0000000000440313 in cmd_probe (argc=5, argv=0x7fffffffe2f0,
>       prefix=<optimized out>) at builtin-probe.c:506
>   #11 0x000000000041d133 in run_builtin (p=0x805680, argc=5,
>       argv=0x7fffffffe2f0) at perf.c:341
>   #12 0x000000000041c8b2 in handle_internal_command (argv=<optimized out>,
>       argc=<optimized out>) at perf.c:400
>   #13 run_argv (argv=<optimized out>, argcp=<optimized out>) at perf.c:444
>   #14 main (argc=5, argv=0x7fffffffe2f0) at perf.c:559
> 
> And I found a related commit (5704c8c4fa71 "getcfi_scn_eh_frame: Don't
> crash and burn when .eh_frame bits aren't there.") in elfutils that
> can lead to a unexpected crash like this.  To safely use the function,
> it needs to check the .eh_frame section is a PROGBITS type.
> 

Looks good to me :)

> Reported-by: David Ahern <dsahern@gmail.com>
> Cc: Mark Wielaard <mjw@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

> ---
>  tools/perf/util/probe-finder.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index c7918f83b300..b5247d777f0e 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -989,8 +989,24 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
>  	int ret = 0;
>  
>  #if _ELFUTILS_PREREQ(0, 142)
> +	Elf *elf;
> +	GElf_Ehdr ehdr;
> +	GElf_Shdr shdr;
> +
>  	/* Get the call frame information from this dwarf */
> -	pf->cfi = dwarf_getcfi_elf(dwarf_getelf(dbg->dbg));
> +	elf = dwarf_getelf(dbg->dbg);
> +	if (elf == NULL)
> +		return -EINVAL;
> +
> +	if (gelf_getehdr(elf, &ehdr) == NULL)
> +		return -EINVAL;
> +
> +	if (elf_section_by_name(elf, &ehdr, &shdr, ".eh_frame", NULL) &&
> +	    shdr.sh_type == SHT_PROGBITS) {
> +		pf->cfi = dwarf_getcfi_elf(elf);
> +	} else {
> +		pf->cfi = dwarf_getcfi(dbg->dbg);
> +	}
>  #endif
>  
>  	off = 0;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


