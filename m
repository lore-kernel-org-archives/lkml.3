Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaFDN1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 09:27:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbaFDN1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 09:27:16 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/2] perf probe: Fix perf probe to find correct variable DIE
Date: Wed,  4 Jun 2014 15:27:00 +0200
Message-Id: <1401888420-23191-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1401888420-23191-1-git-send-email-jolsa@kernel.org>
References: <1401888420-23191-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix perf probe to find correct variable DIE which has location or
external instance by tracking down the lexical blocks.

Current die_find_variable() expects that the all variable DIEs
which has DW_TAG_variable have a location. However, since recent
dwarf information may have declaration variable DIEs at the
entry of function (subprogram), die_find_variable() returns it.

To solve this problem, it must track down the DIE tree to find
a DIE which has an actual location or a reference for external
instance.

e.g. finding a DIE which origin is <0xdc73>;

 <1><11496>: Abbrev Number: 95 (DW_TAG_subprogram)
    <11497>   DW_AT_abstract_origin: <0xdc42>
    <1149b>   DW_AT_low_pc      : 0x1850
[...]
 <2><114cc>: Abbrev Number: 119 (DW_TAG_variable) <- this is a declaration
    <114cd>   DW_AT_abstract_origin: <0xdc73>
 <2><114d1>: Abbrev Number: 119 (DW_TAG_variable)
[...]
 <3><115a7>: Abbrev Number: 105 (DW_TAG_lexical_block)
    <115a8>   DW_AT_ranges      : 0xaa0
 <4><115ac>: Abbrev Number: 96 (DW_TAG_variable) <- this has a location
    <115ad>   DW_AT_abstract_origin: <0xdc73>
    <115b1>   DW_AT_location    : 0x486c        (location list)

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Tested-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Acked-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20140529121930.30879.87092.stgit@ltc230.yrl.intra.hitachi.co.jp
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 7defd77..cc66c40 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -747,14 +747,17 @@ struct __find_variable_param {
 static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
 {
 	struct __find_variable_param *fvp = data;
+	Dwarf_Attribute attr;
 	int tag;
 
 	tag = dwarf_tag(die_mem);
 	if ((tag == DW_TAG_formal_parameter ||
 	     tag == DW_TAG_variable) &&
-	    die_compare_name(die_mem, fvp->name))
+	    die_compare_name(die_mem, fvp->name) &&
+	/* Does the DIE have location information or external instance? */
+	    (dwarf_attr(die_mem, DW_AT_external, &attr) ||
+	     dwarf_attr(die_mem, DW_AT_location, &attr)))
 		return DIE_FIND_CB_END;
-
 	if (dwarf_haspc(die_mem, fvp->addr))
 		return DIE_FIND_CB_CONTINUE;
 	else
-- 
1.8.3.1

