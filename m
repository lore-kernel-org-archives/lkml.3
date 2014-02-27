Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaB0Nac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:30:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaB0Na1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:30:27 -0500
Date: Thu, 27 Feb 2014 05:30:01 -0800
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-0d3dc5e8b85a144aaeb5dc26f7f2113e4c4e7e81@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <1392859976-32760-3-git-send-email-namhyung@kernel.org>
References: <1392859976-32760-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Check return value of filename__read_debuglink()
Git-Commit-ID: 0d3dc5e8b85a144aaeb5dc26f7f2113e4c4e7e81
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

Commit-ID:  0d3dc5e8b85a144aaeb5dc26f7f2113e4c4e7e81
Gitweb:     http://git.kernel.org/tip/0d3dc5e8b85a144aaeb5dc26f7f2113e4c4e7e81
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 20 Feb 2014 10:32:55 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 16:24:38 -0300

perf symbols: Check return value of filename__read_debuglink()

When dso__read_binary_type_filename() called, it doesn't check the
return value of filename__read_debuglink() so that it'll try to open the
debuglink file even if it doesn't exist.

Also fix return value of the filename__read_debuglink() as it always
return -1 regardless of the result.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392859976-32760-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c        | 4 ++--
 tools/perf/util/symbol-elf.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 4045d08..64453d6 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -45,8 +45,8 @@ int dso__read_binary_type_filename(const struct dso *dso,
 			debuglink--;
 		if (*debuglink == '/')
 			debuglink++;
-		filename__read_debuglink(dso->long_name, debuglink,
-					 size - (debuglink - filename));
+		ret = filename__read_debuglink(dso->long_name, debuglink,
+					       size - (debuglink - filename));
 		}
 		break;
 	case DSO_BINARY_TYPE__BUILD_ID_CACHE:
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3e9f336..8ac4a4f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -506,6 +506,8 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 	/* the start of this section is a zero-terminated string */
 	strncpy(debuglink, data->d_buf, size);
 
+	err = 0;
+
 out_elf_end:
 	elf_end(elf);
 out_close:
