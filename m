Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3AYKCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:02:33 -0500
Received: from re04.intra2net.com ([82.165.46.26]:51986 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243Ab3AYKCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:02:30 -0500
From: Thomas Jarosch <thomas.jarosch@intra2net.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Subject: [perf PATCH v2] Use pclose() instead of fclose() on pipe stream
Date: Fri, 25 Jan 2013 11:02:13 +0100
Message-ID: <1359112354.yZcisNZ4k0@storm>
User-Agent: KMail/4.9.5 (Linux/3.6.11-5.fc17.x86_64; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cppcheck message:
[tools/perf/util/sort.c:277]: (error) Mismatching allocation and deallocation: fp

Also fix descriptor leak on error and always initialize the "fp" variable.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 tools/perf/util/sort.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 7ad6239..a83ded2 100644
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
@@ -280,8 +279,10 @@ static int hist_entry__srcline_snprintf(struct hist_entry *self, char *bf,
 		*nl = '\0';
 	path = self->srcline;
 out_path:
+	pclose(fp);
 	return repsep_snprintf(bf, size, "%s", path);
 out_ip:
+	pclose(fp);
 	return repsep_snprintf(bf, size, "%-#*llx", BITS_PER_LONG / 4, self->ip);
 }
 
-- 
1.7.11.7

