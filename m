Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbaC0To3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 15:44:29 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63491 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679AbaC0TmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 15:42:10 -0400
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>
Subject: [RFC PATCH 2/4] ARM: align cpu_method_of_table naming
Date: Thu, 27 Mar 2014 14:41:55 -0500
Message-Id: <1395949317-8738-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
References: <1395949317-8738-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The cpu_method_of_table is the oddball of the various OF linker sections.
In preparation to have common linker section definitions, align the
cpu_method_of_table with the other definitions for the naming and ending
with a blank struct.

Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/kernel/devtree.c         | 11 +++++++----
 include/asm-generic/vmlinux.lds.h |  4 ++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index c7419a5..bdac7a9 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -65,18 +65,21 @@ void __init arm_dt_memblock_reserve(void)
 }
 
 #ifdef CONFIG_SMP
-extern struct of_cpu_method __cpu_method_of_table_begin[];
-extern struct of_cpu_method __cpu_method_of_table_end[];
+extern struct of_cpu_method __cpu_method_of_table[];
+
+static const struct of_cpu_method __cpu_method_of_table_sentinel
+	__used __section(__cpu_method_of_table_end);
+
 
 static int __init set_smp_ops_by_method(struct device_node *node)
 {
 	const char *method;
-	struct of_cpu_method *m = __cpu_method_of_table_begin;
+	struct of_cpu_method *m = __cpu_method_of_table;
 
 	if (of_property_read_string(node, "enable-method", &method))
 		return 0;
 
-	for (; m < __cpu_method_of_table_end; m++)
+	for (; m->method; m++)
 		if (!strcmp(m->method, method)) {
 			smp_set_ops(m->ops);
 			return 1;
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f8d1783..d09e670 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -169,9 +169,9 @@
 
 #ifdef CONFIG_SMP
 #define CPU_METHOD_OF_TABLES() . = ALIGN(8);				    \
-			   VMLINUX_SYMBOL(__cpu_method_of_table_begin) = .; \
+			   VMLINUX_SYMBOL(__cpu_method_of_table) = .; \
 			   *(__cpu_method_of_table)			    \
-			   VMLINUX_SYMBOL(__cpu_method_of_table_end) = .;
+			   *(__cpu_method_of_table_end)
 #else
 #define CPU_METHOD_OF_TABLES()
 #endif
-- 
1.8.3.2

