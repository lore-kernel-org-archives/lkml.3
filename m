Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab3JOF1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:27:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933109Ab3JOF1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:27:13 -0400
Date: Mon, 14 Oct 2013 22:26:58 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4adcc43003024354b45edadfad4ea2fa205f135f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1378876173-13363-10-git-send-email-namhyung@kernel.org>
References: <1378876173-13363-10-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix srcline sort key behavior
Git-Commit-ID: 4adcc43003024354b45edadfad4ea2fa205f135f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:27:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4adcc43003024354b45edadfad4ea2fa205f135f
Gitweb:     http://git.kernel.org/tip/4adcc43003024354b45edadfad4ea2fa205f135f
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 11 Sep 2013 14:09:33 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:26:42 -0300

perf tools: Fix srcline sort key behavior

Currently the srcline sort key compares ip rather than srcline info.  I
guess this was due to a performance reason to run external addr2line
utility.  Now we have implemented the functionality inside, use the
srcline info when comparing hist entries.

Also constantly print "??:0" string for unknown srcline rather than
printing ip.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1378876173-13363-10-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f732120..32c5637 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -243,33 +243,32 @@ struct sort_entry sort_sym = {
 static int64_t
 sort__srcline_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	return (int64_t)(right->ip - left->ip);
+	if (!left->srcline) {
+		if (!left->ms.map)
+			left->srcline = SRCLINE_UNKNOWN;
+		else {
+			struct map *map = left->ms.map;
+			left->srcline = get_srcline(map->dso,
+					    map__rip_2objdump(map, left->ip));
+		}
+	}
+	if (!right->srcline) {
+		if (!right->ms.map)
+			right->srcline = SRCLINE_UNKNOWN;
+		else {
+			struct map *map = right->ms.map;
+			right->srcline = get_srcline(map->dso,
+					    map__rip_2objdump(map, right->ip));
+		}
+	}
+	return strcmp(left->srcline, right->srcline);
 }
 
 static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
 {
-	FILE *fp = NULL;
-	char *path = self->srcline;
-
-	if (path != NULL)
-		goto out_path;
-
-	if (!self->ms.map)
-		goto out_ip;
-
-	path = get_srcline(self->ms.map->dso, self->ip);
-	self->srcline = path;
-
-out_path:
-	if (fp)
-		pclose(fp);
-	return repsep_snprintf(bf, size, "%s", path);
-out_ip:
-	if (fp)
-		pclose(fp);
-	return repsep_snprintf(bf, size, "%-#*llx", BITS_PER_LONG / 4, self->ip);
+	return repsep_snprintf(bf, size, "%s", self->srcline);
 }
 
 struct sort_entry sort_srcline = {
