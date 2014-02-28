Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaB1Roe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:44:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbaB1Rob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:44:31 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Richard Fowles <rfowles@redhat.com>
Subject: [PATCH 09/19] perf c2c: Dump raw records, decode data_src bits
Date: Fri, 28 Feb 2014 12:42:58 -0500
Message-Id: <1393609388-40489-10-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

>From the c2c prototype:

[root@sandy ~]# perf c2c -r report | head -7
T Status    Pid Tid CPU          Inst Adrs     Virt Data Adrs Phys Data Adrs Cycles Source      Decoded Source                ObJect:Symbol
--------------------------------------------------------------------------------------------------------------------------------------------
  raw input 779 779   7 0xffffffff810865dd 0xffff8803f4d75ec8              0    370 0x68080882 [LOAD,LCL_LLC,MISS,SNP NA]    [kernel.kallsyms]:try_to_wake_up
  raw input 779 779   7 0xffffffff8107acb3 0xffff8802a5b73158              0    297 0x6a100142 [LOAD,L1,HIT,SNP NONE,LOCKED] [kernel.kallsyms]:up_read
  raw input 779 779   7       0x3b7e009814     0x7fff87429ea0              0    925 0x68100142 [LOAD,L1,HIT,SNP NONE]        ???:???
  raw input   0   0   1 0xffffffff8108bf81 0xffff8803eafebf50              0    172 0x68800842 [LOAD,LCL_LLC,HIT,SNP HITM]   [kernel.kallsyms]:update_stats_wait_end
  raw input 779 779   7       0x3b7e0097cc     0x7fac94b69068              0    228 0x68100242 [LOAD,LFB,HIT,SNP NONE]       ???:???
[root@sandy ~]#

The "Phys Data Adrs" column is not available at this point.

Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Fowles <rfowles@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-c2c.c | 148 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 125 insertions(+), 23 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 2935484..7082913 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -11,51 +11,148 @@
 
 struct perf_c2c {
 	struct perf_tool tool;
+	bool		 raw_records;
 };
 
-static int perf_sample__fprintf(struct perf_sample *sample,
-				struct perf_evsel *evsel,
-				struct addr_location *al, FILE *fp)
+enum { OP, LVL, SNP, LCK, TLB };
+
+static int perf_c2c__scnprintf_data_src(char *bf, size_t size, uint64_t val)
 {
-	return fprintf(fp, "%25.25s: %5d %5d 0x%016" PRIx64 " 0x016%" PRIx64 " %5" PRIu64 " 0x%06" PRIx64 " %s:%s\n",
-		       perf_evsel__name(evsel),
-		       sample->pid, sample->tid, sample->ip, sample->addr,
-		       sample->weight, sample->data_src,
-		       al->map ? (al->map->dso ? al->map->dso->long_name : "???") : "???",
-		       al->sym ? al->sym->name : "???");
+#define PREFIX       "["
+#define SUFFIX       "]"
+#define ELLIPSIS     "..."
+	static const struct {
+		uint64_t   bit;
+		int64_t    field;
+		const char *name;
+	} decode_bits[] = {
+	{ PERF_MEM_OP_LOAD,       OP,  "LOAD"     },
+	{ PERF_MEM_OP_STORE,      OP,  "STORE"    },
+	{ PERF_MEM_OP_NA,         OP,  "OP_NA"    },
+	{ PERF_MEM_LVL_LFB,       LVL, "LFB"      },
+	{ PERF_MEM_LVL_L1,        LVL, "L1"       },
+	{ PERF_MEM_LVL_L2,        LVL, "L2"       },
+	{ PERF_MEM_LVL_L3,        LVL, "LCL_LLC"  },
+	{ PERF_MEM_LVL_LOC_RAM,   LVL, "LCL_RAM"  },
+	{ PERF_MEM_LVL_REM_RAM1,  LVL, "RMT_RAM"  },
+	{ PERF_MEM_LVL_REM_RAM2,  LVL, "RMT_RAM"  },
+	{ PERF_MEM_LVL_REM_CCE1,  LVL, "RMT_LLC"  },
+	{ PERF_MEM_LVL_REM_CCE2,  LVL, "RMT_LLC"  },
+	{ PERF_MEM_LVL_IO,        LVL, "I/O"	  },
+	{ PERF_MEM_LVL_UNC,       LVL, "UNCACHED" },
+	{ PERF_MEM_LVL_NA,        LVL, "N"        },
+	{ PERF_MEM_LVL_HIT,       LVL, "HIT"      },
+	{ PERF_MEM_LVL_MISS,      LVL, "MISS"     },
+	{ PERF_MEM_SNOOP_NONE,    SNP, "SNP NONE" },
+	{ PERF_MEM_SNOOP_HIT,     SNP, "SNP HIT"  },
+	{ PERF_MEM_SNOOP_MISS,    SNP, "SNP MISS" },
+	{ PERF_MEM_SNOOP_HITM,    SNP, "SNP HITM" },
+	{ PERF_MEM_SNOOP_NA,      SNP, "SNP NA"   },
+	{ PERF_MEM_LOCK_LOCKED,   LCK, "LOCKED"   },
+	{ PERF_MEM_LOCK_NA,       LCK, "LOCK_NA"  },
+	};
+	union perf_mem_data_src dsrc = { .val = val, };
+	int printed = scnprintf(bf, size, PREFIX);
+	size_t i;
+	bool first_present = true;
+
+	for (i = 0; i < ARRAY_SIZE(decode_bits); i++) {
+		int bitval;
+
+		switch (decode_bits[i].field) {
+		case OP:  bitval = decode_bits[i].bit & dsrc.mem_op;    break;
+		case LVL: bitval = decode_bits[i].bit & dsrc.mem_lvl;   break;
+		case SNP: bitval = decode_bits[i].bit & dsrc.mem_snoop; break;
+		case LCK: bitval = decode_bits[i].bit & dsrc.mem_lock;  break;
+		case TLB: bitval = decode_bits[i].bit & dsrc.mem_dtlb;  break;
+		default: bitval = 0;					break;
+		}
+
+		if (!bitval)
+			continue;
+
+		if (strlen(decode_bits[i].name) + !!i > size - printed - sizeof(SUFFIX)) {
+			sprintf(bf + size - sizeof(SUFFIX) - sizeof(ELLIPSIS) + 1, ELLIPSIS);
+			printed = size - sizeof(SUFFIX);
+			break;
+		}
+
+		printed += scnprintf(bf + printed, size - printed, "%s%s",
+				     first_present ? "" : ",", decode_bits[i].name);
+		first_present = false;
+	}
+
+	printed += scnprintf(bf + printed, size - printed, SUFFIX);
+	return printed;
 }
 
-static int perf_c2c__process_load(struct perf_evsel *evsel,
-				  struct perf_sample *sample,
-				  struct addr_location *al)
+static int perf_c2c__fprintf_header(FILE *fp)
 {
-	perf_sample__fprintf(sample, evsel, al, stdout);
-	return 0;
+	int printed = fprintf(fp, "%c %-16s  %6s  %6s  %4s  %18s  %18s  %18s  %6s  %-10s %-60s %s\n", 
+			      'T',
+			      "Status",
+			      "Pid",
+			      "Tid",
+			      "CPU",
+			      "Inst Adrs",
+			      "Virt Data Adrs",
+			      "Phys Data Adrs",
+			      "Cycles",
+			      "Source",
+			      "  Decoded Source",
+			      "ObJect:Symbol");
+	return printed + fprintf(fp, "%-*.*s\n", printed, printed, graph_dotted_line);
+}
+
+static int perf_sample__fprintf(struct perf_sample *sample, char tag,
+				const char *reason, struct addr_location *al, FILE *fp)
+{
+	char data_src[61];
+
+	perf_c2c__scnprintf_data_src(data_src, sizeof(data_src), sample->data_src);
+
+	return fprintf(fp, "%c %-16s  %6d  %6d  %4d  %#18" PRIx64 "  %#18" PRIx64 "  %#18" PRIx64 "  %6" PRIu64 "  %#10" PRIx64 " %-60.60s %s:%s\n",
+		       tag,
+		       reason ?: "valid record",
+		       sample->pid,
+		       sample->tid,
+		       sample->cpu,
+		       sample->ip,
+		       sample->addr,
+		       0UL,
+		       sample->weight,
+		       sample->data_src,
+		       data_src,
+		       al->map ? (al->map->dso ? al->map->dso->long_name : "???") : "???",
+		       al->sym ? al->sym->name : "???");
 }
 
-static int perf_c2c__process_store(struct perf_evsel *evsel,
-				   struct perf_sample *sample,
-				   struct addr_location *al)
+static int perf_c2c__process_load_store(struct perf_c2c *c2c,
+					struct perf_sample *sample,
+					struct addr_location *al)
 {
-	perf_sample__fprintf(sample, evsel, al, stdout);
+	if (c2c->raw_records)
+		perf_sample__fprintf(sample, ' ', "raw input", al, stdout);
+
 	return 0;
 }
 
 static const struct perf_evsel_str_handler handlers[] = {
-	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load, },
-	{ "cpu/mem-stores/pp",	       perf_c2c__process_store, },
+	{ "cpu/mem-loads,ldlat=30/pp", perf_c2c__process_load_store, },
+	{ "cpu/mem-stores/pp",	       perf_c2c__process_load_store, },
 };
 
-typedef int (*sample_handler)(struct perf_evsel *evsel,
+typedef int (*sample_handler)(struct perf_c2c *c2c,
 			      struct perf_sample *sample,
 			      struct addr_location *al);
 
-static int perf_c2c__process_sample(struct perf_tool *tool __maybe_unused,
+static int perf_c2c__process_sample(struct perf_tool *tool,
 				    union perf_event *event,
 				    struct perf_sample *sample,
 				    struct perf_evsel *evsel,
 				    struct machine *machine)
 {
+	struct perf_c2c *c2c = container_of(tool, struct perf_c2c, tool);
 	struct addr_location al;
 	int err = 0;
 
@@ -67,7 +164,7 @@ static int perf_c2c__process_sample(struct perf_tool *tool __maybe_unused,
 
 	if (evsel->handler != NULL) {
 		sample_handler f = evsel->handler;
-		err = f(evsel, sample, &al);
+		err = f(c2c, sample, &al);
 	}
 
 	return err;
@@ -111,6 +208,10 @@ out:
 static int perf_c2c__report(struct perf_c2c *c2c)
 {
 	setup_pager();
+
+	if (c2c->raw_records)
+		perf_c2c__fprintf_header(stdout);
+
 	return perf_c2c__read_events(c2c);
 }
 
@@ -161,6 +262,7 @@ int cmd_c2c(int argc, const char **argv, const char *prefix __maybe_unused)
 		},
 	};
 	const struct option c2c_options[] = {
+	OPT_BOOLEAN('r', "raw_records", &c2c.raw_records, "dump raw events"),
 	OPT_END()
 	};
 	const char * const c2c_usage[] = {
-- 
1.7.11.7

