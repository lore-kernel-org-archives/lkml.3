Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630Ab3JOF0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:26:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33129 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab3JOF0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:26:03 -0400
Date: Mon, 14 Oct 2013 22:25:48 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-963ba5fd5d04f36d6a5c9a94562484a4f270c1de@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1378876173-13363-2-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Fix a memory leak on srcline
Git-Commit-ID: 963ba5fd5d04f36d6a5c9a94562484a4f270c1de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:25:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  963ba5fd5d04f36d6a5c9a94562484a4f270c1de
Gitweb:     http://git.kernel.org/tip/963ba5fd5d04f36d6a5c9a94562484a4f270c1de
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 11 Sep 2013 14:09:25 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 15:58:07 -0300

perf sort: Fix a memory leak on srcline

In the hist_entry__srcline_snprintf(), path and self->srcline are
pointing the same memory region, but they are doubly allocated.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b4ecc0e..97cf3ef 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -269,10 +269,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 	if (!fp)
 		goto out_ip;
 
-	if (getline(&path, &line_len, fp) < 0 || !line_len)
-		goto out_ip;
-	self->srcline = strdup(path);
-	if (self->srcline == NULL)
+	if (getline(&self->srcline, &line_len, fp) < 0 || !line_len)
 		goto out_ip;
 
 	nl = strchr(self->srcline, '\n');
