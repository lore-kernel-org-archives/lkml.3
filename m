Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbaKUKzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:55:11 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:34969 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKUKzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:55:09 -0500
From: Steve Capper <steve.capper@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, will.deacon@arm.com,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steve Capper <steve.capper@linaro.org>
Subject: [PATCH] perf symbols: Consider the syms_ss in dso__load_sym
Date: Fri, 21 Nov 2014 10:54:57 +0000
Message-Id: <1416567297-9000-1-git-send-email-steve.capper@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dso__load_sym we only try to load the .debug_frame section from the
runtime image. For distros, the debug symbols are generally in a
separate file.

As a result, running perf report on arm64 can give errors such as:
"$file with build id $id not found, continuing without symbols"

Even when the debug symbols have been correctly installed (and loaded
by perf).

This patch adds logic to dso__load_sym to query syms_ss for the
.debug_frame section if it can't be found in the elf file pointed to by
runtime_ss.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
---
This patch is against 3.18-rc5.
---
 tools/perf/util/symbol-elf.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 1e23a5b..1336392 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -830,8 +830,11 @@ int dso__load_sym(struct dso *dso, struct map *map,
 			continue;
 
 		sec = elf_getscn(runtime_ss->elf, sym.st_shndx);
-		if (!sec)
-			goto out_elf_end;
+		if (!sec) {
+			sec = elf_getscn(syms_ss->elf, sym.st_shndx);
+			if (!sec)
+				goto out_elf_end;
+		}
 
 		gelf_getshdr(sec, &shdr);
 
-- 
1.9.3

