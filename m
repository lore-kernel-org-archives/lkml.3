Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbbA1VV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:21:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964985AbbA1UuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:14 -0500
Date: Wed, 28 Jan 2015 07:10:00 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-6chfytoflyx3jwfqm7ebltu0@git.kernel.org>
Cc: acme@redhat.com, jolsa@redhat.com, bp@suse.de, adrian.hunter@intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, eranian@google.com,
        dsahern@gmail.com, mingo@kernel.org, hpa@zytor.com,
        namhyung@kernel.org, dzickus@redhat.com, fweisbec@gmail.com
Reply-To: eranian@google.com, linux-kernel@vger.kernel.org, dsahern@gmail.com,
        mingo@kernel.org, hpa@zytor.com, fweisbec@gmail.com,
        dzickus@redhat.com, namhyung@kernel.org, acme@redhat.com,
        jolsa@redhat.com, bp@suse.de, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib fs debugfs:
  Check if debugfs is mounted when handling ENOENT
Git-Commit-ID: f816b3cc99804a9f771315331deb36abec47f5b4
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

Commit-ID:  f816b3cc99804a9f771315331deb36abec47f5b4
Gitweb:     http://git.kernel.org/tip/f816b3cc99804a9f771315331deb36abec47f5b4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 22 Jan 2015 16:35:42 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Jan 2015 17:02:23 -0300

tools lib fs debugfs: Check if debugfs is mounted when handling ENOENT

If debugfs was already mounted, then its a matter of not finding the
tracepoint, tell the user that perhaps a CONFIG_ setting is not enabled.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6chfytoflyx3jwfqm7ebltu0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index bf9e216..d2b18e8 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -106,6 +106,13 @@ int debugfs__strerror_open(int err, char *buf, size_t size, const char *filename
 
 	switch (err) {
 	case ENOENT:
+		if (debugfs_found) {
+			snprintf(buf, size,
+				 "Error:\tFile %s/%s not found.\n"
+				 "Hint:\tPerhaps this kernel misses some CONFIG_ setting to enable this feature?.\n",
+				 debugfs_mountpoint, filename);
+			break;
+		}
 		snprintf(buf, size, "%s",
 			 "Error:\tUnable to find debugfs\n"
 			 "Hint:\tWas your kernel compiled with debugfs support?\n"
