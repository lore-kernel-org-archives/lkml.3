Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab3LTHzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 02:55:55 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:5187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab3LTHzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 02:55:01 -0500
X-IronPort-AV: E=Sophos;i="4.95,519,1384272000"; 
   d="scan'208";a="9296752"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, namhyung.kim@lge.com, jolsa@redhat.com,
        dsahern@gmail.com, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 6/7] perf tools: Add support of user space symbols for guest in perf kvm top.
Date: Fri, 20 Dec 2013 15:53:01 -0500
Message-Id: <c223056929649d74ea4f742945e5ebd561807ad2.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1387572416.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/20 15:54:24,
	Serialize complete at 2013/12/20 15:54:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	# perf kvm --guestmount /tmp/guestmount/ top
	Samples: 1K of event 'cycles', Event count (approx.): 259112905
	 17.34%  libcrypto.so.1.0.1e  [u] 0x000000000007d971
	  5.60%  [guest.kernel]       [g] kallsyms_expand_symbol
	  5.44%  libcrypto.so.1.0.1e  [u] md5_block_asm_data_order
	  4.09%  [guest.kernel]       [g] number.isra.1
	  3.59%  [guest.kernel]       [g] vsnprintf
	  3.52%  sshd                 [u] 0x00000000000441c0
	  2.37%  [guest.kernel]       [g] format_decode
	  2.36%  [guest.kernel]       [g] memcpy
	  2.11%  [guest.kernel]       [g] strnlen

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-top.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 03d37a7..670bd0b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -821,11 +821,9 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 			break;
 		case PERF_RECORD_MISC_GUEST_USER:
 			++top->guest_us_samples;
-			/*
-			 * TODO: we don't process guest user from host side
-			 * except simple counting.
-			 */
-			/* Fall thru */
+			machine = perf_session__find_machine(session,
+							     sample.pid);
+			break;
 		default:
 			goto next_event;
 		}
@@ -912,6 +910,7 @@ static int __cmd_top(struct perf_top *top)
 	struct perf_record_opts *opts = &top->record_opts;
 	pthread_t thread;
 	int ret;
+	struct rb_node *nd;
 
 	top->session = perf_session__new(NULL, false, NULL);
 	if (top->session == NULL)
@@ -931,6 +930,12 @@ static int __cmd_top(struct perf_top *top)
 
 	machine__synthesize_threads(&top->session->machines.host, &opts->target,
 				    top->evlist->threads, false);
+
+	for (nd = rb_first(&top->session->machines.guests); nd; nd = rb_next(nd)) {
+		struct machine *pos = rb_entry(nd, struct machine, rb_node);
+		machine__synthesize_threads(pos, &opts->target, top->evlist->threads, false);
+	}
+
 	ret = perf_top__start_counters(top);
 	if (ret)
 		goto out_delete;
-- 
1.8.2.1

