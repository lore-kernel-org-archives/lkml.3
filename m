Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab3B0DJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 22:09:48 -0500
Received: from mail1.windriver.com ([147.11.146.13]:62588 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759890Ab3B0DJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 22:09:46 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: [v3][PATCH 5/6] kgdb/kgdbts: support ppc64
Date: Wed, 27 Feb 2013 11:09:27 +0800
Message-ID: <1361934568-31989-6-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361934568-31989-1-git-send-email-tiejun.chen@windriver.com>
References: <1361934568-31989-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't look up the address of the entry point of the function simply
via that function symbol for all architectures.

For PPC64 ABI, actually there is a function descriptors structure.

A function descriptor is a three doubleword data structure that contains
the following values:
	* The first doubleword contains the address of the entry point of
		the function.
	* The second doubleword contains the TOC base address for
		the function.
	* The third doubleword contains the environment pointer for
		languages such as Pascal and PL/1.

So we should call a wapperred dereference_function_descriptor() to get
the address of the entry point of the function.

Note this is also safe for other architecture after refer to
"include/asm-generic/sections.h" since:

dereference_function_descriptor(p) always is (p) if without arched definition.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 drivers/misc/kgdbts.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 3aa9a96..4799e1f 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -103,6 +103,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/module.h>
+#include <asm/sections.h>
 
 #define v1printk(a...) do { \
 	if (verbose) \
@@ -222,6 +223,7 @@ static unsigned long lookup_addr(char *arg)
 		addr = (unsigned long)do_fork;
 	else if (!strcmp(arg, "hw_break_val"))
 		addr = (unsigned long)&hw_break_val;
+	addr = (unsigned long )dereference_function_descriptor((void *)addr);
 	return addr;
 }
 
-- 
1.7.9.5

