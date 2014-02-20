Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaBTBdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 20:33:07 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58001 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaBTBdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 20:33:05 -0500
X-AuditID: 9c93016f-b7c65ae000004a2a-54-53055b4c30ec
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 3/4] perf tools: Check return value of filename__read_debuglink()
Date: Thu, 20 Feb 2014 10:32:55 +0900
Message-Id: <1392859976-32760-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392859976-32760-1-git-send-email-namhyung@kernel.org>
References: <1392859976-32760-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

When dso__read_binary_type_filename() called, it doesn't check the
return value of filename__read_debuglink() so that it'll try to open
the debuglink file even if it doesn't exist.

Also fix return value of the filename__read_debuglink() as it always
return -1 regardless of the result.

Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
Stephane, can I add your s-o-b here?

 tools/perf/util/dso.c        | 4 ++--
 tools/perf/util/symbol-elf.c | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 4045d086d9d9..64453d63b971 100644
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
index 3e9f336740fa..8ac4a4fe2abd 100644
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
-- 
1.7.11.7

