Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534Ab3L0KGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 05:06:31 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:42406 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab3L0KFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 05:05:49 -0500
X-IronPort-AV: E=Sophos;i="4.95,559,1384272000"; 
   d="scan'208";a="9336939"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 7/8] perf tools: Fix bug when --raw-dump is not the first arguement for perf list.
Date: Fri, 27 Dec 2013 18:03:33 -0500
Message-Id: <8488ba3c35ce8bb00d9f3919ef6b2384536362dd.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1388184724.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/27 18:04:55,
	Serialize complete at 2013/12/27 18:04:55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we use PARSE_OPT_STOP_AT_NON_OPTION option in parse_option(), if --raw-dump
is not the first argument, it will be treat as an argument rather than option.

Example:
	# ./perf list kvmmmu --raw-dump
	  kvmmmu:kvm_mmu_pagetable_walk                      [Tracepoint event]
	  kvmmmu:kvm_mmu_paging_element                      [Tracepoint event]
	  kvmmmu:kvm_mmu_set_accessed_bit                    [Tracepoint event]
	  kvmmmu:kvm_mmu_set_dirty_bit                       [Tracepoint event]
	  kvmmmu:kvm_mmu_walker_error                        [Tracepoint event]
	  kvmmmu:kvm_mmu_get_page                            [Tracepoint event]
	  kvmmmu:kvm_mmu_sync_page                           [Tracepoint event]
	  kvmmmu:kvm_mmu_unsync_page                         [Tracepoint event]
	  kvmmmu:kvm_mmu_prepare_zap_page                    [Tracepoint event]
	  kvmmmu:mark_mmio_spte                              [Tracepoint event]
	  kvmmmu:handle_mmio_page_fault                      [Tracepoint event]
	  kvmmmu:fast_page_fault                             [Tracepoint event]

This patch replace PARSE_OPT_STOP_AT_NON_OPTION as 0, then we can parse it even if
it is not the first argument.

Verification:
	# ./perf list kvmmmu --raw-dump
	kvmmmu:kvm_mmu_pagetable_walk kvmmmu:kvm_mmu_paging_element
	 kvmmmu:kvm_mmu_set_accessed_bit kvmmmu:kvm_mmu_set_dirty_b
	it kvmmmu:kvm_mmu_walker_error kvmmmu:kv

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-list.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-list.c b/tools/perf/builtin-list.c
index ec90d0a..9430666 100644
--- a/tools/perf/builtin-list.c
+++ b/tools/perf/builtin-list.c
@@ -30,8 +30,7 @@ int cmd_list(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL
 	};
 
-	argc = parse_options(argc, argv, list_options, list_usage,
-			     PARSE_OPT_STOP_AT_NON_OPTION);
+	argc = parse_options(argc, argv, list_options, list_usage, 0);
 
 	setup_pager();
 
-- 
1.8.2.1

