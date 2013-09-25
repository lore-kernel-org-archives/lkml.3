Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab3IYSbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:31:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41563 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3IYSbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:31:51 -0400
Date: Wed, 25 Sep 2013 11:31:32 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-de95ab53645a2f0015e0f68ee723f18dce2b8b51@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1378998998-10802-1-git-send-email-andi@firstfloor.org>
References: <1378998998-10802-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Demangle cloned functions
Git-Commit-ID: de95ab53645a2f0015e0f68ee723f18dce2b8b51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 11:31:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  de95ab53645a2f0015e0f68ee723f18dce2b8b51
Gitweb:     http://git.kernel.org/tip/de95ab53645a2f0015e0f68ee723f18dce2b8b51
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 12 Sep 2013 08:16:38 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Sep 2013 12:58:21 -0300

perf symbols: Demangle cloned functions

The libbfd C++ demangler doesn't seem to deal with cloned functions,
like symbol.clone.NUM.

Just strip the dot part before demangling and add it back later.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1378998998-10802-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol-elf.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index a9c829b..d2a888e 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -928,8 +928,33 @@ int dso__load_sym(struct dso *dso, struct map *map,
 		 * to it...
 		 */
 		if (symbol_conf.demangle) {
-			demangled = bfd_demangle(NULL, elf_name,
+			/*
+			 * The demangler doesn't deal with cloned functions.
+			 * XXXX.clone.NUM or similar
+			 * Strip the dot part and readd it later.
+			 */
+			char *p = (char *)elf_name, *dot;
+			dot = strchr(elf_name, '.');
+			if (dot) {
+				p = strdup(elf_name);
+				if (!p)
+					goto new_symbol;
+				dot = strchr(p, '.');
+				*dot = 0;
+			}
+
+			demangled = bfd_demangle(NULL, p,
 						 DMGL_PARAMS | DMGL_ANSI);
+			if (dot)
+				*dot = '.';
+			if (demangled && dot) {
+				demangled = realloc(demangled, strlen(demangled) + strlen(dot) + 1);
+				if (!demangled)
+					goto new_symbol;
+				strcpy(demangled + (dot - p), dot);
+			}
+			if (p != elf_name)
+				free(p);
 			if (demangled != NULL)
 				elf_name = demangled;
 		}
