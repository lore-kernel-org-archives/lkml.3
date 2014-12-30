Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaL3RNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 12:13:50 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50412 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaL3RNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 12:13:49 -0500
Message-ID: <54A2DD44.60308@gmail.com>
Date: Tue, 30 Dec 2014 10:13:40 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>
Subject: Re: perf-probe crash in dwarf_getcfi_elf
References: <54A22C76.9000403@gmail.com> <20141230084708.GG6081@sejong> <20141230090533.GH6081@sejong>
In-Reply-To: <20141230090533.GH6081@sejong>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/14 2:05 AM, Namhyung Kim wrote:
>  From f56964e74d60a9921214d0e2e5c3d082f5a910c1 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung@kernel.org>
> Date: Tue, 30 Dec 2014 17:47:47 +0900
> Subject: [PATCH] perf probe: Fix a segfault on old libdw
>
> David reported that perf can segfault when adding an uprobe event like
> this:
>
>    $ perf probe -x /lib64/libc-2.14.90.so -a 'malloc  size=%di'
>
>    (gdb) bt
>    #0  parse_eh_frame_hdr (hdr=0x0, hdr_size=2596, hdr_vaddr=71788,
>        ehdr=0x7fffffffd390, eh_frame_vaddr=
>        0x7fffffffd378, table_entries=0x8808d8, table_encoding=0x8808e0 "") at
>        dwarf_getcfi_elf.c:79
>    #1  0x000000385f81615a in getcfi_scn_eh_frame (hdr_vaddr=71788,
>        hdr_scn=0x8839b0, shdr=0x7fffffffd2f0, scn=<optimized out>,
>        ehdr=0x7fffffffd390, elf=0x882b30) at dwarf_getcfi_elf.c:231
>    #2  getcfi_shdr (ehdr=0x7fffffffd390, elf=0x882b30) at dwarf_getcfi_elf.c:283
>    #3  dwarf_getcfi_elf (elf=0x882b30) at dwarf_getcfi_elf.c:309
>    #4  0x00000000004d5bac in debuginfo__find_probes (pf=0x7fffffffd4f0,
>        dbg=Unhandled dwarf expression opcode 0xfa) at util/probe-finder.c:993
>    #5  0x00000000004d634a in debuginfo__find_trace_events (dbg=0x880840,
>        pev=<optimized out>, tevs=0x880f88, max_tevs=<optimized out>) at
>        util/probe-finder.c:1200
>    #6  0x00000000004aed6b in try_to_find_probe_trace_events (target=0x881b20
>        "/lib64/libpthread-2.14.90.so",
>        max_tevs=128, tevs=0x880f88, pev=0x859b30) at util/probe-event.c:482
>    #7  convert_to_probe_trace_events (target=0x881b20
>        "/lib64/libpthread-2.14.90.so", max_tevs=128, tevs=0x880f88,
>        pev=0x859b30) at util/probe-event.c:2356
>    #8  add_perf_probe_events (pevs=<optimized out>, npevs=1, max_tevs=128,
>        target=0x881b20 "/lib64/libpthread-2.14.90.so", force_add=false) at
>        util/probe-event.c:2391
>    #9  0x000000000044014f in __cmd_probe (argc=<optimized out>,
>        argv=0x7fffffffe2f0, prefix=Unhandled dwarf expression opcode 0xfa) at
>        at builtin-probe.c:488
>    #10 0x0000000000440313 in cmd_probe (argc=5, argv=0x7fffffffe2f0,
>        prefix=<optimized out>) at builtin-probe.c:506
>    #11 0x000000000041d133 in run_builtin (p=0x805680, argc=5,
>        argv=0x7fffffffe2f0) at perf.c:341
>    #12 0x000000000041c8b2 in handle_internal_command (argv=<optimized out>,
>        argc=<optimized out>) at perf.c:400
>    #13 run_argv (argv=<optimized out>, argcp=<optimized out>) at perf.c:444
>    #14 main (argc=5, argv=0x7fffffffe2f0) at perf.c:559
>
> And I found a related commit (5704c8c4fa71 "getcfi_scn_eh_frame: Don't
> crash and burn when .eh_frame bits aren't there.") in elfutils that
> can lead to a unexpected crash like this.  To safely use the function,
> it needs to check the .eh_frame section is a PROGBITS type.
>
> Reported-by: David Ahern <dsahern@gmail.com>
> Cc: Mark Wielaard <mjw@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Solves the crash for me.

Tested-by: David Ahern <dsahern@gmail.com>

Thanks for the quick response, Namhyung.

David
