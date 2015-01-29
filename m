Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbbA2NDu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:03:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41573 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbbA2NDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:03:48 -0500
Message-ID: <54CA2FB2.6070202@suse.cz>
Date: Thu, 29 Jan 2015 14:03:46 +0100
From: =?windows-1252?Q?Martin_Li=9Aka?= <mliska@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] perf: introduce new two options for objdump.
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newly introduced options usedfull for off-box usage:
   --objdump-prefix: specify prefix to add to the absolute paths
   where objdump looks for source files.
   --objdump-prefix-strip: indicate how many initial directory names
   to strip off the hardwired absolute paths, passed to objdump.
   It has no effect without --objdump-prefix.

Signed-off-by: Martin Liska <mliska@suse.cz>

---
  tools/perf/Documentation/perf-annotate.txt |  6 ++++++
  tools/perf/Documentation/perf-report.txt   |  6 ++++++
  tools/perf/Documentation/perf-top.txt      | 10 ++++++++++
  tools/perf/builtin-annotate.c              |  5 +++++
  tools/perf/builtin-report.c                |  5 +++++
  tools/perf/builtin-top.c                   |  5 +++++
  tools/perf/util/annotate.c                 |  8 +++++++-
  tools/perf/util/annotate.h                 |  2 ++
  8 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index e9cd39a..4d2a5be 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -90,6 +90,12 @@ OPTIONS
  --objdump=<path>::
          Path to objdump binary.
  
+--objdump-prefix=<path>::
+	Specify prefix to add to the absolute paths where objdump looks for source files.
+
+--objdump-prefix-strip=<level>::
+	Indicate how many initial directory names to strip off the hardwired absolute paths, passed to objdump. It has no effect without --objdump-prefix.
+
  --skip-missing::
  	Skip symbols that cannot be annotated.
  
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index dd7cccd..8e1ed80 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -279,6 +279,12 @@ OPTIONS
  --objdump=<path>::
          Path to objdump binary.
  
+--objdump-prefix=<path>::
+	Specify prefix to add to the absolute paths where objdump looks for source files.
+
+--objdump-prefix-strip=<level>::
+	Indicate how many initial directory names to strip off the hardwired absolute paths, passed to objdump. It has no effect without --objdump-prefix.
+
  --group::
  	Show event group information together.
  
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 3265b10..6e71045 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -157,6 +157,16 @@ Default is to monitor all CPUS.
  --asm-raw::
  	Show raw instruction encoding of assembly instructions.
  
+--objdump=<path>::
+        Path to objdump binary.
+
+--objdump-prefix=<path>::
+	Specify prefix to add to the absolute paths where objdump looks for source files.
+
+--objdump-prefix-strip=<level>::
+	Indicate how many initial directory names to strip off the hardwired absolute paths, passed to objdump. It has no effect without --objdump-prefix.
+
+
  -g::
  	Enables call-graph (stack chain/backtrace) recording.
  
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 747f861..25b84b1 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -322,6 +322,11 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
  		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
  	OPT_STRING(0, "objdump", &objdump_path, "path",
  		   "objdump binary to use for disassembly and annotations"),
+	OPT_STRING(0, "objdump-prefix", &objdump_prefix_path, "path",
+		   "prefix to the absolute paths where objdump looks for source files"),
+	OPT_STRING(0, "objdump-prefix-strip", &objdump_prefix_strip, "level",
+		   "Indicate how many initial directory names to strip off the hardwired "
+		   "absolute paths, passed to objdump."),
  	OPT_BOOLEAN(0, "group", &symbol_conf.event_group,
  		    "Show event group information together"),
  	OPT_END()
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 072ae8a..c4f2c2f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -712,6 +712,11 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
  		    "add last branch records to call history"),
  	OPT_STRING(0, "objdump", &objdump_path, "path",
  		   "objdump binary to use for disassembly and annotations"),
+	OPT_STRING(0, "objdump-prefix", &objdump_prefix_path, "path",
+		   "prefix to the absolute paths where objdump looks for source files"),
+	OPT_STRING(0, "objdump-prefix-strip", &objdump_prefix_strip, "level",
+		   "Indicate how many initial directory names to strip off the hardwired "
+		   "absolute paths, passed to objdump."),
  	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
  		    "Disable symbol demangling"),
  	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 616f0fc..ac70949 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1147,6 +1147,11 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
  		    "Enable kernel symbol demangling"),
  	OPT_STRING(0, "objdump", &objdump_path, "path",
  		    "objdump binary to use for disassembly and annotations"),
+	OPT_STRING(0, "objdump-prefix", &objdump_prefix_path, "path",
+		   "prefix to the absolute paths where objdump looks for source files"),
+	OPT_STRING(0, "objdump-prefix-strip", &objdump_prefix_strip, "level",
+		   "Indicate how many initial directory names to strip off the hardwired "
+		   "absolute paths, passed to objdump."),
  	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
  		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
  	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 79999ce..ec62c0b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -23,6 +23,8 @@
  
  const char 	*disassembler_style;
  const char	*objdump_path;
+const char	*objdump_prefix_path;
+const char	*objdump_prefix_strip;
  static regex_t	 file_lineno;
  
  static struct ins *ins__find(const char *name);
@@ -1001,12 +1003,16 @@ fallback:
  	}
  
  	snprintf(command, sizeof(command),
-		 "%s %s%s --start-address=0x%016" PRIx64
+		 "%s %s%s %s%s %s%s --start-address=0x%016" PRIx64
  		 " --stop-address=0x%016" PRIx64
  		 " -l -d %s %s -C %s 2>/dev/null|grep -v %s|expand",
  		 objdump_path ? objdump_path : "objdump",
  		 disassembler_style ? "-M " : "",
  		 disassembler_style ? disassembler_style : "",
+		 objdump_prefix_path ? "--prefix=" : "",
+		 objdump_prefix_path ? objdump_prefix_path : "",
+		 objdump_prefix_strip ? "--prefix-strip=" : "",
+		 objdump_prefix_strip ? objdump_prefix_strip : "",
  		 map__rip_2objdump(map, sym->start),
  		 map__rip_2objdump(map, sym->end),
  		 symbol_conf.annotate_asm_raw ? "" : "--no-show-raw",
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index cadbdc9..fd9782e 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -168,5 +168,7 @@ static inline int symbol__tui_annotate(struct symbol *sym __maybe_unused,
  #endif
  
  extern const char	*disassembler_style;
+extern const char	*objdump_prefix_path;
+extern const char	*objdump_prefix_strip;
  
  #endif	/* __PERF_ANNOTATE_H */
-- 
2.1.2

