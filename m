Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161176AbaDTIFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 04:05:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161144AbaDTIEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 04:04:34 -0400
Date: Sun, 20 Apr 2014 01:03:57 -0700
From: tip-bot for Adrien BAK <tipbot@zytor.com>
Message-ID: <tip-ffa91880a992ec1aaee4b4f7c9ddffda0c277ba9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        will.deacon@arm.com, adrien.bak@metascale.org, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, adrien.bak@metascale.org, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1397786443.3093.4.camel@beast>
References: <1397786443.3093.4.camel@beast>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Improve error reporting
Git-Commit-ID: ffa91880a992ec1aaee4b4f7c9ddffda0c277ba9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffa91880a992ec1aaee4b4f7c9ddffda0c277ba9
Gitweb:     http://git.kernel.org/tip/ffa91880a992ec1aaee4b4f7c9ddffda0c277ba9
Author:     Adrien BAK <adrien.bak@metascale.org>
AuthorDate: Fri, 18 Apr 2014 11:00:43 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Sun, 20 Apr 2014 00:15:12 +0200

perf tools: Improve error reporting

In the current version, when using perf record, if something goes
wrong in tools/perf/builtin-record.c:375
  session = perf_session__new(file, false, NULL);

The error message:
"Not enough memory for reading per file header"

is issued. This error message seems to be outdated and is not very
helpful. This patch proposes to replace this error message by
"Perf session creation failed"

I believe this issue has been brought to lkml:
https://lkml.org/lkml/2014/2/24/458
although this patch only tackles a (small) part of the issue.

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
