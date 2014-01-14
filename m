Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaANQmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:42:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaANQm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:42:27 -0500
Date: Tue, 14 Jan 2014 08:42:13 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-a5846e215bd47f61133383822422c683600efa7a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com,
        jolsa@redhat.com
In-Reply-To: <1388390555-10808-1-git-send-email-artagnon@gmail.com>
References: <1388390555-10808-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Color the Weighted Diff column
Git-Commit-ID: a5846e215bd47f61133383822422c683600efa7a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:42:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5846e215bd47f61133383822422c683600efa7a
Gitweb:     http://git.kernel.org/tip/a5846e215bd47f61133383822422c683600efa7a
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Mon, 30 Dec 2013 13:32:35 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 11:38:25 -0300

perf diff: Color the Weighted Diff column

In

  $ perf diff -c wdiff:M,N

color the numbers in the Weighted Diff column using color_snprintf(),
picking the colors using get_percent_color().

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1388390555-10808-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 73d8bff..a77e312 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -778,6 +778,7 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		container_of(fmt, struct diff_hpp_fmt, fmt);
 	struct hist_entry *pair = get_pair_fmt(he, dfmt);
 	double diff;
+	s64 wdiff;
 	char pfmt[20] = " ";
 
 	if (!pair)
@@ -806,6 +807,18 @@ static int __hpp__color_compare(struct perf_hpp_fmt *fmt,
 		scnprintf(pfmt, 20, "%%%d.6f", dfmt->header_width);
 		return value_color_snprintf(hpp->buf, hpp->size,
 					pfmt, diff);
+	case COMPUTE_WEIGHTED_DIFF:
+		if (he->dummy)
+			goto dummy_print;
+		if (pair->diff.computed)
+			wdiff = pair->diff.wdiff;
+		else
+			wdiff = compute_wdiff(he, pair);
+
+		scnprintf(pfmt, 20, "%%14ld", dfmt->header_width);
+		return color_snprintf(hpp->buf, hpp->size,
+				get_percent_color(wdiff),
+				pfmt, wdiff);
 	default:
 		BUG_ON(1);
 	}
@@ -826,6 +839,12 @@ static int hpp__color_ratio(struct perf_hpp_fmt *fmt,
 	return __hpp__color_compare(fmt, hpp, he, COMPUTE_RATIO);
 }
 
+static int hpp__color_wdiff(struct perf_hpp_fmt *fmt,
+			struct perf_hpp *hpp, struct hist_entry *he)
+{
+	return __hpp__color_compare(fmt, hpp, he, COMPUTE_WEIGHTED_DIFF);
+}
+
 static void
 hpp__entry_unpair(struct hist_entry *he, int idx, char *buf, size_t size)
 {
@@ -1007,6 +1026,9 @@ static void data__hpp_register(struct data__file *d, int idx)
 	case PERF_HPP_DIFF__RATIO:
 		fmt->color = hpp__color_ratio;
 		break;
+	case PERF_HPP_DIFF__WEIGHTED_DIFF:
+		fmt->color = hpp__color_wdiff;
+		break;
 	default:
 		break;
 	}
