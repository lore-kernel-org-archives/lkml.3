Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3K1I5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:57:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:33275 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757373Ab3K1I5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:57:17 -0500
X-IronPort-AV: E=Sophos;i="4.93,789,1378828800"; 
   d="scan'208";a="9145398"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: eranian@google.com, dsahern@gmail.com, adrian.hunter@intel.com,
        acme@ghostprotocols.net, mingo@redhat.com, paulus@samba.org,
        a.p.zijlstra@chello.nl, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] perf machine: Remove condition in machine__get_kernel_start_addr.
Date: Thu, 28 Nov 2013 16:55:29 -0500
Message-Id: <1385675729-3247-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/28 16:57:14,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/28 16:57:16,
	Serialize complete at 2013/11/28 16:57:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In machine__get_kernel_start_addr, the code, which is
using machine->root_dir to build filename, works for both
host and guests initialized from guestmount. So this patch
remove the branch for machine__is_host.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/util/machine.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 84cdb07..bac817a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -502,15 +502,11 @@ static u64 machine__get_kernel_start_addr(struct machine *machine)
 	char path[PATH_MAX];
 	struct process_args args;
 
-	if (machine__is_host(machine)) {
-		filename = "/proc/kallsyms";
-	} else {
-		if (machine__is_default_guest(machine))
-			filename = (char *)symbol_conf.default_guest_kallsyms;
-		else {
-			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-			filename = path;
-		}
+	if (machine__is_default_guest(machine))
+		filename = (char *)symbol_conf.default_guest_kallsyms;
+	else {
+		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+		filename = path;
 	}
 
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
-- 
1.8.2.1

