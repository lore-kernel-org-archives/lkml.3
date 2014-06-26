Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaFZUes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 16:34:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaFZUeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 16:34:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Cc: ebiederm@xmission.com, hpa@zytor.com, mjg59@srcf.ucam.org, greg@kroah.com,
        bp@alien8.de, dyoung@redhat.com, chaowang@redhat.com, bhe@redhat.com,
        akpm@linux-foundation.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 01/15] bin2c: Move bin2c in scripts/basic
Date: Thu, 26 Jun 2014 16:33:30 -0400
Message-Id: <1403814824-7587-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
References: <1403814824-7587-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec wants to use bin2c and it wants to use it really early in the build
process. See arch/x86/purgatory/ code in later patches.

So move bin2c in scripts/basic so that it can be built very early and
be usable by arch/x86/purgatory/

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 kernel/Makefile          |  2 +-
 scripts/.gitignore       |  1 -
 scripts/Makefile         |  1 -
 scripts/basic/.gitignore |  1 +
 scripts/basic/Makefile   |  1 +
 scripts/basic/bin2c.c    | 35 +++++++++++++++++++++++++++++++++++
 scripts/bin2c.c          | 36 ------------------------------------
 7 files changed, 38 insertions(+), 39 deletions(-)
 create mode 100644 scripts/basic/bin2c.c
 delete mode 100644 scripts/bin2c.c

diff --git a/kernel/Makefile b/kernel/Makefile
index f2a8b62..9b07bb7 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -105,7 +105,7 @@ targets += config_data.gz
 $(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
 	$(call if_changed,gzip)
 
-      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/bin2c; echo "MAGIC_END;")
+      filechk_ikconfiggz = (echo "static const char kernel_config_data[] __used = MAGIC_START"; cat $< | scripts/basic/bin2c; echo "MAGIC_END;")
 targets += config_data.h
 $(obj)/config_data.h: $(obj)/config_data.gz FORCE
 	$(call filechk,ikconfiggz)
diff --git a/scripts/.gitignore b/scripts/.gitignore
index fb070fa..5ecfe93 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -4,7 +4,6 @@
 conmakehash
 kallsyms
 pnmtologo
-bin2c
 unifdef
 ihex2fw
 recordmcount
diff --git a/scripts/Makefile b/scripts/Makefile
index 890df5c..72902b5 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -13,7 +13,6 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
-hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 hostprogs-$(CONFIG_ASN1)	 += asn1_compiler
diff --git a/scripts/basic/.gitignore b/scripts/basic/.gitignore
index a776371..9528ec9 100644
--- a/scripts/basic/.gitignore
+++ b/scripts/basic/.gitignore
@@ -1 +1,2 @@
 fixdep
+bin2c
diff --git a/scripts/basic/Makefile b/scripts/basic/Makefile
index 4fcef87..afbc1cd 100644
--- a/scripts/basic/Makefile
+++ b/scripts/basic/Makefile
@@ -9,6 +9,7 @@
 # fixdep: 	 Used to generate dependency information during build process
 
 hostprogs-y	:= fixdep
+hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 always		:= $(hostprogs-y)
 
 # fixdep is needed to compile other host programs
diff --git a/scripts/basic/bin2c.c b/scripts/basic/bin2c.c
new file mode 100644
index 0000000..af187e6
--- /dev/null
+++ b/scripts/basic/bin2c.c
@@ -0,0 +1,35 @@
+/*
+ * Unloved program to convert a binary on stdin to a C include on stdout
+ *
+ * Jan 1999 Matt Mackall <mpm@selenic.com>
+ *
+ * This software may be used and distributed according to the terms
+ * of the GNU General Public License, incorporated herein by reference.
+ */
+
+#include <stdio.h>
+
+int main(int argc, char *argv[])
+{
+	int ch, total = 0;
+
+	if (argc > 1)
+		printf("const char %s[] %s=\n",
+			argv[1], argc > 2 ? argv[2] : "");
+
+	do {
+		printf("\t\"");
+		while ((ch = getchar()) != EOF) {
+			total++;
+			printf("\\x%02x", ch);
+			if (total % 16 == 0)
+				break;
+		}
+		printf("\"\n");
+	} while (ch != EOF);
+
+	if (argc > 1)
+		printf("\t;\n\nconst int %s_size = %d;\n", argv[1], total);
+
+	return 0;
+}
diff --git a/scripts/bin2c.c b/scripts/bin2c.c
deleted file mode 100644
index 96dd2bc..0000000
--- a/scripts/bin2c.c
+++ /dev/null
@@ -1,36 +0,0 @@
-/*
- * Unloved program to convert a binary on stdin to a C include on stdout
- *
- * Jan 1999 Matt Mackall <mpm@selenic.com>
- *
- * This software may be used and distributed according to the terms
- * of the GNU General Public License, incorporated herein by reference.
- */
-
-#include <stdio.h>
-
-int main(int argc, char *argv[])
-{
-	int ch, total=0;
-
-	if (argc > 1)
-		printf("const char %s[] %s=\n",
-			argv[1], argc > 2 ? argv[2] : "");
-
-	do {
-		printf("\t\"");
-		while ((ch = getchar()) != EOF)
-		{
-			total++;
-			printf("\\x%02x",ch);
-			if (total % 16 == 0)
-				break;
-		}
-		printf("\"\n");
-	} while (ch != EOF);
-
-	if (argc > 1)
-		printf("\t;\n\nconst int %s_size = %d;\n", argv[1], total);
-
-	return 0;
-}
-- 
1.9.0

