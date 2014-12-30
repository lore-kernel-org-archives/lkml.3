Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaL3IqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 03:46:06 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:51565 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbaL3IqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 03:46:04 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
Date: Tue, 30 Dec 2014 17:47:08 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Wielaard <mjw@redhat.com>
Subject: Re: perf-probe crash in dwarf_getcfi_elf
Message-ID: <20141230084708.GG6081@sejong>
References: <54A22C76.9000403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <54A22C76.9000403@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 09:39:18PM -0700, David Ahern wrote:
> Hi Namhyung:
> 
> Using perf-probe from top of Linus' tree I get a segfault on both Fedora 16
> and 18 (does not crash on Fedora 20). Command used is:
> 
> perf probe -x /lib64/libc-2.14.90.so -a 'malloc  size=%di'
> 
> git bisect points to:
> 
> commit 03d89412981a7681971bc77edba1669595763030
> Author: Namhyung Kim <namhyung@kernel.org>
> Date:   Mon Apr 7 16:05:48 2014 +0900
> 
>     perf probe: Use dwarf_getcfi_elf() instead of dwarf_getcfi()
> 

It seems to be related to below commit in elfutils.  We might need to
check .eh_frame section has SHT_PROGBITS.  Will send a patch soon.

Thanks,
Namhyung


  commit 5704c8c4fa717b6e9c2d2e4304dfbc810ad42e4b
  Author: Mark Wielaard <mjw@redhat.com>
  Date:   Tue Jul 2 11:22:35 2013 +0200

    getcfi_scn_eh_frame: Don't crash and burn when .eh_frame bits aren't there.

    Trying to read non-existing bits sometimes works and normally a sanity
    check will fail. But it could also lead to an unexpected crash much later
    when trying to use the non-existing data.

    Signed-off-by: Mark Wielaard <mjw@redhat.com>

  diff --git a/libdw/ChangeLog b/libdw/ChangeLog
  index 700c166..22f8b0c 100644
  --- a/libdw/ChangeLog
  +++ b/libdw/ChangeLog
  @@ -1,3 +1,7 @@
  +2013-07-02  Mark Wielaard  <mjw@redhat.com>
  +
  +       * dwarf_getcfi_elf.c (getcfi_shdr): Check sh_type == SHT_PROGBITS.
  +
   2013-06-26  Mark Wielaard  <mjw@redhat.com>
  
          * libdw_visit_scopes.c (__libdw_visit_scopes): Don't reject root
  diff --git a/libdw/dwarf_getcfi_elf.c b/libdw/dwarf_getcfi_elf.c
  index ba00e05..a423ef3 100644
  --- a/libdw/dwarf_getcfi_elf.c
  +++ b/libdw/dwarf_getcfi_elf.c
  @@ -280,8 +280,13 @@ getcfi_shdr (Elf *elf, const GElf_Ehdr *ehdr)
                hdr_vaddr = shdr->sh_addr;
              }
            else if (!strcmp (name, ".eh_frame"))
  -           return getcfi_scn_eh_frame (elf, ehdr, scn, shdr,
  -                                       hdr_scn, hdr_vaddr);
  +           {
  +             if (shdr->sh_type == SHT_PROGBITS)
  +               return getcfi_scn_eh_frame (elf, ehdr, scn, shdr,
  +                                           hdr_scn, hdr_vaddr);
  +             else
  +               return NULL;
  +           }
            }
          }



> Backtrace at time of crash is:
> 
> (gdb) bt
> #0  parse_eh_frame_hdr (hdr=0x0, hdr_size=2596, hdr_vaddr=71788,
> ehdr=0x7fffffffd390, eh_frame_vaddr=
>     0x7fffffffd378, table_entries=0x8808d8, table_encoding=0x8808e0 "") at
> dwarf_getcfi_elf.c:79
> #1  0x000000385f81615a in getcfi_scn_eh_frame (hdr_vaddr=71788,
> hdr_scn=0x8839b0, shdr=0x7fffffffd2f0,
>     scn=<optimized out>, ehdr=0x7fffffffd390, elf=0x882b30) at
> dwarf_getcfi_elf.c:231
> #2  getcfi_shdr (ehdr=0x7fffffffd390, elf=0x882b30) at
> dwarf_getcfi_elf.c:283
> #3  dwarf_getcfi_elf (elf=0x882b30) at dwarf_getcfi_elf.c:309
> #4  0x00000000004d5bac in debuginfo__find_probes (pf=0x7fffffffd4f0,
> dbg=Unhandled dwarf expression opcode 0xfa
> ) at util/probe-finder.c:993
> #5  0x00000000004d634a in debuginfo__find_trace_events (dbg=0x880840,
> pev=<optimized out>, tevs=0x880f88,
>     max_tevs=<optimized out>) at util/probe-finder.c:1200
> #6  0x00000000004aed6b in try_to_find_probe_trace_events (target=0x881b20
> "/lib64/libpthread-2.14.90.so",
>     max_tevs=128, tevs=0x880f88, pev=0x859b30) at util/probe-event.c:482
> #7  convert_to_probe_trace_events (target=0x881b20
> "/lib64/libpthread-2.14.90.so", max_tevs=128, tevs=0x880f88,
>     pev=0x859b30) at util/probe-event.c:2356
> #8  add_perf_probe_events (pevs=<optimized out>, npevs=1, max_tevs=128,
> target=
>     0x881b20 "/lib64/libpthread-2.14.90.so", force_add=false) at
> util/probe-event.c:2391
> #9  0x000000000044014f in __cmd_probe (argc=<optimized out>,
> argv=0x7fffffffe2f0, prefix=Unhandled dwarf expression opcode 0xfa
> )
>     at builtin-probe.c:488
> #10 0x0000000000440313 in cmd_probe (argc=5, argv=0x7fffffffe2f0,
> prefix=<optimized out>) at builtin-probe.c:506
> #11 0x000000000041d133 in run_builtin (p=0x805680, argc=5,
> argv=0x7fffffffe2f0) at perf.c:341
> #12 0x000000000041c8b2 in handle_internal_command (argv=<optimized out>,
> argc=<optimized out>) at perf.c:400
> #13 run_argv (argv=<optimized out>, argcp=<optimized out>) at perf.c:444
> #14 main (argc=5, argv=0x7fffffffe2f0) at perf.c:559
> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
