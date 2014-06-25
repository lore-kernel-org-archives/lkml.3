Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaFYFxD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:53:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36370 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaFYFxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:53:00 -0400
Date: Tue, 24 Jun 2014 22:52:48 -0700
From: tip-bot for Simon Que <tipbot@zytor.com>
Message-ID: <tip-a93f0e551af9e194db38bfe16001e17a3a1d189a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sque@chromium.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sque@chromium.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, tglx@linutronix.de
In-Reply-To: <1402943529-13244-1-git-send-email-sque@chromium.org>
References: <1402943529-13244-1-git-send-email-sque@chromium.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Get kernel start address by symbol name
Git-Commit-ID: a93f0e551af9e194db38bfe16001e17a3a1d189a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a93f0e551af9e194db38bfe16001e17a3a1d189a
Gitweb:     http://git.kernel.org/tip/a93f0e551af9e194db38bfe16001e17a3a1d189a
Author:     Simon Que <sque@chromium.org>
AuthorDate: Mon, 16 Jun 2014 11:32:09 -0700
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Fri, 20 Jun 2014 09:34:22 +0200

perf symbols: Get kernel start address by symbol name

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
 
