Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab3A3Ovw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 09:51:52 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54407
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755330Ab3A3OrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 09:47:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/21] perf sort: Use pclose() instead of fclose() on pipe stream
Date: Wed, 30 Jan 2013 11:46:59 -0300
Message-Id: <1359557222-17547-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359557222-17547-1-git-send-email-acme@infradead.org>
References: <1359557222-17547-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

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
 
-- 
1.8.1.1.361.gec3ae6e

