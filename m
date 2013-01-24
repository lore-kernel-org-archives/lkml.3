Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab3AXSpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:45:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32778 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3AXSpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:45:24 -0500
Date: Thu, 24 Jan 2013 10:44:57 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-3843b05d6ef20acbd4b0043e4ab7536602eb10ae@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1353502185-26521-19-git-send-email-eranian@google.com>
References: <1353502185-26521-19-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Ignore ABS symbols when loading data maps
Git-Commit-ID: 3843b05d6ef20acbd4b0043e4ab7536602eb10ae
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:45:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3843b05d6ef20acbd4b0043e4ab7536602eb10ae
Gitweb:     http://git.kernel.org/tip/3843b05d6ef20acbd4b0043e4ab7536602eb10ae
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 21 Nov 2012 13:49:44 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:05 -0300

perf symbols: Ignore ABS symbols when loading data maps

When loading symbols in a data mapping, ABS symbols (which has a value
of SHN_ABS in its st_shndx) failed at elf_getscn().  And it marks the
loading as a failure so already loaded symbols cannot be fixed up.

I'm not sure what should be done. Just ignore them for now. :)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1353502185-26521-19-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index db0cc92..f63557b 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -718,6 +718,17 @@ int dso__load_sym(struct dso *dso, struct map *map,
 					sym.st_value);
 			used_opd = true;
 		}
+		/*
+		 * When loading symbols in a data mapping, ABS symbols (which
+		 * has a value of SHN_ABS in its st_shndx) failed at
+		 * elf_getscn().  And it marks the loading as a failure so
+		 * already loaded symbols cannot be fixed up.
+		 *
+		 * I'm not sure what should be done. Just ignore them for now.
+		 * - Namhyung Kim
+		 */
+		if (sym.st_shndx == SHN_ABS)
+			continue;
 
 		sec = elf_getscn(runtime_ss->elf, sym.st_shndx);
 		if (!sec)
