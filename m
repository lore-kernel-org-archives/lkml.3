Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966349Ab3E2N6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:58:38 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:65386 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966336Ab3E2N6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:58:35 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: [PATCH v6, part4 07/41] UML: normalize global variables exported by vmlinux.lds
Date: Wed, 29 May 2013 21:57:25 +0800
Message-Id: <1369835879-23553-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
References: <1369835879-23553-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normalize global variables exported by vmlinux.lds to conform usage
guidelines from include/asm-generic/sections.h.

1) Use _text to mark the start of the kernel image including the head
text, and _stext to mark the start of the .text section.
2) Export mandatory global variables __bss_stop.
3) Adjust __init_begin and __init_end to avoid acrossing .text and
   .data sections.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: user-mode-linux-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
---
 arch/um/include/asm/common.lds.S | 1 -
 arch/um/kernel/dyn.lds.S         | 6 ++++--
 arch/um/kernel/uml.lds.S         | 7 +++++--
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/um/include/asm/common.lds.S b/arch/um/include/asm/common.lds.S
index 4938de5..1dd5bd8 100644
--- a/arch/um/include/asm/common.lds.S
+++ b/arch/um/include/asm/common.lds.S
@@ -57,7 +57,6 @@
 	*(.uml.initcall.init)
 	__uml_initcall_end = .;
   }
-  __init_end = .;
 
   SECURITY_INIT
 
diff --git a/arch/um/kernel/dyn.lds.S b/arch/um/kernel/dyn.lds.S
index fb8fd6f..adde088 100644
--- a/arch/um/kernel/dyn.lds.S
+++ b/arch/um/kernel/dyn.lds.S
@@ -14,8 +14,6 @@ SECTIONS
   __binary_start = .;
   . = ALIGN(4096);		/* Init code and data */
   _text = .;
-  _stext = .;
-  __init_begin = .;
   INIT_TEXT_SECTION(PAGE_SIZE)
 
   . = ALIGN(PAGE_SIZE);
@@ -67,6 +65,7 @@ SECTIONS
   } =0x90909090
   .plt            : { *(.plt) }
   .text           : {
+    _stext = .;
     TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
@@ -91,7 +90,9 @@ SECTIONS
 
   #include <asm/common.lds.S>
 
+  __init_begin = .;
   init.data : { INIT_DATA }
+  __init_end = .;
 
   /* Ensure the __preinit_array_start label is properly aligned.  We
      could instead move the label definition inside the section, but
@@ -155,6 +156,7 @@ SECTIONS
    . = ALIGN(32 / 8);
   . = ALIGN(32 / 8);
   }
+   __bss_stop = .;
   _end = .;
   PROVIDE (end = .);
 
diff --git a/arch/um/kernel/uml.lds.S b/arch/um/kernel/uml.lds.S
index ff65fb4..6899195 100644
--- a/arch/um/kernel/uml.lds.S
+++ b/arch/um/kernel/uml.lds.S
@@ -20,13 +20,12 @@ SECTIONS
   . = START + SIZEOF_HEADERS;
 
   _text = .;
-  _stext = .;
-  __init_begin = .;
   INIT_TEXT_SECTION(0)
   . = ALIGN(PAGE_SIZE);
 
   .text      :
   {
+    _stext = .;
     TEXT_TEXT
     SCHED_TEXT
     LOCK_TEXT
@@ -62,7 +61,10 @@ SECTIONS
 
   #include <asm/common.lds.S>
 
+  __init_begin = .;
   init.data : { INIT_DATA }
+  __init_end = .;
+
   .data    :
   {
     INIT_TASK_DATA(KERNEL_STACK_SIZE)
@@ -97,6 +99,7 @@ SECTIONS
   PROVIDE(_bss_start = .);
   SBSS(0)
   BSS(0)
+   __bss_stop = .;
   _end = .;
   PROVIDE (end = .);
 
-- 
1.8.1.2

