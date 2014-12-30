Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbaL3EjW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 23:39:22 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:47356 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbaL3EjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 23:39:21 -0500
Message-ID: <54A22C76.9000403@gmail.com>
Date: Mon, 29 Dec 2014 21:39:18 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: perf-probe crash in dwarf_getcfi_elf
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung:

Using perf-probe from top of Linus' tree I get a segfault on both Fedora 
16 and 18 (does not crash on Fedora 20). Command used is:

perf probe -x /lib64/libc-2.14.90.so -a 'malloc  size=%di'

git bisect points to:

commit 03d89412981a7681971bc77edba1669595763030
Author: Namhyung Kim <namhyung@kernel.org>
Date:   Mon Apr 7 16:05:48 2014 +0900

     perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()


Backtrace at time of crash is:

(gdb) bt
#0  parse_eh_frame_hdr (hdr=0x0, hdr_size=2596, hdr_vaddr=71788, 
ehdr=0x7fffffffd390, eh_frame_vaddr=
     0x7fffffffd378, table_entries=0x8808d8, table_encoding=0x8808e0 "") 
at dwarf_getcfi_elf.c:79
#1  0x000000385f81615a in getcfi_scn_eh_frame (hdr_vaddr=71788, 
hdr_scn=0x8839b0, shdr=0x7fffffffd2f0,
     scn=<optimized out>, ehdr=0x7fffffffd390, elf=0x882b30) at 
dwarf_getcfi_elf.c:231
#2  getcfi_shdr (ehdr=0x7fffffffd390, elf=0x882b30) at 
dwarf_getcfi_elf.c:283
#3  dwarf_getcfi_elf (elf=0x882b30) at dwarf_getcfi_elf.c:309
#4  0x00000000004d5bac in debuginfo__find_probes (pf=0x7fffffffd4f0, 
dbg=Unhandled dwarf expression opcode 0xfa
) at util/probe-finder.c:993
#5  0x00000000004d634a in debuginfo__find_trace_events (dbg=0x880840, 
pev=<optimized out>, tevs=0x880f88,
     max_tevs=<optimized out>) at util/probe-finder.c:1200
#6  0x00000000004aed6b in try_to_find_probe_trace_events 
(target=0x881b20 "/lib64/libpthread-2.14.90.so",
     max_tevs=128, tevs=0x880f88, pev=0x859b30) at util/probe-event.c:482
#7  convert_to_probe_trace_events (target=0x881b20 
"/lib64/libpthread-2.14.90.so", max_tevs=128, tevs=0x880f88,
     pev=0x859b30) at util/probe-event.c:2356
#8  add_perf_probe_events (pevs=<optimized out>, npevs=1, max_tevs=128, 
target=
     0x881b20 "/lib64/libpthread-2.14.90.so", force_add=false) at 
util/probe-event.c:2391
#9  0x000000000044014f in __cmd_probe (argc=<optimized out>, 
argv=0x7fffffffe2f0, prefix=Unhandled dwarf expression opcode 0xfa
)
     at builtin-probe.c:488
#10 0x0000000000440313 in cmd_probe (argc=5, argv=0x7fffffffe2f0, 
prefix=<optimized out>) at builtin-probe.c:506
#11 0x000000000041d133 in run_builtin (p=0x805680, argc=5, 
argv=0x7fffffffe2f0) at perf.c:341
#12 0x000000000041c8b2 in handle_internal_command (argv=<optimized out>, 
argc=<optimized out>) at perf.c:400
#13 run_argv (argv=<optimized out>, argcp=<optimized out>) at perf.c:444
#14 main (argc=5, argv=0x7fffffffe2f0) at perf.c:559

David
