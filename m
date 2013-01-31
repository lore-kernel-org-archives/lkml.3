Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3AaLBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:01:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab3AaLBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:01:42 -0500
Date: Thu, 31 Jan 2013 03:01:28 -0800
From: tip-bot for Thomas Jarosch <thomas.jarosch@intra2net.com>
Message-ID: <tip-8eb44dd76ac994b020e5cfe72635c90d9e0ad995@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, thomas.jarosch@intra2net.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, thomas.jarosch@intra2net.com, tglx@linutronix.de
In-Reply-To: <2266358.qvDXKLvJ67@storm>
References: <1359112354.yZcisNZ4k0@storm>
	<2266358.qvDXKLvJ67@storm>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sort: Use pclose() instead of fclose()
  on pipe stream
Git-Commit-ID: 8eb44dd76ac994b020e5cfe72635c90d9e0ad995
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 03:01:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8eb44dd76ac994b020e5cfe72635c90d9e0ad995
Gitweb:     http://git.kernel.org/tip/8eb44dd76ac994b020e5cfe72635c90d9e0ad995
Author:     Thomas Jarosch <thomas.jarosch@intra2net.com>
AuthorDate: Fri, 25 Jan 2013 11:02:13 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:38:48 -0300

perf sort: Use pclose() instead of fclose() on pipe stream

cppcheck message:
[tools/perf/util/sort.c:277]: (error) Mismatching allocation and deallocation: fp

Also fix descriptor leak on error and always initialize the "fp" variable.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/1359112354.yZcisNZ4k0@storm
Link: http://lkml.kernel.org/r/2266358.qvDXKLvJ67@storm
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 7ad6239..8333661 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -249,7 +249,7 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 					size_t size,
 					unsigned int width __maybe_unused)
 {
-	FILE *fp;
+	FILE *fp = NULL;
 	char cmd[PATH_MAX + 2], *path = self->srcline, *nl;
 	size_t line_len;
 
@@ -270,7 +270,6 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 
 	if (getline(&path, &line_len, fp) < 0 || !line_len)
 		goto out_ip;
-	fclose(fp);
 	self->srcline = strdup(path);
 	if (self->srcline == NULL)
 		goto out_ip;
@@ -280,8 +279,12 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 		*nl = '\0';
 	path = self->srcline;
 out_path:
+	if (fp)
+		pclose(fp);
 	return repsep_snprintf(bf, size, "%s", path);
 out_ip:
+	if (fp)
+		pclose(fp);
 	return repsep_snprintf(bf, size, "%-#*llx", BITS_PER_LONG / 4, self->ip);
 }
 
