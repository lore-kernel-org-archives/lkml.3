Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbaB0Na1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 08:30:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54844 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaB0NaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 08:30:25 -0500
Date: Thu, 27 Feb 2014 05:29:50 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-98e9f03bbf2cb21a60f94b8b700eb5d38470819d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        eranian@google.com, hpa@zytor.com, mingo@kernel.org,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        cody@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, tglx@linutronix.de
In-Reply-To: <1392859976-32760-2-git-send-email-namhyung@kernel.org>
References: <1392859976-32760-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Destroy unused symsrcs
Git-Commit-ID: 98e9f03bbf2cb21a60f94b8b700eb5d38470819d
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

Commit-ID:  98e9f03bbf2cb21a60f94b8b700eb5d38470819d
Gitweb:     http://git.kernel.org/tip/98e9f03bbf2cb21a60f94b8b700eb5d38470819d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 20 Feb 2014 10:32:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Feb 2014 11:13:08 -0300

perf symbols: Destroy unused symsrcs

Stephane reported that perf report and annotate failed to process data
using lots of (> 500) shared libraries.  It was because of the limit on
number of open files (ulimit -n).

Currently when perf loads a DSO, it'll look for normal and dynamic
symbol tables.  And if it fails to find out both tables, it'll iterate
all of possible symtab types.  But many of them are useless since they
have no additional information and the problem is that it's not closing
those files even though they're not used.  Fix it.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1392859976-32760-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a9d758a..e89afc0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1336,6 +1336,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 			if (syms_ss && runtime_ss)
 				break;
+		} else {
+			symsrc__destroy(ss);
 		}
 
 	}
