Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102Ab3IDOng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:43:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935078Ab3IDOnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:43:21 -0400
From: Frantisek Hrbata <fhrbata@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jstancek@redhat.com, keescook@chromium.org, peter.oberparleiter@de.ibm.com,
        rusty@rustcorp.com.au, linux-arch@vger.kernel.org, arnd@arndb.de,
        mgahagan@redhat.com, agospoda@redhat.com, akpm@linux-foundation.org
Subject: [PATCH v2 4/4] kernel: add support for init_array constructors
Date: Wed,  4 Sep 2013 16:42:56 +0200
Message-Id: <1378305776-3644-5-git-send-email-fhrbata@redhat.com>
In-Reply-To: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
References: <1378305776-3644-1-git-send-email-fhrbata@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the .init_array section as yet another section with constructors. This
is needed because gcc could add __gcov_init calls to .init_array or .ctors
section, depending on gcc version.

v2: - reuse mod->ctors for .init_array section for modules, because gcc uses
      .ctors or .init_array, but not both at the same time

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
---
 include/asm-generic/vmlinux.lds.h | 1 +
 kernel/module.c                   | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 69732d2..c55d8d9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -468,6 +468,7 @@
 #define KERNEL_CTORS()	. = ALIGN(8);			   \
 			VMLINUX_SYMBOL(__ctors_start) = .; \
 			*(.ctors)			   \
+			*(.init_array)			   \
 			VMLINUX_SYMBOL(__ctors_end) = .;
 #else
 #define KERNEL_CTORS()
diff --git a/kernel/module.c b/kernel/module.c
index 2069158..bbbd953 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2760,6 +2760,9 @@ static void find_module_sections(struct module *mod, struct load_info *info)
 #ifdef CONFIG_CONSTRUCTORS
 	mod->ctors = section_objs(info, ".ctors",
 				  sizeof(*mod->ctors), &mod->num_ctors);
+	if (!mod->ctors)
+		mod->ctors = section_objs(info, ".init_array",
+				sizeof(*mod->ctors), &mod->num_ctors);
 #endif
 
 #ifdef CONFIG_TRACEPOINTS
-- 
1.8.3.1

