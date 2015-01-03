Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbbACC4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 21:56:06 -0500
Received: from mail.kernel.org ([198.145.29.136]:42898 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbbACCzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 21:55:54 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>, Mark Wielaard <mjw@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf probe: Fix crash in dwarf_getcfi_elf
Date: Fri,  2 Jan 2015 23:55:35 -0300
Message-Id: <1420253737-2488-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420253737-2488-1-git-send-email-acme@kernel.org>
References: <1420253737-2488-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

David reported that perf can segfault when adding an uprobe event like
this:

  $ perf probe -x /lib64/libc-2.14.90.so -a 'malloc  size=%di'

  (gdb) bt
  #0  parse_eh_frame_hdr (hdr=0x0, hdr_size=2596, hdr_vaddr=71788,
      ehdr=0x7fffffffd390, eh_frame_vaddr=
      0x7fffffffd378, table_entries=0x8808d8, table_encoding=0x8808e0 "") at
      dwarf_getcfi_elf.c:79
  #1  0x000000385f81615a in getcfi_scn_eh_frame (hdr_vaddr=71788,
      hdr_scn=0x8839b0, shdr=0x7fffffffd2f0, scn=<optimized out>,
      ehdr=0x7fffffffd390, elf=0x882b30) at dwarf_getcfi_elf.c:231
  #2  getcfi_shdr (ehdr=0x7fffffffd390, elf=0x882b30) at dwarf_getcfi_elf.c:283
  #3  dwarf_getcfi_elf (elf=0x882b30) at dwarf_getcfi_elf.c:309
  #4  0x00000000004d5bac in debuginfo__find_probes (pf=0x7fffffffd4f0,
      dbg=Unhandled dwarf expression opcode 0xfa) at util/probe-finder.c:993
  #5  0x00000000004d634a in debuginfo__find_trace_events (dbg=0x880840,
      pev=<optimized out>, tevs=0x880f88, max_tevs=<optimized out>) at
      util/probe-finder.c:1200
  #6  0x00000000004aed6b in try_to_find_probe_trace_events (target=0x881b20
      "/lib64/libpthread-2.14.90.so",
      max_tevs=128, tevs=0x880f88, pev=0x859b30) at util/probe-event.c:482
  #7  convert_to_probe_trace_events (target=0x881b20
      "/lib64/libpthread-2.14.90.so", max_tevs=128, tevs=0x880f88,
      pev=0x859b30) at util/probe-event.c:2356
  #8  add_perf_probe_events (pevs=<optimized out>, npevs=1, max_tevs=128,
      target=0x881b20 "/lib64/libpthread-2.14.90.so", force_add=false) at
      util/probe-event.c:2391
  #9  0x000000000044014f in __cmd_probe (argc=<optimized out>,
      argv=0x7fffffffe2f0, prefix=Unhandled dwarf expression opcode 0xfa) at
      at builtin-probe.c:488
  #10 0x0000000000440313 in cmd_probe (argc=5, argv=0x7fffffffe2f0,
      prefix=<optimized out>) at builtin-probe.c:506
  #11 0x000000000041d133 in run_builtin (p=0x805680, argc=5,
      argv=0x7fffffffe2f0) at perf.c:341
  #12 0x000000000041c8b2 in handle_internal_command (argv=<optimized out>,
      argc=<optimized out>) at perf.c:400
  #13 run_argv (argv=<optimized out>, argcp=<optimized out>) at perf.c:444
  #14 main (argc=5, argv=0x7fffffffe2f0) at perf.c:559

And I found a related commit (5704c8c4fa71 "getcfi_scn_eh_frame: Don't
crash and burn when .eh_frame bits aren't there.") in elfutils that can
lead to a unexpected crash like this.  To safely use the function, it
needs to check the .eh_frame section is a PROGBITS type.

Reported-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Mark Wielaard <mjw@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20141230090533.GH6081@sejong
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c7918f83b300..b5247d777f0e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -989,8 +989,24 @@ static int debuginfo__find_probes(struct debuginfo *dbg,
 	int ret = 0;
 
 #if _ELFUTILS_PREREQ(0, 142)
+	Elf *elf;
+	GElf_Ehdr ehdr;
+	GElf_Shdr shdr;
+
 	/* Get the call frame information from this dwarf */
-	pf->cfi = dwarf_getcfi_elf(dwarf_getelf(dbg->dbg));
+	elf = dwarf_getelf(dbg->dbg);
+	if (elf == NULL)
+		return -EINVAL;
+
+	if (gelf_getehdr(elf, &ehdr) == NULL)
+		return -EINVAL;
+
+	if (elf_section_by_name(elf, &ehdr, &shdr, ".eh_frame", NULL) &&
+	    shdr.sh_type == SHT_PROGBITS) {
+		pf->cfi = dwarf_getcfi_elf(elf);
+	} else {
+		pf->cfi = dwarf_getcfi(dbg->dbg);
+	}
 #endif
 
 	off = 0;
-- 
1.9.3

