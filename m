Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaANQmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:42:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaANQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:42:06 -0500
Date: Tue, 14 Jan 2014 08:41:53 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-01f10bc85f538cd681d0a3338b97a33f308d944b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com,
        jolsa@redhat.com
In-Reply-To: <1388388861-7931-3-git-send-email-artagnon@gmail.com>
References: <1388388861-7931-3-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Color the Delta column
Git-Commit-ID: 01f10bc85f538cd681d0a3338b97a33f308d944b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:41:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01f10bc85f538cd681d0a3338b97a33f308d944b
Gitweb:     http://git.kernel.org/tip/01f10bc85f538cd681d0a3338b97a33f308d944b
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Mon, 30 Dec 2013 13:04:19 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 11:36:46 -0300

perf diff: Color the Delta column

Color the numbers in the Delta column using percent_color_snprintf().

Generalize the coloring function so that we can accommodate all three
comparison methods in future patches: delta, ratio, and wdiff.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1388388861-7931-3-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 987cac3..6c3f220 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -770,6 +770,45 @@ static int hpp__entry_baseline(struct hist_entry *he, char *buf, size_t size)
 	return ret;
 }
 
+static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
+				struct perf_hpp *hpp, struct hist_entry *he,
+				int comparison_method)
+{
+	struct diff_hpp_fmt *dfmt =
+		container_of(fmt, struct diff_hpp_fmt, fmt);
+	struct hist_entry *pair = get_pair_fmt(he, dfmt);
+	double diff;
+	char pfmt[20] = " ";
+
+	if (!pair)
+		goto dummy_print;
+
+	switch (comparison_method) {
+	case COMPUTE_DELTA:
+		if (pair->diff.computed)
+			diff = pair->diff.period_ratio_delta;
+		else
+			diff = compute_delta(he, pair);
+
+		if (fabs(diff) < 0.01)
+			goto dummy_print;
+		scnprintf(pfmt, 20, "%%%+d.2f%%%%", dfmt->header_width - 1);
+		return percent_color_snprintf(hpp->buf, hpp->size,
+					pfmt, diff);
+	default:
+		BUG_ON(1);
+	}
+dummy_print:
+	return scnprintf(hpp->buf, hpp->size, "%*s",
+			dfmt->header_width, pfmt);
+}
+
+static int hpp__color_delta(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_DELTA);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -941,8 +980,16 @@ static void data__hpp_register(struct data__file *d, int idx)
 	fmt->entry  = hpp__entry_global;
 
 	/* TODO more colors */
-	if (idx == PERF_HPP_DIFF__BASELINE)
+	switch (idx) {
+	case PERF_HPP_DIFF__BASELINE:
 		fmt->color = hpp__color_baseline;
+		break;
+	case PERF_HPP_DIFF__DELTA:
+		fmt->color = hpp__color_delta;
+		break;
+	default:
+		break;
+	}
 
 	init_header(d, dfmt);
 	perf_hpp__column_register(fmt);
