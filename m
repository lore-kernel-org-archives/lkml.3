Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3CEAtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 19:49:50 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:48275 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569Ab3CEAtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 19:49:49 -0500
Date: Mon, 4 Mar 2013 16:49:11 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ksm: fix m68k build: only NUMA needs pfn_to_nid
Message-ID: <alpine.LNX.2.00.1303041644020.24822@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A CONFIG_DISCONTIGMEM=y m68k config gave

mm/ksm.c: In function `get_kpfn_nid':
mm/ksm.c:492: error: implicit declaration of function `pfn_to_nid'

linux/mmzone.h declares it for CONFIG_SPARSEMEM and CONFIG_FLATMEM, but
expects the arch's asm/mmzone.h to declare it for CONFIG_DISCONTIGMEM
(see arch/mips/include/asm/mmzone.h for example).

Or perhaps it is only expected when CONFIG_NUMA=y: too much of a maze,
and m68k got away without it so far, so fix the build in mm/ksm.c.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
---
Sorry, the non-ASCII quoting in the version I sent earlier threw
alpine into quoted-printable, hence a patch that would not apply:
I hope this version fares better.

 mm/ksm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.9-rc1/mm/ksm.c	2013-03-03 19:35:40.120006587 -0800
+++ linux/mm/ksm.c	2013-03-04 14:20:12.464047569 -0800
@@ -489,7 +489,7 @@ out:		page = NULL;
  */
 static inline int get_kpfn_nid(unsigned long kpfn)
 {
-	return ksm_merge_across_nodes ? 0 : pfn_to_nid(kpfn);
+	return ksm_merge_across_nodes ? 0 : NUMA(pfn_to_nid(kpfn));
 }
 
 static void remove_node_from_stable_tree(struct stable_node *stable_node)
