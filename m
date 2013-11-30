Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3K3Mzo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:55:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59727 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3K3MxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:53:11 -0500
Date: Sat, 30 Nov 2013 04:52:58 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-80b8b496ec6edaff01f9ab74dbe8a517cd718de8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1384920457-5986-1-git-send-email-dsahern@gmail.com>
References: <1384920457-5986-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Print callchains and symbols if they exist
Git-Commit-ID: 80b8b496ec6edaff01f9ab74dbe8a517cd718de8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:53:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  80b8b496ec6edaff01f9ab74dbe8a517cd718de8
Gitweb:     http://git.kernel.org/tip/80b8b496ec6edaff01f9ab74dbe8a517cd718de8
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 19 Nov 2013 21:07:37 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:38 -0300

perf script: Print callchains and symbols if they exist

The intent of perf-script is to dump the events and information in the
file. H/W, S/W and raw events all dump callchains if they are present;
might as well make that the default for tracepoints too.

v2: Only add options for sym, dso and ip if callchains are present

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1384920457-5986-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b392770..9f3ba44 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -280,6 +280,30 @@ static int perf_session__check_output_opt(struct perf_session *session)
 		set_print_ip_opts(&evsel->attr);
 	}
 
+	/*
+	 * set default for tracepoints to print symbols only
+	 * if callchains are present
+	 */
+	if (symbol_conf.use_callchain &&
+	    !output[PERF_TYPE_TRACEPOINT].user_set) {
+		struct perf_event_attr *attr;
+
+		j = PERF_TYPE_TRACEPOINT;
+		evsel = perf_session__find_first_evtype(session, j);
+		if (evsel == NULL)
+			goto out;
+
+		attr = &evsel->attr;
+
+		if (attr->sample_type & PERF_SAMPLE_CALLCHAIN) {
+			output[j].fields |= PERF_OUTPUT_IP;
+			output[j].fields |= PERF_OUTPUT_SYM;
+			output[j].fields |= PERF_OUTPUT_DSO;
+			set_print_ip_opts(attr);
+		}
+	}
+
+out:
 	return 0;
 }
 
