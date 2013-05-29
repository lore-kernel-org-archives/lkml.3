Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966333Ab3E2N6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:58:34 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46874 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966161Ab3E2N6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:58:31 -0400
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
        Rusty Russell <rusty@rustcorp.com.au>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v6, part4 06/41] tile: normalize global variables exported by vmlinux.lds
Date: Wed, 29 May 2013 21:57:24 +0800
Message-Id: <1369835879-23553-7-git-send-email-jiang.liu@huawei.com>
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
2) Export mandatory global variables __init_begin and __init_end.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Wen Congyang <wency@cn.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 arch/tile/include/asm/sections.h | 2 +-
 arch/tile/kernel/setup.c         | 4 ++--
 arch/tile/kernel/vmlinux.lds.S   | 4 +++-
 arch/tile/mm/init.c              | 2 +-
 4 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/tile/include/asm/sections.h b/arch/tile/include/asm/sections.h
index d062d46..7d8a935 100644
--- a/arch/tile/include/asm/sections.h
+++ b/arch/tile/include/asm/sections.h
@@ -34,7 +34,7 @@ extern char __sys_cmpxchg_grab_lock[];
 extern char __start_atomic_asm_code[], __end_atomic_asm_code[];
 #endif
 
-/* Handle the discontiguity between _sdata and _stext. */
+/* Handle the discontiguity between _sdata and _text. */
 static inline int arch_is_kernel_data(unsigned long addr)
 {
 	return addr >= (unsigned long)_sdata &&
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 7a5aa1a..41818e3 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -307,8 +307,8 @@ static void __cpuinit store_permanent_mappings(void)
 		hv_store_mapping(addr, pages << PAGE_SHIFT, pa);
 	}
 
-	hv_store_mapping((HV_VirtAddr)_stext,
-			 (uint32_t)(_einittext - _stext), 0);
+	hv_store_mapping((HV_VirtAddr)_text,
+			 (uint32_t)(_einittext - _text), 0);
 }
 
 /*
diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
index 631f10d..a13ed90 100644
--- a/arch/tile/kernel/vmlinux.lds.S
+++ b/arch/tile/kernel/vmlinux.lds.S
@@ -27,7 +27,6 @@ SECTIONS
   .intrpt1 (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
   {
     _text = .;
-    _stext = .;
     *(.intrpt1)
   } :intrpt1 =0
 
@@ -36,6 +35,7 @@ SECTIONS
 
   /* Now the real code */
   . = ALIGN(0x20000);
+  _stext = .;
   .text : AT (ADDR(.text) - LOAD_OFFSET) {
     HEAD_TEXT
     SCHED_TEXT
@@ -58,11 +58,13 @@ SECTIONS
   #define LOAD_OFFSET PAGE_OFFSET
 
   . = ALIGN(PAGE_SIZE);
+  __init_begin = .;
   VMLINUX_SYMBOL(_sinitdata) = .;
   INIT_DATA_SECTION(16) :data =0
   PERCPU_SECTION(L2_CACHE_BYTES)
   . = ALIGN(PAGE_SIZE);
   VMLINUX_SYMBOL(_einitdata) = .;
+  __init_end = .;
 
   _sdata = .;                   /* Start of data section */
 
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 45ce26d..f2ac2f4 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -562,7 +562,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 			prot = ktext_set_nocache(prot);
 		}
 
-		BUG_ON(address != (unsigned long)_stext);
+		BUG_ON(address != (unsigned long)_text);
 		pte = NULL;
 		for (; address < (unsigned long)_einittext;
 		     pfn++, address += PAGE_SIZE) {
-- 
1.8.1.2

