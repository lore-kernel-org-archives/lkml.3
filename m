Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab3IAPa6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:30:58 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50770 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3IAPa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:30:56 -0400
From: Chenggang Qin <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Chenggang Qin <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] perf core: Fix a memory leak bug because symbol__delete is ignored
Date: Sun,  1 Sep 2013 23:29:45 +0800
Message-Id: <1378049385-4466-3-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378049385-4466-1-git-send-email-chenggang.qin@gmail.com>
References: <1378049385-4466-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

In function symbols__fixup_duplicate(), while the duplicated symbols are found,
only the rb_node are deleted. The symbol structures themself are ignored.
Then, these memory areas are lost.
This patch fixed the bug. 
Thanks.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/util/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9675866..3c9aa6f 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -148,10 +148,12 @@ again:
 
 		if (choose_best_symbol(curr, next) == SYMBOL_A) {
 			rb_erase(&next->rb_node, symbols);
+			symbol__delete(next);
 			goto again;
 		} else {
 			nd = rb_next(&curr->rb_node);
 			rb_erase(&curr->rb_node, symbols);
+			symbol__delete(curr);
 		}
 	}
 }
-- 
1.7.8.rc2.5.g815b

