Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaLaB0F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 20:26:05 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:40566 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaLaBW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 20:22:26 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/19] lib/list_sort.c: Rearrange includes
Date: Wed, 31 Dec 2014 02:21:42 +0100
Message-Id: <1419988915-20730-8-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1419988915-20730-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memory allocation only happens in the self test, just as random
numbers are only used there. So move the inclusion of slab.h inside
the CONFIG_TEST_LIST_SORT.

We don't need module.h and all of the stuff it carries with it, so
replace with export.h and compiler.h. Unfortunately, the ARRAY_SIZE
macro from kernel.h requires the user to ensure bug.h is also included
(for BUILD_BUG_ON_ZERO, used by __must_be_array). We used to get that
through some maze of nested includes, but just include it explicitly.

linux/string.h is then only included implicitly through
kernel.h->printk.h->dynamic_debug.h, but only if
!CONFIG_DYNAMIC_DEBUG, so just include it explicitly (for memset).

objdump -d says the generated code is the same, and wc -l says that
lib/.list_sort.o.cmd went from 579 to 165 lines.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 lib/list_sort.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/lib/list_sort.c b/lib/list_sort.c
index 12bcba1c8612..b29015102698 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -2,9 +2,11 @@
 #define pr_fmt(fmt) "list_sort_test: " fmt
 
 #include <linux/kernel.h>
-#include <linux/module.h>
+#include <linux/bug.h>
+#include <linux/compiler.h>
+#include <linux/export.h>
+#include <linux/string.h>
 #include <linux/list_sort.h>
-#include <linux/slab.h>
 #include <linux/list.h>
 
 #define MAX_LIST_LENGTH_BITS 20
@@ -146,6 +148,7 @@ EXPORT_SYMBOL(list_sort);
 
 #ifdef CONFIG_TEST_LIST_SORT
 
+#include <linux/slab.h>
 #include <linux/random.h>
 
 /*
-- 
2.1.3

