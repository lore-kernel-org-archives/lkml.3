Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750974Ab3GKEcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 00:32:54 -0400
Received: from ozlabs.org ([203.10.76.45]:41706 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab3GKEcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 00:32:53 -0400
Date: Thu, 11 Jul 2013 14:33:01 +1000
From: Anton Blanchard <anton@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf annotate: Fix SEGV with assembly labels
Message-ID: <20130711143301.1f014c7b@kryten>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm getting a SEGV when running perf annotate on a ppc64 box. The
objdump -S output causing the SEGV looks like:

        b       .ret_from_except_lite
c00000000000a508:       b       c00000000000a4d4 <.ret_from_except_lite>

1:      bl      .save_nvgprs
c00000000000a50c:       bl      c00000000000a110 <.save_nvgprs>

symbol__parse_objdump_line makes an effort to distinguish between
instruction addresses and assembly labels but the check is
insufficent.

In the above case we get line_ip = 1, and (line_ip - start) is
positive so our offset < 0 check does not catch it.

Fix this by adding an unsigned comparison against start.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org>
---

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index d102716..a791d23 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -809,7 +809,7 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		    end = map__rip_2objdump(map, sym->end);
 
 		offset = line_ip - start;
-		if (offset < 0 || (u64)line_ip > end)
+		if (offset < 0 || (u64)line_ip < start || (u64)line_ip > end)
 			offset = -1;
 		else
 			parsed_line = tmp2 + 1;
