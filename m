Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab3KTNzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:55:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3KTNzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:55:47 -0500
Date: Wed, 20 Nov 2013 05:55:23 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-210e812f036736aeda097d9a6ef84b1f2b334bae@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1384741244-7271-1-git-send-email-namhyung@kernel.org>
References: <1384741244-7271-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf header: Fix bogus group name
Git-Commit-ID: 210e812f036736aeda097d9a6ef84b1f2b334bae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 20 Nov 2013 05:55:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  210e812f036736aeda097d9a6ef84b1f2b334bae
Gitweb:     http://git.kernel.org/tip/210e812f036736aeda097d9a6ef84b1f2b334bae
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 18 Nov 2013 11:20:43 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Nov 2013 10:33:57 -0300

perf header: Fix bogus group name

When processing event group descriptor in perf file header, we reuse an
allocated group name but forgot to prevent it from freeing.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1384741244-7271-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 369c036..559c516 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2078,8 +2078,10 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 		if (evsel->idx == (int) desc[i].leader_idx) {
 			evsel->leader = evsel;
 			/* {anon_group} is a dummy name */
-			if (strcmp(desc[i].name, "{anon_group}"))
+			if (strcmp(desc[i].name, "{anon_group}")) {
 				evsel->group_name = desc[i].name;
+				desc[i].name = NULL;
+			}
 			evsel->nr_members = desc[i].nr_members;
 
 			if (i >= nr_groups || nr > 0) {
