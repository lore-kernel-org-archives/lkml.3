Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbaCVCCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 22:02:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:41573 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987AbaCVCC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 22:02:26 -0400
Date: Fri, 21 Mar 2014 19:01:56 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Anton Blanchard <anton@au1.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] perf: Add 'merge-recursive' callchain option
Message-ID: <20140322020156.GA12474@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032202-0928-0000-0000-000000A8DD28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 9ad9432dab2bf4d1c8e6ff9201e88d5ae9f3994a Mon Sep 17 00:00:00 2001
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 20:24:22 -0500
Subject: [PATCH 1/1] perf: Add 'merge-recursive' callchain option

Powerpc saves the link register (LR) with each sample to help resolve
callchains for programs involving tail calls. Sometimes the value in the
LR is same as the NIP register. Other times it is not. This results in
callchains samples like these:

3547953334790 0x1ec0 [0x78]: PERF_RECORD_SAMPLE(IP, 2): 4667/4667: 0x80a7be3c58 period: 1773985 addr: 0
... chain: nr:9
.....  0: fffffffffffffe00
.....  1: 00000080a7be3c58	__random
.....  2: 00000080a7be3c40	__random
.....  3: 00000080a7be4270	rand
.....  4: 0000000010000784	do_my_sprintf
.....  5: 00000000100009d8	main
.....  6: 00000080a7bc482c
.....  7: 00000080a7bc4a34
.....  8: 0000000000000000
 ... thread: sprintft:4667
 ...... dso: /usr/lib64/libc-2.18.so

67470723107802 0x2f10 [0x78]: PERF_RECORD_SAMPLE(IP, 0x2): 5706/5706: 0x80a7be3c20 period: 872629 addr: 0
... chain: nr:9
.....  0: fffffffffffffe00
.....  1: 00000080a7be3c20	__random
.....  2: 00000080a7be4270	rand
.....  3: 00000080a7be4270	rand
.....  4: 0000000010000784
.....  5: 00000000100009d8
.....  6: 00000080a7bc482c
.....  7: 00000080a7bc4a34
.....  8: 0000000000000000
 ... thread: sprintft:5706
 ...... dso: /usr/lib64/libc-2.18.so

67470738362072 0x4cf8 [0x78]: PERF_RECORD_SAMPLE(IP, 0x2): 5706/5706: 0x80a7be3c14 period: 869774 addr: 0
... chain: nr:9
.....  0: fffffffffffffe00
.....  1: 00000080a7be3c14	__random
.....  2: 00000080a7be4270	rand
.....  3: 00000080a7be4270	rand
.....  4: 0000000010000784	do_my_sprintf
.....  5: 00000000100009d8	main
.....  6: 00000080a7bc482c
.....  7: 00000080a7bc4a34
.....  8: 0000000000000000
 ... thread: sprintft:5706
 ...... dso: /usr/lib64/libc-2.18.so

In the perf tool, these samples end up on different branches of the RB-Tree
resulting in duplicated arcs in the final call-graph.

    15.02%  sprintft  libc-2.18.so       [.] __random
            |
            --- __random
               |
               |--58.45%-- rand
               |          rand
               |          do_my_sprintf
               |          main
               |          generic_start_main.isra.0
               |          __libc_start_main
               |          0x0
               |
                --41.55%-- __random
                          rand
                          do_my_sprintf
                          main
                          generic_start_main.isra.0
                          __libc_start_main
                          0x0

This is an RFC for adding a 'merge-recursive' call-graph option that would
discard the duplicate entries resulting in a more compact call-graph. The
duplicates can be either identical instruction pointer values or IP values
within the same function.

	perf report --call-graph=fractal,0.5,callee,function,merge-recursive

    15.02%  sprintft  libc-2.18.so       [.] __random
            |
            ---__random
               rand
               do_my_sprintf
               main
               generic_start_main.isra.0
               __libc_start_main
                (nil)

This option could also be used to collapse call-graphs of recursive functions.

AFAICT, the existing CCKEY_FUNCTION does not address this case because
the callchain lengths can vary across samples.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/builtin-report.c |   14 ++++++++++++--
 tools/perf/util/callchain.h |    1 +
 tools/perf/util/machine.c   |   39 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d882b6f..0b68749 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -647,6 +647,16 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 		callchain_param.key = CCKEY_ADDRESS;
 	else
 		return -1;
+
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (!strncmp(tok2, "merge-recursive", strlen("merge-recursive")))
+		callchain_param.merge_recursive = 1;
+	else
+		return -1;
+
 setup:
 	if (callchain_register_param(&callchain_param) < 0) {
 		pr_err("Can't register callchain params\n");
@@ -762,8 +772,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address). "
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent[,print_limit],call_order,merge-recursive",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold, optional print limit, callchain order, key (function or address), merge or don't merge recursive calls"
 		     "Default: fractal,0.5,callee,function", &parse_callchain_opt, callchain_default_opt),
 	OPT_INTEGER(0, "max-stack", &report.max_stack,
 		    "Set the maximum stack depth when parsing the callchain, "
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 8ad97e9..d8d0822 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -53,6 +53,7 @@ struct callchain_param {
 	sort_chain_func_t	sort;
 	enum chain_order	order;
 	enum chain_key		key;
+	u32			merge_recursive;
 };
 
 struct callchain_list {
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index eb26544..e74ad95 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1272,6 +1272,32 @@ struct branch_info *sample__resolve_bstack(struct perf_sample *sample,
 	return bi;
 }
 
+static int duplicate_symbol(struct symbol *sym, char **prev_name)
+{
+	char *prev = *prev_name;
+
+	if (sym) {
+		if (prev) {
+			if (!strcmp(sym->name, prev))
+				return 1;		/* duplicate */
+			free(prev);
+		}
+
+		*prev_name = prev = strdup(sym->name);
+		if (!prev) {
+			pr_debug("%s: Unable to alloc memory\n", __func__);
+			return -ENOMEM;
+		}
+	} else if (prev) {
+		/* new symbol is NULL, so forget prev name */
+		free(prev);
+		*prev_name = NULL;
+	}
+	
+	/* Not duplicate */
+	return 0;
+}
+
 static int machine__resolve_callchain_sample(struct machine *machine,
 					     struct thread *thread,
 					     struct ip_callchain *chain,
@@ -1283,6 +1309,8 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 	int chain_nr = min(max_stack, (int)chain->nr);
 	int i;
 	int err;
+	u64 prev_ip = 0;
+	char *prev_name = NULL;
 
 	callchain_cursor_reset(&callchain_cursor);
 
@@ -1324,6 +1352,10 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			continue;
 		}
 
+		if (callchain_param.merge_recursive && prev_ip == ip)
+			continue;
+		prev_ip = ip;
+
 		al.filtered = false;
 		thread__find_addr_location(thread, machine, cpumode,
 					   MAP__FUNCTION, ip, &al);
@@ -1340,6 +1372,13 @@ static int machine__resolve_callchain_sample(struct machine *machine,
 			}
 		}
 
+		if (callchain_param.merge_recursive) {
+			if ((err = duplicate_symbol(al.sym, &prev_name)) > 0)
+				continue;	/* duplicate */
+			else if (err < 0)
+				return err;
+		}
+
 		err = callchain_cursor_append(&callchain_cursor,
 					      ip, al.map, al.sym);
 		if (err)
-- 
1.7.9.5

