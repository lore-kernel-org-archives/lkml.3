Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbaJVVHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:07:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:44409 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933037AbaJVVHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:07:08 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf diff: Add missing hists__init() call at tool start
Date: Wed, 22 Oct 2014 18:06:57 -0300
Message-Id: <1414012017-26261-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414012017-26261-1-git-send-email-acme@kernel.org>
References: <1414012017-26261-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

It also uses hists/hist_entries, hists__init() should be called before
creating any evsels.

Otherwise no extra space will be allocated per perf_evsel nor this space
will be initialized when allocating a new perf_evsel instance, resulting
in reads/writes to non allocated space, oops. Fix it.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Link: http://lkml.kernel.org/r/1414004561-22096-1-git-send-email-kan.liang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8c5c11ca8c53..25114c9a6801 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1142,6 +1142,11 @@ static int data_init(int argc, const char **argv)
 
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	int ret = hists__init();
+
+	if (ret < 0)
+		return ret;
+
 	perf_config(perf_default_config, NULL);
 
 	argc = parse_options(argc, argv, options, diff_usage, 0);
-- 
1.9.3

