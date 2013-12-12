Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3LLHmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:42:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab3LLHl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:41:26 -0500
X-IronPort-AV: E=Sophos;i="4.95,469,1384272000"; 
   d="scan'208";a="9242843"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/6] perf tools: Fix perf list --raw-dump option bug.
Date: Thu, 12 Dec 2013 15:39:27 -0500
Message-Id: <f152528aeeda8af6cc0e2b343e155b3ec9281a39.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
References: <761a4bdc646650d31955f9e539c3b7f5def20472.1386873922.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:03,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/12 15:41:06,
	Serialize complete at 2013/12/12 15:41:06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perf completion will use perf list --raw-dump to get the events available for '-e'.
But currently, it does not work well.

Example:
	# perf stat -e kvmm[TAB]  Error: unknown option `raw-dump'

	usage: perf list [hw|sw|cache|tracepoint|pmu|event_glob]

Because perf-completion.sh use 'perf list --raw-dump' to get the all events, but
as we introduced the parse_options() for perf list. We will get a error when we
use --raw-dump option.

This patch add an hiden option raw_dump for perf list. Then the --raw-dump will
work well to get the all event names and it will not be noise in perf list -h.

Verification:
	# ./perf stat -e kvmmmu:[TAB]
	fast_page_fault           kvm_mmu_get_page          kvm_mmu_paging_element    kvm_mmu_set_accessed_bit  kvm_mmu_sync_page         kvm_mmu_walker_error
	handle_mmio_page_fault    kvm_mmu_pagetable_walk    kvm_mmu_prepare_zap_page  kvm_mmu_set_dirty_bit     kvm_mmu_unsync_page       mark_mmio_spte

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-list.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index 011195e..82d54b6 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -19,7 +19,9 @@
 int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int i;
+	bool raw_dump = false;
 	const struct option list_options[] = {
+		OPT_BOOLEAN_HIDEN(0, "raw-dump", &raw_dump, NULL),
 		OPT_END()
 	};
 	const char * const list_usage[] = {
@@ -30,6 +32,11 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 	argc = parse_options(argc, argv, list_options, list_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 
+	if (raw_dump) {
+		print_events(NULL, true);
+		return 0;
+	}
+
 	setup_pager();
 
 	if (argc == 0) {
@@ -53,8 +60,6 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 			print_hwcache_events(NULL, false);
 		else if (strcmp(argv[i], "pmu") == 0)
 			print_pmu_events(NULL, false);
-		else if (strcmp(argv[i], "--raw-dump") == 0)
-			print_events(NULL, true);
 		else {
 			char *sep = strchr(argv[i], ':'), *s;
 			int sep_idx;
-- 
1.8.2.1

