Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935028Ab3BNVox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:44:53 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:46994
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030254Ab3BNVos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:44:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/10] perf annotate: Fix warning message on a missing vmlinux
Date: Thu, 14 Feb 2013 18:44:15 -0300
Message-Id: <1360878263-12694-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360878263-12694-1-git-send-email-acme@infradead.org>
References: <1360878263-12694-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When perf annotate runs with no vmlinux file it cannot annotate kernel
symbols because the kallsyms only provides symbol addresses.  So it
recommends to run perf buildid-cache to install proper vmlinux image.

But running perf buildid-cache -av vmlinux as the message gives me a
following error:

  $ perf buildid-cache -av /home/namhyung/build/kernel/vmlinux
  Couldn't add v: No such file or directory

Since the -a option receives a parameter, 'v' should not be after the
option.

In addition -a option is not work for this case since the build-id cache
already has a kallsyms with same build-id so it'll fail with EEXIST.
Use recently added -u (--update) option for it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360227734-375-6-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 07aaeea..d33fe93 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -809,7 +809,7 @@ fallback:
 		pr_err("Can't annotate %s:\n\n"
 		       "No vmlinux file%s\nwas found in the path.\n\n"
 		       "Please use:\n\n"
-		       "  perf buildid-cache -av vmlinux\n\n"
+		       "  perf buildid-cache -vu vmlinux\n\n"
 		       "or:\n\n"
 		       "  --vmlinux vmlinux\n",
 		       sym->name, build_id_msg ?: "");
-- 
1.8.1.1.361.gec3ae6e

