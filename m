Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649AbaJXHzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:55:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41567 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJXHz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:55:29 -0400
Date: Fri, 24 Oct 2014 00:55:08 -0700
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-9ab1f50876dbb8b962db058259be7aae920d4c25@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@kernel.org,
        kan.liang@intel.com, acme@redhat.com, hpa@zytor.com
Reply-To: linux-kernel@vger.kernel.org, tglx@linutronix.de, acme@redhat.com,
        hpa@zytor.com, kan.liang@intel.com, mingo@kernel.org
In-Reply-To: <1414004561-22096-1-git-send-email-kan.liang@intel.com>
References: <1414004561-22096-1-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf diff: Add missing hists__init()
  call at tool start
Git-Commit-ID: 9ab1f50876dbb8b962db058259be7aae920d4c25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ab1f50876dbb8b962db058259be7aae920d4c25
Gitweb:     http://git.kernel.org/tip/9ab1f50876dbb8b962db058259be7aae920d4c25
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Wed, 22 Oct 2014 15:02:41 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Oct 2014 16:31:06 -0300

perf diff: Add missing hists__init() call at tool start

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
index 8c5c11c..25114c9 100644
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
