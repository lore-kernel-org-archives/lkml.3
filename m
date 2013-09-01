Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572Ab3IAPao (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 11:30:44 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54751 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757529Ab3IAPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 11:30:40 -0400
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
Subject: [PATCH 2/3] perf core: Fix a mmap & munmap mismatches bug in dso__load
Date: Sun,  1 Sep 2013 23:29:44 +0800
Message-Id: <1378049385-4466-2-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378049385-4466-1-git-send-email-chenggang.qin@gmail.com>
References: <1378049385-4466-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chenggang Qin <chenggang.qcg@taobao.com>

Some dsos' symsrc is neither syms_ss or runtime_ss. In this situation, the
corresponding ELF file is opened and mmapped in symsrc__init(), but they will
be not closed and munmapped in any place.
This bug can lead to mmap & munmap mismatched, the mmap areas will exist during
the life of perf. We can think this is a memory leak.
This patch fixed the bug. symsrc__destroy() is called while the opened and
mmaped ELF file has neither symtlb section nor dynsym section, and opdsec
section.
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
 tools/perf/util/symbol.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index d5528e1..9675866 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -828,7 +828,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 			if (syms_ss && runtime_ss)
 				break;
-		}
+		} else
+			symsrc__destroy(ss);
 
 	}
 
-- 
1.7.8.rc2.5.g815b

