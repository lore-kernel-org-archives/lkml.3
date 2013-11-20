Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3KTNzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:55:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35896 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3KTNzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:55:50 -0500
Date: Wed, 20 Nov 2013 05:55:34 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-50a2740b839ece03b305facd3fc07cdc3b74247c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1384741244-7271-2-git-send-email-namhyung@kernel.org>
References: <1384741244-7271-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf header:
  Fix possible memory leaks in process_group_desc()
Git-Commit-ID: 50a2740b839ece03b305facd3fc07cdc3b74247c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 20 Nov 2013 05:55:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50a2740b839ece03b305facd3fc07cdc3b74247c
Gitweb:     http://git.kernel.org/tip/50a2740b839ece03b305facd3fc07cdc3b74247c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 18 Nov 2013 11:20:44 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Nov 2013 10:34:05 -0300

perf header: Fix possible memory leaks in process_group_desc()

After processing all group descriptors or encountering an error, it
frees all descriptors.  However, current logic can leak memory since it
might not traverse all descriptors.

Note that the 'i' can have different value than nr_groups when an error
occurred and it's safe to call free(desc[i].name) for every desc since
we already make it NULL when it's reused for group names.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1384741244-7271-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 559c516..1cd0357 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2107,7 +2107,7 @@ static int process_group_desc(struct perf_file_section *section __maybe_unused,
 
 	ret = 0;
 out_free:
-	while ((int) --i >= 0)
+	for (i = 0; i < nr_groups; i++)
 		free(desc[i].name);
 	free(desc);
 
