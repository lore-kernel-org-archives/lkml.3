Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3GJTTu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:19:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56795 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3GJTTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:19:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/23] tools lib lk: Fix for cross build
Date: Wed, 10 Jul 2013 16:19:06 -0300
Message-Id: <1373483963-19277-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Currently, lib lk doesn't use CROSS_COMPILE environment variable, so
cross build always fails.

This is a quick fix for this problem.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1371603750-15053-2-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/lk/Makefile | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/tools/lib/lk/Makefile b/tools/lib/lk/Makefile
index 2c5a197..f0ecc0a 100644
--- a/tools/lib/lk/Makefile
+++ b/tools/lib/lk/Makefile
@@ -3,6 +3,21 @@ include ../../scripts/Makefile.include
 CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
+# Makefiles suck: This macro sets a default value of $(2) for the
+# variable named by $(1), unless the variable has been set by
+# environment or command line. This is necessary for CC and AR
+# because make sets default values, so the simpler ?= approach
+# won't work as expected.
+define allow-override
+  $(if $(or $(findstring environment,$(origin $(1))),\
+            $(findstring command line,$(origin $(1)))),,\
+    $(eval $(1) = $(2)))
+endef
+
+# Allow setting CC and AR, or setting CROSS_COMPILE as a prefix.
+$(call allow-override,CC,$(CROSS_COMPILE)gcc)
+$(call allow-override,AR,$(CROSS_COMPILE)ar)
+
 # guard against environment variables
 LIB_H=
 LIB_OBJS=
-- 
1.8.1.4

