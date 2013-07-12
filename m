Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab3GLIvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:51:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54734 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757453Ab3GLIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:50:26 -0400
Date: Fri, 12 Jul 2013 01:50:09 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-079787f209416416383c74ea5d5044be2d586f5e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, tglx@linutronix.de,
        iamjoonsoo.kim@lge.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, iamjoonsoo.kim@lge.com, tglx@linutronix.de
In-Reply-To: <1371603750-15053-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1371603750-15053-2-git-send-email-iamjoonsoo.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib lk: Fix for cross build
Git-Commit-ID: 079787f209416416383c74ea5d5044be2d586f5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:50:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  079787f209416416383c74ea5d5044be2d586f5e
Gitweb:     http://git.kernel.org/tip/079787f209416416383c74ea5d5044be2d586f5e
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Wed, 19 Jun 2013 10:02:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 17:36:17 -0300

tools lib lk: Fix for cross build

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
