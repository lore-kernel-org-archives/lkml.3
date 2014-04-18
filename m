Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaDRKWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 06:22:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaDRKVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 06:21:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrien BAK <adrien.bak@metascale.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/3] perf tools: Error reporting improvement
Date: Fri, 18 Apr 2014 12:20:43 +0200
Message-Id: <1397816443-14630-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397816443-14630-1-git-send-email-jolsa@redhat.com>
References: <1397816443-14630-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrien BAK <adrien.bak@metascale.org>

In the current version, when using perf record, if something goes
wrong in tools/perf/builtin-record.c:375
  session = perf_session__new(file, false, NULL);

The error message:
"Not enough memory for reading per file header"

is issued. This error message seems to be outdated and is not very
helpful.  This patch propose to replace this error message by
"Perf session creation failed"

I believe this issue has been brought to lkml:
https://lkml.org/lkml/2014/2/24/458
although this patch only tackle a (small) part of the issue.

Additionnaly, this patch improves error reporting in
tools/perf/util/data.c open_file_write.

Currently, if the call to open fails, the user is unaware of it.
This patch logs the error, before returning the error code to
the caller.

Reported-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Adrien BAK <adrien.bak@metascale.org>
Link: http://lkml.kernel.org/r/1397786443.3093.4.camel@beast
[ Reorganize the changelog into paragraphs ]
[ Added empty line after fd declaration in open_file_write ]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c | 2 +-
 tools/perf/util/data.c      | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index eb524f9..8ce62ef 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -374,7 +374,7 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 
 	session = perf_session__new(file, false, NULL);
 	if (session == NULL) {
-		pr_err("Not enough memory for reading perf file header\n");
+		pr_err("Perf session creation failed.\n");
 		return -1;
 	}
 
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 1fbcd8b..55de44e 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -86,10 +86,17 @@ static int open_file_read(struct perf_data_file *file)
 
 static int open_file_write(struct perf_data_file *file)
 {
+	int fd;
+
 	if (check_backup(file))
 		return -1;
 
-	return open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
+	fd = open(file->path, O_CREAT|O_RDWR|O_TRUNC, S_IRUSR|S_IWUSR);
+
+	if (fd < 0)
+		pr_err("failed to open %s : %s\n", file->path, strerror(errno));
+
+	return fd;
 }
 
 static int open_file(struct perf_data_file *file)
-- 
1.8.3.1

