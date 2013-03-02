Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3CEHHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 02:07:33 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50291 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3CEHGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 02:06:38 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH v2 18/20] vmcore: round-up offset of vmcore object in
 page-size boundary
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 02 Mar 2013 17:37:31 +0900
Message-ID: <20130302083731.31252.30477.stgit@localhost6.localdomain6>
In-Reply-To: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
References: <20130302083447.31252.93914.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To satisfy mmap()'s page-size bounary requirement, round-up offset of
each vmcore objects in page-size boundary; each offset is connected to
user-space virtual address through mapping of mmap().

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---

 fs/proc/vmcore.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 5582aaa..6660cd5 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -700,7 +700,7 @@ static int __init process_ptload_program_headers_elf32(char *elfptr,
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf64(char *elfptr,
+static void __init set_vmcore_list_offsets_elf64(char *elfptr, size_t elfsz,
 						struct list_head *vc_list)
 {
 	loff_t vmcore_off;
@@ -710,17 +710,16 @@ static void __init set_vmcore_list_offsets_elf64(char *elfptr,
 	ehdr_ptr = (Elf64_Ehdr *)elfptr;
 
 	/* Skip Elf header and program headers. */
-	vmcore_off = ehdr_ptr->e_phoff +
-			(ehdr_ptr->e_phnum) * sizeof(Elf64_Phdr);
+	vmcore_off = elfsz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
-		vmcore_off += m->size;
+		vmcore_off += roundup(m->size, PAGE_SIZE);
 	}
 }
 
 /* Sets offset fields of vmcore elements. */
-static void __init set_vmcore_list_offsets_elf32(char *elfptr,
+static void __init set_vmcore_list_offsets_elf32(char *elfptr, size_t elfsz,
 						struct list_head *vc_list)
 {
 	loff_t vmcore_off;
@@ -730,12 +729,11 @@ static void __init set_vmcore_list_offsets_elf32(char *elfptr,
 	ehdr_ptr = (Elf32_Ehdr *)elfptr;
 
 	/* Skip Elf header and program headers. */
-	vmcore_off = ehdr_ptr->e_phoff +
-			(ehdr_ptr->e_phnum) * sizeof(Elf32_Phdr);
+	vmcore_off = elfsz;
 
 	list_for_each_entry(m, vc_list, list) {
 		m->offset = vmcore_off;
-		vmcore_off += m->size;
+		vmcore_off += roundup(m->size, PAGE_SIZE);
 	}
 }
 
@@ -795,7 +793,7 @@ static int __init parse_crash_elf64_headers(void)
 			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
-	set_vmcore_list_offsets_elf64(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets_elf64(elfcorebuf, elfcorebuf_sz, &vmcore_list);
 	return 0;
 }
 
@@ -855,7 +853,7 @@ static int __init parse_crash_elf32_headers(void)
 			   get_order(elfcorebuf_sz_orig));
 		return rc;
 	}
-	set_vmcore_list_offsets_elf32(elfcorebuf, &vmcore_list);
+	set_vmcore_list_offsets_elf32(elfcorebuf, elfcorebuf_sz, &vmcore_list);
 	return 0;
 }
 

