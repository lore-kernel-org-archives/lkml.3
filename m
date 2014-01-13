Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbaAMSPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:15:08 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:58786 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaAMSPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:15:04 -0500
Date: Mon, 13 Jan 2014 15:14:58 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jiri Olsa <jolsa@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: perf probe: Build error with missing libraries
Message-ID: <20140113181458.GE5318@ghostprotocols.net>
References: <20140113180400.GD5318@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140113180400.GD5318@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 13, 2014 at 03:04:00PM -0300, Arnaldo Carvalho de Melo escreveu:
> On a Ubuntu system just installed (13.10, x86_64), I'm installing the
> devel libs one by one to check if there are problems with the automatic
> disabling of features that requires libraries not installed.
 
> Stumbled at this:
 
> util/probe-event.c: At top level:
> util/probe-event.c:193:12: error: ‘get_text_start_address’ defined but
> not used [-Werror=unused-function]

> Investigating...

This patch below fixes it, applying.

Jiri, this is something else for the give-me-more-ponies list for
tests/make: build it on freshly provisioned systems with multiple mixes
of devel packages installed ;-)

- Arnaldo

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 86ed858..a4ee6b4 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -172,6 +172,7 @@ const char *kernel_get_module_path(const char *module)
 	return (dso) ? dso->long_name : NULL;
 }
 
+#ifdef HAVE_DWARF_SUPPORT
 /* Copied from unwind.c */
 static Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
 				    GElf_Shdr *shp, const char *name)
@@ -217,6 +218,7 @@ out:
 	elf_end(elf);
 	return ret;
 }
+#endif
 
 static int init_user_exec(void)
 {
@@ -750,7 +752,8 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 				struct probe_trace_event **tevs __maybe_unused,
-				int max_tevs __maybe_unused, const char *target)
+				int max_tevs __maybe_unused,
+				const char *target __maybe_unused)
 {
 	if (perf_probe_event_need_dwarf(pev)) {
 		pr_warning("Debuginfo-analysis is not supported.\n");
