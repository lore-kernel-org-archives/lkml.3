Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933642Ab3JOFgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:36:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab3JOFgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:36:15 -0400
Date: Mon, 14 Oct 2013 22:35:50 -0700
From: tip-bot for Chenggang Qin <tipbot@zytor.com>
Message-ID: <tip-d4f74eb89199dc7bde5579783e9188841e1271e3@git.kernel.org>
Cc: acme@redhat.com, mingo@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, akpm@linux-foundation.org,
        yanmin.zhang@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        namhyung@kernel.org, namhyung@gmail.com, chenggang.qcg@taobao.com
Reply-To: mingo@kernel.org, mingo@redhat.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, akpm@linux-foundation.org,
        yanmin.zhang@intel.com, dsahern@gmail.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, arjan@linux.intel.com,
        namhyung@kernel.org, namhyung@gmail.com, chenggang.qcg@taobao.com
In-Reply-To: <1381451279-4109-3-git-send-email-chenggang.qin@gmail.com>
References: <1381451279-4109-3-git-send-email-chenggang.qin@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols:
  Fix a memory leak due to symbol__delete not being used
Git-Commit-ID: d4f74eb89199dc7bde5579783e9188841e1271e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:35:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4f74eb89199dc7bde5579783e9188841e1271e3
Gitweb:     http://git.kernel.org/tip/d4f74eb89199dc7bde5579783e9188841e1271e3
Author:     Chenggang Qin <chenggang.qcg@taobao.com>
AuthorDate: Fri, 11 Oct 2013 08:27:59 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 12:21:20 -0300

perf symbols: Fix a memory leak due to symbol__delete not being used

In function symbols__fixup_duplicate(), while duplicated symbols are
found, only the rb_node is removed from the tree. The symbol structures
themself are ignored.  Then, these memory areas are lost.

Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Link: http://lkml.kernel.org/r/1381451279-4109-3-git-send-email-chenggang.qin@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b66c1ee..c0c3696 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -160,10 +160,12 @@ again:
 
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
