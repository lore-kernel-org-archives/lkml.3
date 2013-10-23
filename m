Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350Ab3JWDS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 23:18:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36409 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3JWDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 23:18:55 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Chen Gang <gang.chen@asianux.com>
Subject: [RFC PATCH] kernel/kallsyms.c: only show legal kernel symbol
Date: Wed, 23 Oct 2013 11:18:40 +0800
Message-Id: <1382498320-26594-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address of non-module kernel symbol should always be located
from CONFIG_PAGE_OFFSET on, so only show these legal kernel
symbols in /proc/kallsyms.

On ARM, some symbols(see below) may drop in relocatable code, so
perf can't parse kernel symbols any more from /proc/kallsyms, this
patch fixes the problem.

	00000000 t __vectors_start
	00000020 A cpu_v7_suspend_size
	00001000 t __stubs_start
	00001004 t vector_rst
	00001020 t vector_irq
	000010a0 t vector_dabt
	00001120 t vector_pabt
	000011a0 t vector_und
	00001220 t vector_addrexcptn
	00001224 t vector_fiq
	00001224 T vector_fiq_offset

The issue can be fixed in scripts/kallsyms.c too, but looks this
approach is easier.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 3127ad5..184f271 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -543,7 +543,7 @@ static int s_show(struct seq_file *m, void *p)
 					tolower(iter->type);
 		seq_printf(m, "%pK %c %s\t[%s]\n", (void *)iter->value,
 			   type, iter->name, iter->module_name);
-	} else
+	} else if (iter->value >= CONFIG_PAGE_OFFSET)
 		seq_printf(m, "%pK %c %s\n", (void *)iter->value,
 			   iter->type, iter->name);
 	return 0;
-- 
1.7.9.5

