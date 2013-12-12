Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab3LLHlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:41:36 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:21904 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3LLHl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:41:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,469,1384272000"; 
   d="scan'208";a="9242848"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 6/6] perf tools: Enhancement for perf list for unexpected input.
Date: Thu, 12 Dec 2013 15:39:30 -0500
Message-Id: <0fae6f6a6ea27b0ab31a0ff9e884792080e7acf7.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
References: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:08,
	Serialize complete at 2013/12/12 15:41:08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Example:
	# perf list test

	List of pre-defined events (to be used in -e):
	# echo $?
	0

Verification:
	# perf list test

	Error: No event for test.
	Usage:
		perf list [hw|sw|cache|tracepoint|pmu|event_glob]
	# echo $?
	255

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-list.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 82d54b6..ba23f65 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -63,9 +63,11 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
+			unsigned int count;
 
 			if (sep == NULL) {
-				print_events(argv[i], false);
+				if(!(count = print_events(argv[i], false)))
+					goto err_out;
 				continue;
 			}
 			sep_idx = sep - argv[i];
@@ -74,9 +76,16 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 				return -1;
 
 			s[sep_idx] = '\0';
-			print_tracepoint_events(s, s + sep_idx + 1, false);
+			if (!(count = print_tracepoint_events(s, s + sep_idx + 1, false)))
+				goto err_out;
 			free(s);
 		}
 	}
+
 	return 0;
+
+err_out:
+	printf("\nError: No event for %s.\n", argv[i]);
+	printf("Usage:\n\t%s\n", list_usage[0]);
+	return -1;
 }
-- 
1.8.2.1

