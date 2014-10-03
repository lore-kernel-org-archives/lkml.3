Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaJCAyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 20:54:10 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52516 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaJCAyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 20:54:05 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org
Cc: Anton Blanchard <anton@au1.ibm.com>, <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 3/3] tools/perf: Fix error reporting
Date: Thu,  2 Oct 2014 17:53:36 -0700
Message-Id: <1412297616-14179-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412297616-14179-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1412297616-14179-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100300-1344-0000-0000-000004A60622
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user explicitly specifies a vmlinux or kallsyms file on the command
line and the specified file doesn't yield any symbols, print a warning
message.

	$ perf report -kallsyms
	No kernel symbols in the vmlinux 'allsyms'?
	Failed to load symbols for DSO [kernel.kallsyms], continuing
	without symbols

This could help user better recognize the typo -kallsyms v. --kallsyms.
It would also help if the user points to a stripped/invalid vmlinux or
an invalid kallsyms.

With a stripped vmlinux:

	$ perf report -k /tmp/vmlinux
	No kernel symbols in the vmlinux '/tmp/vmlinux'?
	Failed to load symbols for DSO [kernel.kallsyms], continuing
	without symbols

and with perf top

	$ perf top -k /tmp/vmlinux
	No kernel symbols in the vmlinux '/tmp/vmlinux'?
	/tmp/vmlinux with build id f43f4e78d3afac6492dcae52cd756394247997d6
	not found, continuing without symbols

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/symbol.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9b66e27..ad5baa4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1658,8 +1658,13 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map,
 	}
 
 	if (!symbol_conf.ignore_vmlinux && symbol_conf.vmlinux_name != NULL) {
-		return dso__load_vmlinux(dso, map, symbol_conf.vmlinux_name,
+		nsyms = dso__load_vmlinux(dso, map, symbol_conf.vmlinux_name,
 					 false, filter);
+		if (nsyms <= 0) {
+			pr_warning("No kernel symbols in the vmlinux '%s'?\n",
+					symbol_conf.vmlinux_name);
+		}
+		return nsyms;
 	}
 
 	if (!symbol_conf.ignore_vmlinux && vmlinux_path != NULL) {
@@ -1682,6 +1687,10 @@ do_kallsyms:
 	nsyms = dso__load_kallsyms(dso, kallsyms_filename, map, filter);
 	if (nsyms > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
+	else if (symbol_conf.kallsyms_name) {
+		pr_warning("No kernel symbols in the kallsyms '%s'?\n",
+				kallsyms_filename);
+	}
 	free(kallsyms_allocated_filename);
 
 	if (nsyms > 0 && !dso__is_kcore(dso)) {
-- 
1.8.3.1

