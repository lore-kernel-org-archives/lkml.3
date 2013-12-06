Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab3LFJ1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:27:45 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6295 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757314Ab3LFJ1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:27:40 -0500
X-IronPort-AV: E=Sophos;i="4.93,839,1378828800"; 
   d="scan'208";a="9205956"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/3] perf tools: Change the default filenames for perf kvm diff to perf.data.xxx and perf.data.xxx.old
Date: Fri, 6 Dec 2013 17:25:53 -0500
Message-Id: <2cb684452df6a8eb1a55b450e4f5328e28e34495.1386368672.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <5e09a5c47e8a495e888cbdc65a6fafb2c950f529.1386368672.git.yangds.fnst@cn.fujitsu.com>
References: <5e09a5c47e8a495e888cbdc65a6fafb2c950f529.1386368672.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/06 17:27:25,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/06 17:27:28,
	Serialize complete at 2013/12/06 17:27:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Command perf kvm diff is used to diff perf.data.host and
perf.data.guest by default currently. But it is not a good
default behavior. We are more frequently using it to diff
the perf data files with the same type but captured in
different times, such as perf.data.guest and perf.data.guest.old.

This patch remove the hard coding of default filenames in builtin-diff.c,
and generate the suitable filename from current options in perf kvm diff
command. It makes the default behavior of perf kvm diff be more
valuable.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-diff.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 2a85cc9..6a32213 100644
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
+		file_name = (char *)get_filename_for_perf_kvm();
+		if (!file_name) {
+			pr_err("Failed to allocate memory for filename\n");
+			return -ENOMEM;
+		}
+
+		defaults[0] = strdup(file_name);
+		if (!file_name) {
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

