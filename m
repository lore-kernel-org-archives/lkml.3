Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbaFSQjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:39:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933953AbaFSQjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:39:10 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Simon Que <sque@chromium.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 9/9] perf symbols: Get kernel start address by symbol name
Date: Thu, 19 Jun 2014 18:38:48 +0200
Message-Id: <1403195928-1331-10-git-send-email-jolsa@kernel.org>
In-Reply-To: <1403195928-1331-1-git-send-email-jolsa@kernel.org>
References: <1403195928-1331-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Simon Que <sque@chromium.org>

The function machine__get_kernel_start_addr() was taking the first symbol
of kallsyms as the start address. This is incorrect in certain cases
where the first symbol is something at 0, while the actual kernel
functions begin at a later point (e.g. 0x80200000).

This patch fixes machine__get_kernel_start_addr() to search for the
symbol "_text" or "_stext", which marks the beginning of kernel mapping.
This was already being done in machine__create_kernel_maps(). Thus, this
patch is just a refactor, to move that code into
machine__get_kernel_start_addr().

Signed-off-by: Simon Que <sque@chromium.org>
Link: http://lkml.kernel.org/r/1402943529-13244-1-git-send-email-sque@chromium.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/machine.c | 54 +++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 32 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0e5fea9..c73e1fc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -496,18 +496,6 @@ struct process_args {
 	u64 start;
 };
 
-static int symbol__in_kernel(void *arg, const char *name,
-			     char type __maybe_unused, u64 start)
-{
-	struct process_args *args = arg;
-
-	if (strchr(name, '['))
-		return 0;
-
-	args->start = start;
-	return 1;
-}
-
 static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
 					   size_t bufsz)
 {
@@ -517,27 +505,41 @@ static void machine__get_kallsyms_filename(struct machine *machine, char *buf,
 		scnprintf(buf, bufsz, "%s/proc/kallsyms", machine->root_dir);
 }
 
-/* Figure out the start address of kernel map from /proc/kallsyms */
-static u64 machine__get_kernel_start_addr(struct machine *machine)
+const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
+
+/* Figure out the start address of kernel map from /proc/kallsyms.
+ * Returns the name of the start symbol in *symbol_name. Pass in NULL as
+ * symbol_name if it's not that important.
+ */
+static u64 machine__get_kernel_start_addr(struct machine *machine,
+					  const char **symbol_name)
 {
 	char filename[PATH_MAX];
-	struct process_args args;
+	int i;
+	const char *name;
+	u64 addr = 0;
 
 	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
 
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
 		return 0;
 
-	if (kallsyms__parse(filename, &args, symbol__in_kernel) <= 0)
-		return 0;
+	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
+		addr = kallsyms__get_function_start(filename, name);
+		if (addr)
+			break;
+	}
+
+	if (symbol_name)
+		*symbol_name = name;
 
-	return args.start;
+	return addr;
 }
 
 int __machine__create_kernel_maps(struct machine *machine, struct dso *kernel)
 {
 	enum map_type type;
-	u64 start = machine__get_kernel_start_addr(machine);
+	u64 start = machine__get_kernel_start_addr(machine, NULL);
 
 	for (type = 0; type < MAP__NR_TYPES; ++type) {
 		struct kmap *kmap;
@@ -852,23 +854,11 @@ static int machine__create_modules(struct machine *machine)
 	return 0;
 }
 
-const char *ref_reloc_sym_names[] = {"_text", "_stext", NULL};
-
 int machine__create_kernel_maps(struct machine *machine)
 {
 	struct dso *kernel = machine__get_kernel(machine);
-	char filename[PATH_MAX];
 	const char *name;
-	u64 addr = 0;
-	int i;
-
-	machine__get_kallsyms_filename(machine, filename, PATH_MAX);
-
-	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
-		addr = kallsyms__get_function_start(filename, name);
-		if (addr)
-			break;
-	}
+	u64 addr = machine__get_kernel_start_addr(machine, &name);
 	if (!addr)
 		return -1;
 
-- 
1.8.3.1

