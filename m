Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3KNIbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:31:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:28923 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab3KNIb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:31:27 -0500
X-IronPort-AV: E=Sophos;i="4.93,698,1378828800"; 
   d="scan'208";a="9033201"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, yangds.fnst@cn.fujitsu.com
Subject: [PATCH] perf kvm record: Change the default value of perf_guest to 0.
Date: Thu, 14 Nov 2013 16:29:49 -0500
Message-Id: <1384464589-12346-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/14 16:29:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/11/14 16:29:33,
	Serialize complete at 2013/11/14 16:29:33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we can not record the event counters of host to perf.data.host.
Example:
   perf kvm --host record -a sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.625 MB perf.data.guest (~27290 samples) ]

The record file is named 'perf.data.kvm' and the content of it is about host
and guest. But we expect the record file is named 'perf.data.host' with the
counters only about host.

The issue was introduced by 1aed267(perf kvm: Do guest-only counting by default).

Actually, the following code can make sure that do guest-only by default:
    if (!perf_host)
        perf_guest = 1;

So, changing the default value from 0 to 1 is not a good idea, it prevents
us from getting 'perf.data.host' by '--host'.

With this patch applied, the behavior of perf-kvm is shown as below:
	* Default 	 -> perf.data.guest
	* --host  	 -> perf.data.host
	* --guest 	 -> perf.data.guest
	* --host --guest -> perf.data.kvm

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-kvm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index cd9f920..eac8269 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1709,8 +1709,7 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL
 	};
 
-	perf_host  = 0;
-	perf_guest = 1;
+	perf_host = perf_guest = 0;
 
 	argc = parse_options(argc, argv, kvm_options, kvm_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
-- 
1.8.2.1

