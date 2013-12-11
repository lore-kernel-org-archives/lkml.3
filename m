Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab3LKEtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 23:49:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3640 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab3LKEtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 23:49:36 -0500
X-IronPort-AV: E=Sophos;i="4.93,869,1378828800"; 
   d="scan'208";a="9234830"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] perf tools: Change the default filenames for perf kvm diff to perf.data.xxx and perf.data.xxx.old
Date: Wed, 11 Dec 2013 12:47:38 -0500
Message-Id: <bded0b7f74e2317e7f0297c7eb97ba5cb345b7e7.1386783950.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1122029b8eed159852fe6669827b6dff12f81698.1386783950.git.yangds.fnst@cn.fujitsu.com>
References: <1122029b8eed159852fe6669827b6dff12f81698.1386783950.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/11 12:49:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/11 12:49:16,
	Serialize complete at 2013/12/11 12:49:16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command perf kvm diff is used to diff perf.data.host and
perf.data.guest by default currently. But it is not a good
default behavior.

Example:
	# perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.669 MB perf.data.guest (~29207 samples) ]
	# perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.669 MB perf.data.guest (~29207 samples) ]
	# perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules diff
	failed to open perf.data.host: No such file or directory
	Failed to open perf.data.host

We should keep the style of 'perf kvm diff' same with 'perf diff'.
It is used to diff files with same type but captured in different
times, perf.data and perf.data.old. So we need to make perf kvm diff
to diff perf.data.guest and perf.data.guest.old as a default behavior.

What's worse, as we have changed the behaviors of perf kvm record,
we can not get a perf.data.host easily. We have to use a --no-guest
to get a perf.data.host, it means we use perf.data.host as a default
input in 'perf kvm diff' is an odd design.

This patch remove the hard coding of default filenames in builtin-diff.c,
and generate the suitable filename from current options in perf kvm diff
command. It makes the default behavior of perf kvm diff be more valuable.

Verification:
	# perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules record -a sleep 1
	  [ perf record: Woken up 1 times to write data ]
	  [ perf record: Captured and wrote 0.669 MB perf.data.guest (~29207 samples) ]
	# perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules record -a sleep 1
	  [ perf record: Woken up 1 times to write data ]
	  [ perf record: Captured and wrote 0.669 MB perf.data.guest (~29207 samples) ]
	# perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules diff
	  # Event 'cycles'
	  #
	  # Baseline    Delta            Shared Object                                   Symbol
	  # ........  .......  .......................  .......................................
	  #
	    92.00%           [guest.kernel.kallsyms]  [g] rb_insert_color
	     7.51%           [guest.kernel.kallsyms]  [g] smp_apic_timer_interrupt
	     0.48%   +0.60%  [guest.kernel.kallsyms]  [g] apic_timer_interrupt
		    +16.35%  [guest.kernel.kallsyms]  [g] kvm_clock_get_cycles
		    +82.56%  [guest.kernel.kallsyms]  [g] irqtime_account_process_tick.isra.2

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-diff.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2a85cc9..a1d59d8 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -17,6 +17,7 @@
 #include "util/symbol.h"
 #include "util/util.h"
 #include "util/data.h"
+#include "linux/string.h"
 
 #include <stdlib.h>
 #include <math.h>
@@ -1001,8 +1002,28 @@ static int data_init(int argc, const char **argv)
 			use_default = false;
 		}
 	} else if (perf_guest) {
-		defaults[0] = "perf.data.host";
-		defaults[1] = "perf.data.guest";
+		char *file_name;
+		int len, ret;
+
+		file_name = strdup(get_filename_for_perf_kvm());
+		if (!file_name) {
+			pr_err("Failed to allocate memory for filename\n");
+			return -ENOMEM;
+		}
+
+		defaults[0] = strdup(file_name);
+		if (!defaults[0]) {
+			pr_err("Failed to allocate memory for defaults[0]\n");
+			return -ENOMEM;
+		}
+
+		len = strlen(file_name);
+		ret = str_append(&file_name, &len, ".old");
+		if (ret) {
+			pr_err("Failed to allocate memory for defaults[1]\n");
+			return -ENOMEM;
+		}
+		defaults[1] = file_name;
 	}
 
 	if (sort_compute >= (unsigned int) data__files_cnt) {
-- 
1.8.2.1

